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
#import "ios_uibutton_delegate.h"
#import "ios_util.h"

IOS::UIButtonDelegate::UIButtonDelegate(UIButton * iosView)
	: IOS::UIViewDelegate(iosView)
{
}

bool IOS::UIButtonDelegate::setElementProperty(UI::Element *, const std::string & name, const std::string & val)
{
	UIButton * button = (UIButton *)m_View;

	if (name == "title")
	{
		NSString * title = [NSString stringWithUTF8String:val.c_str()];
		[button setTitle:title forState:UIControlStateNormal];
		return true;
	}
	else if (name == "background")
	{
		UIImage * image = iosImageFromResource([NSString stringWithUTF8String:val.c_str()]);
		[button setBackgroundImage:image forState:UIControlStateNormal];
		return true;
	}

	return false;
}
