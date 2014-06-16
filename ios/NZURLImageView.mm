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
#import "NZURLImageView.h"
#import "network.h"

@interface NZURLImageView ()
{
	NSString * imageURL;
	UIImage * placeholderImage;
	BOOL usingPlaceholder;
}
@end

@implementation NZURLImageView

@synthesize activityIndicator;

-(id)init
{
	self = [super initWithImage:nil];
	if (self)
	{
		[self commonInit];
		usingPlaceholder = YES;
	}
	return self;
}

-(id)initWithImage:(UIImage *)image
{
	self = [super initWithImage:image];
	if (self)
	{
		[self commonInit];
		usingPlaceholder = (image == nil);
	}
	return self;
}

-(id)initWithImageURL:(NSString *)url
{
	self = [super initWithImage:nil];
	if (self)
	{
		[self commonInit];
		usingPlaceholder = YES;
		self.imageURL = url;
	}
	return self;
}

-(id)initWithImageURL:(NSString *)url placeholderImage:(UIImage *)image
{
	self = [super initWithImage:image];
	if (self)
	{
		placeholderImage = [image retain];
		[self commonInit];
		usingPlaceholder = YES;
		self.imageURL = url;
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithImage:nil];
	if (self)
	{
		self.frame = frame;
		[self commonInit];
		usingPlaceholder = YES;
	}
	return self;
}

-(void)commonInit
{
	activityIndicator = [[UIActivityIndicatorView alloc]
		initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.hidden = YES;
	[self addSubview:activityIndicator];
}

-(void)dealloc
{
	[imageURL release];
	imageURL = nil;
	[placeholderImage release];
	placeholderImage = nil;
	[activityIndicator release];
	activityIndicator = nil;
	[super dealloc];
}

-(void)layoutSubviews
{
	activityIndicator.frame = self.bounds;
}

-(NSString *)imageURL
{
	return imageURL;
}

-(UIImage *)placeholderImage
{
	return placeholderImage;
}

-(void)setImage:(UIImage *)image
{
	[imageURL release];
	imageURL = nil;

	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;

	super.image = (image ? image : placeholderImage);
	usingPlaceholder = (image == nil);
}

-(void)setImageURL:(NSString *)url
{
	if (!url)
	{
		self.image = placeholderImage;
		usingPlaceholder = YES;
		return;
	}

	if ([imageURL isEqualToString:url])
		return;

	[imageURL release];
	imageURL = nil;
	imageURL = [url copy];

	super.image = placeholderImage;
	usingPlaceholder = YES;

	activityIndicator.hidden = NO;
	[activityIndicator startAnimating];

	iosAsyncDownloadForceCached(url, ^(NSString * reqURL, NSURLResponse *, NSData * data, NSError * error)
	{
		if (![reqURL isEqualToString:self->imageURL])
			return;

		if (error)
		{
			super.image = placeholderImage;
			usingPlaceholder = YES;
			[activityIndicator stopAnimating];
			activityIndicator.hidden = YES;
		}
		else
		{
			CGFloat scale = [[UIScreen mainScreen] scale];
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				UIImage * image = [UIImage imageWithData:data scale:scale];
				dispatch_async(dispatch_get_main_queue(), ^{
					super.image = image;
					usingPlaceholder = NO;
					[activityIndicator stopAnimating];
					activityIndicator.hidden = YES;
				});
			});
		}
	});
}

-(void)setPlaceholderImage:(UIImage *)image
{
	if (placeholderImage == image)
		return;

	[placeholderImage release];
	placeholderImage = [image retain];

	if (usingPlaceholder)
		super.image = placeholderImage;
}

@end
