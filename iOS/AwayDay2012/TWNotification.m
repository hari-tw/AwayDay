

#import "TWNotification.h"

@interface TWNotification()

@end

@implementation TWNotification

@dynamic objectId;
@dynamic title;
@dynamic message;


+ (NSString *)parseClassName {
    return @"Notification";
}

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [TWNotification query];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *notifications, NSError *error) {
        resultBlock(notifications, error);
    }];
}

@end
