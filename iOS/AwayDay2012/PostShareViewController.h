//
//  PostShareViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "UserPath.h"

@interface PostShareViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) Session *session;
@property(nonatomic, strong) UIImage *userImage;
@property(nonatomic, strong) IBOutlet UITextView *textView;
@property(nonatomic, strong) IBOutlet UILabel *textCountLabel;
@property(nonatomic, strong) IBOutlet UILabel *sessionTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)sendButtonPressed:(id)sender;

@end
