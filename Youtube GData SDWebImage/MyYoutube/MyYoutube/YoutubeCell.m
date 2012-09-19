//
//  YoutubeCell.m
//  MyYoutube
//
//  Created by Jenn on 9/14/12.
//  Copyright (c) 2012 Jenn. All rights reserved.
//

#import "YoutubeCell.h"

@implementation YoutubeCell
@synthesize videoMetadata;
@synthesize videoThumbnail;
@synthesize videoTitle;
@synthesize backgroundCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews
{
    CGSize titleStringSize;
    CGFloat labelHeight = 0.0;
    
    if (videoTitle.text) {
        titleStringSize =[videoTitle.text sizeWithFont: [UIFont boldSystemFontOfSize: 14.0]
                                     constrainedToSize: CGSizeMake(185.0, MAXFLOAT)
                                         lineBreakMode: UILineBreakModeWordWrap];
        self.videoTitle.frame = CGRectMake(self.videoTitle.frame.origin.x, self.videoTitle.frame.origin.y, self.videoTitle.frame.size.width, titleStringSize.height);
        labelHeight += titleStringSize.height;
        //self.videoTitle.backgroundColor = [UIColor yellowColor];
    }
    
    if (videoMetadata.text) {
        titleStringSize =[videoMetadata.text sizeWithFont: [UIFont boldSystemFontOfSize: 14.0]
                                        constrainedToSize: CGSizeMake(185.0, MAXFLOAT)
                                            lineBreakMode: UILineBreakModeWordWrap];
        
        self.videoMetadata.frame = CGRectMake(self.videoMetadata.frame.origin.x, self.videoTitle.frame.origin.y + self.videoTitle.frame.size.height, self.videoMetadata.frame.size.width, titleStringSize.height);
        labelHeight += titleStringSize.height;
        //self.videoMetadata.backgroundColor = [UIColor redColor];
    }    
    
    //NSLog(@"labelHeight: %.2f", labelHeight);
    self.backgroundCell.frame = CGRectMake(self.backgroundCell.frame.origin.x, self.backgroundCell.frame.origin.y, self.backgroundCell.frame.size.width, labelHeight);
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, labelHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
