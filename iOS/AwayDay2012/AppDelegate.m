//
//  AppDelegate.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//  the Agenda View

#import "AppDelegate.h"
#import "AppConstant.h"
#import "TWNotification.h"
#import "NotificationsController.h"
#import "TWQuestion.h"

#import <Crashlytics/Crashlytics.h>

#define away_day_user_state_key @"away_day_2012_user_state"
#define away_day_user_db_name   @"user_db.sqlite"

@implementation AppDelegate

@synthesize window = _window;
@synthesize agendaViewController = _agendaViewController;
@synthesize userState = _userState;
@synthesize navigationController = _navigationController;
@synthesize menuViewController = _menuViewController;
//@synthesize settingViewController=_settingViewController;
@synthesize userPathViewController = _userPathViewController;
@synthesize database;

- (void)dealloc {
    sqlite3_close(database);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [TWSession registerSubclass];
    [TWNotification registerSubclass];
    [TWQuestion registerSubclass];
    [Parse setApplicationId:@"cRkqJtkVvjyuC5pvKRzLNz8CFm6WgrbPqX0uKX7a"
                  clientKey:@"o4Dr0m1oV8PBWw0DQSeaYmd9T3LSayKIPJCkbIxd"];

    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100
    [self.locationManager startUpdatingLocation];


//    [Crashlytics startWithAPIKey:@"12cf69bcd58555af123af07396580d08d970eee1"];



    [self copyDatabaseIfNeeded];
    [self openDatabase];
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];

    //restore user state
    NSMutableDictionary *tmpDic = [[NSUserDefaults standardUserDefaults] objectForKey:away_day_user_state_key];
    if (tmpDic != nil) {
        self.userState = tmpDic;
    }
    if (self.userState == nil) {
        //1st launch
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        self.userState = dic;

        NSMutableArray *userJoinList = [[NSMutableArray alloc] initWithCapacity:0];
        [self.userState setObject:userJoinList forKey:kUserJoinListKey];
    }

    if (self.agendaViewController == nil) {
        AgendaViewController *rvc = [[AgendaViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
        self.agendaViewController = rvc;
    }
    
    if (self.notificationsViewController == nil) {
        UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        NotificationsController *videoViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"gameViewIdentifier"];
        self.notificationsViewController = videoViewController;
    }

    if (self.userPathViewController == nil) {
        UserPathViewController *uavc = [[UserPathViewController alloc] initWithNibName:@"UserPathViewController" bundle:nil];
        self.userPathViewController = uavc;
    }

    if (self.navigationController == nil) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil]];
        nav.navigationBar.hidden = YES;
        self.navigationController = nav;
    }

    [self.window addSubview:self.navigationController.view];

    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    if(!launchOptions){
        NSLog(@"App invoked directly");
    }
    else {
        NSLog(@"Launch options  %@", launchOptions );
        [self.navigationController pushViewController:self.notificationsViewController animated:YES];
    }
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.window.clipsToBounds =YES;
//        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
//        
//        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
//    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits

    //save user state
    [self saveUserState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


#pragma mark - util method

/**
save user's state to the NSUserDefault
*/
- (void)saveUserState {
    [[NSUserDefaults standardUserDefaults] setObject:self.userState forKey:away_day_user_state_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 hide the bottom menu view
 */
- (void)hideMenuView {
    [self.menuViewController.view setFrame:CGRectMake(0, 480, self.menuViewController.view.frame.size.width, self.menuViewController.view.frame.size.height)];
}

/**
show the bottom menu view
*/
- (void)showMenuView {
    [self.menuViewController.view setFrame:CGRectMake(0, 450, self.menuViewController.view.frame.size.width, self.menuViewController.view.frame.size.height)];
}

- (NSString *)getDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:away_day_user_db_name];
}

- (void)copyDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:away_day_user_db_name];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];

        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}

- (void)openDatabase {
    NSString *databaseName = away_day_user_db_name;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
//    NSLog(@"%@", databasePath);
    sqlite3_open([databasePath UTF8String], &database);
}


- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {

    NSMutableDictionary *md = [NSMutableDictionary dictionary];

    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];

    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;

        NSString *key = pair[0];
        NSString *value = pair[1];

        md[key] = value;
    }

    return md;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([[url scheme] isEqualToString:@"awaydayapp"] == NO) return NO;

    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];

    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];

    NSLog(@"token = %@", token);
    NSLog(@"verifier = %@", verifier);

    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:token forKey:@"token"];
    [defaults setObject:verifier forKey:@"verifier"];

    [defaults synchronize];

    return YES;
}

@end
