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
#import <UIKit/UIKit.h>

/**
 * Completion handler for asynchronous download.
 * @param url Original URL that has been requested.
 * @param response Response.
 * @param data File data.
 * @param error Error code.
 */
typedef void (^ PFNIOSASYNCDOWNLOADHANDLERPROC)
	(NSString * url, NSURLResponse * response, NSData * data, NSError * error);

/**
 * Sets the `User-Agent` header for the given instance of `NSMutableURLRequest`.
 * @param request Instance of `NSMutableURLRequest`.
 */
void iosSetRequestUserAgent(NSMutableURLRequest * request);

/**
 * Asynchronously downloads the specified URL.
 * @param url URL to download.
 * @param cachePolicy Caching policy.
 * @param timeout Timeout.
 * @param handler Completion handler.
 */
void iosAsyncDownload(NSString * url, NSURLRequestCachePolicy cachePolicy, NSTimeInterval timeout,
	PFNIOSASYNCDOWNLOADHANDLERPROC handler);

#ifdef __cplusplus

/**
 * Asynchronously downloads the specified URL.
 * @param url URL to download.
 * @param handler Completion handler.
 */
void iosAsyncDownload(NSString * url, PFNIOSASYNCDOWNLOADHANDLERPROC handler);

#endif

/**
 * Asynchronously downloads the specified URL.
 * This function invalidates any caches before downloading.
 * @param url URL to download.
 * @param handler Completion handler.
 */
void iosAsyncDownloadForceDownload(NSString * url, PFNIOSASYNCDOWNLOADHANDLERPROC handler);

/**
 * Asynchronously downloads the specified URL.
 * If there is cached copy of the data, this function does not download the data and returns a cached copy instead.
 * @param url URL to download.
 * @param handler Completion handler.
 */
void iosAsyncDownloadForceCached(NSString * url, PFNIOSASYNCDOWNLOADHANDLERPROC handler);
