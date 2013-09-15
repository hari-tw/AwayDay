//
//  BreakOutSectionInfo.h
//  AMG
//
//  Created by mohammad safad on 16/04/13.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BreakOutSectionHeaderView;
@interface BreakOutSectionInfo : NSObject


@property (assign) BOOL open;

@property (strong) BreakOutSectionHeaderView* headerView;

@property (nonatomic,strong) NSMutableArray *rowHeights;
@property(nonatomic,assign)NSMutableArray *play;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;


@end
