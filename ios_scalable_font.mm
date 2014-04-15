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
#import "ios_scalable_font.h"
#import "ios_util.h"
#import <yip-imports/strtod.h>
#import <yip-imports/cxx-util/fmt.h>
#import <stdexcept>

IOS::ScalableFont::ScalableFont()
	: m_FontFamily(nil),
	  m_FontSize(16.0f),
	  m_HasFontSize(false)
{
}

IOS::ScalableFont::~ScalableFont()
{
	[m_FontFamily release];
}

void IOS::ScalableFont::setFamily(const std::string & val)
{
	[m_FontFamily release];
	m_FontFamily = [[NSString stringWithUTF8String:val.c_str()] retain];
}

void IOS::ScalableFont::setSize(const std::string & val)
{
	const char * p = val.c_str();
	char * end = nullptr;
	float size = static_cast<float>(p_strtod(p, &end));

	if (*end != 0)
		throw std::runtime_error(fmt() << "invalid font size '" << val << "'.");

	m_FontSize = size;
	m_HasFontSize = true;
}

bool IOS::ScalableFont::setProperty(const std::string & name, const std::string & val)
{
	if (name == "fontFamily")
	{
		setFamily(val);
		return true;
	}
	else if (name == "fontSize")
	{
		setSize(val);
		return true;
	}
	return false;
}

UIFont * IOS::ScalableFont::getUIFontForScale(float scale) const
{
	if (!m_FontFamily && !m_HasFontSize)
		return nil;

	try
	{
		NSString * family = (m_FontFamily ? m_FontFamily : @"Helvetica");
		return iosGetFont(family, m_FontSize * scale);
	}
	catch (const std::exception & e)
	{
		NSLog(@"%s", e.what());
		return nil;
	}
}
