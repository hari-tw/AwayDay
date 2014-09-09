

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SessionAddress.h"

@interface TWNotification : PFObject<PFSubclassing>

@property(nonatomic, strong) NSString *objectId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *message;

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
@end
