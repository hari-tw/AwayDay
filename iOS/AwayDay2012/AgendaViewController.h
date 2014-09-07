//
//  RootViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//  the view to list the agenda

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AgendaViewController.h"
#import "Agenda.h"
#import "ReminderViewController.h"
#import "TopSessionClockView.h"
#import "EGORefreshTableHeaderView.h"
#import "InputNameViewController.h"
#import "PostShareViewController.h"
#import "Reminder.h"

@interface AgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate>{
    BOOL loading;
}

@property(nonatomic, strong) NSMutableArray *agendaList;
@property(nonatomic, strong) NSMutableArray *reminderList;
@property(nonatomic, strong) IBOutlet UILabel *topSessionTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel *topSessionDurationLabel;
@property(nonatomic, strong) IBOutlet UITableView *agendaTable;
@property(nonatomic, strong) NSIndexPath *selectedCell;
@property(nonatomic, strong) ReminderViewController *reminderViewController;
@property(nonatomic, strong) IBOutlet TopSessionClockView *clockView;
@property(nonatomic, strong) IBOutlet UILabel *topSessionRestTimeLabel;
@property(nonatomic, strong) EGORefreshTableHeaderView *refreshView;
@property(nonatomic, strong) InputNameViewController *inputNameViewController;
@property(nonatomic, strong) PostShareViewController *postShareViewController;


-(IBAction)sideMenuTapped:(id)sender;

/**
 load the agenda list and their sessions
 */
-(void)loadAgendaList;

/**
 update the top session area's UI
 */
-(void)updateTopSession;

/**
 build the common session cell of the table
 */
-(void)buildSessionCell:(UITableViewCell *)cell withSession:(Session *)session;

/**
 build the selection effect of the choosed session
 */
-(void)buildSessionDetailView:(UITableViewCell *)cell withSession:(Session *)session;

-(NSMutableArray *)checkSessionJoinConflict:(Session *)session;

-(IBAction)joinButtonPressed:(id)sender;
-(IBAction)remindButtonPressed:(id)sender;

@end
