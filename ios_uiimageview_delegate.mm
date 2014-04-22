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
#import "ios_uiimageview_delegate.h"
#import "ios_util.h"
#import "UIImage+Resize.h"
#import <yip-imports/ui_layout.h>
#import <yip-imports/strtod.h>
#import <yip-imports/cxx-util/macros.h>
#import <yip-imports/cxx-util/explode.h>
#import <yip-imports/cxx-util/trim.h>

IOS::UIImageViewDelegate::UIImageViewDelegate(UIImageView * iosView)
	: IOS::UIViewDelegate(iosView),
	  m_Image(nil),
	  m_HasMargins(false)
{
}

IOS::UIImageViewDelegate::~UIImageViewDelegate()
{
	[m_Image release];
}

bool IOS::UIImageViewDelegate::setElementProperty(UI::Element * element,
	const std::string & name, const std::string & val)
{
	if (name == "image")
	{
		UIImage * image;

		size_t pos = val.find('|');
		if (pos == std::string::npos)
			image = iosImageFromResource([NSString stringWithUTF8String:val.c_str()]);
		else
		{
			std::vector<std::string> margins = explode(val.substr(pos + 1), ',');
			if (UNLIKELY(margins.size() != 4))
				throw std::runtime_error("invalid value for the 'image' property.");

			if (UNLIKELY(!strToFloat(trim(margins[0]), m_LeftMargin)))
				throw std::runtime_error("invalid value for the 'image' property.");
			if (UNLIKELY(!strToFloat(trim(margins[1]), m_TopMargin)))
				throw std::runtime_error("invalid value for the 'image' property.");
			if (UNLIKELY(!strToFloat(trim(margins[2]), m_RightMargin)))
				throw std::runtime_error("invalid talue for the 'image' property.");
			if (UNLIKELY(!strToFloat(trim(margins[3]), m_BottomMargin)))
				throw std::runtime_error("invalid value for the 'image' property.");

			image = iosImageFromResource([NSString stringWithUTF8String:val.substr(0, pos).c_str()]);
			m_HasMargins = true;
		}

		[m_Image release];
		m_Image = [image retain];

		((UIImageView *)m_View).image = image;

		return true;
	}

	return UIViewDelegate::setElementProperty(element, name, val);
}

void IOS::UIImageViewDelegate::onElementLayoutChanged(UI::Element * elem, const glm::vec2 & pos,
	const glm::vec2 & sz)
{
	UIViewDelegate::onElementLayoutChanged(elem, pos, sz);

	if (!m_HasMargins)
		return;

	float scale = UI::Layout::scaleFactorForElement(elem, UI::Layout::PreferSmaller);
	CGSize newSize = CGSizeMake(CGImageGetWidth(m_Image.CGImage) * scale, CGImageGetHeight(m_Image.CGImage) * scale);

	CGFloat left = m_LeftMargin * scale;
	CGFloat top = m_TopMargin * scale;
	CGFloat right = m_RightMargin * scale;
	CGFloat bottom = m_BottomMargin * scale;
	UIEdgeInsets insets = UIEdgeInsetsMake(left, top, right, bottom);

	UIImage * scaledImage = [m_Image resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
	((UIImageView *)m_View).image = [scaledImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}
