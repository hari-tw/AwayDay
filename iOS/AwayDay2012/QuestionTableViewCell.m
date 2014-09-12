//
// Created by Hari B on 11/09/14.
//

#import "QuestionTableViewCell.h"


@implementation QuestionTableViewCell {


}
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }

    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;

    return self;
}

- (void)setQuestion:(NSString *)question {
    _question = question;

    self.detailTextLabel.text = question;
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithQuestion:(NSString *)question {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize sizeToFit = [question sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop

    return fmaxf(70.0f, sizeToFit.height + 45.0f);
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(10.0f, 10.0f, 240.0f, 20.0f);

    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = [[self class] heightForCellWithQuestion:self.question] - 45.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end