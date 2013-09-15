//
//  ViewController.m
//  PathMenuExample
//
//  Created by Tobin Schwaiger-Hastanan on 1/9/12.
//  Copyright (c) 2012 Tobin Schwaiger-Hastanan. All rights reserved.
//

#import "PathMenuViewController.h"
#import "AppDelegate.h"
//#import "ExpandableNavigation.h"

@implementation PathMenuViewController

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize main;
@synthesize navigation;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
       
    // initialize ExpandableNavigation object with an array of buttons.
    NSArray* buttons = [NSArray arrayWithObjects:button1, button2,button3 ,nil];// button3, button4, button5, nil];
    
//    self.navigation = [[ExpandableNavigation alloc] initWithMenuItems:buttons mainButton:self.main radius:80.0] ;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.main = nil;    
    self.navigation = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only support portriat orientation for now
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) touchMenuItem:(id)sender {
    
    // if the menu is expanded, then collapse it when an menu item is touched.
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
//                                                       message:[(UIButton *)sender currentTitle]
//                                                      delegate:nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//    [message show];
    
    if([[(UIButton *)sender currentTitle] isEqualToString:@"agenda"])
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.agendaViewController] animated:YES];
        
    }
    else if([[(UIButton *)sender currentTitle] isEqualToString:@"path"])
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.userPathViewController] animated:YES];
    }
    
    else
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.settingViewController] animated:YES];
        
    }
    
    [self hideNavigationMenu];
    
    
    
}

-(void)hideNavigationMenu
{
//    if( self.navigation.expanded ) {
//        [self.navigation collapse];
//    }
//    
}

@end
