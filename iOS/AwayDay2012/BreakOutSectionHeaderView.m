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

-(id)initWithFrame:(CGRect)frame title:(NSString*)trackTopic coordinator:(NSString *)coordinator section:(NSInteger)sectionNumber delegate:(id <InviteFriendsSectionHeaderViewDelegate>)delegate
{
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        
//        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        
        _delegate = delegate;
        self.userInteractionEnabled = YES;
//        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 3.5, 316, 45)];
//        
//        imageView.image=[UIImage imageNamed:@"container.png"];
//        [self addSubview:imageView];
        
        // Create and configure the title label.
        _section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 10.0;
        titleLabelFrame.origin.y+=10.0;
        titleLabelFrame.size.width -= 60.0;
        //CGRectInset(titleLabelFrame, 0.0, 5.0);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 , 10 , 200, 60)];
        label.text =  [NSString  stringWithFormat:@" \"%@ \"" ,trackTopic];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        self.trackLabel = label;
        
        
        
        
        
        
        self.dividerImageVIew =[[UIImageView alloc]initWithFrame:CGRectMake(10, 98 ,300, 1)];
        self.dividerImageVIew.image = [UIImage imageNamed:@"line.png"];
        [self addSubview:self.dividerImageVIew];
        
        [self.trackLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]];
        [self.trackLabel setTextColor: [UIColor colorWithRed:10/255.0f green:10/255.0f blue:10/255.0f alpha:1.0f]];
       
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(289, 75, 20, 20.0);
        [button setImage:[UIImage imageNamed:@"plus-symbol.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"plus-symbol.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _disclosureButton = button;
        
        
        
        self.coordinatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 250, 25)];
        self.coordinatorLabel.backgroundColor= [UIColor clearColor];
        
        [self.coordinatorLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:13]];
        [self.coordinatorLabel setTextColor: [UIColor colorWithRed:10/255.0f green:10/255.0f blue:10/255.0f alpha:1.0f]];
        self.coordinatorLabel.text=[NSString  stringWithFormat:@"%@" ,coordinator];
        [self addSubview:self.coordinatorLabel];
        
        
        
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
            [_disclosureButton setImage:[UIImage imageNamed:@"plus-symbol.png"] forState:UIControlStateNormal];
            
            
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
                
            }
            [_disclosureButton setImage:[UIImage imageNamed:@"plus-symbol.png"] forState:UIControlStateNormal];
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
