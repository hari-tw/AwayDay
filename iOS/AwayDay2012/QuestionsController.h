//
//  QuestionsController.h
//  AwayDay2012
//
//  Created by Hari B on 11/09/14.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface QuestionsController : UIViewController<UITabBarDelegate,UITableViewDataSource, EGORefreshTableHeaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *questionsView;
@property (weak, nonatomic) NSString *sessionTitle;
@property (weak, nonatomic) NSString *speakerName;
@property (weak, nonatomic) NSString *objectId;
@property(nonatomic, strong) EGORefreshTableHeaderView *refreshView;

-(IBAction) backToSpeakerView;

-(IBAction) askQuestion;


@end
