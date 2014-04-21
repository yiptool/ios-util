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
#import <UIKit/UIKit.h>

namespace IOS
{
	/** Delegate for *UIImageView*. */
	class UIImageViewDelegate : public UIViewDelegate
	{
	public:
		/**
		 * Constructor.
		 * @param iosView Pointer to the instance of *UIImageView*.
		 */
		UIImageViewDelegate(UIImageView * iosView);

		/** Destructor. */
		~UIImageViewDelegate();

		/**
		 * Sets property of the image view.
		 * @param element Pointer to the element.
		 * @param name Name of the property.
		 * @param val Value of the property.
		 * @return *true* on success or *false* if element does not have such property.
		 */
		bool setElementProperty(UI::Element * element, const std::string & name, const std::string & val) override;

		/**
		 * Called when position or size of this element changes.
		 * @param elem Pointer to the element.
		 * @param pos New coordinates of the top left corner of this element relative to the parent element.
		 * @param sz New size of this element.
		 */
		void onElementLayoutChanged(UI::Element * elem, const glm::vec2 & pos, const glm::vec2 & sz) override;

	private:
		UIImage * m_Image;
		bool m_HasMargins;
		float m_LeftMargin;
		float m_TopMargin;
		float m_RightMargin;
		float m_BottomMargin;

		UIImageViewDelegate(const UIImageViewDelegate &) = delete;
		UIImageViewDelegate & operator=(const UIImageViewDelegate &) = delete;
	};
}
