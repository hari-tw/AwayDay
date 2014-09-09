//
//  RootViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AgendaViewController.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "AppConstant.h"

//#import "CFShareCircleView.h"
#import <Social/Social.h>
#import "AgendatableViewCell.h"
#import "agendExpandTableViewCell.h"

#import "CustomSlider.h"
#import "CFShareCircleView.h"
#import "TWSession.h"


#define tag_cell_view_start 1001
#define tag_cell_session_title_view tag_cell_view_start+1
#define tag_cell_session_time_view  tag_cell_view_start+2
#define tag_cell_session_detail_title_view 2001
#define tag_cell_view_session_detail_view   10002
#define tag_req_load_session_list   10003

@interface AgendaViewController () <RNFrostedSidebarDelegate, CFShareCircleViewDelegate> {
    CustomSlider *slider;
}
@property(nonatomic, strong) NSMutableIndexSet *optionIndices;

@property(nonatomic, strong) CFShareCircleView *shareCircleView;

@end

NSUInteger selectedRow;
NSUInteger selectedSection;

@implementation AgendaViewController
@synthesize agendaList = _agendaList;
@synthesize topSessionTitleLabel = _topSessionTitleLabel;
@synthesize topSessionDurationLabel = _topSessionDurationLabel;
@synthesize agendaTable = _agendaTable;
@synthesize selectedCell = _selectedCell;
@synthesize reminderViewController = _reminderViewController;
@synthesize clockView = _clockView;
@synthesize topSessionRestTimeLabel = _topSessionRestTimeLabel;
@synthesize refreshView = _refreshView;
@synthesize inputNameViewController = _inputNameViewController;
@synthesize postShareViewController = _postShareViewController;
@synthesize reminderList = _reminderList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.optionIndices = [[NSMutableIndexSet alloc] init];


    self.selectedCell = [NSIndexPath indexPathForRow:-1 inSection:-1];
    loading = NO;

    if (self.refreshView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
        self.refreshView = view;
    }
    [self.refreshView setDelegate:self];
    [self.agendaTable addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];


}


- (void)viewWillAppear:(BOOL)animated {
    selectedRow = -1;
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];


    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSLog(@"%@", NSStringFromCGRect(appDelegate.menuViewController.view.frame));

    NSString *userName = [appDelegate.userState objectForKey:kUserNameKey];
    if (userName == nil || userName.length == 0) {
        //1st lauch, ask for user's name
        if (self.inputNameViewController == nil) {
            InputNameViewController *invc = [[InputNameViewController alloc] init];
            self.inputNameViewController = invc;
        }
        // [self presentModalViewController:self.inputNameViewController animated:NO];
    }

    if (self.agendaList == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.agendaList = array;

        [self loadAgendaList];
    }

    if (self.reminderList != nil) {
        [self.reminderList removeAllObjects];
    }

    self.reminderList = [Reminder getAllReminder];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.agendaList != nil && self.agendaList.count > 0) {
        [self updateTopSession];
    }
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController.view setFrame:CGRectMake(0, 380, 320, 100)];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController hideNavigationMenu];


}

#pragma mark - util method

- (void)removeInfoView {
    [AppHelper removeInfoView:self.view];
}

/**
load the agenda list and their sessions
*/
- (void)loadAgendaList {
    __block NSMutableArray *allSessions = [[NSMutableArray alloc] init];

    [TWSession findAllInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        NSLog(@"after loading the session from parse.. ");
        for (TWSession *twSession in sessions) {
            NSLog(@"twSession = %@", twSession);
        }
        allSessions = sessions;
        NSDictionary *sessionsGroupedByDate = [self groupObjectsInArray:sessions byKey:@"date"];

        NSMutableDictionary *tempAgendaMapping = [[NSMutableDictionary alloc] initWithCapacity:0];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];

        self.agendaList = [[NSMutableArray alloc] init];

        for (NSString *agendaDate in [sessionsGroupedByDate.allKeys sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]) {
            NSLog(@"agendaDate = %@", agendaDate);

            NSDateFormatter *format = [[NSDateFormatter alloc] init];

            [format setDateFormat:@"dd/MM/yyyy"];
            NSDate *date = [format dateFromString:agendaDate];

            Agenda *agenda = [tempAgendaMapping objectForKey:date];
            if (agenda == nil) {
                agenda = [[Agenda alloc] init];
                [agenda setAgendaDate:date];
                [agenda setSessions:sessionsGroupedByDate[agendaDate]];
            }

            [self.agendaList addObject:agenda];
        }

        [self.agendaTable reloadData];
        [self updateTopSession];

        NSLog(@"self.agendaList = %@", self.agendaList);
    }];
}

/**
update the top session area's UI
*/
- (void)updateTopSession {
    if (self.agendaList.count == 0) return;
    NSDate *today = [NSDate date];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyy"];
    NSString *todayString = [df stringFromDate:today];

    int topAgendaIndex = 0;
    int topSessionIndex = 0;

    for (int i = 0; i < self.agendaList.count; i++) {
        Agenda *agenda = [self.agendaList objectAtIndex:i];
        NSString *agendaDateString = [df stringFromDate:agenda.agendaDate];
        NSLog(@"agendaDateString = %@", agendaDateString);
        if ([todayString isEqualToString:agendaDateString]) {
            for (int k = 0; k < agenda.sessions.count; k++) {
                Session *session = [agenda.sessions objectAtIndex:k];
                NSDate *sessionStartTime = session.sessionStartTime;
                if ([[sessionStartTime earlierDate:today] isEqualToDate:today]) {
                    topSessionIndex = k;
                    topAgendaIndex = i;
                    break;
                }
            }
        }
    }

    Agenda *agenda = [self.agendaList objectAtIndex:topAgendaIndex];
    TWSession *session = [agenda.sessions objectAtIndex:topSessionIndex];

    [self.topSessionTitleLabel setText:session.title];
    NSLog(@"%@", session.title);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [self.topSessionDurationLabel setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:[self getDate:session.startTime]], [dateFormatter stringFromDate:[self getDate:session.endTime]]]];

    NSTimeInterval interval = [[self getDate:session.startTime] timeIntervalSinceDate:today];

    if (interval > 0) {
        [self.clockView setRestMinutes:[NSNumber numberWithFloat:interval]];
        [self.clockView setNeedsDisplay];

        int hour = (int) (interval / 3600);
        int min = (int) (fmodf(interval, 3600) / 60);
        [self.topSessionRestTimeLabel setText:[NSString stringWithFormat:@"%d:%d", hour, min]];
    }
}

#pragma mark - UIAction method

- (IBAction)joinButtonPressed:(id)sender {
    //to create a user path
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableArray *userJoinList = [appDelegate.userState objectForKey:kUserJoinListKey];

    UIButton *joinButton = (UIButton *) sender;
    UITableViewCell *cell = [self.agendaTable cellForRowAtIndexPath:self.selectedCell];
    UILabel *sessionTitleLabel = (UILabel *) [cell viewWithTag:tag_cell_session_title_view];
    UILabel *sessionTimeLabel = (UILabel *) [cell viewWithTag:tag_cell_session_time_view];

    Agenda *agenda = [self.agendaList objectAtIndex:self.selectedCell.section];
    TWSession *session = [agenda.sessions objectAtIndex:self.selectedCell.row];

    if ([userJoinList containsObject:session.objectId]) {
        [userJoinList removeObject:session.objectId];
        [joinButton setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
        [sessionTitleLabel setTextColor:[UIColor colorWithRed:78 / 255.0 green:78 / 255.0 blue:78 / 255.0 alpha:1.0f]];
        [sessionTimeLabel setTextColor:[UIColor colorWithRed:78 / 255.0 green:78 / 255.0 blue:78 / 255.0 alpha:1.0f]];
        [AppHelper showInfoView:self.view withText:@"Left!" withLoading:NO];
    } else {
        UserPath *path = [[UserPath alloc] init];
        [path setPathID:[AppHelper generateUDID]];
        [path setPathContent:[NSString stringWithFormat:@"Join %@", session.title]];
        [path setPathCreateTime:[NSDate date]];
        [path save];

        [userJoinList addObject:session.objectId];
        [joinButton setImage:[UIImage imageNamed:@"unjoin_button.png"] forState:UIControlStateNormal];
        [sessionTitleLabel setTextColor:[UIColor colorWithRed:214 / 255.0 green:95 / 255.0 blue:54 / 255.0 alpha:1.0f]];
        [sessionTimeLabel setTextColor:[UIColor colorWithRed:214 / 255.0 green:95 / 255.0 blue:54 / 255.0 alpha:1.0f]];
        [AppHelper showInfoView:self.view withText:@"Joined!" withLoading:NO];
    }

    UITextView *detailTitleView = (UITextView *) [cell viewWithTag:tag_cell_session_detail_title_view];
    if (detailTitleView != nil) {
        [detailTitleView setTextColor:sessionTitleLabel.textColor];
    }

    [appDelegate saveUserState];

    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];
}

- (IBAction)remindButtonPressed:(id)sender {
    Agenda *agenda = [self.agendaList objectAtIndex:self.selectedCell.section];
    Session *session = [agenda.sessions objectAtIndex:self.selectedCell.row];

    if (self.reminderViewController == nil) {
        ReminderViewController *rvc = [[ReminderViewController alloc] initWithNibName:@"ReminderViewController" bundle:nil];
        self.reminderViewController = rvc;
    }
    [self.reminderViewController setSession:session];
    [self.navigationController pushViewController:self.reminderViewController animated:YES];
}

#pragma mark - UITableView method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%d", self.agendaList.count);
    return self.agendaList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Agenda *agenda = [self.agendaList objectAtIndex:section];
    NSLog(@"agenda sessions count %d", agenda.sessions.count);
    return agenda.sessions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedRow == indexPath.row && selectedSection == indexPath.section) {
        return 136;
    } else {
        return 50.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];

    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]]];

    Agenda *agenda = [self.agendaList objectAtIndex:section];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"d"];

    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 24)];
    [monthLabel setBackgroundColor:[UIColor clearColor]];
    [monthLabel setTextColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0f]];
    [monthLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];


    [monthLabel setText:[dateFormatter stringFromDate:agenda.agendaDate]];
    [view addSubview:monthLabel];
    NSLog(@"%@", monthLabel.text);


    [dateFormatter setDateFormat:@"MMM, yyyy"];;
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 180, 24)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTextColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0f]];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    NSString *text = [dateFormatter stringFromDate:agenda.agendaDate];
    text = [text uppercaseString];
    [dateLabel setText:text];
    NSLog(@"%@", dateLabel.text);
    [view addSubview:dateLabel];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    imageView.frame = CGRectMake(10, 38, 300, 1);
    [view addSubview:imageView];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Agenda *agenda = [self.agendaList objectAtIndex:indexPath.section];
    TWSession *session = [agenda.sessions objectAtIndex:indexPath.row];
    if (selectedRow == indexPath.row && selectedSection == indexPath.section) {

        static NSString *CellIdentifier = @"agendaExpandCell";
        agendExpandTableViewCell *cell1 = (agendExpandTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AgendaExpndedCell" owner:self options:nil];
            cell1 = [topLevelObjects objectAtIndex:0];
        }
        cell1.agendaTitleTextLabel.text = session.title;

        cell1.speakerTextLabel.text = session.speaker;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        cell1.timeTextLabel.text = [NSString stringWithFormat:@"Time: %@ ~ %@", [formatter stringFromDate:[self getDate:session.startTime]], [formatter stringFromDate:[self getDate:session.endTime]]];
        cell1.roomTextLabel.text = session.address;


        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSMutableArray *userJoinList = [appDelegate.userState objectForKey:kUserJoinListKey];
        if (userJoinList != nil && [userJoinList containsObject:session.objectId]) {

            [cell1.joinButton setImage:nil forState:UIControlStateNormal];
            [cell1.joinButton setImage:[UIImage imageNamed:@"unjoin_button.png"] forState:UIControlStateNormal];
        } else {

            [cell1.joinButton setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
        }
        [cell1.joinButton addTarget:self action:@selector(joinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


        [cell1.reminderBUtton setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
        for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if (notification.userInfo != nil && notification.userInfo.count > 0) {
                NSString *sessionID = [notification.userInfo objectForKey:@"session_id"];
                if ([sessionID isEqualToString:session.objectId]) {
                    [cell1.reminderBUtton setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
                }
            }
        }

        [cell1.reminderBUtton addTarget:self action:@selector(remindButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


        return cell1;
    }

    else {
        static NSString *CellIdentifier = @"agendaCellIdentifier";

        AgendatableViewCell *cell = (AgendatableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AgendaCustomCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];

        }

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        //[self buildSessionCell:cell withSession:session];

        [cell.timeTextLabel setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:[self getDate:session.startTime]], [dateFormatter stringFromDate:[self getDate:session.endTime]]]];
        [cell.sessionTitleTextLabel setText:session.title];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (selectedRow == indexPath.row && selectedSection == indexPath.section) {
        self.selectedCell = NULL;
        selectedRow = -1;
        selectedSection = -1;
    }
    else {
        selectedRow = indexPath.row;
        selectedSection = indexPath.section;
        self.selectedCell = indexPath;
    }
    //[self.agendaTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.agendaTable reloadData];
}


#pragma mark - Pull Refresh delegate

- (void)reloadTableViewDataSource {
    loading = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];

}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    loading = YES;
    [self loadAgendaList];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return loading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}

#pragma mark - Netowork callback method

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (IBAction)sideMenuTapped:(id)sender {

    slider = [[CustomSlider alloc] init];
    [slider showSliderMenu];
    slider.callout.delegate = self;


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
//        case 6 : {
//            [slider showNotificationScreen];
//            [sidebar dismiss];
//
//        }
            break;
        case 7: {
            [sidebar dismiss];
            // Do any additional setup after loading the view, typically from a nib.
//            self.shareCircleView = [[CFShareCircleView alloc] init];
//            self.shareCircleView.delegate = self;
//            [self.shareCircleView show];
            [slider showGameInfoSCreen];

        }
            break;


        default:
            break;
    }

}


- (NSDictionary *)groupObjectsInArray:(NSArray *)array byKey:(NSString *)key {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    for (id obj in array) {
        id keyValue = [obj valueForKey:key];
        NSMutableArray *arr = dictionary[keyValue];
        if (!arr) {
            arr = [NSMutableArray array];
            dictionary[keyValue] = arr;
        }
        [arr addObject:obj];

    }
    NSLog(@"dictionary = %@", dictionary);
    return [dictionary copy];
}

- (NSDate *) getDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy HH:mm"];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];

    return [dateFormatter2 dateFromString:dateString];
}

@end
