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
#import "NZTextField.h"

@implementation NZTextField
{
	BOOL attachRightViewToText;
	CGFloat rightViewLeftMargin;
}

@synthesize rightViewLeftMargin;

-(BOOL)attachRightViewToText
{
	return attachRightViewToText;
}

-(void)setAttachRightViewToText:(BOOL)flag
{
	attachRightViewToText = flag;
	[self setNeedsLayout];
}

-(CGFloat)rightViewLeftMargin
{
	return rightViewLeftMargin;
}

-(void)setRightViewLeftMargin:(CGFloat)margin
{
	rightViewLeftMargin = margin;
	[self setNeedsLayout];
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
	if (!attachRightViewToText)
		return [super rightViewRectForBounds:bounds];

	CGRect textBounds = [self textRectForBounds:bounds];
	CGRect viewBounds = [super rightViewRectForBounds:bounds];

	return CGRectMake(
		textBounds.origin.x + textBounds.size.width,
		viewBounds.origin.y,
		viewBounds.size.width,
		viewBounds.size.height
	);
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
	if (!attachRightViewToText)
		return [super textRectForBounds:bounds];

	NSAttributedString * text = (self.text.length > 0 ? self.attributedText : self.attributedPlaceholder);
	return [self attributedString:text rectForBounds:bounds];
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
	if (!attachRightViewToText)
		return [super placeholderRectForBounds:bounds];
	return [self attributedString:self.attributedPlaceholder rectForBounds:bounds];
}

-(CGRect)attributedString:(NSAttributedString *)text rectForBounds:(CGRect)bounds
{
	CGRect rightViewBounds = [super rightViewRectForBounds:bounds];
	CGSize maxTextSize = CGSizeMake(
		bounds.size.width - rightViewBounds.size.width - rightViewLeftMargin,
		bounds.size.height
	);

	CGRect textBounds = [text boundingRectWithSize:maxTextSize
		options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
		context:nil];
	textBounds.origin.y = bounds.origin.y;
	textBounds.size.width = MIN(textBounds.size.width, maxTextSize.width);
	textBounds.size.height = bounds.size.height;

	switch (self.textAlignment)
	{
	case NSTextAlignmentLeft:
	case NSTextAlignmentJustified:
	case NSTextAlignmentNatural:
		break;
	case NSTextAlignmentCenter:
		textBounds.origin.x = bounds.origin.x + (bounds.size.width - textBounds.size.width) * 0.5f;
		break;
	case NSTextAlignmentRight:
		textBounds.origin.x = bounds.origin.x + maxTextSize.width - textBounds.size.width;
		break;
	}

	CGFloat w1 = textBounds.origin.x + textBounds.size.width;
	CGFloat w2 = bounds.origin.x + maxTextSize.width;
	if (w1 > w2)
		textBounds.origin.x -= w1 - w2;
	textBounds.size.width += rightViewLeftMargin;

	return textBounds;
}

@end
