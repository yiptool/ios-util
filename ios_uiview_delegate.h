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
#import <yip-imports/ui_element_delegate.h>
#import <UIKit/UIKit.h>

namespace IOS
{
	/** Implementation of UI::ElementDelegate for the iOS platform. */
	class UIViewDelegate : public UI::ElementDelegate
	{
	public:
		/**
		 * Constructor.
		 * @param iosView Pointer to the iOS view.
		 */
		UIViewDelegate(UIView * iosView);

		/** Destructor. */
		~UIViewDelegate();

		/**
		 * Retrieves pointer to the iOS view.
		 * @return Pointer to the iOS view.
		 */
		inline UIView * view() const { return m_View; }

		/**
		 * Measures contents of the element for the means of layouting.
		 * @param element Pointer to the element.
		 * @param sz Size of the area available to the element.
		 * @param horz Horizontal size constraint.
		 * @param vert Vertical size constraint.
		 * @return Size of the contents of the element.
		 */
		glm::vec2 measureElementSize(const UI::Element * element, const glm::vec2 & sz,
			UI::SizeConstraint horz = UI::AT_MOST, UI::SizeConstraint vert = UI::AT_MOST) override;

		/**
		 * Sets property of the element.
		 * @param element Pointer to the element.
		 * @param name Name of the property.
		 * @param val Value of the property.
		 * @return *true* on success or *false* if element does not have such property.
		 */
		bool setElementProperty(UI::Element * element, const std::string & name, const std::string & val) override;

		/**
		 * Called when element is being destroyed.
		 * @param element Pointer to the element. This could be *nullptr* if an exception has occured
		 * while constructing the element.
		 */
		void onElementDestroyed(UI::Element * element) override;

		/**
		 * Called when parent of the element changes.
		 * @param element Pointer to the element.
		 * @param oldP Pointer to the old parent element.
		 * @param newP Pointer to the new parent element.
		 */
		void onElementParentChanged(UI::Element * element, UI::Element * oldP, UI::Element * newP) override;

		/**
		 * Called when position or size of this element changes.
		 * @param element Pointer to the element.
		 * @param pos New coordinates of the top left corner of this element relative to the parent element.
		 * @param sz New size of this element.
		 */
		void onElementLayoutChanged(UI::Element * element, const glm::vec2 & pos, const glm::vec2 & sz) override;

	protected:
		UIView * m_View;			/**< Pointer to the iOS view. */

		UIViewDelegate(const UIViewDelegate &) = delete;
		UIViewDelegate & operator=(const UIViewDelegate &) = delete;
	};
}
