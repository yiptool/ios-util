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
extern "C" {
#endif

/**
 * Scales the given image.
 * @param image Source image.
 * @param scaleW Scale for the width.
 * @param scaleH Scale for the height.
 * @returns scaled image.
 */
UIImage * iosScaledImage(UIImage * image, float scaleW, float scaleH);

/**
 * Creates a resizable image with cap insets from the ginve image.
 * @param image Source image.
 * @param insetLeft Left cap inset.
 * @param insetTop Top cap inset.
 * @param insetRight Right cap inset.
 * @param insetBottom Bottom cap inset.
 * @returns Image with cap insets.
 */
UIImage * iosImageWithCapInsets(UIImage * image, float insetLeft, float insetTop, float insetRight,
	float insetBottom);

/**
 * Scales the given image and creates a resizable image with cap insets.
 * @param image Source image.
 * @param scaleW Scale for the width.
 * @param scaleH Scale for the height.
 * @param insetLeft Left cap inset.
 * @param insetTop Top cap inset.
 * @param insetRight Right cap inset.
 * @param insetBottom Bottom cap inset.
 * @returns scaled image with cap insets.
 */
UIImage * iosScaledImageWithCapInsets(UIImage * image, float scaleW, float scaleH,
	float insetLeft, float insetTop, float insetRight, float insetBottom);

#ifdef __cplusplus
} // extern "C"
#endif
