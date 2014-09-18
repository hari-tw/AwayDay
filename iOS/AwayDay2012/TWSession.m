

#import "TWSession.h"

@interface TWSession()

+ (NSDateFormatter *)_dateFormatter;
+ (NSComparator)_orderByTimeThenRoomComparator;

@end

@implementation TWSession

@dynamic objectId;
@dynamic title;
@dynamic note;
@dynamic speaker;
@dynamic startTime;
@dynamic endTime;
@dynamic address;
@dynamic location;

+ (NSString *)parseClassName {
    return @"Session";
}

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
    PFQuery *query = [TWSession query];
    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [query findObjectsInBackgroundWithBlock:^(NSArray *talks, NSError *error) {
        resultBlock([[self class] sortedTalkArray:talks], error);
    }];
}

+ (NSArray *)sortedTalkArray:(NSArray *)talks {

    NSSortDescriptor *startTimeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime"
                                                                              ascending:YES
                                                                               selector:@selector(localizedStandardCompare:)];
    return [talks sortedArrayUsingDescriptors:@[startTimeDescriptor]];
}

+ (NSString *)stringTime:(NSDate *)startTime {
    NSString *stTime = [[[self class] _dateFormatter] stringFromDate:startTime];
    NSLog(@"stTime = %@", stTime);
    return stTime;
}

- (NSString *)talkTime {
    return [[self class] stringTime:self.startTime];
}

- (NSString *)description {
    return self.title;
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

+ (NSComparator)_orderByTimeThenRoomComparator {
    return ^NSComparisonResult(TWSession *talk1, TWSession *talk2) {
        NSComparisonResult timeResult = [[[self class] getDate:talk1.startTime] compare:[[self class] getDate:talk1.endTime]];
        if (timeResult != NSOrderedSame) {
            return timeResult;
        }
        return [talk1.location compare:talk2.location];
    };
}

+ (NSDate *) getDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy HH:mm"];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];

    return [dateFormatter2 dateFromString:dateString];
}

@end
