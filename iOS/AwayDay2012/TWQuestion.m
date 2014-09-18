

#import "TWQuestion.h"

@interface TWQuestion ()


@end

@implementation TWQuestion

@dynamic objectId;
@dynamic questionText;
@dynamic sessionTitle;
@dynamic questionerName;
@dynamic deviceToken;


+ (NSString *)parseClassName {
    return @"Questions";
}

+ (void)findAllInBackgroundForSessionTitle:(NSString *)sessionTitle withBlock:(PFArrayResultBlock)resultBlock {

    PFQuery *query = [TWQuestion query];
    [query whereKey:@"sessionTitle" containsString:sessionTitle];
    [query orderByAscending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *notifications, NSError *error) {
        resultBlock(notifications, error);
    }];
}

@end
