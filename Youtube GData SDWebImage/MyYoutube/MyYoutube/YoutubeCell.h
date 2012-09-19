//
//  YoutubeCell.h
//  MyYoutube
//
//  Created by Jenn on 9/14/12.
//  Copyright (c) 2012 Jenn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *videoTitle;
@property (nonatomic, strong) IBOutlet UILabel *videoMetadata;
@property (nonatomic, strong) IBOutlet UIImageView *videoThumbnail;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundCell;
@end
