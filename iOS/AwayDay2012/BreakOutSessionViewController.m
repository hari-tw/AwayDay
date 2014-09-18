//
//  BreakOutSessionViewController.m
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import "BreakOutSessionViewController.h"
#import "CustomBreakOutSessionCell.h"
#import "BreakOutSectionHeaderView.h"
#import "BreakOutSectionInfo.h"
#import "CustomSlider.h"
#import "CFShareCircleView.h"
#import "BreakOutSession.h"
#import "TWBreakoutSession.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "TWSpeaker.h"

#define HEADER_HEIGHT 60
#define COMMENT_LABEL_WIDTH 230

@interface BreakOutSessionViewController () <RNFrostedSidebarDelegate, UIScrollViewDelegate, CFShareCircleViewDelegate, CustomBreakOutDelegate> {
    CustomSlider *slider;
}

@property(nonatomic, assign) NSInteger openSectionIndex;
@property(nonatomic, strong) NSMutableArray *breakOutSessionDetails;

@end

@implementation BreakOutSessionViewController {
    NSInteger selectedIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadInfo {

    NSMutableArray *sectionHeaderText = [@[@"Track1", @"Track2", @"Track3"] mutableCopy];
    self.sectionInfoDictionary = [[NSMutableArray alloc] init];

    NSMutableDictionary *trackOneInfo = [[NSMutableDictionary alloc] init];
    trackOneInfo[@"sectionHeaderName"] = sectionHeaderText[0];
    NSMutableArray *emailCellRowHeights = [[NSMutableArray alloc] init];

    NSNumber *rowHeight = @97.0F;
    for (int i = 0; i < [[(self.breakOutSessionDetails)[0] topics] count]; i++) {
        [emailCellRowHeights addObject:rowHeight];
    }
    trackOneInfo[@"rowHeights"] = emailCellRowHeights;
    [self.sectionInfoDictionary addObject:trackOneInfo];


    NSMutableDictionary *trackTwoInfo = [[NSMutableDictionary alloc] init];
    trackTwoInfo[@"sectionHeaderName"] = sectionHeaderText[1];
    NSMutableArray *telephoneCellrowHeight = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[(self.breakOutSessionDetails)[1] topics] count]; i++)
        [telephoneCellrowHeight addObject:rowHeight];

    trackTwoInfo[@"rowHeights"] = telephoneCellrowHeight;
    [self.sectionInfoDictionary addObject:trackTwoInfo];


    NSMutableDictionary *trackThreeInfo = [[NSMutableDictionary alloc] init];
    trackThreeInfo[@"sectionHeaderName"] = sectionHeaderText[2];
    NSMutableArray *byConnectingCellrowHeight = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[(self.breakOutSessionDetails)[2] topics] count]; i++)
        [byConnectingCellrowHeight addObject:rowHeight];

    trackThreeInfo[@"rowHeights"] = byConnectingCellrowHeight;
    [self.sectionInfoDictionary addObject:trackThreeInfo];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    __block NSDictionary *breakoutsByStream;

    [AppHelper showInfoView:self.view withText:@"Loading Data!" withLoading:YES];

    [TWSpeaker findAllInBackgroundWithBlock:^(NSArray *speakers, NSError *error) {

        [TWBreakoutSession findAllInBackgroundWithBlock:^(NSArray *breakouts, NSError *error) {

            self.breakoutSessions = [breakouts mutableCopy];

            self.breakOutSessionDetails = [[NSMutableArray alloc] init];

            NSLog(@"all breakouts");
            if (!error) {
                breakoutsByStream = [TWBreakoutSession groupByStream:breakouts];
                for (NSString *stream in [breakoutsByStream.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
                    BreakOutSession *session = [[BreakOutSession alloc] init];
                    session.trackTopic = stream;
                    session.topics = [breakoutsByStream valueForKey:stream];

                    [self setSpeakersName:speakers session:session];

                    [self.breakOutSessionDetails addObject:session];
                }

                [self loadInfo];

                self.openSectionIndex = NSNotFound;
                [self buildSectionHeaderInfo];

                [self.breakOutSessionTableView reloadData];

                [AppHelper removeInfoView:self.view];
            }
        }

        ];


    }];


}

- (void)buildSectionHeaderInfo {
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.breakOutSessionTableView])) {

        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];

        for (NSMutableArray *array in self.sectionInfoDictionary) {

            BreakOutSectionInfo *sectionInfo = [[BreakOutSectionInfo alloc] init];
            sectionInfo.play = array;
            sectionInfo.open = NO;

            NSInteger countOfTeamNames = [[sectionInfo.play valueForKey:@"rowHeights"] count];
            for (NSInteger i = 0; i < countOfTeamNames; i++) {
                [sectionInfo insertObject:[[sectionInfo.play valueForKey:@"rowHeights"] objectAtIndex:i] inRowHeightsAtIndex:i];
            }

            [infoArray addObject:sectionInfo];
        }
        self.sectionInfoArray = infoArray;
    }
}

- (void)setSpeakersName:(NSArray *)speakers session:(BreakOutSession *)session {
    for (TWBreakoutSession *topic in session.topics) {
        NSString *names = @"";
        for (id speakerId in topic.speakers) {
            NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"objectId = %@", speakerId];
            if ([names length] > 0)
                names = [names stringByAppendingString:@" , "];
            NSArray *spkrs = [speakers filteredArrayUsingPredicate:idPredicate];

            if ([spkrs count] > 0)
                names = [names stringByAppendingString:spkrs[0][@"Name"]];
        }
        topic.Speaker = names;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}


#pragma mark -table view data source method.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSLog(@"_breakOutSessionDetailsCount = %d", self.breakOutSessionDetails.count);
    return self.breakOutSessionDetails.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
//    NSLog(@"%@", sectionInfo);
    NSInteger numStoriesInSection = [[sectionInfo valueForKey:@"rowHeights"] count];

    return sectionInfo.open ? numStoriesInSection : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    static NSString *emailListIdentifier = @"breakOutCellIdentifier";

    CustomBreakOutSessionCell *cell = (CustomBreakOutSessionCell *) [tableView dequeueReusableCellWithIdentifier:emailListIdentifier];
    BreakOutSession *session = (self.breakOutSessionDetails)[(NSUInteger) indexPath.section];

    cell.indexPath = indexPath;
    cell.delegate = self;

    TWBreakoutSession *object = (session.topics)[indexPath.row];
    cell.topicTextLabel.text = [NSString stringWithFormat:@"%@", object.Title];
    cell.topicSpeakerNameTextLabel.text = [NSString stringWithFormat:@"%@", object.Speaker];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];

    cell.timeTextLabel.text = [NSString stringWithFormat:@"Time: %@ ~ %@", [formatter stringFromDate:[self getDate:object.Start]], [formatter stringFromDate:[self getDate:object.End]]];

    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableArray *userJoinList = [appDelegate.userState objectForKey:kUserJoinListKey];

    if (userJoinList != nil && [userJoinList containsObject:object.objectId]) {
        [cell.joinButton setImage:nil forState:UIControlStateNormal];
        [cell.joinButton setImage:[UIImage imageNamed:@"unjoin_button.png"] forState:UIControlStateNormal];
    } else {

        [cell.joinButton setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
    }

    [cell.reminderButton setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if (notification.userInfo != nil && notification.userInfo.count > 0) {
            NSString *sessionID = [notification.userInfo objectForKey:@"session_id"];
            if ([sessionID isEqualToString:object.objectId]) {
                [cell.reminderButton setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
            }
        }
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
        sectionInfo.headerView = [[BreakOutSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.breakOutSessionTableView.bounds.size.width, HEADER_HEIGHT) title:[[self.breakOutSessionDetails objectAtIndex:section] trackTopic] coordinator:[[self.breakOutSessionDetails objectAtIndex:section] captainName] section:section delegate:self];
    }

    return sectionInfo.headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[[[self.sectionInfoDictionary objectAtIndex:indexPath.section] valueForKey:@"rowHeights"] objectAtIndex:indexPath.row] floatValue];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"selected indexPath = %@", indexPath);

    BreakOutSession *session = (self.breakOutSessionDetails)[(NSUInteger) indexPath.section];
    TWBreakoutSession *object = (session.topics)[indexPath.row];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.detailedViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"breakoutDetailIdentifier"];

    [self.detailedViewController setSession:object];
    [self.navigationController pushViewController:self.detailedViewController animated:YES];
}


//#pragma mark Section header delegate

- (void)sectionHeaderView:(BreakOutSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {

    BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
//    NSLog(@"%d", sectionOpened);

    if(sectionInfo)
    {
        sectionInfo.open = YES;
        NSInteger countOfRowsToInsert = [[sectionInfo valueForKey:@"rowHeights"] count];
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
        }

        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];

        NSInteger previousOpenSectionIndex = self.openSectionIndex;
        if (previousOpenSectionIndex != NSNotFound) {

            BreakOutSectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
            previousOpenSection.open = NO;
            [previousOpenSection.headerView toggleOpenWithUserAction:NO];
            NSInteger countOfRowsToDelete = [[previousOpenSection.play valueForKey:@"rowHeights"] count];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
            }
        }

        for (NSIndexPath *index in indexPathsToDelete)
            NSLog(@"%@", index);

        // Style the animation so that there's a smooth flow in either direction.
        UITableViewRowAnimation insertAnimation = nil;
        UITableViewRowAnimation deleteAnimation = nil;
        if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
            insertAnimation = UITableViewRowAnimationFade;
            deleteAnimation = UITableViewRowAnimationFade;
        }
        else {
            insertAnimation = UITableViewRowAnimationFade;
            deleteAnimation = UITableViewRowAnimationFade;
        }

        // Apply the updates.
        [self.breakOutSessionTableView beginUpdates];
        //    [self.breakOutSessionTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:insertAnimation];
        [self.breakOutSessionTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
        [self.breakOutSessionTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
        [self.breakOutSessionTableView endUpdates];
        self.openSectionIndex = sectionOpened;

    }



}

- (void)sectionHeaderView:(BreakOutSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {

    BreakOutSectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];

    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.breakOutSessionTableView numberOfRowsInSection:sectionClosed];

    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.breakOutSessionTableView
                deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    }
    self.openSectionIndex = NSNotFound;
}


- (void)viewDidUnload {

    [self setBreakOutSessionTableView:nil];
    [super viewDidUnload];
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
        case 6: {
            [slider showTweetScreen];
            [sidebar dismiss];

        }
            break;
        case 7: {
            [sidebar dismiss];
            [slider showGameInfoSCreen];

        }
            break;
        default:
            break;
    }

}

#pragma mark - action ethod.

- (IBAction)sideMenuTapped:(id)sender {
    slider = [[CustomSlider alloc] init];
    [slider showSliderMenu];
    slider.callout.delegate = self;
}


- (void)joinTappedAt:(NSIndexPath *)indexPath sender:(id)sender {
    NSLog(@"join tapped at indexPath = %@", indexPath);

    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableArray *userJoinList = [appDelegate.userState objectForKey:kUserJoinListKey];

    UIButton *joinButton = (UIButton *) sender;

    BreakOutSession *session = (self.breakOutSessionDetails)[(NSUInteger) indexPath.section];
    TWBreakoutSession *object = (session.topics)[indexPath.row];


    if ([userJoinList containsObject:object.objectId]) {
        [userJoinList removeObject:object.objectId];
        [joinButton setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
        [AppHelper showInfoView:self.view withText:@"Left!" withLoading:NO];
    } else {
        UserPath *path = [[UserPath alloc] init];
        [path setPathID:[AppHelper generateUDID]];
        [path setPathContent:[NSString stringWithFormat:@"Join %@", object.Title]];
        [path setPathCreateTime:[NSDate date]];
        [path save];

        [userJoinList addObject:object.objectId];
        [joinButton setImage:[UIImage imageNamed:@"unjoin_button.png"] forState:UIControlStateNormal];
        [AppHelper showInfoView:self.view withText:@"Joined!" withLoading:NO];
    }

    [appDelegate saveUserState];

    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];
}

- (void)removeInfoView {

    [AppHelper removeInfoView:self.view];
}

- (void)remindTappedAt:(NSIndexPath *)indexPath sender:(id)sender {
    NSLog(@"remind tapped at indexPath = %@", indexPath);

    BreakOutSession *session = (self.breakOutSessionDetails)[(NSUInteger) indexPath.section];
    TWBreakoutSession *object = (session.topics)[indexPath.row];

    if (self.reminderViewController == nil) {
        ReminderViewController *rvc = [[ReminderViewController alloc] initWithNibName:@"ReminderViewController" bundle:nil];
        self.reminderViewController = rvc;
    }

    NSMutableDictionary *remSession = [[NSMutableDictionary alloc] init];
    remSession[@"title"] = object.Title;
    remSession[@"objectId"] = object.objectId;
    remSession[@"startTime"] = object.Start;

    [self.reminderViewController setSession:remSession];
    [self.navigationController pushViewController:self.reminderViewController animated:YES];
}

- (NSDate *)getDate:(NSString *)dateString {

//    2014-09-20T15:20:00+05:30
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];

    return [dateFormatter2 dateFromString:dateString];
}

@end
