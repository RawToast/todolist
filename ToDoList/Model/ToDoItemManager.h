//
//  ToDoItemManager.h
//  ToDoList
//
//  Created by James Morris on 23/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"

@interface ToDoItemManager : NSObject

- (void) loadInitialData;

- (void) addItem: (ToDoItem *) toDoItem;

- (void) undo;

- (void) removeCompletedItems;

- (void) updateCompletedStatus:(ToDoItem *) toDoItem;

- (NSUInteger) count;

- (ToDoItem *) itemAtIndex: (NSUInteger) index;

@end
