//
//  customTableCell.m
//  ExpandedTableViewCell
//
//  Created by safadmoh on 12/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import "customTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation customTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
        return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)expandButtonTapped:(id)sender
{

    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didButtonTappedAt:)])
       {
           [self.delegate didButtonTappedAt:self.indexPath];
       }
    
}

-(void)setLabelFontsColor
{
    

    self.speakerImageView.layer.cornerRadius = 50;
    self.speakerImageView.layer.masksToBounds=YES;
}

@end
