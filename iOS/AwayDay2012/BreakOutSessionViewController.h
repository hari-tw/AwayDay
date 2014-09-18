//
//  BreakOutSessionViewController.h
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import <UIKit/UIKit.h>

@class ReminderViewController;

#import "BreakOutDetailViewController.h"

@interface BreakOutSessionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//Properties.
@property (strong,nonatomic) NSMutableArray *sectionHeaderTitles;
@property (strong,nonatomic) NSMutableArray *sectionInfoArray;
@property (strong,nonatomic) NSMutableArray *sectionInfoDictionary;

//IBoutlets.
@property (weak, nonatomic) IBOutlet UITableView *breakOutSessionTableView;


@property(nonatomic) ReminderViewController *reminderViewController;

@property(nonatomic, strong) BreakOutDetailViewController *detailedViewController;

@property(nonatomic, strong) NSMutableArray *breakoutSessions;

//Action method.
- (IBAction)sideMenuTapped:(id)sender;

@end
