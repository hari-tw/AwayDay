//
//  expandCell.m
//  ExpandedTableViewCell
//
//  Created by safadmoh on 12/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import "expandCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation expandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLabelFontsColor
{
    
    
    self.speakerImageView.layer.cornerRadius = 30;
    self.speakerImageView.layer.masksToBounds=YES;
}


@end
