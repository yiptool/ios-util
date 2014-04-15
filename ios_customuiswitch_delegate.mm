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
#import "ios_customuiswitch_delegate.h"
#import "ios_util.h"

@implementation CustomUISwitch

@synthesize value;
@synthesize turnedOn;
@synthesize turnedOff;
@synthesize knob;

-(id)init
{
	self = [super init];
	if (self)
	{
		self.turnedOn = [[[UIImageView alloc] initWithImage:nil] autorelease];
		turnedOn.userInteractionEnabled = NO;
		[self addSubview:turnedOn];

		self.turnedOff = [[[UIImageView alloc] initWithImage:nil] autorelease];
		turnedOff.userInteractionEnabled = NO;
		[self addSubview:turnedOff];

		self.knob = [[[UIImageView alloc] initWithImage:nil] autorelease];
		knob.userInteractionEnabled = NO;
		[self addSubview:knob];

		turnedOn.alpha = 0.0;
		turnedOff.alpha = 1.0;
		value = NO;

		[self calcKnobPositionForValue:value];
	}
	return self;
}

-(void)dealloc
{
	self.turnedOn = nil;
	self.turnedOff = nil;
	self.knob = nil;
	[super dealloc];
}

-(void)setValue:(BOOL)val animated:(BOOL)animated
{
	void (^ anim)() = ^{
		self.turnedOn.alpha = (val ? 1.0 : 0.0);
		self.turnedOff.alpha = (val ? 0.0 : 1.0);
		[self calcKnobPositionForValue:val];
	};

	if (!animated)
		anim();
	else
	{
		animating = YES;
		[UIView animateWithDuration:0.3 delay:0.0
			options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:anim
			completion:^(BOOL finished) { animating = NO; }
		];
	}

	value = val;
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super beginTrackingWithTouch:touch withEvent:event];
	initialValue = value;
	valueChanged = NO;
	return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super continueTrackingWithTouch:touch withEvent:event];

	CGPoint lastPoint = [touch locationInView:self];
	if (lastPoint.x > self.bounds.size.width * 0.5)
	{
		[self setValue:YES animated:YES];
		if (!initialValue)
			valueChanged = YES;
	}
	else
	{
		[self setValue:NO animated:YES];
		if (initialValue)
			valueChanged = YES;
	}

	return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	[self setValue:(valueChanged ? value : !value) animated:YES];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)cancelTrackingWithEvent:(UIEvent *)event
{
	[super cancelTrackingWithEvent:event];
	[self setValue:value animated:YES];
}

-(void)calcKnobPositionForValue:(BOOL)val
{
	const CGSize & size = self.bounds.size;
	CGFloat x = (val ? size.width - size.height : 0);
	knob.frame = CGRectMake(x, 0, size.height, size.height);
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	self.turnedOn.frame = self.bounds;
	self.turnedOff.frame = self.bounds;
	if (!animating)
		[self calcKnobPositionForValue:value];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
