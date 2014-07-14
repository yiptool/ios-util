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
#import "i18n.h"

NSString * iosGetCurrentLanguage()
{
	return [[NSLocale preferredLanguages] objectAtIndex:0];
}

NSString * iosGetCurrentLanguageID()
{
	return [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
}

NSString * iosChooseTranslation(NSString * def, NSDictionary * strings)
{
	NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
	NSString * message = [strings objectForKey:language];
	if (message)
		return message;

	language = [language substringToIndex:2];
	message = [strings objectForKey:language];
	if (message)
		return message;

	return def;
}

NSString * iosTranslationForOk()
{
	return iosChooseTranslation(@"OK", @{
		@"ru": @"ОК"
	});
}

NSString * iosTranslationForCancel()
{
	return iosChooseTranslation(@"Cancel", @{
		@"ru": @"Отмена"
	});
}

NSString * iosTranslationForError()
{
	return iosChooseTranslation(@"Error", @{
		@"ru": @"Ошибка"
	});
}

NSString * iosTranslationForTakePhoto()
{
	return iosChooseTranslation(@"Take Photo", @{
		@"ru": @"Новое фото"
	});
}

NSString * iosTranslationForBrowseGallery()
{
	return iosChooseTranslation(@"Browse Gallery", @{
		@"ru": @"Фото из галереи"
	});
}
