//
//  NewAgendaViewController.m
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import "NewAgendaViewController.h"
#import "TopSessionClockView.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "UserPath.h"
#import "ASIHttpRequest.h"
#import "DBService.h"
#import "AFJSONRequestOperation.h"
//#import "CFShareCircleView.h"
#import <Social/Social.h>
#import "RNFrostedSidebar.h"
#import "SpeakersViewController.h"
#import <Accounts/Accounts.h>


@interface NewAgendaViewController ()

@end

@implementation NewAgendaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedCell = [NSIndexPath indexPathForRow:-1 inSection:-1];
    loading = NO;
    
    if (self.refreshView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
        self.refreshView = view;
    }
    [self.refreshView setDelegate:self];
    [self.agendaTableView addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    
//    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    NSLog(@"%@",NSStringFromCGRect(appDelegate.menuViewController.view.frame));
//    
//    NSString *userName = [appDelegate.userState objectForKey:kUserNameKey];
//    if (userName == nil || userName.length == 0) {
//        //1st lauch, ask for user's name
//        if (self.inputNameViewController == nil) {
//            InputNameViewController *invc = [[InputNameViewController alloc] init];
//            self.inputNameViewController = invc;
//        }
//        [self presentModalViewController:self.inputNameViewController animated:NO];
//    }
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAgendaTableView:nil];
    [super viewDidUnload];
}





@end
