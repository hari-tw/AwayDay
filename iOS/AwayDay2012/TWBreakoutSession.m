#import "TWBreakoutSession.h"
#import "NSArray+AwayDay.h"
#import "TWSpeaker.h"

@interface TWBreakoutSession ()

+ (NSDateFormatter *)_dateFormatter;

@end

@implementation TWBreakoutSession

@dynamic objectId;
@dynamic Title;
@dynamic Description;
@dynamic speakers;
@dynamic Start;
@dynamic End;
@dynamic Stream;

+ (NSString *)parseClassName {
    return @"Breakouts";
}

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [TWBreakoutSession query];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *talks, NSError *error) {
        resultBlock([[self class] sortedArray:talks], error);
    }];
}

+ (NSArray *)sortedArray:(NSArray *)talks {
    NSSortDescriptor *startTimeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Start"
                                                                          ascending:YES
                                                                           selector:@selector(localizedStandardCompare:)];
    return [talks sortedArrayUsingDescriptors:@[startTimeDescriptor]];
}

- (NSString *)description {
    return self.Description;
}

#pragma mark - Private methods

+ (NSDateFormatter *)_dateFormatter {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
    }
    return formatter;
}

+ (NSDate *)getDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy HH:mm"];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];

    return [dateFormatter2 dateFromString:dateString];
}

+ (NSDictionary *)groupByStream:(NSArray *)array {
    return [NSArray groupObjectsInArray:array byKey:@"Stream"];
}
@end
