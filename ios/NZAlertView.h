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

typedef void (^ PFNALERTVIEWDISMISSEDPROC)();
typedef void (^ PFNALERTVIEWDISMISSED2PROC)(NSInteger buttonIndex);

@interface NZAlertView : UIAlertView<UIAlertViewDelegate>
@property (nonatomic, copy) PFNALERTVIEWDISMISSEDPROC onDismiss;
@property (nonatomic, copy) PFNALERTVIEWDISMISSED2PROC onDismiss2;
-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
	cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
+(id)withTitle:(NSString *)title message:(NSString *)message;
+(id)withTitle:(NSString *)title message:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)withTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle;
+(id)withTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle
	onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)withTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2;
+(id)withTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2 onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler;
+(id)withErrorMessage:(NSString *)message;
+(id)withErrorMessage:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)withErrorMessage:(NSString *)message button:(NSString *)btnTitle;
+(id)withErrorMessage:(NSString *)message button:(NSString *)btnTitle onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)withErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2;
+(id)withErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2
	onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler;
+(id)showWithTitle:(NSString *)title message:(NSString *)message;
+(id)showWithTitle:(NSString *)title message:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)showWithTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle;
+(id)showWithTitle:(NSString *)title message:(NSString *)message button:(NSString *)btnTitle
	onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)showWithTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2;
+(id)showWithTitle:(NSString *)title message:(NSString *)message firstButton:(NSString *)btnTitle1
	secondButton:(NSString *)btnTitle2 onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler;
+(id)showWithErrorMessage:(NSString *)message;
+(id)showWithErrorMessage:(NSString *)message onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)showWithErrorMessage:(NSString *)message button:(NSString *)btnTitle;
+(id)showWithErrorMessage:(NSString *)message button:(NSString *)btnTitle
	onDismiss:(PFNALERTVIEWDISMISSEDPROC)handler;
+(id)showWithErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2;
+(id)showWithErrorMessage:(NSString *)message firstButton:(NSString *)btnTitle1 secondButton:(NSString *)btnTitle2
	onDismiss:(PFNALERTVIEWDISMISSED2PROC)handler;
-(void)dealloc;
-(id)delegate;
-(void)setDelegate:(id)delegate;
@end
