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
#import "ios_util.h"
#import "ios_simple_uipickerview_delegate.h"
#import "ios_uiview_delegate.h"
#import "ios_action_sheet.h"
#import <yip-imports/cxx-util/unhex.h>
#import <yip-imports/cxx-util/fmt.h>
#import <sstream>
#import <stdexcept>

BOOL iosBoolFromName(const std::string & str)
{
	if (str == "yes")
		return YES;
	else if (str == "no")
		return NO;
	throw std::runtime_error(fmt() << "invalid value '" << str << "' (expected 'yes' or 'no').");
}

UIColor * iosColorFromName(const std::string & str)
{
	if (str == "black")
		return [UIColor blackColor];
	else if (str == "darkgray")
		return [UIColor darkGrayColor];
	else if (str == "lightgray")
		return [UIColor lightGrayColor];
	else if (str == "white")
		return [UIColor whiteColor];
	else if (str == "gray")
		return [UIColor grayColor];
	else if (str == "red")
		return [UIColor redColor];
	else if (str == "green")
		return [UIColor greenColor];
	else if (str == "blue")
		return [UIColor blueColor];
	else if (str == "cyan")
		return [UIColor cyanColor];
	else if (str == "yellow")
		return [UIColor yellowColor];
	else if (str == "magenta")
		return [UIColor magentaColor];
	else if (str == "orange")
		return [UIColor orangeColor];
	else if (str == "purple")
		return [UIColor purpleColor];
	else if (str == "brown")
		return [UIColor brownColor];
	else if (str == "clear")
		return [UIColor clearColor];

	if (str.length() > 0 && str[0] == '#')
	{
		if (str.length() == 4)
		{
			float red = unhex(str[1]) / 15.0f;
			float green = unhex(str[2]) / 15.0f;
			float blue = unhex(str[3]) / 15.0f;
			return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
		}
		else if (str.length() == 5)
		{
			float red = unhex(str[1]) / 15.0f;
			float green = unhex(str[2]) / 15.0f;
			float blue = unhex(str[3]) / 15.0f;
			float alpha = unhex(str[4]) / 15.0f;
			return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
		}
		else if (str.length() == 7)
		{
			float red = unhex2(str[1], str[2]) / 255.0f;
			float green = unhex2(str[3], str[4]) / 255.0f;
			float blue = unhex2(str[5], str[6]) / 255.0f;
			return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
		}
		else if (str.length() == 9)
		{
			float red = unhex2(str[1], str[2]) / 255.0f;
			float green = unhex2(str[3], str[4]) / 255.0f;
			float blue = unhex2(str[5], str[6]) / 255.0f;
			float alpha = unhex2(str[7], str[8]) / 255.0f;
			return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
		}
	}

	throw std::runtime_error(fmt() << "invalid color value '" << str << "'.");
}

UIFont * iosGetFont(NSString * fontName, CGFloat sizeInPixels)
{
	// Based on code from http://stackoverflow.com/questions/1059101/font-size-in-pixels

	// Lets play around and create a font that falls near the point size needed
	CGFloat pointStart = sizeInPixels / 4;
	CGFloat lastHeight = -1;
	UIFont * lastFont = [UIFont fontWithName:fontName size:0.5f];

	NSMutableDictionary * dictAttrs = [NSMutableDictionary dictionaryWithCapacity:1];
	NSString * fontCompareString = @"M";

	for (CGFloat pnt = pointStart; pnt < 1000; pnt += 0.5f)
	{
		UIFont * font = [UIFont fontWithName:fontName size:pnt];
		if (!font)
			throw std::runtime_error(fmt() << "unable to create font '" << fontName << "'.");

		CGSize cs;
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
			cs = [fontCompareString sizeWithFont:font];
		else
		{
			dictAttrs[NSFontAttributeName] = font;
			cs = [fontCompareString sizeWithAttributes:dictAttrs];
		}

		CGFloat fheight = cs.height;
		if (fheight == sizeInPixels)
		{
			// That will be rare but we found it
			return font;
		}

		if (fheight > sizeInPixels)
		{
			if (!lastFont)
				return font;

			// Check which one is closer last height or this one and return to the user
			CGFloat fc1 = fabs(fheight - sizeInPixels);
			CGFloat fc2 = fabs(lastHeight - sizeInPixels);

			// Return the smallest differential
			return (fc1 < fc2 ? font : lastFont);
		}

		lastFont = font;
		lastHeight = fheight;
	}

	return nil;
}

void iosDisplayPicker(UIView * superview, NSArray * items, int selected, void (^callback)(int selected))
{
	__block ActionSheet * actionSheet = [[ActionSheet alloc] init];

	SimpleUIPickerViewDelegate * delegate = [[[SimpleUIPickerViewDelegate alloc] init] autorelease];
	delegate.items = items;
	delegate.selectedIndex = selected;

	UIPickerView * pickerView = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
	pickerView.delegate = delegate;
	pickerView.showsSelectionIndicator = YES;
	[pickerView selectRow:selected inComponent:0 animated:NO];
	[actionSheet addContentsView:pickerView];

	UIButton * okButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[okButton setTitle:@"OK" forState:UIControlStateNormal];
	[okButton addTarget:actionSheet action:@selector(dismissFromView) forControlEvents:UIControlEventTouchUpInside];
	[actionSheet addContentsView:okButton];

	actionSheet.onDismiss = ^{
		callback(delegate.selectedIndex);
		[actionSheet release];
	};

	[actionSheet presentInView:superview];
}

NSString * iosPathForResource(NSString * resource)
{
	return [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].resourcePath, resource];
}

UIImage * iosImageFromResource(NSString * resource)
{
	NSString * path = iosPathForResource(resource);
	NSData * data = [NSData dataWithContentsOfFile:path];

	CGFloat scale = [[UIScreen mainScreen] scale];
	UIImage * image = [[[UIImage alloc] initWithData:data scale:scale] autorelease];

	return image;
}

std::string iosLoadResource(NSString * resource)
{
	NSString * path = iosPathForResource(resource);
	NSData * data = [NSData dataWithContentsOfFile:path];
	return std::string(reinterpret_cast<const char *>(data.bytes), static_cast<size_t>(data.length));
}

std::shared_ptr<TiXmlDocument> iosXmlFromResource(NSString * resource)
{
	NSString * path = iosPathForResource(resource);
	NSData * data = [NSData dataWithContentsOfFile:path];

	const char * ptr = reinterpret_cast<const char *>(data.bytes);
	size_t len = static_cast<size_t>(data.length);

	std::shared_ptr<TiXmlDocument> xml = std::make_shared<TiXmlDocument>([resource UTF8String]);
	if (!xml->LoadBuffer(const_cast<char *>(ptr), len))
	{
		std::stringstream ss;
		ss << "error in '" << xml->ValueStr() << "' at row " << xml->ErrorRow() << ", column " << xml->ErrorCol()
			<< ": " << xml->ErrorDesc();
		throw std::runtime_error(ss.str());
	}

	return xml;
}

id iosGetViewById(const UI::ManagerPtr & mgr, const std::string & elemID)
{
	UI::Element * element = mgr->getElementById(elemID);
	if (!element)
		return nil;

	IOS::UIViewDelegate * delegate = dynamic_cast<IOS::UIViewDelegate *>(element->delegate);
	if (!delegate)
		return nil;

	return delegate->view();
}
