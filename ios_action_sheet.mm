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
#import "ios_action_sheet.h"

@implementation ActionSheet

@synthesize onDismiss;

-(id)init
{
	self = [super initWithFrame:CGRectZero];
	if (self)
	{
		overlayView = [[UIButton alloc] initWithFrame:CGRectZero];
		overlayView.backgroundColor = [UIColor blackColor];
		[overlayView addTarget:self action:@selector(dismissFromView) forControlEvents:UIControlEventTouchUpInside];

		sheetView = [[UIView alloc] initWithFrame:CGRectZero];
		sheetView.backgroundColor = [UIColor whiteColor];

		baseView = [[UIView alloc] initWithFrame:CGRectZero];
		baseView.backgroundColor = [UIColor clearColor];
		[baseView addSubview:overlayView];
		[baseView addSubview:sheetView];
	}
	return self;
}

-(void)dealloc
{
	self.onDismiss = nil;
	[overlayView removeFromSuperview];
	[overlayView release];
	[sheetView removeFromSuperview];
	[sheetView release];
	[baseView removeFromSuperview];
	[baseView release];
	[super dealloc];
}

-(void)addContentsView:(UIView *)view
{
	NSLayoutConstraint * constraint;
	if (sheetView.subviews.count == 0)
	{
		constraint = [NSLayoutConstraint constraintWithItem:sheetView
			attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view
			attribute:NSLayoutAttributeBottom multiplier:0.0f constant:0.0f];
	}
	else
	{
		constraint = [NSLayoutConstraint constraintWithItem:sheetView.subviews.lastObject
			attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view
			attribute:NSLayoutAttributeBottom multiplier:0.0f constant:0.0f];
	}

	[sheetView addSubview:view];
	[sheetView addConstraint:constraint];
}

-(void)presentInView:(UIView *)view height:(CGFloat)height
{
	[baseView removeFromSuperview];
	[view addSubview:baseView];

	CGRect bounds = view.bounds;
	baseView.frame = bounds;
	overlayView.frame = bounds;
	overlayView.alpha = 0.0f;

	__block CGRect contentsBounds = CGRectMake(0.0f, bounds.size.height, bounds.size.width, height);
	sheetView.frame = contentsBounds;

	[UIView animateWithDuration:0.3f delay:0.0f
		options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
		animations:^{
			overlayView.alpha = 0.7f;
			contentsBounds.origin.y = bounds.size.height - contentsBounds.size.height;
			sheetView.frame = contentsBounds;
		}
		completion:nil];
}

-(void)dismissFromView
{
	[UIView animateWithDuration:0.3f delay:0.0f
		options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
		animations:^{
			overlayView.alpha = 0.0f;
			CGRect contentsBounds = sheetView.frame;
			contentsBounds.origin.y = baseView.superview.bounds.size.height;
			sheetView.frame = contentsBounds;
		}
		completion:^(BOOL) {
			[baseView removeFromSuperview];
			if (onDismiss)
				onDismiss();
		}
	];
}

@end
