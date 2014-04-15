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

#ifdef __cplusplus
#import <yip-imports/tinyxml.h>
#import <yip-imports/ui_manager.h>
#import <string>
#import <memory>
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Converts given text string ("yes" or "no") into BOOL.
 * @param str Text String.
 * @return Corresponding BOOL value.
 * @throw std::runtime_error If *str* does not contain either "yes" or "no".
 */
BOOL iosBoolFromName(const std::string & str);

/**
 * Converts given text string into UIColor.
 * @param str Text string.
 * @return Instance of UIColor.
 * @throw std::runtime_error If *str* contains an invalid color name.
 */
UIColor * iosColorFromName(const std::string & str);

/**
 * Loads font as close to the given pixel size, as possible.
 * @param fontName Name of the font.
 * @param sizeInPixels Size of the font in pixels.
 * @return Instance of *UIFont*.
 */
UIFont * iosGetFont(NSString * fontName, CGFloat sizeInPixels);

/**
 * Presents an action sheet with the *UIPicker* view.
 * @param superview Superview to display action sheet in.
 * @param items Array of items to display in the picker.
 * @param selected Index of the selected item.
 * @param callback Method to call when user makes a selection.
 */
void iosDisplayPicker(UIView * superview, NSArray * items, int selected, void (^callback)(int selected));

/**
 * Determines full path to the specified resource inside the application bundle.
 * @param resource Relative path to the resource.
 * @return Full path to the result.
 */
NSString * iosPathForResource(NSString * resource);

/**
 * Loads the specified image from resource file.
 * @param resource Relative path to the resource.
 * @return Instance of *UIImage*.
 */
UIImage * iosImageFromResource(NSString * resource);

#ifdef __cplusplus
}
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C++

#ifdef __cplusplus

/**
 * Loads the specified resource into memory.
 * @param resource Relative path to the resource.
 * @return Resource data.
 */
std::string iosLoadResource(NSString * resource);

/**
 * Loads the specified XML resource into memory.
 * @param resource Relative path to the resource.
 * @return XML document for the resource.
 */
std::shared_ptr<TiXmlDocument> iosXmlFromResource(NSString * resource);

/**
 * Retrieves instance of UIView for the specified UI element id.
 * @param mgr Pointer to the UI manager.
 * @param elemID ID of the UI element.
 * @return Pointer to the instance of UIView or *nil* if there is no such UI element.
 */
id iosGetViewById(const UI::ManagerPtr & mgr, const std::string & elemID);

#endif
