//
//  CustomBreakOutSessionCell.m
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import "CustomBreakOutSessionCell.h"

@implementation CustomBreakOutSessionCell

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

- (IBAction)joinButtonTapped:(id)sender {

    NSLog(@"join tapped - tableview cell");

    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(joinTappedAt:sender:)])
    {
        [self.delegate joinTappedAt:self.indexPath sender:sender];
    }
}

- (IBAction)reminderButtonTapped:(id)sender {

    NSLog(@"remind tapped - tableview cell");
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(remindTappedAt:sender:)])
    {
        [self.delegate remindTappedAt:self.indexPath sender:sender];
    }
}


@end
