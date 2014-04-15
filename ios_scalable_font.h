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
#import <string>

namespace IOS
{
	/** Scalable font. */
	class ScalableFont
	{
	public:
		/** Constructor. */
		ScalableFont();

		/** Destructor. */
		~ScalableFont();

		/**
		 * Sets name of the font family.
		 * @param val Name of the font family.
		 */
		void setFamily(const std::string & val);

		/**
		 * Sets size of the font.
		 * @param val Size of the font.
		 */
		void setSize(const std::string & val);

		/**
		 * Sets property of the font.
		 * @param name Name of the property.
		 * @param val Value of the property.
		 * @return *true* if property value has been set or *false* if there is no such property.
		 */
		bool setProperty(const std::string & name, const std::string & val);

		/**
		 * Retrieves an instance of *UIFont* for the given scale.
		 * @param scale Scale.
		 * @return Instance of *UIFont*.
		 */
		UIFont * getUIFontForScale(float scale) const;

	private:
		NSString * m_FontFamily;
		float m_FontSize;
		bool m_HasFontSize;

		ScalableFont(const ScalableFont &) = delete;
		ScalableFont & operator=(const ScalableFont &) = delete;
	};
}
