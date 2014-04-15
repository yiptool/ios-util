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
#import "ios_uilabel_delegate.h"
#import "ios_util.h"
#import <yip-imports/ui_layout.h>
#import <yip-imports/strtod.h>
#import <yip-imports/cxx-util/fmt.h>
#import <stdexcept>

IOS::UILabelDelegate::UILabelDelegate(UILabel * iosView)
	: IOS::UIViewDelegate(iosView)
{
	UILabel * label = (UILabel *)m_View;
	label.backgroundColor = [UIColor clearColor];
}

bool IOS::UILabelDelegate::setElementProperty(UI::Element * element, const std::string & name,
	const std::string & val)
{
	UILabel * label = (UILabel *)m_View;

	if (name == "text")
	{
		label.text = [NSString stringWithUTF8String:val.c_str()];
		return true;
	}
	else if (name == "textColor")
	{
		label.textColor = iosColorFromName(val);
		return true;
	}
	else if (m_Font.setProperty(name, val))
		return true;
	else if (setUILabelProperty(label, name, val))
		return true;

	return UIViewDelegate::setElementProperty(element, name, val);
}

bool IOS::UILabelDelegate::setUILabelProperty(UILabel * label, const std::string & name, const std::string & val)
{
	if (name == "fitText")
	{
		label.adjustsFontSizeToFitWidth = iosBoolFromName(val);
		return true;
	}
	else if (name == "minimumScaleFactor")
	{
		const char * p = val.c_str();
		char * end = nullptr;
		float factor = static_cast<float>(p_strtod(p, &end));
		if (*end != 0)
			throw std::runtime_error(fmt() << "invalid value '" << val << "' for the 'minimumScaleFactor' attribute.");
		label.minimumScaleFactor = factor;
		return true;
	}
	else if (name == "textAlign")
	{
		if (val == "left")
			label.textAlignment = NSTextAlignmentLeft;
		else if (val == "center")
			label.textAlignment = NSTextAlignmentCenter;
		else if (val == "right")
			label.textAlignment = NSTextAlignmentRight;
		else if (val == "justified")
			label.textAlignment = NSTextAlignmentJustified;
		else if (val == "natural")
			label.textAlignment = NSTextAlignmentNatural;
		else
			throw std::runtime_error(fmt() << "invalid text alignment '" << val << "'.");
		return true;
	}

	return false;
}

void IOS::UILabelDelegate::onElementLayoutChanged(UI::Element * elem, const glm::vec2 & pos, const glm::vec2 & sz)
{
	UIViewDelegate::onElementLayoutChanged(elem, pos, sz);

	float scale = UI::Layout::scaleFactorForElement(elem);
	UIFont * font = m_Font.getUIFontForScale(scale);
	if (font)
		((UILabel *)m_View).font = font;
}
