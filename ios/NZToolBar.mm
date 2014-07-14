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
#import "NZToolBar.h"
#import "UIButton+ExtraMethods.h"
#import <vector>

@implementation NZToolBar
{
	UIImage * separatorImage;
	std::vector<CGFloat> separatorPositions;
	std::vector<UIButton *> buttons;
}

-(void)dealloc
{
	[separatorImage release];
	separatorImage = nil;

	[super dealloc];
}

-(UIImage *)separatorImage
{
	return separatorImage;
}

-(void)setSeparatorImage:(UIImage *)image
{
	[separatorImage release];
	separatorImage = [image retain];
	[self setNeedsLayout];
}

-(void)addButton:(UIImage *)image withTarget:(id)target action:(SEL)action
{
	UIButton * button = [[[UIButton alloc] init] autorelease];
	button.image = image;
	[button addTarget:target action:action];
	[self addSubview:button];
	buttons.push_back(button);
}

-(void)setImage:(UIImage *)image forButton:(int)index
{
	buttons[index].image = image;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	separatorPositions.clear();
	[self setNeedsDisplay];

	size_t count = buttons.size();
	if (count == 0)
		return;

	CGRect frame = self.bounds;
	if (count == 1)
	{
		buttons.front().frame = frame;
		return;
	}

	CGFloat viewWidth = frame.size.width;
	CGFloat separatorWidth = 0.0f;
	if (separatorImage)
	{
		CGFloat scale = frame.size.height / separatorImage.size.height;
		separatorWidth = separatorImage.size.width * scale;
		viewWidth -= separatorWidth * (count - 1);
	}

	CGFloat itemWidth = floor(viewWidth / float(count) * 2.0f) * 0.5f;
	separatorPositions.reserve(count);
	for (UIButton * button : buttons)
	{
		frame.size.width = itemWidth;
		button.frame = frame;
		frame.origin.x += itemWidth;
		separatorPositions.push_back(frame.origin.x);
		frame.origin.x += separatorWidth;
	}

	if (!separatorPositions.empty())
		separatorPositions.pop_back();
}

-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	if (separatorImage)
	{
		CGFloat scale = rect.size.height / separatorImage.size.height;
		rect.size.width = separatorImage.size.width * scale;
		rect.size.height = rect.size.height;
		for (CGFloat x : separatorPositions)
		{
			rect.origin.x = x;
			[separatorImage drawInRect:rect];
		}
	}
}

@end
