//
//  AskQuestionViewController.m
//  AwayDay2012
//
//  Created by Hari B on 12/09/14.
//
//

#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import <JVFloatLabeledTextField/JVFloatLabeledTextView.h>
#import "AskQuestionViewController.h"

const static CGFloat kJVFieldHeight = 44.0f;
const static CGFloat kJVFieldHMargin = 50.0f;

const static CGFloat kJVFieldFontSize = 16.0f;

const static CGFloat kJVFieldFloatingLabelFontSize = 11.0f;

@interface AskQuestionViewController ()

@end

@implementation AskQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat topOffset = 63;
    UIColor *floatingLabelColor = [UIColor brownColor];

    self.titleField = [[JVFloatLabeledTextField alloc] initWithFrame:
            CGRectMake(kJVFieldHMargin, topOffset, self.view.frame.size.width - 2 * kJVFieldHMargin, kJVFieldHeight)];
    self.titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Name", @"")
                                                                            attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    self.titleField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.titleField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.titleField.floatingLabelTextColor = floatingLabelColor;
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.titleField];

    UIView *div1 = [UIView new];
    div1.frame = CGRectMake(kJVFieldHMargin, self.titleField.frame.origin.y + self.titleField.frame.size.height,
            self.view.frame.size.width - 2 * kJVFieldHMargin, 1.0f);
    div1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    [self.view addSubview:div1];

    self.descriptionField = [[JVFloatLabeledTextView alloc] initWithFrame:CGRectMake(kJVFieldHMargin,
            div1.frame.origin.y + div1.frame.size.height,
            self.view.frame.size.width - 2 * kJVFieldHMargin,
            kJVFieldHeight * 3)];
    self.descriptionField.placeholder = NSLocalizedString(@"Question", @"");
    self.descriptionField.placeholderTextColor = [UIColor darkGrayColor];
    self.descriptionField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    self.descriptionField.floatingLabel.font = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    self.descriptionField.floatingLabelTextColor = floatingLabelColor;
    [self.view addSubview:self.descriptionField];

    [self.descriptionField setDelegate:self];
    [self.descriptionField setReturnKeyType:UIReturnKeyDone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)       textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
        replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
