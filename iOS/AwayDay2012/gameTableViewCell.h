//
//  gameTableViewCell.h
//  AwayDay2012
//
//  Created by safadmoh on 24/09/13.
//
//

#import <UIKit/UIKit.h>
@protocol CustomTableDelegate <NSObject>
-(void)didButtonTappedAt:(NSIndexPath *)indexPath;
@end


@interface gameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gameNameTextLabel;
@property(nonatomic,weak)NSObject < CustomTableDelegate> *delegate;
@property(strong,nonatomic) NSIndexPath *indexPath;

- (IBAction)expandButtonTapped:(id)sender;
@end
