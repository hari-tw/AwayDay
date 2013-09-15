//
//  AMGInviteFriendsSectionHeaderView.m
//  AMG
//
//  Created by mohammad safad on 16/04/13.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import "BreakOutSectionHeaderView.h"
#define kPointToPixelConversion(x)     roundf(x*326.0f/144.0f)


@implementation BreakOutSectionHeaderView

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <InviteFriendsSectionHeaderViewDelegate>)delegate
{
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        
        _delegate = delegate;
        self.userInteractionEnabled = YES;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 3.5, 316, 45)];
        
        imageView.image=[UIImage imageNamed:@"container.png"];
        [self addSubview:imageView];
        
        // Create and configure the title label.
        _section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 18.0;
        titleLabelFrame.origin.y+=18.0;
        titleLabelFrame.size.width -= 50.0;
        //CGRectInset(titleLabelFrame, 0.0, 5.0);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 17, 235, 21)];
        label.text = title;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        _titleLabel = label;
        
        
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:kPointToPixelConversion(6.5)]];
        [_titleLabel setTextColor: [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f]];
        [_titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
        [_titleLabel setShadowColor:[UIColor whiteColor]];
        
        self.verticalDividerView=[[UIImageView alloc]initWithFrame:CGRectMake(258, 3.5, 1, 43)];
        
        self.verticalDividerView.image=[UIImage imageNamed:@"divider_vertical.png"];
        [self addSubview:self.verticalDividerView];
        
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(282.0, 17.5, 15.0, 15.0);
        [button setImage:[UIImage imageNamed:@"right-arrow-button.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _disclosureButton = button;
        
        
    }
    return self;
}

-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.disclosureButton.selected)
        {
            
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
            [_disclosureButton setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
            
            
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
                
            }
            [_disclosureButton setImage:[UIImage imageNamed:@"right-arrow-button.png"] forState:UIControlStateNormal];
        }
    }
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
