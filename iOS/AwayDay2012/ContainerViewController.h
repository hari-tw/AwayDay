//
//  ContainerViewController.h
//  AwayDay2012
//
//  Created by safadmoh on 11/09/13.
//
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface ContainerViewController : UIViewController<RNFrostedSidebarDelegate>

@property (strong, nonatomic) IBOutlet UIView *menuButton;
- (IBAction)onBurger:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *hoursTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTextLabel;

@end
