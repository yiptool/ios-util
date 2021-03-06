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

#ifdef __cplusplus
#include <string>
#endif

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Determines full path to the specified resource inside the application bundle.
 * @param resource Relative path to the resource.
 * @return Full path to the result.
 */
NSString * iosPathForResource(NSString * resource);

/**
 * Loads the specified image from resource file.
 * @param resource Relative path to the resource.
 * @return Instance of *UIImage*.
 */
UIImage * iosImageFromResource(NSString * resource);

/**
 * Loads the specified image from resource file.
 * @param resource Relative path to the resource.
 * @param scale Scale of the image.
 * @return Instance of *UIImage*.
 */
UIImage * iosImageFromResourceEx(NSString * resource, CGFloat scale);

/**
 * Loads the specified HTML resource and displays its contents in the given instance of UIWebView.
 * @param webView Instance of UIWebView.
 * @param resource Name of the resource.
 */
void iosDisplayResourceInWebView(UIWebView * webView, NSString * resource);

#ifdef __cplusplus
} // extern "C"
#endif

#ifdef __cplusplus
/**
 * Loads the specified resource into memory.
 * @param resource Relative path to the resource.
 * @return Resource data.
 */
std::string iosLoadResource(NSString * resource);
#endif
