//
//  AMGInviteFriendsSectionInfo.m
//  AMG
//
//  Created by mohammad safad on 16/04/13.
//  Copyright (c) 2013 AMG. All rights reserved.
//

#import "BreakOutSectionInfo.h"

#import "BreakOutSectionHeaderView.h"
@implementation BreakOutSectionInfo


-init {
	
	self = [super init];
	if (self) {
		self.rowHeights = [[NSMutableArray alloc] init];
	}
	return self;
}


- (NSUInteger)countOfRowHeights {
	return [self.rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
	return [self.rowHeights objectAtIndex:idx];
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx {
	[self.rowHeights insertObject:anObject atIndex:idx];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes {
	[self.rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx {
	[self.rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes {
	[self.rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject {
	[self.rowHeights replaceObjectAtIndex:idx withObject:anObject];
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray {
	[self.rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

@end
