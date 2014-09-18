//
//  BreakOutDetailViewController.h
//  AwayDay2012
//
//  Created by Hari B on 17/09/14.
//
//

#import <UIKit/UIKit.h>

@class TWBreakoutSession;

@interface BreakOutDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) TWBreakoutSession *session;
- (IBAction)backToBreakouts;

@end
