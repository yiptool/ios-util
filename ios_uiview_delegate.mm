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
#import "ios_uiview_delegate.h"
#import "ios_util.h"

IOS::UIViewDelegate::UIViewDelegate(UIView * iosView)
	: m_View([iosView retain])
{
}

IOS::UIViewDelegate::~UIViewDelegate()
{
	[m_View removeFromSuperview];
	[m_View release];
}

glm::vec2 IOS::UIViewDelegate::measureElementSize(const UI::Element *, const glm::vec2 & sz,
	UI::SizeConstraint, UI::SizeConstraint vert)
{
	CGSize size = CGSizeMake(sz.x, sz.y);
	size = [m_View sizeThatFits:size];
	return glm::vec2(size.width, size.height);
}

bool IOS::UIViewDelegate::setElementProperty(UI::Element *, const std::string & name, const std::string & val)
{
	if (name == "backgroundColor")
	{
		m_View.backgroundColor = iosColorFromName(val);
		return true;
	}
	else if (name == "userInteractionEnabled")
	{
		m_View.userInteractionEnabled = iosBoolFromName(val);
		return true;
	}

	return false;
}

void IOS::UIViewDelegate::onElementDestroyed(UI::Element *)
{
	delete this;
}

void IOS::UIViewDelegate::onElementParentChanged(UI::Element *, UI::Element *, UI::Element * newP)
{
	[m_View removeFromSuperview];

	if (!newP)
		return;

	IOS::UIViewDelegate * delegate = dynamic_cast<IOS::UIViewDelegate *>(newP->delegate);
	if (delegate)
		[delegate->m_View addSubview:m_View];
}

void IOS::UIViewDelegate::onElementLayoutChanged(UI::Element *, const glm::vec2 & pos, const glm::vec2 & sz)
{
	m_View.frame = CGRectMake(pos.x, pos.y, sz.x, sz.y);
}
