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
#import "ios_refreshing_table_view_cell.h"
#import "ios_util.h"

@implementation NZRefreshingTableViewCell

@synthesize activityIndicatorView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];

		self.activityIndicatorView = [[[UIActivityIndicatorView alloc]
			initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
		activityIndicatorView.frame = CGRectMake(0, 0, 320, [NZRefreshingTableViewCell height]);
		activityIndicatorView.backgroundColor = [UIColor clearColor];
		activityIndicatorView.color = iosColorFromName("#333333");
		activityIndicatorView.hidesWhenStopped = NO;
		[activityIndicatorView startAnimating];
		[self.contentView addSubview:activityIndicatorView];
	}
	return self;
}

-(void)dealloc
{
	self.activityIndicatorView = nil;
	[super dealloc];
}

+(CGFloat)height
{
	return 50;
}

@end
