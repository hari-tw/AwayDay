//
//  HomeViewController.h
//  AwayDay2012
//
//  Created by safadmoh on 11/09/13.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class STTwitterAPI;


@interface TweetViewController : UIViewController<UITabBarDelegate,UITableViewDataSource, EGORefreshTableHeaderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *counterTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *feedView;
@property(nonatomic, strong) EGORefreshTableHeaderView *refreshView;

@property(nonatomic, strong) id tweets;

@property(nonatomic, strong) STTwitterAPI *twitter;

- (IBAction)onBurger:(id)sender;

@end
