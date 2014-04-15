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

@interface CustomUISwitch : UIControl
{
	BOOL animating;
	// For touch tracking
	BOOL initialValue;
	BOOL valueChanged;
}
@property (nonatomic, readonly) BOOL value;
@property (nonatomic, retain) UIImageView * turnedOn;
@property (nonatomic, retain) UIImageView * turnedOff;
@property (nonatomic, retain) UIImageView * knob;
-(id)init;
-(void)dealloc;
-(void)setValue:(BOOL)value animated:(BOOL)animated;
@end

namespace IOS
{
	/** Delegate for *CustomUISwitch*. */
	class CustomUISwitchDelegate : public UIViewDelegate
	{
	public:
		/**
		 * Constructor.
		 * @param iosView Pointer to the instance of *CustomUISwitch*.
		 */
		CustomUISwitchDelegate(CustomUISwitch * iosView);

		/**
		 * Sets property of the switch.
		 * @param element Pointer to the element.
		 * @param name Name of the property.
		 * @param val Value of the property.
		 * @return *true* on success or *false* if element does not have such property.
		 */
		bool setElementProperty(UI::Element * element, const std::string & name, const std::string & val) override;

		CustomUISwitchDelegate(const CustomUISwitchDelegate &) = delete;
		CustomUISwitchDelegate & operator=(const CustomUISwitchDelegate &) = delete;
	};
}