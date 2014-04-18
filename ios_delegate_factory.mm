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
#import "ios_delegate_factory.h"
#import "ios_custom_uiswitch_delegate.h"
#import "ios_uibutton_delegate.h"
#import "ios_uilabel_delegate.h"
#import "ios_uiimageview_delegate.h"
#import "ios_uiview_delegate.h"
#import "ios_uiwebview_delegate.h"
#import <yip-imports/cxx-util/fmt.h>

UI::ElementDelegate * IOS::DelegateFactory::delegateForClass(const std::string & className) const
{
	if (className == "UIImageView")
		return new IOS::UIImageViewDelegate([[[UIImageView alloc] initWithImage:nil] autorelease]);
	else if (className == "UIButton")
		return new IOS::UIButtonDelegate([UIButton buttonWithType:UIButtonTypeCustom]);
	else if (className == "UILabel")
		return new IOS::UILabelDelegate([[UILabel alloc] initWithFrame:CGRectZero]);
	else if (className == "UIWebView")
		return new IOS::UIWebViewDelegate([[UIWebView alloc] init]);
	else if (className == "CustomUISwitch")
		return new IOS::CustomUISwitchDelegate([[[CustomUISwitch alloc] init] autorelease]);
	else if (className == "UIView")
		return new IOS::UIViewDelegate([[[UIView alloc] initWithFrame:CGRectZero] autorelease]);

	throw std::runtime_error(fmt() << "invalid UI element '" << className << "'.");
}
