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
#import "camera.h"
#import "i18n.h"
#import "util.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface NZImagePickerControllerDelegate
	: NSObject<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, copy) void (^ callback)(const CameraData *, BOOL);
@property (nonatomic, assign) NSTimeInterval videoMaximumDuration;
@property (nonatomic, assign) CameraMediaType mediaType;
@property (nonatomic, retain) UIViewController * viewController;
@end

@implementation NZImagePickerControllerDelegate

@synthesize callback;
@synthesize videoMaximumDuration;
@synthesize mediaType;
@synthesize viewController;

-(void)dealloc
{
	[callback release];
	callback = nil;
	[viewController release];
	viewController = nil;
	[super dealloc];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex)
	{
		if (callback)
			callback(nil, NO);
		return;
	}

	[self displayImagePickerForSource:(buttonIndex == 0 ? CameraDevice : CameraGallery)];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	picker.delegate = nil;
	[self autorelease];

	[picker dismissViewControllerAnimated:YES completion:nil];

	NSString * mediaTypeString = info[UIImagePickerControllerMediaType];
	CameraMediaType outputMediaType;
	if ([mediaTypeString isEqualToString:(NSString *)kUTTypeImage])
		outputMediaType = CameraPhoto;
	else if ([mediaTypeString isEqualToString:(NSString *)kUTTypeMovie])
		outputMediaType = CameraVideo;
	else
	{
		if (callback)
			callback(nil, YES);
		return;
	}

	if (callback)
	{
		CameraData data;
		data.mediaType = outputMediaType;
		data.mediaURL = info[UIImagePickerControllerMediaURL];
		data.originalImage = info[UIImagePickerControllerOriginalImage];
		callback(&data, NO);
	}
}

-(void)displayImagePickerForSource:(CameraSource)source
{
	UIImagePickerControllerSourceType type = (source == CameraDevice ?
		UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary);
	if (![UIImagePickerController isSourceTypeAvailable:type])
	{
		if (callback)
			callback(nil, YES);
		return;
	}

	UIImagePickerController * controller = [[[UIImagePickerController alloc] init] autorelease];
	if (!controller)
	{
		if (callback)
			callback(nil, YES);
		return;
	}

	controller.allowsEditing = NO;
	controller.delegate = self;
	controller.sourceType = type;

	switch (mediaType)
	{
	case CameraPhoto:
		controller.mediaTypes = @[ (NSString *)kUTTypeImage ];
		break;

	case CameraVideo:
		controller.videoMaximumDuration = videoMaximumDuration;
		controller.mediaTypes = @[ (NSString *)kUTTypeMovie ];
		break;

	case CameraPhotoAndVideo:
		controller.videoMaximumDuration = videoMaximumDuration;
		controller.mediaTypes = @[ (NSString *)kUTTypeImage, (NSString *)kUTTypeMovie ];
		break;
	}

	[self retain];
	[viewController presentViewController:controller animated:YES completion:nil];
}

-(void)displayActionSheetInView:(UIView *)view
{
	UIActionSheet * actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
			cancelButtonTitle:iosTranslationForCancel() destructiveButtonTitle:nil
			otherButtonTitles:iosTranslationForTakePhoto(), iosTranslationForBrowseGallery(), nil]
		autorelease];

	if (!actionSheet)
	{
		if (callback)
			callback(nil, YES);
		return;
	}

	[self retain];
	[actionSheet showInView:view];
}

@end

void iosGetMediaFromCamera(UIView * view, CameraSource source, CameraMediaType mediaType,
	NSTimeInterval videoMaximumDuration, void (^ callback)(const CameraData * data, BOOL error))
{
	NZImagePickerControllerDelegate * delegate = [[[NZImagePickerControllerDelegate alloc] init] autorelease];
	delegate.callback = callback;
	delegate.videoMaximumDuration = videoMaximumDuration;
	delegate.mediaType = mediaType;
	delegate.viewController = iosTopmostViewController();

	switch (source)
	{
	case CameraDevice:
	case CameraGallery:
		[delegate displayImagePickerForSource:source];
		break;

	case CameraDeviceOrGallery:
		[delegate displayActionSheetInView:view];
		break;
	}
}
