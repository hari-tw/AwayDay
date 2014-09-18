//
//  CustomSlider.m
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import "CustomSlider.h"
#import "AppDelegate.h"
#import "SpeakersViewController.h"
#import "AgendaViewController.h"
#import "BreakOutSessionViewController.h"
#import "UserLocationUtilities.h"
#import "HomeViewController.h"
#import <Accounts/Accounts.h>
#import "NotificationsController.h"





@interface CustomSlider () <RNFrostedSidebarDelegate>
@end

@implementation CustomSlider



-(void)showSliderMenu
{
    self.optionIndices=[[NSMutableIndexSet alloc]init];
    
    NSArray *images = @[
                        [UIImage imageNamed:@"home-button"],
                        [UIImage imageNamed:@"agenda"],
                        [UIImage imageNamed:@"speaker_icon"],
                        [UIImage imageNamed:@"breakout-icon"],
                        [UIImage imageNamed:@"my_schedule"],
                        [UIImage imageNamed:@"notification"],
                        [UIImage imageNamed:@"twitter-icon"],
                        
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        
                       // [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        
                        
                        
                        ];
    
    self.callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    //self.callout.delegate = self;
    //    callout.showFromRight = YES;
    [self.callout show];

}





-(void)showTweetScreen
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:[[TweetViewController alloc]initWithNibName:@"TweetViewController" bundle:nil ]] animated:YES];
   
}

-(void) showAgendaScreen
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:[[AgendaViewController alloc]initWithNibName:@"RootViewController" bundle:nil ]] animated:YES];

}

-(void)showNotificationScreen
{
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NotificationsController *videoViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"gameViewIdentifier"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController pushViewController:videoViewController animated:YES];
}

-(void) showSpeakersScreen
{
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SpeakersViewController *speakerViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"speakersViewIdentifier"];
     AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController pushViewController:speakerViewController animated:YES];

    
}

-(void) showMyEventsScreen
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.userPathViewController] animated:YES];
    
}


-(void) showBreakOutSessionScreen
{
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BreakOutSessionViewController *breakOutSessionViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"breakOutViewIdentifer"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController pushViewController:breakOutSessionViewController animated:YES];
}


-(void)showHomeScreen
{
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    HomeViewController *videoViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeViewIdentifier"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController pushViewController:videoViewController animated:YES];

}

-(void)showGameInfoSCreen
{
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NotificationsController *videoViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"gameViewIdentifier"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController pushViewController:videoViewController animated:YES];
    
}




@end
