//
//  AskQuestionViewController.h
//  AwayDay2012
//
//  Created by Hari B on 12/09/14.
//
//

#import <UIKit/UIKit.h>

@class JVFloatLabeledTextField;
@class JVFloatLabeledTextView;

@interface AskQuestionViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveQuestion;
@property (weak, nonatomic) IBOutlet UIButton *cancelQuestion;
@property(nonatomic, strong) JVFloatLabeledTextField *titleField;
@property(nonatomic, strong) JVFloatLabeledTextView *descriptionField;
@end
