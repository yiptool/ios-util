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
#import "NZButton.h"

@interface NZButton ()
{
	BOOL imageOnRightSide;
}
@end

@implementation NZButton

-(BOOL)imageOnRightSide
{
	return imageOnRightSide;
}

-(void)setImageOnRightSide:(BOOL)flag
{
	if (flag != imageOnRightSide)
	{
		imageOnRightSide = flag;
		[self setNeedsDisplay];
	}
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
	CGRect rect = [super imageRectForContentRect:contentRect];
	if (imageOnRightSide)
	{
		rect.origin.x += [super titleRectForContentRect:contentRect].size.width;
		rect.origin.x += self.titleEdgeInsets.left;
	}
	return rect;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
	CGRect rect = [super titleRectForContentRect:contentRect];
	if (imageOnRightSide)
	{
		rect.origin.x -= [super imageRectForContentRect:contentRect].size.width;
		rect.origin.x -= self.imageEdgeInsets.right;
	}
	return rect;
}

@end
