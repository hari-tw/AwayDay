//
//  expandCell.h
//  ExpandedTableViewCell
//
//  Created by safadmoh on 12/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface expandCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextlabel;


-(void)setLabelFontsColor;
@end
