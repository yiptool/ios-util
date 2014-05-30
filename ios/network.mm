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
#import "network.h"
#import "uuid.h"

void iosSetRequestUserAgent(NSMutableURLRequest * request)
{
	NSString * udid = iosGetDeviceUniqueID();

	NSString * bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	NSString * version = (id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);

	UIDevice * currentDevice = [UIDevice currentDevice];
	NSString * deviceModel = [currentDevice model];
	NSString * systemVersion = [currentDevice systemVersion];

	NSString * agentString = [NSString stringWithFormat:@"%@/%@ (iOS/%@; %@; ID/%@)",
		bundleIdentifier, version, deviceModel, systemVersion, udid];

	[request addValue:agentString forHTTPHeaderField:@"User-Agent"];
}

void iosAsyncDownload(NSString * url, NSURLRequestCachePolicy cachePolicy, NSTimeInterval timeout,
	PFNIOSASYNCDOWNLOADHANDLERPROC handler)
{
	url = [[url copy] autorelease];

	NSURL * nsUrl = [NSURL URLWithString:url];
	NSMutableURLRequest * request = [[[NSMutableURLRequest alloc]
		initWithURL:nsUrl cachePolicy:cachePolicy timeoutInterval:timeout] autorelease];

	iosSetRequestUserAgent(request);

	NSString * cachePolicyName = @"???";
	switch (cachePolicy)
	{
	case NSURLRequestUseProtocolCachePolicy:
		cachePolicyName = @"NSURLRequestUseProtocolCachePolicy";
		break;
	case NSURLRequestReloadIgnoringLocalCacheData:
		cachePolicyName = @"NSURLRequestReloadIgnoringLocalCacheData";
		break;
	case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
		cachePolicyName = @"NSURLRequestReloadIgnoringLocalAndRemoteCacheData";
		break;
	case NSURLRequestReturnCacheDataElseLoad:
		cachePolicyName = @"NSURLRequestReturnCacheDataElseLoad";
		break;
	case NSURLRequestReturnCacheDataDontLoad:
		cachePolicyName = @"NSURLRequestReturnCacheDataDontLoad";
		break;
	case NSURLRequestReloadRevalidatingCacheData:
		cachePolicyName = @"NSURLRequestReloadRevalidatingCacheData";
		break;
	}
	NSLog(@"Downloading '%@' (cache policy %@, timeout %.2f sec).", nsUrl, cachePolicyName, timeout);

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
		completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
		{
			long statusCode = ([response respondsToSelector:@selector(statusCode)]
				? long([(NSHTTPURLResponse *)response statusCode]) : 0L);

			if (error)
			{
				NSLog(@"Unable to download '%@' (status code %03ld): %@", url, statusCode, error);
				dispatch_async(dispatch_get_main_queue(), ^{
					handler(url, nil, nil, error);
				});
			}
			else
			{
				long length = (long)[data length];
				NSLog(@"Finished download of '%@' (status code %03ld, %ld bytes).", url, statusCode, length);
				if (!error && statusCode != 0L && (statusCode < 200L || statusCode >= 300L))
					error = [NSError errorWithDomain:@"HTTPStatusCode" code:statusCode userInfo:nil];
				dispatch_async(dispatch_get_main_queue(), ^{
					handler(url, response, data, error);
				});
			}
		}
	];
}

void iosAsyncDownload(NSString * url, PFNIOSASYNCDOWNLOADHANDLERPROC handler)
{
	iosAsyncDownload(url, NSURLRequestUseProtocolCachePolicy, 20, handler);
}

void iosAsyncDownloadForceDownload(NSString * url, PFNIOSASYNCDOWNLOADHANDLERPROC handler)
{
	iosAsyncDownload(url, NSURLRequestReloadRevalidatingCacheData, 20, handler);
}

void iosAsyncDownloadForceCached(NSString * url, PFNIOSASYNCDOWNLOADHANDLERPROC handler)
{
	iosAsyncDownload(url, NSURLRequestReturnCacheDataElseLoad, 20, handler);
}
