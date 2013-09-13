//
//  customTableCell.h
//  ExpandedTableViewCell
//
//  Created by safadmoh on 12/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTableDelegate <NSObject>

-(void)didButtonTappedAt:(NSIndexPath *)indexPath;
@end


@interface customTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicTextLabel;

@property(nonatomic,weak)NSObject < CustomTableDelegate> *delegate;

@property(strong,nonatomic) NSIndexPath *indexPath;

- (IBAction)expandButtonTapped:(id)sender;





-(void)setLabelFontsColor;


@end
