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
#import "NZAlertView.h"
#import <yip-imports/ios/i18n.h>
#import <stdarg.h>

@interface NZAlertView ()
{
	id<UIAlertViewDelegate> customDelegate;
	BOOL active;
}
@end

@implementation NZAlertView

@synthesize onDismiss;
@synthesize onDismiss2;

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
	cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle
		otherButtonTitles:otherButtonTitles, nil];
	if (self)
	{
		customDelegate = delegate;
		[super setDelegate:self];

		if (otherButtonTitles)
		{
			va_list args;
			va_start(args, otherButtonTitles);
			for (;;)
			{
				NSString * buttonTitle = va_arg(args, NSString *);
				if (!buttonTitle)
					break;
				[self addButtonWithTitle:buttonTitle];
			}
			va_end(args);
		}
	}
	return self;
}

+(id)withTitle:(NSString *)title message:(NSString *)message
{
	return [[[NZAlertView alloc] initWithTitle:title message:message delegate:nil
		cancelButtonTitle:iosTranslationForOk() otherButtonTitles:nil] autorelease];
}

+(id)withTitle:(NSString *)title message:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message];
	alertView.onDismiss = handler;
	return alertView;
}

+(id)withTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle
{
	return [[[NZAlertView alloc] initWithTitle:title message:message delegate:nil
		cancelButtonTitle:btnTitle otherButtonTitles:nil] autorelease];
}

+(id)withTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle
	onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message button:btnTitle];
	alertView.onDismiss = handler;
	return alertView;
}

+(id)withTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2
{
	return [[[NZAlertView alloc] initWithTitle:title message:message delegate:nil
		cancelButtonTitle:btnTitle1 otherButtonTitles:btnTitle2, nil] autorelease];
}

+(id)withTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2 onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message firstButton:btnTitle1
		secondButton:btnTitle2];
	alertView.onDismiss2 = handler;
	return alertView;
}

+(id)withErrorMessage:(NSString *)message
{
	return [[[NZAlertView alloc] initWithTitle:iosTranslationForError() message:message delegate:nil
		cancelButtonTitle:iosTranslationForOk() otherButtonTitles:nil] autorelease];
}

+(id)withErrorMessage:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [[[NZAlertView alloc] initWithTitle:iosTranslationForError() message:message
		delegate:nil cancelButtonTitle:iosTranslationForOk() otherButtonTitles:nil] autorelease];
	alertView.onDismiss = handler;
	return alertView;
}

+(id)withErrorMessage:(NSString *)message button:(NSString *)btnTitle
{
	return [[[NZAlertView alloc] initWithTitle:iosTranslationForError() message:message
		delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil] autorelease];
}

+(id)withErrorMessage:(NSString *)message button:(NSString *)btnTitle onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [[[NZAlertView alloc] initWithTitle:iosTranslationForError() message:message
		delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil] autorelease];
	alertView.onDismiss = handler;
	return alertView;
}

+(id)withErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2
{
	return [[[NZAlertView alloc] initWithTitle:iosTranslationForError() message:message
		delegate:nil cancelButtonTitle:btnTitle1 otherButtonTitles:btnTitle2, nil] autorelease];
}

+(id)withErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2
	onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler
{
	NZAlertView * alertView = [[[NZAlertView alloc] initWithTitle:iosTranslationForError() message:message
		delegate:nil cancelButtonTitle:btnTitle1 otherButtonTitles:btnTitle2, nil] autorelease];
	alertView.onDismiss2 = handler;
	return alertView;
}

+(id)showWithTitle:(NSString *)title message:(NSString *)message
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message button:iosTranslationForOk()];
	[alertView show];
	return alertView;
}

+(id)showWithTitle:(NSString *)title message:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message button:iosTranslationForOk()
		onDismiss:handler];
	[alertView show];
	return alertView;
}

+(id)showWithTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message button:btnTitle];
	[alertView show];
	return alertView;
}

+(id)showWithTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle
	onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message button:btnTitle onDismiss:handler];
	[alertView show];
	return alertView;
}

+(id)showWithTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message firstButton:btnTitle1
		secondButton:btnTitle2];
	[alertView show];
	return alertView;
}

+(id)showWithTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2 onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler
{
	NZAlertView * alertView = [NZAlertView withTitle:title message:message firstButton:btnTitle1
		secondButton:btnTitle2 onDismiss:handler];
	[alertView show];
	return alertView;
}

+(id)showWithErrorMessage:(NSString *)message
{
	NZAlertView * alertView = [NZAlertView withErrorMessage:message];
	[alertView show];
	return alertView;
}

+(id)showWithErrorMessage:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [NZAlertView withErrorMessage:message onDismiss:handler];
	[alertView show];
	return alertView;
}

+(id)showWithErrorMessage:(NSString *)message button:(NSString *)btnTitle
{
	NZAlertView * alertView = [NZAlertView withErrorMessage:message button:btnTitle];
	[alertView show];
	return alertView;
}

+(id)showWithErrorMessage:(NSString *)message button:(NSString *)btnTitle
	onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler
{
	NZAlertView * alertView = [NZAlertView withErrorMessage:message button:btnTitle onDismiss:handler];
	[alertView show];
	return alertView;
}

+(id)showWithErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2
{
	NZAlertView * alertView = [NZAlertView withErrorMessage:message firstButton:btnTitle1 secondButton:btnTitle2];
	[alertView show];
	return alertView;
}

+(id)showWithErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2
	onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler
{
	NZAlertView * alertView = [NZAlertView withErrorMessage:message firstButton:btnTitle1 secondButton:btnTitle2
		onDismiss:handler];
	[alertView show];
	return alertView;
}

-(void)dealloc
{
	self.onDismiss = nil;
	self.onDismiss2 = nil;
	[super dealloc];
}

-(id)delegate
{
	return customDelegate;
}

-(void)setDelegate:(id)delegate
{
	customDelegate = delegate;
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
	if ([customDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)])
		return [customDelegate alertViewShouldEnableFirstOtherButton:alertView];
	return YES;
}

-(void)willPresentAlertView:(UIAlertView *)alertView
{
	if ([customDelegate respondsToSelector:@selector(willPresentAlertView:)])
		[customDelegate willPresentAlertView:alertView];
}

-(void)didPresentAlertView:(UIAlertView *)alertView
{
	if ([customDelegate respondsToSelector:@selector(didPresentAlertView:)])
		[customDelegate didPresentAlertView:alertView];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([customDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
		[customDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
	if ([customDelegate respondsToSelector:@selector(alertViewCancel:)])
		[customDelegate alertViewCancel:alertView];
	else
		[self dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([customDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
		[customDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (onDismiss)
		onDismiss();

	if (onDismiss2)
		onDismiss2(buttonIndex);

	if ([customDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
		[customDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
}

@end
