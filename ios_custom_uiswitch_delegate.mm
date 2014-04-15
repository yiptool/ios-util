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
#import "ios_custom_uiswitch_delegate.h"
#import "ios_util.h"

IOS::CustomUISwitchDelegate::CustomUISwitchDelegate(CustomUISwitch * iosView)
	: IOS::UIViewDelegate(iosView)
{
}

bool IOS::CustomUISwitchDelegate::setElementProperty(UI::Element * element, const std::string & name,
	const std::string & val)
{
	CustomUISwitch * swtch = (CustomUISwitch *)m_View;

	if (name == "value")
	{
		[swtch setValue:iosBoolFromName(val) animated:NO];
		return true;
	}
	else if (name == "off_image")
	{
		swtch.turnedOff.image = iosImageFromResource([NSString stringWithUTF8String:val.c_str()]);
		return true;
	}
	else if (name == "on_image")
	{
		swtch.turnedOn.image = iosImageFromResource([NSString stringWithUTF8String:val.c_str()]);
		return true;
	}
	else if (name == "knob_image")
	{
		swtch.knob.image = iosImageFromResource([NSString stringWithUTF8String:val.c_str()]);
		return true;
	}

	return UIViewDelegate::setElementProperty(element, name, val);
}
