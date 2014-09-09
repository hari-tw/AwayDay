

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SessionAddress.h"

@interface TWSession : PFObject<PFSubclassing>

@property(nonatomic, strong) NSString *objectId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *note;
@property(nonatomic, strong) NSString *speaker;
@property(nonatomic, strong) NSString *startTime;
@property(nonatomic, strong) NSString *endTime;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *date;

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
//+ (void)findFavorites:(NSArray *)talkIds inBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
+ (NSArray *)sortedTalkArray:(NSArray *)talks;
+ (NSString *)stringTime:(NSDate *)startTime;
//- (NSDate *)startTime;
//- (NSDate *)endTime;
//- (NSDate *)date;



- (NSString *)talkTime;
//- (void)toggleFavorite:(BOOL)isFavorite;
//- (BOOL)isFavorite;
@end
