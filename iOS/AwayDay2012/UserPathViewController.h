//
//  UserPathViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostShareViewController.h"

@interface UserPathViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *pathList;
@property(nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *userRecordsCountLabel;
@property(nonatomic, strong) IBOutlet UITableView *userPathTable;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic, strong) PostShareViewController *postShareViewController;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)addPathButtonPressed:(id)sender;
-(IBAction)pathImageButtonPressed:(id)sender;
-(IBAction)handleTapGesture:(UITapGestureRecognizer *)sender;
- (IBAction)sideMenuTapped:(id)sender;

/**
 load user joined sessions
 */
-(void)loadUserActivity;

-(void)deleteUserPathOnServer:(UserPath *)userPath;

@end
