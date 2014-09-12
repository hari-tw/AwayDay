#import "HomeViewController.h"
#import "CFShareCircleView.h"
#import "RNFrostedSidebar.h"
#import "CustomSlider.h"
#import "STTwitterAPI.h"
#import "Post.h"
#import "PostTableViewCell.h"

static CGFloat const FVEDetailControllerTargetedViewTag = 111;
bool blinkStatus = NO;

@interface HomeViewController () <RNFrostedSidebarDelegate, CFShareCircleViewDelegate> {
    CustomSlider *slider;
}

@property(nonatomic) UIView *flipView;
@property(nonatomic) NSIndexPath *indexPath;
@property(nonatomic) UILabel *infoLabel;
@property(nonatomic, strong) CFShareCircleView *shareCircleView;

@end

@implementation HomeViewController {
    BOOL loading;
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

    if (self.refreshView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
        self.refreshView = view;
    }
    [self.refreshView setDelegate:self];
    [self.feedView addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    self.feedView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.feedView.backgroundColor = [UIColor clearColor];
    self.feedView.alpha = 0.9;

    [self loadTweets];
}

- (void)loadTweets {
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"CyqRuU77Lbyv7i9EOkDMGinSo" consumerSecret:@"h2ElL2l13ANJG5qYCUqGacL1uGNnPKkA6mfJmWwnofOI8w6bUb" oauthToken:@"97134656-DGmVyE2Npqw5AEx6tI4r8KY2pEFBcsWkN74YnkOOX" oauthTokenSecret:@"qoVv6SRRFHQF2CRZ0t66xTUCf3L78aY4402qjOlTmJpRp"];

    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {

        [twitter getSearchTweetsWithQuery:@"indiaawayday" successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {

            NSLog(@"statuses = %@", statuses);

            self.tweets = [NSMutableArray arrayWithCapacity:[statuses count]];

            for (NSDictionary *attributes in statuses) {
                Post *post = [[Post alloc] initWithAttributes:attributes];
                [self.tweets addObject:post];
            }

            [self.feedView reloadData];
            loading = NO;
            [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.feedView];
        }                      errorBlock:^(NSError *error) {
            NSLog(@"search query error.debugDescription = %@", error.debugDescription);
        }];
    }                               errorBlock:^(NSError *error) {
        NSLog(@"credential verify error.debugDescription = %@", error.debugDescription);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)layoutSubviews {
    if (!self.flipView) {
        return;
    }
    self.flipView.frame = CGRectMake(60, 380, 200, 200);//CGRectInset(self.view.bounds, 20, 20);

}

- (IBAction)onBurger:(id)sender {
    slider = [[CustomSlider alloc] init];
    [slider showSliderMenu];
    slider.callout.delegate = self;
}

#pragma mark -RNFrostedSidebar delegate method.

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {

    switch (index) {
        case 0: {
            [slider showHomeScreen];
            [sidebar dismiss];
        }
            break;

        case 1: {
            [slider showAgendaScreen];
            [sidebar dismiss];
        }
            break;
        case 2 : {
            [slider showSpeakersScreen];
            [sidebar dismiss];
        }
            break;
        case 3 : {
            [slider showBreakOutSessionScreen];
            [sidebar dismiss];
        }
            break;
        case 4 : {
            [slider showMyEventsScreen];
            [sidebar dismiss];
        }
            break;
        case 5 : {
            [slider showNotificationScreen];
            [sidebar dismiss];
        }
            break;

        default:
            break;
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.post = [self.tweets objectAtIndex:(NSUInteger) indexPath.row];

    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PostTableViewCell heightForCellWithPost:[self.tweets objectAtIndex:(NSUInteger) indexPath.row]];
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
    [self loadTweets];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return loading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}


- (void)viewDidUnload {
    [self setCounterTextLabel:nil];
    [super viewDidUnload];
}
@end
