//
//  Session.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWSession.h"

@interface TWSession()

+ (NSDateFormatter *)_dateFormatter;
+ (NSComparator)_orderByTimeThenRoomComparator;

@end

@implementation TWSession

@dynamic id;
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



//+ (void)findFavorites:(NSArray *)talkIds inBackgroundWithBlock:(PFArrayResultBlock)resultBlock {
//    PFQuery *query = [TWSession query];
//    [query whereKey:@"alwaysFavorite" equalTo:@(YES)];
//    if (talkIds) {
//        PFQuery *favoriteQuery = [TWSession query];
//        [favoriteQuery whereKey:@"objectId" containedIn:talkIds];
//        query = [PFQuery orQueryWithSubqueries:@[ query, favoriteQuery ]];
//    }
//    [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *talks, NSError *error) {
//        resultBlock([[self class] sortedTalkArray:talks], error);
//    }];
//}

+ (NSArray *)sortedTalkArray:(NSArray *)talks {
    return [talks sortedArrayUsingComparator:[[self class] _orderByTimeThenRoomComparator]];
}

+ (NSString *)stringTime:(NSDate *)startTime {
    return [[[self class] _dateFormatter] stringFromDate:startTime];
}

- (NSString *)talkTime {
    return [[self class] stringTime:self.startTime];
}

//- (NSDate *)startTime {
//
//    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
//    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+0800'"];
//    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];
//
//    return [dateFormatter2 dateFromString:self.startTime];
//}

//- (NSDate *)endTime {
//
//    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
//    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+0800'"];
//    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];
//
//    return [dateFormatter2 dateFromString:self.endTime];
//}

//- (NSDate *)date {
//
//    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
//    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
//
//    return [dateFormatter2 dateFromString:self.date];
//}



//- (void)toggleFavorite:(BOOL)isFavorite {
//    NSArray *favorites = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFavoriteKey];
//    BOOL contains = [self isFavorite];
//
//    if (!(contains ^ isFavorite)) {
//        return; // status quo is fine, the UI shouldn't have allowed this case in the first place
//    }
//
//    NSNotification *notification;
//    if (isFavorite) {
//        if (favorites == nil) {
//            favorites = @[ self.objectId ];
//        } else {
//            favorites = [favorites arrayByAddingObject:self.objectId];
//        }
//        notification = [NSNotification notificationWithName:PDDTalkFavoriteTalkAddedNotification object:self];
//    } else {
//        favorites = [favorites filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *objectId, NSDictionary *bindings) {
//            return ![objectId isEqualToString:self.objectId];
//        }]];
//        notification = [NSNotification notificationWithName:PDDTalkFavoriteTalkRemovedNotification object:self];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:favorites forKey:kDefaultsFavoriteKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//}

//- (BOOL)isFavorite {
//    NSSet *favorites = [NSSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsFavoriteKey]];
//    return [favorites containsObject:self.objectId];
//}

- (NSString *)description {
    return self.title;
}

#pragma mark - Private methods
+ (NSDateFormatter *)_dateFormatter {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm"];
    }
    return formatter;
}

+ (NSComparator)_orderByTimeThenRoomComparator {
    return ^NSComparisonResult(TWSession *talk1, TWSession *talk2) {
        NSComparisonResult timeResult = [talk1.startTime compare:talk2.startTime];
        if (timeResult != NSOrderedSame) {
            return timeResult;
        }
        return [talk1.location compare:talk2.location];
    };
}


@end
