//
//  ViewController.m
//  MyYoutube
//
//  Created by Jenn on 9/14/12.
//  Copyright (c) 2012 Jenn. All rights reserved.
//

#import "ViewController.h"
#import "YoutubeCell.h"
#import "GDataYouTube.h"
#import "GDataServiceGoogleYouTube.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
}

@property (nonatomic, strong) GDataFeedYouTubeVideo *feed;
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) UIScrollView *menuScroll;
@property (nonatomic, strong) IBOutlet UITableView *youtubeTable;
@property (nonatomic, strong) UIImageView *imageViewL;
@property (nonatomic, strong) UIImageView *imageViewR;

- (GDataServiceGoogleYouTube *)youTubeService;
- (void)addMenuButtons;
@end

@implementation ViewController
@synthesize playlist;
@synthesize menuScroll;
@synthesize youtubeTable;
@synthesize imageViewR;
@synthesize imageViewL;
@synthesize feed;

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Youtube", @"Youtube");
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    playlist = [[NSArray alloc] initWithObjects:@"Menu1", @"Menu2", @"Menu3", @"Menu4", @"Menu5", @"Menu6", @"Menu7", @"Menu8", nil];
    
    menuScroll = [[UIScrollView alloc] init];
    menuScroll.frame = CGRectMake(self.view.frame.origin.x + 30, self.view.frame.origin.y + 3, self.view.frame.size.width-60, 35);
    menuScroll.backgroundColor = [UIColor clearColor];
    menuScroll.scrollEnabled = YES;
    menuScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:menuScroll];
    
    [self addMenuButtons];
    youtubeTable.delegate = self;
    youtubeTable.dataSource = self;
    menuScroll.delegate = self;
    
    imageViewL = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowLeft.png"]];
    imageViewL.frame = CGRectMake(self.view.frame.origin.x+10, (menuScroll.frame.size.height/2) - menuScroll.frame.size.height/4, menuScroll.frame.size.height/2, menuScroll.frame.size.height/2);
    [imageViewL setHidden:YES];
    [self.view addSubview:imageViewL];
    
    imageViewR = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRight.png"]];
    imageViewR.frame = CGRectMake(self.view.frame.size.width -  (menuScroll.frame.size.height/2) - 10,(menuScroll.frame.size.height/2) - menuScroll.frame.size.height/4, menuScroll.frame.size.height/2, menuScroll.frame.size.height/2);
    [imageViewR setHidden:YES];
    [self.view addSubview:imageViewR];
    
    [self loadYoutube];
    
    [super viewDidLoad];
}

#pragma mark - Methods

-(void)addMenuButtons
{
    float x = self.menuScroll.frame.origin.x + 5;
    UIButton *button;
    for (int i = 0; i < [playlist count]; i++) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:nil
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:[playlist objectAtIndex:i] forState:UIControlStateNormal];
        button.frame = CGRectMake(x, menuScroll.frame.origin.y, 70.0, 27.0);
        [menuScroll addSubview:button];
        x += button.frame.size.width + 5;
    }
    self.menuScroll.contentSize = CGSizeMake(x, button.frame.size.height);
}

- (void)loadYoutube
{
    GDataServiceGoogleYouTube *service = [self youTubeService];
    
	NSString *uploadsID = kGDataYouTubeUserFeedIDUploads;
	NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForUserID:@"ElectricalNick"
														 userFeedID:uploadsID];
	
	[service fetchFeedWithURL:feedURL
                     delegate:self
            didFinishSelector:@selector(request:finishedWithFeed:error:)];
}

- (void)loadYoutubePlaylist
{
    //+ (NSURL *)youTubeURLForChannelStandardFeedID:(NSString *)feedID;
    //kGDataYouTubeUserFeedIDPlaylists
    GDataServiceGoogleYouTube *service = [self youTubeService];
    
	NSString *feedID = kGDataYouTubeUserFeedIDPlaylists;
	NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForChannelStandardFeedID:feedID];
	
	[service fetchFeedWithURL:feedURL
                     delegate:self
            didFinishSelector:@selector(request:finishedWithFeed:error:)];
}

- (GDataServiceGoogleYouTube *)youTubeService {
	static GDataServiceGoogleYouTube* _service = nil;
	
	if (!_service) {
		_service = [[GDataServiceGoogleYouTube alloc] init];
		
		[_service setUserAgent:@"AppWhirl-UserApp-1.0"];
		[_service setServiceShouldFollowNextLinks:YES];
	}
	
	// fetch unauthenticated
	[_service setUserCredentialsWithUsername:nil
                                    password:nil];
	
	return _service;
}

- (void)getVideoInfo:(GDataEntryBase *)entry
{
    NSDictionary *infoDict = [[NSMutableDictionary alloc] init];
    NSArray *keysArray = [NSArray arrayWithObjects: @"title", nil];
    infoDict = [entry dictionaryWithValuesForKeys:keysArray];
    NSLog(@"infoDict: %@", infoDict);
}

#pragma mark - View Lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Youtube Requests

- (void)request:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)aFeed error:(NSError *)error {
    
	self.feed = (GDataFeedYouTubeVideo *)aFeed;
	[self.youtubeTable reloadData];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;    
    if (x == 375 || x == 0) {
        if (x > 375 || x == 375) {
            if (!imageViewR.isHidden) {
                [imageViewR setHidden:YES];
            }
            [imageViewL setHidden:NO];
        }
        if (x < 0 || x == 0) {
            if (!imageViewL.isHidden) {
                [imageViewL setHidden:YES];
            }
            [imageViewR setHidden:NO];
        }
    }else {
        [imageViewL setHidden:NO];
        [imageViewR setHidden:NO];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDataEntryBase *entry = [[feed entries] objectAtIndex:indexPath.row];
	NSString *title = [[entry title] stringValue];
    CGSize titleStringSize;
    CGFloat labelHeight = 0.0;
    
    if (title) {
        titleStringSize =[title sizeWithFont: [UIFont boldSystemFontOfSize: 14.0]
                                     constrainedToSize: CGSizeMake(185.0, MAXFLOAT)
                                         lineBreakMode: UILineBreakModeWordWrap];
        labelHeight += titleStringSize.height;
        //self.videoTitle.backgroundColor = [UIColor yellowColor];
    }
    
    /*if (videoMetadata.text) {
        titleStringSize =[videoMetadata.text sizeWithFont: [UIFont boldSystemFontOfSize: 14.0]
                                        constrainedToSize: CGSizeMake(185.0, MAXFLOAT)
                                            lineBreakMode: UILineBreakModeWordWrap];
        
        self.videoMetadata.frame = CGRectMake(self.videoMetadata.frame.origin.x, self.videoTitle.frame.origin.y + self.videoTitle.frame.size.height, self.videoMetadata.frame.size.width, titleStringSize.height);
        labelHeight += titleStringSize.height;
        //self.videoMetadata.backgroundColor = [UIColor redColor];
    }*/
    labelHeight += 50.0;
    
    //NSLog(@"labelHeight: %.2f", labelHeight);
    /*self.backgroundCell.frame = CGRectMake(self.backgroundCell.frame.origin.x, self.backgroundCell.frame.origin.y, self.backgroundCell.frame.size.width, labelHeight + 6);*/
    labelHeight += 6;
    
    //self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, labelHeight + 8);
    labelHeight += 8;
    
    return labelHeight + 10.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[feed entries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"YoutubeCell";
     YoutubeCell *cell = (YoutubeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if (cell == nil) {
         NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YoutubeCell" owner:self options:nil];
         for (id currentObject in topLevelObjects) {
             if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                 cell = (YoutubeCell *)currentObject;
                 break;
             }
         }
     }
    
    // Configure the cell.
	GDataEntryBase *entry = [[feed entries] objectAtIndex:indexPath.row];
    [self getVideoInfo:entry];
    
	NSString *title = [[entry title] stringValue];
	NSArray *thumbnails = [[(GDataEntryYouTubeVideo *)entry mediaGroup] mediaThumbnails];
    cell.videoTitle.text = title;
    //cell.videoMetadata.text = description;
    [cell.videoThumbnail setImageWithURL:[NSURL URLWithString:[[thumbnails objectAtIndex:0] URLString]]
                        placeholderImage:[UIImage imageNamed:@"Hisoka-hunter-x-hunter-23619245-640-538.jpg"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
     
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
