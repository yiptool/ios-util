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
#import "NZSplashViewController.h"

@implementation NZSplashViewController

-(id)init
{
	return [super initWithNibName:nil bundle:nil];
}

-(void)loadView
{
	@autoreleasepool
	{
		UIScreen * mainScreen = [UIScreen mainScreen];

		int screenWidth = (int)(mainScreen.bounds.size.width * mainScreen.scale);
		int screenHeight = (int)(mainScreen.bounds.size.height * mainScreen.scale);
		NSLog(@"Searching splash image (screen size is %dx%d).", screenWidth, screenHeight);

		NSArray * images = @[
			@"LaunchImage-700-Portrait@2x~ipad",
			@"LaunchImage-700-Portrait~ipad",
			@"LaunchImage-700-568h@2x",
			@"LaunchImage-Portrait@2x~ipad",
			@"LaunchImage-Portrait~ipad",
			@"LaunchImage-568h@2x",
			@"LaunchImage@2x",
			@"LaunchImage",
			@"Default-700-Portrait@2x~ipad",
			@"Default-700-Portrait~ipad",
			@"Default-700-568h@2x",
			@"Default-Portrait@2x~ipad",
			@"Default-Portrait~ipad",
			@"Default-568h@2x",
			@"Default@2x",
			@"Default",
		];

		UIImage * splashImage = nil;
		float splashImageAspect = 0;
		int splashImageWidth = 0;
		int splashImageHeight = 0;

		for (NSString * file in images)
		{
			UIImage * image = [UIImage imageNamed:file];
			if (image)
			{
				CGSize imageSize = image.size;
				int imageWidth = (int)imageSize.width;
				int imageHeight = (int)imageSize.height;
				NSLog(@"Loaded image '%@' (%dx%d).", file, imageWidth, imageHeight);

				float imageAspect = (float)imageWidth / (float)imageHeight;
				float screenAspect = (float)screenWidth / (float)screenHeight;
				float aspectDelta = fabs(imageAspect - screenAspect);

				if (imageWidth == screenWidth && imageHeight == screenHeight)
				{
					NSLog(@"'%@' is an ideal screen image.", file);
					splashImageWidth = imageWidth;
					splashImageHeight = imageHeight;
					splashImage = image;
					break;
				}

				BOOL isBetterImage = NO;
				if (!splashImage)
					isBetterImage = YES;
				else if (aspectDelta < splashImageAspect)
					isBetterImage = YES;
				else if ((imageWidth > splashImageWidth || imageHeight > splashImageHeight) &&
						fabs(aspectDelta - splashImageAspect) < 0.01)
					isBetterImage = YES;

				if (isBetterImage)
				{
					splashImage = image;
					splashImageAspect = aspectDelta;
					splashImageWidth = imageWidth;
					splashImageHeight = imageHeight;
				}
			}
		}

		if (!splashImage)
			NSLog(@"Unable to load splash image.");
		else
			NSLog(@"Splash screen image size: %dx%d", splashImageWidth, splashImageHeight);

		self.view = [[[UIImageView alloc] initWithImage:splashImage] autorelease];
		self.view.frame = mainScreen.bounds;
	}

	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
		self.edgesForExtendedLayout = UIRectEdgeNone;

	if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
		[self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
		[self setNeedsStatusBarAppearanceUpdate];
}

-(BOOL)prefersStatusBarHidden
{
	return YES;
}

-(BOOL)shouldAutorotate
{
	return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
