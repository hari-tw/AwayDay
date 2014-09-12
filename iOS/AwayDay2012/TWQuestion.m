

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

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [TWQuestion query];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *notifications, NSError *error) {
        resultBlock(notifications, error);
    }];
}

@end
