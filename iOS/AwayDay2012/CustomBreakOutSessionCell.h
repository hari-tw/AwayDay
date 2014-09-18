//
//  CustomBreakOutSessionCell.h
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import <UIKit/UIKit.h>

@protocol CustomBreakOutDelegate <NSObject>

- (void)joinTappedAt:(NSIndexPath *)indexPath sender:(id)sender;

- (void)remindTappedAt:(NSIndexPath *)indexPath sender:(id)sender;

@end

@interface CustomBreakOutSessionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicSpeakerNameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;

@property(strong,nonatomic) NSIndexPath *indexPath;

@property(nonatomic,weak)NSObject <CustomBreakOutDelegate> *delegate;

- (IBAction)joinButtonTapped:(id)sender;
- (IBAction)reminderButtonTapped:(id)sender;

@end
