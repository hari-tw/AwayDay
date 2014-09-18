

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface TWSpeaker : PFObject<PFSubclassing>

@property(nonatomic, strong) NSString *objectId;
@property(nonatomic, strong) NSString *Name;

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
@end
