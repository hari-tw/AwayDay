

#import "TWSpeaker.h"

@implementation TWSpeaker

@dynamic objectId;
@dynamic Name;

+ (NSString *)parseClassName {
    return @"Speakers";
}


+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [TWSpeaker query];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *speakers, NSError *error) {
        resultBlock(speakers, error);
    }];
}
@end
