//
//  BreakOutSessionViewController.h
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import <UIKit/UIKit.h>

@interface BreakOutSessionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *sectionHeaderTitles;
@property (strong,nonatomic) NSMutableArray *sectionInfoArray;
@property (strong,nonatomic) NSMutableArray *sectionInfoDictionary;

@property (weak, nonatomic) IBOutlet UITableView *breakOutSessionTableView;

- (IBAction)sideMenuTapped:(id)sender;

@end
