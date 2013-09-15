//
//  NewAgendaViewController.h
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Agenda.h"
#import "Session.h"
#import "ReminderViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "Reminder.h"

@interface NewAgendaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate>{
    BOOL loading;
}
@property(nonatomic, strong) NSMutableArray *agendaList;
@property(nonatomic, strong) NSMutableArray *reminderList;
@property(nonatomic, strong) NSIndexPath *selectedCell;
@property(nonatomic, strong) ReminderViewController *reminderViewController;
@property(nonatomic, strong) EGORefreshTableHeaderView *refreshView;

@property (weak, nonatomic) IBOutlet UITableView *agendaTableView;

-(IBAction)sideMenuTapped:(id)sender;

/**
 load the agenda list and their sessions
 */
-(void)loadAgendaList;

/**
 update the top session area's UI
 */
-(void)updateTopSession;

///**
// build the common session cell of the table
// */
//-(void)buildSessionCell:(UITableViewCell *)cell withSession:(Session *)session;
//
///**
// build the selection effect of the choosed session
// */
//-(void)buildSessionDetailView:(UITableViewCell *)cell withSession:(Session *)session;

-(NSMutableArray *)checkSessionJoinConflict:(Session *)session;

-(IBAction)joinButtonPressed:(id)sender;
-(IBAction)remindButtonPressed:(id)sender;
-(IBAction)shareButtonPressed:(id)sender;


@end
