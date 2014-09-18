//
//  ReminderViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//  user uses the view to set a reminder

#import <UIKit/UIKit.h>
#import "TWSession.h"

@interface ReminderViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) NSDictionary *session;
@property(nonatomic, strong) IBOutlet UIImageView *remindIconView;
@property(nonatomic, strong) NSMutableArray *remindTimeKeyArray;
@property(nonatomic, strong) NSMutableDictionary *remindTimeList;
@property(nonatomic, strong) IBOutlet UILabel *remindTimeLabel;
@property(nonatomic, strong) IBOutlet UIPickerView *timePicker;
@property(nonatomic, strong) NSNumber *choosedTime;

-(IBAction)backButtonPressed:(id)sender;

/**
 prepare date for the reminder picker view
 */
-(void)initRemindTimeList;

/**
 cancel the scheduled local notification for the current session
 */
-(void)cancelScheduledNotificationForCurrentSession;

/**
 schedule a new local notification with the timer interval user choosed for the current session
 */
-(void)scheduleNotificationForCurrentSession;

@end
