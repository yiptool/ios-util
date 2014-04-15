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

-(id)init
{
	self = [super initWithFrame:CGRectZero];
	if (self)
	{
		overlayView = [[UIButton alloc] initWithFrame:CGRectZero];
		overlayView.backgroundColor = [UIColor blackColor];
		[overlayView addTarget:self action:@selector(dismissFromView) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

-(void)dealloc
{
	[overlayView removeFromSuperview];
	[overlayView release];
	[contentsView removeFromSuperview];
	[contentsView release];
	[super dealloc];
}

-(void)setContentsView:(UIView *)view
{
	[contentsView removeFromSuperview];
	[contentsView release];

	contentsView = [view retain];

	if (contentsView)
		[overlayView addSubview:contentsView];
}

-(void)presentInView:(UIView *)view height:(CGFloat)height
{
	[overlayView removeFromSuperview];
	[view addSubview:overlayView];

	CGRect bounds = view.bounds;
	overlayView.frame = bounds;
	overlayView.alpha = 0.0f;

	__block CGRect contentsBounds = CGRectMake(0.0f, bounds.size.height, bounds.size.width, height);
	contentsView.frame = contentsBounds;

	[UIView animateWithDuration:0.3f delay:0.0f
		options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
		animations:^{
			overlayView.alpha = 0.7f;
			contentsBounds.origin.y = bounds.size.height - contentsBounds.size.height;
			contentsView.frame = bounds;
		}
		completion:nil];
}

-(void)dismissFromView
{
	CGRect bounds = overlayView.superview.bounds;
	CGRect contentsBounds = contentsView.frame;
	contentsBounds.origin.y = bounds.size.height;

	[UIView animateWithDuration:0.3f delay:0.0f
		options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
		animations:^{
			overlayView.alpha = 0.0f;
			contentsView.frame = contentsBounds;
		}
		completion:^(BOOL) {
			[overlayView removeFromSuperview];
		}
	];
}

@end
