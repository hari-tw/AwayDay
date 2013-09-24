//
//  agendExpandTableViewCell.h
//  AwayDay2012
//
//  Created by safadmoh on 25/09/13.
//
//

#import <UIKit/UIKit.h>

@interface agendExpandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *agendaTitleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderBUtton;

@end
