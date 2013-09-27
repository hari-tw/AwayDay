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
#import <Accounts/Accounts.h>
#import "CFShareCircleView.h"
#import "AppHelper.h"

#import <Social/Social.h>
@interface VideoViewController ()<RNFrostedSidebarDelegate,CFShareCircleViewDelegate>
{
    NSMutableArray *videoInfo;
    CustomSlider *slider;
    NSMutableArray *urlInfo;
    NSURL *urlString;
    MPMoviePlayerViewController *moviePlayerController;
    NSMutableArray *videoImages;
}
@property (nonatomic, strong) CFShareCircleView *shareCircleView;
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
    urlInfo = [[NSMutableArray alloc]init];
    
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)[[self videoCollectionView] collectionViewLayout];
    [flowLayout setMinimumInteritemSpacing:10.0];
    [flowLayout setMinimumLineSpacing:10.0];
    
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
//    {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"video"
                                                             ofType:@"json"];
        
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        
        NSError *error = nil;
        NSLog(@"%@",data);
        id json = [NSJSONSerialization JSONObjectWithData:data
                                                  options:kNilOptions
                                                    error:&error];
        NSLog(@"%@",json);
        for (NSDictionary *video in json)
        {
            
            [videoInfo addObject:video];
        }
   // }
//
//    else
//    {
    
    [AppHelper showInfoView:self.view withText:@"Buffering!" withLoading:YES];
    
       NSMutableArray *twURL = [[NSMutableArray alloc]initWithObjects:@"http://www.youtube.com/watch?v=Ex2hEG5mwM4",@"http://www.youtube.com/watch?v=QcIQa2VDwEw",@"https://www.youtube.com/watch?v=Zb3MsrpEJDM",nil];
        
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
                    
                    NSLog(@"%@",url);
                    
                    
                    
                    urlString=[NSURL URLWithString:[qualities objectForKey:@"medium"]];
                    
                    NSLog(@"%@",urlString);
                    
                    [urlInfo addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:url,urlString, nil] forKeys:[NSArray arrayWithObjects:@"url",@"youtube_url" ,nil]]];
                    if (urlInfo.count==3) {
                        [AppHelper removeInfoView:self.view];
                    }
            
                    
                    if(urlString!=nil)
                      //  [videoURL addObject:urlString];
                    
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
    return videoInfo.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"videoCell";
    
    CustomVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
   // [cell.indicatorView startAnimating];
    //cell.playButton.hidden=YES;
    [cell.playButton addTarget:self action:@selector(videoButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
  
        //cell.indicatorView.hidden=YES;
       // cell.playButton.hidden=NO;
        cell.videoImageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"%@",[[videoInfo objectAtIndex:indexPath.item] valueForKey:@"video_image"]]];
    
    cell.videoHeaderLabel.text=[NSString stringWithFormat:@"%@",[[videoInfo objectAtIndex:indexPath.item] valueForKey:@"video_theme"]];
   
    return cell;
}



- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320 , 160);
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
    //NSLog(@"%d",videoURL.count);
    if(urlInfo.count>indexPath.item)
    {
        NSURL *videoURL;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[videoInfo objectAtIndex:indexPath.item] valueForKey:@"video_url"]]] ;
        for(NSDictionary *dict in urlInfo)
        {
            if([[dict valueForKey:@"url"] isEqual:[url absoluteURL]])
            {
             
                videoURL = [dict valueForKey:@"youtube_url"];
            }
        }
        
        
        UIGraphicsBeginImageContext(CGSizeMake(1, 1));
        
        moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
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
            [slider showBreakOutSessionScreen];
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
            [slider showVideoScreen];
            [sidebar dismiss];

            
        }
            break;
        case 6 :
        {
            [slider showMapScreen];
            [sidebar dismiss];
                       
        }
            break;
        case 7:
        {
            [sidebar dismiss];
            // Do any additional setup after loading the view, typically from a nib.
            self.shareCircleView = [[CFShareCircleView alloc] init];
            self.shareCircleView.delegate = self;
            [self.shareCircleView show];
            
        }
            break;
            
            
            
            
            
        default:
            break;
    }
    
}


- (void)shareCircleView:(CFShareCircleView *)shareCircleView didSelectSharer:(CFSharer *)sharer
{
    NSLog(@"Selected sharer: %@", sharer.name);
    if([sharer.name isEqualToString:@"Twitter"])
        [self postOnTWitterWall];
    else
        [self postOnFacebookWall];
    
}

- (void)shareCircleCanceled:(NSNotification *)notification{
    NSLog(@"Share circle view was canceled.");
}



-(void)postOnFacebookWall
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        NSString *shareText = @"Thoughtworks Away Day-2013!";
        [mySLComposerSheet setInitialText:shareText];
        
        //        [mySLComposerSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50.jpg"]]]];
        
        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];
        
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    
}

-(void)postOnTWitterWall
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        NSString *shareText = @"Thoughtworks Away Day-2013 (27 & 28th September)! ";
        [mySLComposerSheet setInitialText:shareText];
        
        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    
}


- (IBAction)sideMenuTapped:(id)sender
{
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
}



@end
