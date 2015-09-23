//
//  ToDoItemManager.m
//  ToDoList
//
//  Created by James Morris on 23/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import "ToDoItemManager.h"

@interface ToDoItemManager ()
    @property NSMutableArray* toDoItems;
    @property NSUndoManager* undoManager;
@end

@implementation ToDoItemManager

- (id) init {
    self = [super init];
    if (self) {
        self.toDoItems = [[NSMutableArray alloc] init];
        self.undoManager = [[NSUndoManager alloc] init];
    }
    return self;
}

- (void) addItem:(ToDoItem *)toDoItem {
    [self.undoManager registerUndoWithTarget: self
                                    selector: @selector(removeItem:)
                                      object: toDoItem];
    
    [self.undoManager setActionName: NSLocalizedString(@"Todo List Change", @"list undo")];
    
    [self.toDoItems addObject: toDoItem];
}

- (void) addItemsFromArray:(NSMutableArray*)toDoItem {
    [self.toDoItems addObjectsFromArray:toDoItem];
}

- (void) removeItem:(ToDoItem *) toDoItem {
    [self.toDoItems removeObjectIdenticalTo:toDoItem];
}

- (ToDoItem *) itemAtIndex:(NSUInteger)index{
    return [self.toDoItems objectAtIndex:index];
}

- (void) undo {
    [ self.undoManager undo ];
}

- (NSUInteger) count {
    return self.toDoItems.count;
}


- (void) removeCompletedItems {
    NSMutableArray *remainingItems = [[NSMutableArray alloc] init];
    NSMutableArray *removedItems = [[NSMutableArray alloc] init];
    for (ToDoItem *item in self.toDoItems) {
        if (item.completed) {
            // Store for undo
            [removedItems addObject:item];
        } else {
            // Keep incomplete items
            [remainingItems addObject:item];
        }
    }
    
    if (remainingItems.count != self.toDoItems.count) {
        [self.undoManager registerUndoWithTarget:self selector:@selector(addItemsFromArray:) object:removedItems];
        
        [self.undoManager setActionName: NSLocalizedString(@"Remove Completed Items", @"undo remove")];

    }
    
    self.toDoItems = remainingItems;
}

- (void)loadInitialData {
    ToDoItem *item1 = [[ToDoItem alloc] init];
    item1.itemName = @"Buy Milk";
    
    ToDoItem *item2 = [[ToDoItem alloc] init];
    item2.itemName = @"Take Milk Home";
    
    ToDoItem *item3 = [[ToDoItem alloc] init];
    item3.itemName = @"Drink Milk!";
    
    [self.toDoItems addObject:item1];
    [self.toDoItems addObject:item2];
    [self.toDoItems addObject:item3];
}

@end
