//
//  Session.h
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SessionAddress.h"

@interface TWSession : PFObject<PFSubclassing>

@property(nonatomic, strong) NSString *id;
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
