//
//  BreakOutDetailViewController.m
//  AwayDay2012
//
//  Created by Hari B on 17/09/14.
//
//

#import "BreakOutDetailViewController.h"
#import "TWBreakoutSession.h"

#define COMMENT_LABEL_WIDTH 230

@interface BreakOutDetailViewController ()

@end

@implementation BreakOutDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {

    self.titleLabel.text = _session.Title;
    self.speakerLabel.text = _session.Speaker;


    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x,
            self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10,
            262, 240)];
    textView.font = [UIFont fontWithName:@"Helvetica" size:12];
    textView.font = [UIFont boldSystemFontOfSize:12];
    textView.backgroundColor = [UIColor whiteColor];
    textView.scrollEnabled = YES;
    textView.pagingEnabled = YES;
    textView.editable = NO;

    textView.text = _session.Description;

    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)getLabelHeightFor:(NSString *)desc {
//    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);

    CGSize labelHeighSize = [desc sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0f]
                             constrainedToSize:maximumLabelSize
                                 lineBreakMode:NSLineBreakByWordWrapping];
    return labelHeighSize.height;

}

- (IBAction)backToBreakouts {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
