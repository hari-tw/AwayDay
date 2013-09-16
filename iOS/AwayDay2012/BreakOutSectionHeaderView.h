//
//  AMGInviteFriendsSectionHeaderView.h
//  AMG
//
//  Created by mohammad safad on 16/04/13.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InviteFriendsSectionHeaderViewDelegate;

@interface BreakOutSectionHeaderView : UIView


@property (nonatomic, weak) UILabel *trackLabel;
@property (nonatomic, strong) UIImageView *dividerImageVIew;

@property (nonatomic, weak) UIButton *disclosureButton;
@property(nonatomic,strong) UILabel *coordinatorLabel;
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, weak) id <InviteFriendsSectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)trackTopic coordinator:(NSString *)coordinator image:(NSString *)imageName section:(NSInteger)sectionNumber delegate:(id <InviteFriendsSectionHeaderViewDelegate>)delegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol InviteFriendsSectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(BreakOutSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(BreakOutSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;



@end