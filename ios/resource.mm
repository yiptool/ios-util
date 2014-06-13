/* vim: set ai noet ts=4 sw=4 tw=115: */
//
// Copyright (c) 2014 Nikolay Zapolnov (zapolnov@gmail.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import "resource.h"
#import <unordered_map>
#import <string>
#import <yip-imports/cxx-util/macros.h>
#import "objc_retain_ptr.h"

static std::unordered_map<std::string, UIImage *> g_Images;

@interface NZImage : UIImage
{
	@public
	std::string dictionaryKey;
}
@end

@implementation NZImage
-(void)dealloc
{
	g_Images.erase(dictionaryKey);
	[super dealloc];
}
@end

NSString * iosPathForResource(NSString * resource)
{
	return [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].resourcePath, resource];
}

UIImage * iosImageFromResource(NSString * resource)
{
	return iosImageFromResourceEx(resource, 2.0f);
}

UIImage * iosImageFromResourceEx(NSString * resource, CGFloat scale)
{
	std::string key = [resource UTF8String];

	auto it = g_Images.find(key);
	if (it != g_Images.end())
		return [[it->second retain] autorelease];

	NSData * data = [NSData dataWithContentsOfFile:iosPathForResource(resource)];
	NZImage * image = [[[NZImage alloc] initWithData:data scale:scale] autorelease];

	if (UNLIKELY(!image))
	{
		NSLog(@"Unable to load resource '%@'.",resource);
		return nil;
	}

	image->dictionaryKey = key;
	g_Images.insert(std::make_pair(key, image));

	return image;
}

void iosDisplayResourceInWebView(UIWebView * webView, NSString * resource)
{
	NSString * file = iosPathForResource(resource);

	NSError * error = nil;
	NSString * html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
	if (UNLIKELY(error))
		NSLog(@"Unable to load resource '%@': %@", resource, error);

	NSURL * baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	[webView loadHTMLString:html baseURL:baseURL];
}

std::string iosLoadResource(NSString * resource)
{
	NSData * data = [NSData dataWithContentsOfFile:iosPathForResource(resource)];
	return std::string(reinterpret_cast<const char *>(data.bytes), static_cast<size_t>(data.length));
}
