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
#import "image.h"
#import "UIImage+Resize.h"

UIImage * iosScaledImage(UIImage * image, float scaleW, float scaleH)
{
	CGSize newSize = CGSizeMake(
		image.size.width * scaleW,
		image.size.height * scaleH
	);

	return [image resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
}

UIImage * iosImageWithCapInsets(UIImage * image, float insetLeft, float insetTop, float insetRight,
	float insetBottom)
{
	UIEdgeInsets insets = UIEdgeInsetsMake(insetLeft, insetTop, insetRight, insetBottom);
	return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

UIImage * iosScaledImageWithCapInsets(UIImage * image, float scaleW, float scaleH,
	float insetLeft, float insetTop, float insetRight, float insetBottom)
{
	UIImage * scaledImage = iosScaledImage(image, scaleW, scaleH);

	UIEdgeInsets insets = UIEdgeInsetsMake(
		insetLeft * scaleW,
		insetTop * scaleH,
		insetRight * scaleW,
		insetBottom * scaleH
	);

	return [scaledImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}