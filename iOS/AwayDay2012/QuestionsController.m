//
//  QuestionsController.m
//  AwayDay2012
//
//  Created by Hari B on 11/09/14.
//
//

#import "QuestionsController.h"
#import "TWQuestion.h"
#import "QuestionTableViewCell.h"
#import "AskQuestionViewController.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"

@interface QuestionsController ()

@end

@implementation QuestionsController {
    BOOL loading;
    NSMutableArray *questions;
    AskQuestionViewController *askquestionView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadQuestions];
    [self setupPopupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [questions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"questionCell";

    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    TWQuestion *question = questions[(NSUInteger) indexPath.row];
    cell.question = question.questionText;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    TWQuestion *question = questions[(NSUInteger) indexPath.row];
    return [QuestionTableViewCell heightForCellWithQuestion:question.questionText] + 20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Pull Refresh delegate

- (void)reloadTableViewDataSource {
    loading = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];

}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    loading = YES;
    [self loadQuestions];
}

- (void)loadQuestions {
    NSLog(@"inside load questions");

    [TWQuestion findAllInBackgroundForSessionName:self.sessionTitle speakerName:self.speakerName withBlock:^(NSArray *qns, NSError *error) {
        questions = [qns mutableCopy];
        NSLog(@"qns = %d", qns.count);
        [self.questionsView reloadData];
    }];

}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return loading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}

- (IBAction)backToSpeakerView {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)askQuestion {
    [self showItemPopUpView];
}

- (void)showItemPopUpView {
    NSLog(@"showing popup view");
    [UIView animateWithDuration:0.5
                     animations:^{
                         [askquestionView.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void)setupPopupView {
    UIStoryboard *storyboad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    askquestionView = (AskQuestionViewController *) [storyboad instantiateViewControllerWithIdentifier:@"askQuestion"];
    [askquestionView.view setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
    [askquestionView.saveQuestion addTarget:self action:@selector(saveQuestion) forControlEvents:UIControlEventTouchUpInside];
    [askquestionView.cancelQuestion addTarget:self action:@selector(cancelQuestion) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:askquestionView.view];
}

- (void)saveQuestion {
    [UIView animateWithDuration:0.5
                     animations:^{
                         [askquestionView.view setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {


                         NSString *name = askquestionView.titleField.text;
                         NSString *questionText = askquestionView.descriptionField.text;

                         if (name.length > 0 && questionText.length > 0) {
                             TWQuestion *question = [[TWQuestion alloc] init];
                             question.questionText = questionText;
                             question.questionerName = name;
                             question.sessionTitle = [NSString stringWithFormat:@"%@ - %@", [self.sessionTitle componentsSeparatedByString:@"-"][0], self.speakerName];
                             question.sessionId = self.objectId;
                             question.deviceToken = @"";

                             [questions addObject:question];
                             [self.questionsView reloadData];

                             [question saveInBackground];
                         }

                         NSLog(@"save question ");

                     }];
}

- (void)cancelQuestion {
    [UIView animateWithDuration:0.5
                     animations:^{
                         [askquestionView.view setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {

                     }];
}


@end
