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
#import "color.h"
#import <yip-imports/cxx-util/unhex.h>
#import <yip-imports/cxx-util/fmt.h>

UIColor * iosColorFromName(const char * str)
{
	return iosColorFromName(std::string(str));
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
			float alpha = unhex(str[1]) / 15.0f;
			float red = unhex(str[2]) / 15.0f;
			float green = unhex(str[3]) / 15.0f;
			float blue = unhex(str[4]) / 15.0f;
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
			float alpha = unhex2(str[1], str[2]) / 255.0f;
			float red = unhex2(str[3], str[4]) / 255.0f;
			float green = unhex2(str[5], str[6]) / 255.0f;
			float blue = unhex2(str[7], str[8]) / 255.0f;
			return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
		}
	}

	throw std::runtime_error(fmt() << "invalid color value '" << str << "'.");
}
