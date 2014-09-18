//
//  NSArray+AwayDay.m
//  AwayDay2012
//
//  Created by Hari B on 17/09/14.
//
//

#import "NSArray+AwayDay.h"

@implementation NSArray (AwayDay)
+ (NSDictionary *)groupObjectsInArray:(NSArray *)array byKey:(NSString *)key {

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    for (id obj in array) {
        id keyValue = [obj valueForKey:key];
        NSMutableArray *arr = dictionary[keyValue];
        if (!arr) {
            arr = [NSMutableArray array];
            dictionary[keyValue] = arr;
        }
        [arr addObject:obj];
    }
    return [dictionary copy];
}


@end
