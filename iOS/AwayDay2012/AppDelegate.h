//
//  AppDelegate.h
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AgendaViewController.h"
//#import "SettingViewController.h"
#import "UserPathViewController.h"
#import "TweetViewController.h"
#import "PathMenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@class NotificationsController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UINavigationController *navigationController;
@property(nonatomic, strong) AgendaViewController *agendaViewController;
//@property(nonatomic, strong) SettingViewController *settingViewController;
@property(nonatomic, strong) PathMenuViewController *menuViewController;
//@property(nonatomic, strong) MenuViewController *menuViewController;
@property(nonatomic, strong) UserPathViewController *userPathViewController;
@property(nonatomic, strong) NSMutableDictionary *userState;
@property(nonatomic, readonly) sqlite3 *database;
@property(nonatomic,strong) CLLocationManager *locationManager;

@property(nonatomic) NotificationsController *notificationsViewController;

/**
 save user's state to the NSUserDefault
 */
-(void)saveUserState;

/*
 hide the bottom menu view
 */
-(void)hideMenuView;

/**
 show the bottom menu view
 */
-(void)showMenuView;

- (NSString *) getDBPath;
- (void) copyDatabaseIfNeeded;
-(void)openDatabase;

@end
