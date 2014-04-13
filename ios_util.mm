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
#import "ios_util.h"
#import <sstream>

NSString * iosPathForResource(NSString * resource)
{
	return [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].resourcePath, resource];
}

std::string iosLoadResource(NSString * resource)
{
	NSString * path = iosPathForResource(resource);
	NSData * data = [NSData dataWithContentsOfFile:path];
	return std::string(reinterpret_cast<const char *>(data.bytes), static_cast<size_t>(data.length));
}

std::shared_ptr<TiXmlDocument> iosXmlFromResource(NSString * resource)
{
	NSString * path = iosPathForResource(resource);
	NSData * data = [NSData dataWithContentsOfFile:path];

	const char * ptr = reinterpret_cast<const char *>(data.bytes);
	size_t len = static_cast<size_t>(data.length());

	std::shared_ptr<TiXmlDocument> xml = std::make_shared<TiXmlDocument>([resource UTF8String]);
	if (!xml->LoadBuffer(const_cast<char *>(ptr), len))
	{
		std::stringstream ss;
		ss << "error in '" << doc.ValueStr() << "' at row " << doc.ErrorRow() << ", column " << doc.ErrorCol()
			<< ": " << doc.ErrorDesc();
		throw std::runtime_error(ss.str());
	}

	return xml;
}

UIImage * iosImageFromResource(NSString * resource)
{
	NSString * path = iosPathForResource(resource);
	NSData * data = [NSData dataWithContentsOfFile:path];

	CGFloat scale = [[UIScreen mainScreen] scale];
	UIImage * image = [[[UIImage alloc] initWithData:data scale:scale] autorelease];

	return image;
}
