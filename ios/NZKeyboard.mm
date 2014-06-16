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
#import "NZKeyboard.h"
#import "NSNotificationCenter+ExtraMethods.h"
#import <yip-imports/cxx-util/macros.h>

NSString * const NZKeyboardWillShow = @"NZKeyboardWillShow";
NSString * const NZKeyboardWillHide = @"NZKeyboardWillHide";

static NZKeyboard * g_Keyboard;

@implementation NZKeyboard

@synthesize beginFrame;
@synthesize endFrame;
@synthesize height;
@synthesize animDuration;
@synthesize animCurve;
@synthesize visible;

+(void)initialize
{
	// Ensure that default instance has been constructed
	[NZKeyboard defaultKeyboard];
}

-(id)init
{
	self = [super init];
	if (self)
	{
		[NSNotificationCenter addObserver:self selector:@selector(onKeyboardWillShow:)
			name:UIKeyboardWillShowNotification];
		[NSNotificationCenter addObserver:self selector:@selector(onKeyboardWillHide:)
			name:UIKeyboardWillHideNotification];
	}
	return self;
}

-(void)dealloc
{
	[NSNotificationCenter removeObserver:self];
	[super dealloc];
}

+(NZKeyboard *)defaultKeyboard
{
	if (!g_Keyboard)
		g_Keyboard = [[NZKeyboard alloc] init];
	return g_Keyboard;
}

+(CGRect)beginFrame
{
	return [NZKeyboard defaultKeyboard].beginFrame;
}

+(CGRect)endFrame
{
	return [NZKeyboard defaultKeyboard].endFrame;
}

+(CGFloat)height
{
	return [NZKeyboard defaultKeyboard].height;
}

+(NSTimeInterval)animDuration
{
	return [NZKeyboard defaultKeyboard].animDuration;
}

+(UIViewAnimationCurve)animCurve
{
	return [NZKeyboard defaultKeyboard].animCurve;
}

+(BOOL)visible
{
	return [NZKeyboard defaultKeyboard].visible;
}

-(void)onKeyboardWillShow:(NSNotification *)notification
{
	[self onKeyboardNotification:notification];
	visible = YES;
	[NSNotificationCenter postNotificationName:NZKeyboardWillShow];
}

-(void)onKeyboardWillHide:(NSNotification *)notification
{
	[self onKeyboardNotification:notification];
	visible = NO;
	[NSNotificationCenter postNotificationName:NZKeyboardWillHide];
}

-(void)onKeyboardNotification:(NSNotification *)notification
{
	NSDictionary * keyboardInfo = [notification userInfo];
	NSValue * keyboardBeginFrame = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
	NSValue * keyboardEndFrame = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
	NSNumber * duration = [keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSNumber * curve = [keyboardInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];

	beginFrame = [keyboardBeginFrame CGRectValue];
	endFrame = [keyboardEndFrame CGRectValue];
	animDuration = duration.doubleValue;
	animCurve = UIViewAnimationCurve(curve.intValue);

	CGFloat frameW = endFrame.size.width;
	CGFloat frameH = endFrame.size.height;
	height = (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? frameW : frameH);
}

-(void)animate:(void(^)())block
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animDuration];
	[UIView setAnimationCurve:animCurve];
	[UIView setAnimationBeginsFromCurrentState:YES];

	block();

	[UIView commitAnimations];
}

+(void)animate:(void(^)())block
{
	[[NZKeyboard defaultKeyboard] animate:block];
}

@end
