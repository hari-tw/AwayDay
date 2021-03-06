//
//  ReminderViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//  the Add Reminder view

#import "ReminderViewController.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "Reminder.h"

#define key_notification_session_id @"session_id"
#define key_notification_time_index @"time_index"

@interface ReminderViewController ()

@end

@implementation ReminderViewController
@synthesize session=_session;
@synthesize remindTimeList=_remindTimeList;
@synthesize remindTimeLabel=_remindTimeLabel;
@synthesize choosedTime=_choosedTime;
@synthesize timePicker=_timePicker;
@synthesize remindTimeKeyArray=_remindTimeKeyArray;
@synthesize remindIconView=_remindIconView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.remindTimeList==nil){
        NSMutableDictionary *array=[[NSMutableDictionary alloc]initWithCapacity:0];
        self.remindTimeList=array;
        
        NSMutableArray *keyArray=[[NSMutableArray alloc]initWithCapacity:0];
        self.remindTimeKeyArray=keyArray;
        
        [self initRemindTimeList];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideMenuView];
    
    BOOL found=NO;
    //check if there has been scheduled a reminder for the session
    for(UILocalNotification *notification in [[UIApplication sharedApplication]scheduledLocalNotifications]){
        if(notification.userInfo!=nil && notification.userInfo.count>0){
            NSString *sessionID=[notification.userInfo objectForKey:key_notification_session_id];
            if(sessionID==nil || ![sessionID isKindOfClass:[NSString class]]){
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                continue;
            }
            if([sessionID isEqualToString:self.session[@"objectId"]]){
                found=YES;
                NSNumber *timeIndex=[notification.userInfo objectForKey:key_notification_time_index];
                if(timeIndex!=nil){
                    [self.timePicker selectRow:timeIndex.intValue inComponent:0 animated:NO];
                }
                NSString *key=[self.remindTimeKeyArray objectAtIndex:timeIndex.intValue];
                [self.remindTimeLabel setText:key];
                self.choosedTime=[self.remindTimeList objectForKey:key];
            }
        }
    }
    
    if(!found){
        [self.remindTimeLabel setTextColor:[UIColor darkGrayColor]];
        [self.remindTimeLabel setText:@"No Alarm"];
        [self.timePicker selectRow:0 inComponent:0 animated:NO];
        self.choosedTime=[NSNumber numberWithInt:0];
        [self.remindIconView setImage:[UIImage imageNamed:@"reminder_button.png"]];
    }else{
        [self.remindTimeLabel setTextColor:[UIColor colorWithRed:214/255.0 green:95/255.0 blue:54/255.0 alpha:1.0f]];
        [self.remindIconView setImage:[UIImage imageNamed:@"reminder_button.png"]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showMenuView];
}

#pragma mark - util method
/**
 prepare date for the reminder picker view
 */
-(void)initRemindTimeList{
    [self.remindTimeList removeAllObjects];
    [self.remindTimeKeyArray removeAllObjects];
    
    [self.remindTimeKeyArray addObject:@"No Alarm"];
    [self.remindTimeKeyArray addObject:@"5 Minutes Before"];
    [self.remindTimeKeyArray addObject:@"10 Minutes Before"];
    [self.remindTimeKeyArray addObject:@"30 Minutes Before"];
    [self.remindTimeKeyArray addObject:@"1 Hour Before"];
    
    [self.remindTimeList setObject:[NSNumber numberWithInt:0] forKey:[self.remindTimeKeyArray objectAtIndex:0]];
    [self.remindTimeList setObject:[NSNumber numberWithInt:-5] forKey:[self.remindTimeKeyArray objectAtIndex:1]];
    [self.remindTimeList setObject:[NSNumber numberWithInt:-10] forKey:[self.remindTimeKeyArray objectAtIndex:2]];
    [self.remindTimeList setObject:[NSNumber numberWithInt:-30] forKey:[self.remindTimeKeyArray objectAtIndex:3]];
    [self.remindTimeList setObject:[NSNumber numberWithInt:-60] forKey:[self.remindTimeKeyArray objectAtIndex:4]];
}

/**
 cancel the scheduled local notification for the current session
 */
-(void)cancelScheduledNotificationForCurrentSession{
    for(UILocalNotification *notification in [[UIApplication sharedApplication]scheduledLocalNotifications]){
        if(notification.userInfo!=nil && notification.userInfo.count>0){
            NSString *sessionID=[notification.userInfo objectForKey:key_notification_session_id];
            if([sessionID isEqualToString:self.session[@"objectId"]]){
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
    
    Reminder *reminder=[Reminder getReminderBySessionID:self.session[@"objectId"]];
    if(reminder!=nil){
        [reminder drop];
    }
}

/**
 schedule a new local notification with the timer interval user choosed for the current session
 */
-(void)scheduleNotificationForCurrentSession{
    NSDate *fireDate= [[self getDate:self.session[@"startTime"]] dateByAddingTimeInterval:self.choosedTime.intValue * 60];
    
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc]initWithCapacity:2];
    [userInfo setObject:self.session[@"objectId"] forKey:key_notification_session_id];
    [userInfo setObject:[NSNumber numberWithInt:[self.timePicker selectedRowInComponent:0]] forKey:key_notification_time_index];
    
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    [notification setFireDate:fireDate];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setApplicationIconBadgeNumber:[[UIApplication sharedApplication]applicationIconBadgeNumber]+1];
    
    NSString *text=[self.remindTimeKeyArray objectAtIndex:[self.timePicker selectedRowInComponent:0]];
    text=[text stringByAppendingFormat:@" %@", self.session[@"title"]];
    [notification setAlertBody:text];
    
    [notification setUserInfo:userInfo];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
    Reminder *reminder=[[Reminder alloc]init];
    [reminder setSessionID:self.session[@"objectId"]];
    [reminder setReminderMinute:self.choosedTime];
    [reminder save];
}

-(void)addReminderForSession:(NSTimer *)timer{
    //cancel the last scheduled notification for the session
    [self cancelScheduledNotificationForCurrentSession];
    
    //if user choosed a reminder time, schedule a local notification
    if(self.choosedTime!=nil && self.choosedTime.intValue!=0){
        [self scheduleNotificationForCurrentSession];
    }
    [AppHelper removeInfoView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAction method
-(IBAction)backButtonPressed:(id)sender{
    [AppHelper showInfoView:self.view];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(addReminderForSession:) userInfo:nil repeats:NO];
}

#pragma mark - UIPickerView method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.remindTimeKeyArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *key=[self.remindTimeKeyArray objectAtIndex:row];
    return key;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *key=[self.remindTimeKeyArray objectAtIndex:row];
    self.choosedTime=[self.remindTimeList objectForKey:key];
    [self.remindTimeLabel setText:key];
    
    if(self.choosedTime==nil || self.choosedTime.intValue==0){
        [self.remindTimeLabel setTextColor:[UIColor lightGrayColor]];
        [self.remindIconView setImage:[UIImage imageNamed:@"reminder_button.png"]];
    }else{
        [self.remindTimeLabel setTextColor:[UIColor colorWithRed:214/255.0 green:95/255.0 blue:54/255.0 alpha:1.0f]];
        [self.remindIconView setImage:[UIImage imageNamed:@"reminder_button.png"]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSDate *) getDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy HH:mm"];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];

    return [dateFormatter2 dateFromString:dateString];
}

@end
