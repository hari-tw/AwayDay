//
//  VideoViewController.m
//  YouTubePlayer
//
//  Created by safadmoh on 15/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import "VideoViewController.h"
#import "CustomSlider.h"
#import "CustomVideoCell.h"
#import "Reachability.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HCYoutubeParser.h"
@interface VideoViewController ()<RNFrostedSidebarDelegate>
{
    NSMutableArray *videoURL;
    NSMutableArray *twURL;
    NSMutableArray *videoInfo;
    CustomSlider *slider;
    NSURL *urlString;
    MPMoviePlayerViewController *moviePlayerController;
    NSMutableArray *videoImages;
}

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    videoInfo = [[NSMutableArray alloc]init];
    videoURL = [[NSMutableArray alloc]init];
    videoImages = [[NSMutableArray alloc]init];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)[[self videoCollectionView] collectionViewLayout];
    [flowLayout setMinimumInteritemSpacing:30.0];
    [flowLayout setMinimumLineSpacing:30.0];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        
        
    }
    else
    {
        
        twURL = [[NSMutableArray alloc]initWithObjects:@"http://www.youtube.com/watch?v=Ex2hEG5mwM4",@"http://www.youtube.com/watch?v=QcIQa2VDwEw",@"https://www.youtube.com/watch?v=Zb3MsrpEJDM",nil];
        
        //parsing you tube web page to get video URL.
        for(NSUInteger i=0;i<twURL.count;i++)
        {
            
            NSURL *url = [NSURL URLWithString:[twURL objectAtIndex:i]];
            //_activityIndicator.hidden = NO;
            [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
                
                if(image!=nil)
                    [videoImages addObject:image];
                
                if (!error) {
                    NSDictionary *qualities = [HCYoutubeParser h264videosWithYoutubeURL:url];
                    
                    urlString=[NSURL URLWithString:[qualities objectForKey:@"medium"]];
                    
                    
                    [videoInfo addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:image,urlString,nil] forKeys:[NSArray arrayWithObjects:@"image",@"url",nil]]];
                    
                    if(urlString!=nil)
                        [videoURL addObject:urlString];
                    
                    //if(i==10)
                    {
                        [self.videoCollectionView reloadData];
                    }
                    
                    for(NSDictionary *dict in videoInfo)
             NSLog(@"%@",dict);
             
             
                    
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
        
    }
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UICollection view data source.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return twURL.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"videoCell";
    
    CustomVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.indicatorView startAnimating];
    cell.playButton.hidden=YES;
    [cell.playButton addTarget:self action:@selector(videoButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    if(videoInfo.count>indexPath.item)
    {
        cell.indicatorView.hidden=YES;
        cell.playButton.hidden=NO;
        cell.videoImageView.image= [[videoInfo objectAtIndex:indexPath.item] valueForKey:@"image"];
    }
    return cell;
}



- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320 , 170);
}


#pragma mark -playing video
-(void)videoButtonSelected:(UIButton *)sender
{
    //NSURL *movieURL;
    NSLog(@"%d",sender.tag);
    
    NSLog(@"%@",sender.superview.superview);
    CustomVideoCell *cell=(CustomVideoCell *)sender.superview.superview;
    NSIndexPath *indexPath=[self.videoCollectionView indexPathForCell:cell];
    
    NSLog(@"%d",indexPath.item);
    NSLog(@"%d",videoURL.count);
    if(videoURL.count>=indexPath.item)
    {
        NSURL *url =  [[videoInfo objectAtIndex:indexPath.item] valueForKey:@"url"];
        
        UIGraphicsBeginImageContext(CGSizeMake(1, 1));
        
        moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [[NSNotificationCenter defaultCenter] removeObserver:moviePlayerController
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayerController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPlaybackEndAction:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        
        //MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:_urlToLoad];
        [self presentViewController:moviePlayerController animated:YES completion:nil];
        UIGraphicsEndImageContext();
        
    }
}

#pragma mark --notifcation.
-(void) videoPlaybackEndAction:(NSNotification *)receivedNotification
{
    NSDictionary *userInfo = [receivedNotification userInfo];
    MPMovieFinishReason reason = [[userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (reason == MPMovieFinishReasonUserExited)
    {
        [moviePlayerController.moviePlayer stop];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name: MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [self dismissMoviePlayerViewControllerAnimated]; //Exiting the movie player due to user clicking on "Done" button
        moviePlayerController = nil;
    }
}

#pragma mark -RNFrostedSidebar delegate method.
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    
    switch (index) {
        case 0:
        {
            [slider showHomeScreen];
            [sidebar dismiss];
        }
            break;
            
        case 1:
        {
            [slider showAgendaScreen];
            [sidebar dismiss];
            
        }
            break;
        case 2 :
        {
            [slider showSpeakersScreen];
            [sidebar dismiss];
            
        }
            break;
        case 3 :
        {
            [slider showMapScreen];
            [sidebar dismiss];
            
        }
            break;
        case 4 :
        {
            [slider showMyEventsScreen];
            [sidebar dismiss];
            
        }
            break;
        case 5 :
        {
            [slider showBreakOutSessionScreen];
            [sidebar dismiss];
            
        }
            break;
        case 6 :
        {
            [slider showVideoScreen];
            [sidebar dismiss];
            
        }
            break;
            
        default:
            break;
    }
    
}


- (IBAction)sideMenuTapped:(id)sender
{
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
}



@end
