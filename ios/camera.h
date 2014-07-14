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
extern "C" {
#endif

/** Source to retrieve photo or video from. */
enum CameraSource
{
	CameraDevice = 0,			/**< Photo or video should be retrieved from a physical camera device. */
	CameraGallery,				/**< Photo or video should be retrieved from the gallery. */
	CameraDeviceOrGallery,		/**< User should be asked to choose the source. */
};

/** Media type. */
enum CameraMediaType
{
	CameraPhoto = 0,			/**< Allow only photos. */
	CameraVideo,				/**< Allow only videos. */
	CameraPhotoAndVideo,		/**< Allow both photos and videos. */
};

/** Data from camera. */
struct CameraData
{
	CameraMediaType mediaType;	/**< Media type. */
	NSURL * mediaURL;			/**< URL for the media. */
	UIImage * originalImage;	/**< Image for the media. */
};

/**
 * Retrieves a photo or video from a camera or photo gallery.
 * @param view Parent view.
 * @param source Source to retrieve photo or video from.
 * @param mediaType Media type.
 * @param videoMaximumDuration Maximum duration for video, in seconds.
 * @param callback Callback to invoke.
 */
void iosGetMediaFromCamera(UIView * view, CameraSource source, CameraMediaType mediaType,
	NSTimeInterval videoMaximumDuration, void (^ callback)(const CameraData * data, BOOL error));

#ifdef __cplusplus
} // extern "C"
#endif
