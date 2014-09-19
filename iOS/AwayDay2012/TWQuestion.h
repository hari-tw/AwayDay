

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SessionAddress.h"

@interface TWQuestion : PFObject<PFSubclassing>

@property(nonatomic, strong) NSString *objectId;
@property(nonatomic, strong) NSString *questionText;
@property(nonatomic, strong) NSString *sessionTitle;
@property(nonatomic, strong) NSString *questionerName;
@property(nonatomic, strong) NSString *deviceToken;
@property(nonatomic, strong) NSString *sessionId;

+ (void)findAllInBackgroundForSessionName:(NSString *)sessionName speakerName:(NSString *)speakerName withBlock:(PFArrayResultBlock)resultBlock;
@end
