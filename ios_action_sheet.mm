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
		overlayView = [[UIView alloc] initWithFrame:CGRectZero];
		overlayView.backgroundColor = [UIColor blackColor];

		sheetView = [[UIView alloc] initWithFrame:CGRectZero];
		sheetView.translatesAutoresizingMaskIntoConstraints = NO;
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
	UIView * prevView = sheetView.subviews.lastObject;
	NSLayoutConstraint * constraint;

	view.translatesAutoresizingMaskIntoConstraints = NO;
	[sheetView addSubview:view];

	if (!prevView)
	{
		constraint = [NSLayoutConstraint constraintWithItem:view
			attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sheetView
			attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
		[sheetView addConstraint:constraint];
	}
	else
	{
		[sheetView removeConstraint:sheetView.constraints.lastObject];
		constraint = [NSLayoutConstraint constraintWithItem:prevView
			attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view
			attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
		[sheetView addConstraint:constraint];
	}

	constraint = [NSLayoutConstraint constraintWithItem:view
		attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sheetView
		attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
	[sheetView addConstraint:constraint];

	constraint = [NSLayoutConstraint constraintWithItem:view
		attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:sheetView
		attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
	[sheetView addConstraint:constraint];

	constraint = [NSLayoutConstraint constraintWithItem:view
		attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sheetView
		attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
	[sheetView addConstraint:constraint];
}

-(void)presentInView:(UIView *)view
{
	[baseView removeFromSuperview];
	[view addSubview:baseView];

	CGRect bounds = view.bounds;
	baseView.frame = bounds;
	overlayView.frame = bounds;
	overlayView.alpha = 0.0f;

	CGSize contentsSize = [sheetView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	__block CGRect contentsBounds = CGRectMake(0.0f, bounds.size.height, bounds.size.width, contentsSize.height);
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
