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
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *endTime;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *location;

+ (void)findAllInBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
//+ (void)findFavorites:(NSArray *)talkIds inBackgroundWithBlock:(PFArrayResultBlock)resultBlock;
+ (NSArray *)sortedTalkArray:(NSArray *)talks;
+ (NSString *)stringTime:(NSDate *)startTime;
- (NSString *)talkTime;
//- (void)toggleFavorite:(BOOL)isFavorite;
//- (BOOL)isFavorite;
@end
