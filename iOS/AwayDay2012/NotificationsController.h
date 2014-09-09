//
//  NotificationsController.h
//  AwayDay2012
//
//  Created by safadmoh on 24/09/13.
//
//

#import <UIKit/UIKit.h>

@interface NotificationsController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;

//Action m
- (IBAction)sideMenuTapped:(id)sender;

@end
