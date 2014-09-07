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
#import "DBService.h"
#import "AFJSONRequestOperation.h"

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
    __block NSMutableArray *allSessions = [[NSMutableArray alloc]init];
//    allSessions = [DBService getLocalAgendaList];

    [TWSession findAllInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        NSLog(@"after loading the session from parse.. ");
        for (TWSession *twSession in sessions) {
            NSLog(@"twSession = %@", twSession);
        }
        allSessions = sessions;
    }];

    NSMutableDictionary *tempAgendaMapping = [[NSMutableDictionary alloc] initWithCapacity:0];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (Session *session in allSessions) {
        NSString *sessionDateStr = [dateFormatter stringFromDate:session.sessionStartTime];
        Agenda *agenda = [tempAgendaMapping objectForKey:sessionDateStr];
        if (agenda == nil) {
            agenda = [[Agenda alloc] init];
            [agenda setAgendaDate:session.sessionStartTime];

            NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
            [agenda setSessions:list];
        }
        [agenda.sessions addObject:session];
        [tempAgendaMapping setObject:agenda forKey:sessionDateStr];
    }

    [self.agendaList addObjectsFromArray:tempAgendaMapping.allValues];

    [self getAgendaListFromServer:(NSString *) kServiceLoadSessionList showLoading:YES];
}

- (void)getAgendaListFromServer:(NSString *)urlString showLoading:(BOOL)showLoading {
    loading = YES;

    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url = %@", urlString);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    AFJSONRequestOperation *requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                                   NSLog(@"success response:%@", JSON);
                                                                                                   [self handleAgendaListRequestSuccess:JSON];
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                   NSLog(@"fail response:%@", JSON);
                                                                                                   [self handleAgendaListRequestFailure:error];
                                                                                               }
    ];
    [requestOperation start];

    if (showLoading) {
        [AppHelper showInfoView:self.view withText:@"Loading..." withLoading:YES];
    }
}

- (NSMutableArray *)checkSessionJoinConflict:(Session *)session {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableArray *userJoinList = (NSMutableArray *) [appDelegate.userState objectForKey:kUserJoinListKey];
    NSMutableArray *joinedSessionList = [DBService getSessionListBySessionIDList:userJoinList];
    if (joinedSessionList == nil || joinedSessionList.count == 0) return nil;


    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    for (Session *joinedSession in joinedSessionList) {
        NSDate *joinedSessionStart = joinedSession.sessionStartTime;
        NSDate *joinedSessionEnd = joinedSession.sessionEndTime;

        if ([[joinedSessionStart laterDate:session.sessionEndTime] isEqualToDate:session.sessionEndTime] ||
                [[joinedSessionEnd earlierDate:session.sessionStartTime] isEqualToDate:joinedSessionEnd]) {
            [result addObject:joinedSession];
        }
    }

    return result;
}

/**
update the top session area's UI
*/
- (void)updateTopSession {
    if (self.agendaList.count == 0) return;
    NSDate *today = [NSDate date];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [df stringFromDate:today];

    int topAgendaIndex = 0;
    int topSessionIndex = 0;

    for (int i = 0; i < self.agendaList.count; i++) {
        Agenda *agenda = [self.agendaList objectAtIndex:i];
        NSString *agendaDateString = [df stringFromDate:agenda.agendaDate];
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
    Session *session = [agenda.sessions objectAtIndex:topSessionIndex];
//    NSIndexPath *path=[NSIndexPath indexPathForRow:topSessionIndex inSection:topAgendaIndex];

//    [self.agendaTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [self.topSessionTitleLabel setText:session.sessionTitle];
    NSLog(@"%@", session.sessionTitle);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [self.topSessionDurationLabel setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:session.sessionStartTime], [dateFormatter stringFromDate:session.sessionEndTime]]];

    NSTimeInterval interval = [session.sessionStartTime timeIntervalSinceDate:today];

    if (interval > 0) {
        [self.clockView setRestMinutes:[NSNumber numberWithFloat:interval]];
        [self.clockView setNeedsDisplay];

        int hour = (int) (interval / 3600);
        int min = (int) (fmodf(interval, 3600) / 60);
        [self.topSessionRestTimeLabel setText:[NSString stringWithFormat:@"%d:%d", hour, min]];
    }
}

/**
build the common session cell of the table
*/
- (void)buildSessionCell:(UITableViewCell *)cell withSession:(Session *)session {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableArray *userJoinList = [appDelegate.userState objectForKey:kUserJoinListKey];

    UILabel *sessionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 230, 30)];
    [sessionTitle setTag:tag_cell_session_title_view];
    [sessionTitle setBackgroundColor:[UIColor clearColor]];
    [sessionTitle setTextColor:[UIColor colorWithRed:78 / 255.0 green:78 / 255.0 blue:78 / 255.0 alpha:1.0f]];


    if ([userJoinList containsObject:session.sessionID]) {
        [sessionTitle setTextColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0f]];
    }

    [sessionTitle setFont:[UIFont systemFontOfSize:16.0f]];
    [sessionTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
    [sessionTitle setText:session.sessionTitle];
    [cell addSubview:sessionTitle];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    UILabel *sessionDuration = [[UILabel alloc] initWithFrame:CGRectMake(240, 10, 75, 30)];
    [sessionDuration setTag:tag_cell_session_time_view];
    [sessionDuration setBackgroundColor:[UIColor clearColor]];
    [sessionDuration setTextColor:[UIColor colorWithRed:78 / 255.0 green:78 / 255.0 blue:78 / 255.0 alpha:1.0f]];

    if ([userJoinList containsObject:session.sessionID]) {
        [sessionDuration setTextColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0f]];
    }

    NSDate *today = [NSDate date];
    if ([[today earlierDate:session.sessionEndTime] isEqualToDate:session.sessionEndTime]) {
        [sessionTitle setTextColor:[UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1.0f]];
        [sessionDuration setTextColor:[UIColor colorWithRed:170 / 255.0 green:170 / 255.0 blue:170 / 255.0 alpha:1.0f]];
    }

    [sessionDuration setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [sessionDuration setShadowColor:[UIColor colorWithRed:120 / 255.0 green:120 / 255.0 blue:120 / 255.0 alpha:120 / 255.0]];
    [sessionDuration setShadowOffset:CGSizeMake(-0.1f, -0.1f)];
    [sessionDuration setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:session.sessionStartTime], [dateFormatter stringFromDate:session.sessionEndTime]]];
    [cell addSubview:sessionDuration];
}

/**
build the selection effect of the choosed session
*/
- (void)buildSessionDetailView:(UITableViewCell *)cell withSession:(Session *)session {
    CGSize size = [session.sessionNote sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(320, 100) lineBreakMode:UILineBreakModeWordWrap];
    CGSize titleSize = [session.sessionTitle sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(310, 100)];
    float height = 125 + titleSize.height + size.height - 30;

    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    [detailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]]];
    [detailView setTag:tag_cell_view_session_detail_view];

    int y = 8;
    UILabel *view = (UILabel *) [cell viewWithTag:tag_cell_session_title_view];
    UITextView *sessionTitle = [[UITextView alloc] initWithFrame:CGRectMake(8, y, 310, titleSize.height + 10)];
    [sessionTitle setTag:tag_cell_session_detail_title_view];
    [sessionTitle setBackgroundColor:[UIColor clearColor]];
    [sessionTitle setText:session.sessionTitle];
    [sessionTitle setTextColor:view.textColor];
    [sessionTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
    [sessionTitle setUserInteractionEnabled:NO];
    [detailView addSubview:sessionTitle];
    y += sessionTitle.frame.size.height;

    UILabel *sessionSpeaker = [[UILabel alloc] initWithFrame:CGRectMake(14, y + 3, 320, 16)];
    [sessionSpeaker setBackgroundColor:[UIColor clearColor]];
    [sessionSpeaker setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [sessionSpeaker setTextColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0f]];

    if (![session.sessionSpeaker isEqualToString:@""]) {
        [sessionSpeaker setText:[NSString stringWithFormat:@"Speaker: %@", session.sessionSpeaker]];
    }
    else {
        sessionSpeaker.hidden = YES;
    }
    [detailView addSubview:sessionSpeaker];
    y += sessionSpeaker.frame.size.height;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    UILabel *sessionTime = [[UILabel alloc] initWithFrame:CGRectMake(14, y + 3, 110, 16)];
    [sessionTime setBackgroundColor:[UIColor clearColor]];
    [sessionTime setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [sessionTime setTextColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0f]];
    [sessionTime setText:[NSString stringWithFormat:@"Time: %@ ~ %@", [formatter stringFromDate:session.sessionStartTime], [formatter stringFromDate:session.sessionEndTime]]];
    [detailView addSubview:sessionTime];

    y += sessionTime.frame.size.height;
    UILabel *sessionLocation = [[UILabel alloc] initWithFrame:CGRectMake(14, y + 3, 290, 16)];
    [sessionLocation setBackgroundColor:[UIColor clearColor]];
    [sessionLocation setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [sessionLocation setTextColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0f]];
    [sessionLocation setText:[NSString stringWithFormat:@"Room: %@", session.sessionAddress]];
    [detailView addSubview:sessionLocation];
    y += sessionLocation.frame.size.height;

    UITextView *sessionNote = [[UITextView alloc] initWithFrame:CGRectMake(0, y, 320, 100)];
    [sessionNote setBackgroundColor:[UIColor clearColor]];
    [sessionNote setUserInteractionEnabled:YES];
    [sessionNote setEditable:NO];
    [sessionNote setFrame:CGRectMake(0, y, 320, size.height + 14)];
    [sessionNote setText:session.sessionNote];
    [sessionNote setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [sessionNote setTextColor:[UIColor colorWithRed:120 / 255.0 green:120 / 255.0 blue:120 / 255.0 alpha:1.0f]];
    [sessionNote sizeToFit];
    y += sessionNote.frame.size.height;
    [detailView addSubview:sessionNote];

    y += 3;

//    UIView *transparentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
//    transparentTopView.alpha=0.2f;
//    transparentTopView.backgroundColor=[UIColor blackColor];
//    [detailView addSubview:transparentTopView];
//    
    UIButton *attend = [UIButton buttonWithType:UIButtonTypeCustom];
    [attend setFrame:CGRectMake(280, 10, 35, 35)];

    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableArray *userJoinList = [appDelegate.userState objectForKey:kUserJoinListKey];
    if (userJoinList != nil && [userJoinList containsObject:session.sessionID]) {
        [attend setImage:[UIImage imageNamed:@"unjoin_button.png"] forState:UIControlStateNormal];
    } else {
        [attend setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
    }
    [attend addTarget:self action:@selector(joinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:attend];

    UIButton *remind = [UIButton buttonWithType:UIButtonTypeCustom];
    [remind setFrame:CGRectMake(280, 60, 35, 35)];

    [remind setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if (notification.userInfo != nil && notification.userInfo.count > 0) {
            NSString *sessionID = [notification.userInfo objectForKey:@"session_id"];
            if ([sessionID isEqualToString:session.sessionID]) {
                [remind setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
            }
        }
    }

    [remind addTarget:self action:@selector(remindButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:remind];

//    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
//    [share setFrame:CGRectMake(234, y, 35, 35)];
//    [share setImage:[UIImage imageNamed:@"share_button.png"] forState:UIControlStateNormal];
//    [share addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [detailView addSubview:share];

    CATransition *transition = [CATransition animation];
    transition.duration = 0.15f;
    [detailView.layer addAnimation:transition forKey:@"add"];
    [cell addSubview:detailView];

    NSLog(@"%@", NSStringFromCGRect(detailView.frame));

    float detaily = self.selectedCell.row * 50 + detailView.frame.size.height;
    float tabley = self.agendaTable.contentOffset.y + self.agendaTable.frame.size.height;
    if (detaily > tabley) {
        [self.agendaTable setContentOffset:CGPointMake(0, self.agendaTable.contentOffset.y + (detaily - tabley) + 40) animated:YES];
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
    Session *session = [agenda.sessions objectAtIndex:self.selectedCell.row];

    NSMutableArray *conflictList = [self checkSessionJoinConflict:session];
    if (conflictList != nil && conflictList.count > 0) {
        //need to handle session confiction
    }

    if ([userJoinList containsObject:session.sessionID]) {
        [userJoinList removeObject:session.sessionID];
        [joinButton setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
        [sessionTitleLabel setTextColor:[UIColor colorWithRed:78 / 255.0 green:78 / 255.0 blue:78 / 255.0 alpha:1.0f]];
        [sessionTimeLabel setTextColor:[UIColor colorWithRed:78 / 255.0 green:78 / 255.0 blue:78 / 255.0 alpha:1.0f]];
        [AppHelper showInfoView:self.view withText:@"Left!" withLoading:NO];
    } else {
        UserPath *path = [[UserPath alloc] init];
        [path setPathID:[AppHelper generateUDID]];
        [path setPathContent:[NSString stringWithFormat:@"Join %@", session.sessionTitle]];
        [path setPathCreateTime:[NSDate date]];
        [path save];

        [userJoinList addObject:session.sessionID];
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

- (IBAction)shareButtonPressed:(id)sender {
//    NSLog(@"%@",sender.superview.superview);
//    UITableViewCell *cell=(UITableViewCell *)sender.superview.superview;
//    NSIndexPath *indexPath=[self.agendaTable indexPathForCell:cell];

    self.shareCircleView = [[CFShareCircleView alloc] init];
    self.shareCircleView.delegate = self;
    [self.shareCircleView show];


}

- (void)authorizeWeibo {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"email,direct_messages_write";
    [WeiboSDK sendRequest:request];
}

- (void)displayPostShareVC {
    if (self.postShareViewController == nil) {
        PostShareViewController *psvc = [[PostShareViewController alloc] initWithNibName:@"PostShareViewController" bundle:nil];
        self.postShareViewController = psvc;
    }

    Agenda *agenda = [self.agendaList objectAtIndex:self.selectedCell.section];
    Session *session = [agenda.sessions objectAtIndex:self.selectedCell.row];
    [self.postShareViewController setSession:session];
    [self.navigationController pushViewController:self.postShareViewController animated:YES];
}

#pragma mark - UITableView method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSLog(@"%d", self.agendaList.count);
    return self.agendaList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Agenda *agenda = [self.agendaList objectAtIndex:section];
    NSLog(@"%d", agenda.sessions.count);
    return agenda.sessions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == self.selectedCell.section && indexPath.row == self.selectedCell.row) {
//        Agenda *agenda = [self.agendaList objectAtIndex:self.selectedCell.section];
//        Session *session = [agenda.sessions objectAtIndex:self.selectedCell.row];
//        CGSize size = [session.note sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(320, 100) lineBreakMode:UILineBreakModeWordWrap];
//        CGSize titleSize = [session.title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(310, 100)];
//        float height = 126 + titleSize.height + size.height;
//        //return height-30;
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
    Session *session = [agenda.sessions objectAtIndex:indexPath.row];
    if (selectedRow == indexPath.row && selectedSection == indexPath.section) {

        static NSString *CellIdentifier = @"agendaExpandCell";
        agendExpandTableViewCell *cell1 = (agendExpandTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell1 == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AgendaExpndedCell" owner:self options:nil];
            cell1 = [topLevelObjects objectAtIndex:0];
        }
        cell1.agendaTitleTextLabel.text = session.sessionTitle;

        cell1.speakerTextLabel.text = session.sessionSpeaker;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        cell1.timeTextLabel.text = [NSString stringWithFormat:@"Time: %@ ~ %@", [formatter stringFromDate:session.sessionStartTime], [formatter stringFromDate:session.sessionEndTime]];
        cell1.roomTextLabel.text = session.sessionAddress;


        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSMutableArray *userJoinList = [appDelegate.userState objectForKey:kUserJoinListKey];
        if (userJoinList != nil && [userJoinList containsObject:session.sessionID]) {

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
                if ([sessionID isEqualToString:session.sessionID]) {
                    [cell1.reminderBUtton setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
                }
            }
        }

        [cell1.reminderBUtton addTarget:self action:@selector(remindButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


        return cell1;
    }



        //[self buildSessionDetailView:cell1 withSession:session];

    else {
        static NSString *CellIdentifier = @"agendaCellIdentifier";

        AgendatableViewCell *cell = (AgendatableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AgendaCustomCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];

        }

//    for (UIView *view in cell.subviews) {
//       if (view.tag >= tag_cell_view_start) {
//            [view removeFromSuperview];
//       }
//    }


//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell.backgroundView setBackgroundColor:[UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0f]];




        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        //[self buildSessionCell:cell withSession:session];

        [cell.timeTextLabel setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:session.sessionStartTime], [dateFormatter stringFromDate:session.sessionEndTime]]];
        [cell.sessionTitleTextLabel setText:session.sessionTitle];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *lastSelectedCell = [self.agendaTable cellForRowAtIndexPath:self.selectedCell];
//    if (lastSelectedCell != nil) {
//        if ([lastSelectedCell viewWithTag:tag_cell_view_session_detail_view] != nil) {
//            [[lastSelectedCell viewWithTag:tag_cell_view_session_detail_view] removeFromSuperview];
//        }
//    }
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
    [self getAgendaListFromServer:(NSString *) kServiceLoadSessionList showLoading:YES];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return loading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}

#pragma mark - Netowork callback method

- (void)handleAgendaListRequestSuccess:(NSArray *)agendaList {

    //if (self.agendaList.count > 0) {
    [self.agendaList removeAllObjects];
    for (NSDictionary *object in agendaList) {
        [DBService deleteAllSessions];
        NSLog(@"%@", object);

        Agenda *agenda = [Agenda createAgenda:object];
        [self.agendaList addObject:agenda];
        NSLog(@"%d", self.agendaList.count);
        [DBService saveSessionList:agenda.sessions];
        [self.agendaTable reloadData];
        [self updateTopSession];
    }

    // }
    loading = NO;
    [AppHelper removeInfoView:self.view];

    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agendaTable];
}

- (void)handleAgendaListRequestFailure:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    [AppHelper removeInfoView:self.view];
    loading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agendaTable];
    //[AppHelper showInfoView:self.view withText:@"Failed" withLoading:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];
}

/*
- (void)requestFinished:(ASIHTTPRequest *)request {
//    NSLog(@"%@", request.responseString);
    if (request.tag == tag_req_load_session_list) {

        NSString *resp = [request responseString];
        resp = [resp stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        resp = [resp stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];

        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableArray *receivedObjects = [parser objectWithString:resp];

        if (receivedObjects.count > 0) {
            [self.agendaList removeAllObjects];
            [DBService deleteAllSessions];

            for (NSDictionary *object in receivedObjects) {
                Agenda *agenda = [Agenda createAgenda:object];
                [self.agendaList addObject:agenda];
                [DBService saveSessionList:agenda.sessions];
            }

            [self.agendaTable reloadData];
            [self updateTopSession];
        }

        loading = NO;
        [AppHelper removeInfoView:self.view];

        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agendaTable];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    if (request.tag == tag_req_load_session_list) {
        NSLog(@"%@", [request.error localizedDescription]);
        [AppHelper removeInfoView:self.view];
        loading = NO;
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agendaTable];
        [AppHelper showInfoView:self.view withText:@"Failed" withLoading:NO];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];
    }
}*/

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)postOnFacebookWall {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {

        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];


        NSString *shareText = @"Thoughtworks Away Day-2013!";
        [mySLComposerSheet setInitialText:shareText];

        //        [mySLComposerSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50.jpg"]]]];

        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];


        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];

        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {

            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];

        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }


}

- (void)postOnTWitterWall {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {

        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];


        NSString *shareText = @"Thoughtworks Away Day-2013 (27 & 28th September)! ";
        [mySLComposerSheet setInitialText:shareText];

        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];

        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];

        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {

            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];

        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }


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
            [slider showVideoScreen];
            [sidebar dismiss];


        }
            break;
        case 6 : {
            [slider showMapScreen];
            [sidebar dismiss];

        }
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


- (void)shareCircleView:(CFShareCircleView *)shareCircleView didSelectSharer:(CFSharer *)sharer {
    NSLog(@"Selected sharer: %@", sharer.name);
    if ([sharer.name isEqualToString:@"Twitter"])
        [self postOnTWitterWall];
    else
        [self postOnFacebookWall];

}

- (void)shareCircleCanceled:(NSNotification *)notification {
    NSLog(@"Share circle view was canceled.");
}


@end
