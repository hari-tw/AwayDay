//
//  gameTableViewCell.m
//  AwayDay2012
//
//  Created by safadmoh on 24/09/13.
//
//

#import "gameTableViewCell.h"

@implementation gameTableViewCell

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
- (IBAction)expandButtonTapped:(id)sender
{
    
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didButtonTappedAt:)])
    {
        [self.delegate didButtonTappedAt:self.indexPath];
    }
    
}


@end
