

#import "TWQuestion.h"

@interface TWQuestion ()


@end

@implementation TWQuestion

@dynamic objectId;
@dynamic questionText;
@dynamic sessionTitle;
@dynamic questionerName;
@dynamic sessionId;
@dynamic deviceToken;


+ (NSString *)parseClassName {
    return @"Questions";
}

+ (void)findAllInBackgroundForSessionName:(NSString *)sessionName speakerName:(NSString *)speakerName withBlock:(PFArrayResultBlock)resultBlock {

    PFQuery *query = [TWQuestion query];
    [query whereKey:@"sessionTitle" containsString:sessionName];
    [query whereKey:@"sessionTitle" containsString:speakerName];
    [query orderByAscending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *notifications, NSError *error) {
        resultBlock(notifications, error);
    }];
}

@end
