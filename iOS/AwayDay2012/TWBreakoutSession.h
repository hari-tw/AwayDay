

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SessionAddress.h"


@interface TWBreakoutSession : PFObject<PFSubclassing>

@property(nonatomic, strong) NSString *objectId;
@property(nonatomic, strong) NSString *Title;
@property(nonatomic, strong) NSString *Description;
@property(nonatomic, strong) NSArray *speakers;
@property(nonatomic, strong) NSString *Start;
@property(nonatomic, strong) NSString *End;
@property(nonatomic, strong) NSString *Stream;
@property (nonatomic, strong) NSString *Speaker;

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
+ (NSArray *)sortedArray:(NSArray *)talks;

+ (NSDictionary *)groupByStream:(NSArray *)array;
@end
