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
#import "VideoViewController.h"




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
                        [UIImage imageNamed:@"route-map"],
                        [UIImage imageNamed:@"my_schedule"],
                        [UIImage imageNamed:@"breakout-icon"],
                         [UIImage imageNamed:@"gallery"],
                        [UIImage imageNamed:@"share2"],
                        
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        
                        
                        
                        ];
    
    self.callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    //self.callout.delegate = self;
    //    callout.showFromRight = YES;
    [self.callout show];

}





-(void) showHomeScreen
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil ]] animated:YES];
   
}

-(void) showAgendaScreen
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:[[AgendaViewController alloc]initWithNibName:@"RootViewController" bundle:nil ]] animated:YES];

}

-(void) showMapScreen
{
    //UserLocationUtilities *location = [[UserLocationUtilities alloc]init];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",12.969034,77.745137,appDelegate.locationManager.location.coordinate.latitude,appDelegate.locationManager.location.coordinate.longitude];
    
    NSString *escapedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:escapedString];
    [[UIApplication sharedApplication]openURL:url];

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


-(void)showVideoScreen
{
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    VideoViewController *videoViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"videoViewIdentifier"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController pushViewController:videoViewController animated:YES];
    
    
}


@end
