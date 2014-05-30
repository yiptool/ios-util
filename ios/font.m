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
#import "font.h"
#import <yip-imports/cxx-util/macros.h>

static NSMutableDictionary * g_Fonts;

UIFont * iosGetFont(NSString * name, float sizeInPoints)
{
	if (UNLIKELY(!g_Fonts))
		g_Fonts = [[NSMutableDictionary dictionaryWithCapacity:8] retain];

	NSMutableDictionary * sizes = [g_Fonts objectForKey:name];
	if (UNLIKELY(!sizes))
	{
		sizes = [NSMutableDictionary dictionaryWithCapacity:16];
		[g_Fonts setObject:sizes forKey:name];
	}

	NSNumber * fontSize = [NSNumber numberWithFloat:sizeInPoints];
	UIFont * font = [sizes objectForKey:fontSize];
	if (LIKELY(font))
		return font;

	font = [UIFont fontWithName:name size:sizeInPoints];
	if (UNLIKELY(!font))
	{
		NSLog(@"Unable to load font with name '%@'.", name);
		font = [UIFont systemFontOfSize:sizeInPoints];
	}

	[sizes setObject:font forKey:fontSize];

	return font;
}
