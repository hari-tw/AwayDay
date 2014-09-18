//
//  VideoViewController.m
//  YouTubePlayer
//
//  Created by safadmoh on 15/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomSlider.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CFShareCircleView.h"

@interface HomeViewController () <RNFrostedSidebarDelegate, CFShareCircleViewDelegate> {
    NSMutableArray *videoInfo;
    CustomSlider *slider;
    NSMutableArray *urlInfo;
    NSURL *urlString;
    MPMoviePlayerViewController *moviePlayerController;
    NSMutableArray *videoImages;
}
@property(nonatomic, strong) CFShareCircleView *shareCircleView;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -RNFrostedSidebar delegate method.

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {

    switch (index) {
        case 0: {
            [slider showHomeScreen];
            [sidebar dismiss];
        }
            break;

        case 1: {
            [slider showAgendaScreen];
            [sidebar dismiss];
        }
            break;
        case 2 : {
            [slider showSpeakersScreen];
            [sidebar dismiss];
        }
            break;
        case 3 : {
            [slider showBreakOutSessionScreen];
            [sidebar dismiss];
        }
            break;
        case 4 : {
            [slider showMyEventsScreen];
            [sidebar dismiss];
        }
            break;
        case 5 : {
            [slider showNotificationScreen];
            [sidebar dismiss];
        }
            break;
        case 6 : {
            [slider showTweetScreen];
            [sidebar dismiss];
        }
            break;
        case 7: {
            [sidebar dismiss];
            [slider showGameInfoSCreen];
        }
            break;

        default:
            break;
    }

}

- (IBAction)sideMenuTapped:(id)sender {
    slider = [[CustomSlider alloc] init];
    [slider showSliderMenu];
    slider.callout.delegate = self;
}


@end
