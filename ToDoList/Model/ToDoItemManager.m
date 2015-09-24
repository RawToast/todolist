//
//  ToDoItemManager.m
//  ToDoList
//
//  Created by James Morris on 23/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import "ToDoItemManager.h"
#import "CBObjects.h"
#import "CouchbaseEvents.h"

@interface ToDoItemManager ()
    @property NSMutableArray* toDoItems;
    @property NSUndoManager* undoManager;
    @property CouchbaseEvents* datastore;
@end

@implementation ToDoItemManager

- (id) init {
    self = [super init];
    if (self) {
        self.toDoItems = [[NSMutableArray alloc] init];
        self.undoManager = [[NSUndoManager alloc] init];
        self.datastore = [[CouchbaseEvents alloc] init];
    }
    return self;
}

- (void) addItem:(ToDoItem *)toDoItem {
    // Undo logic
    [self.undoManager registerUndoWithTarget: self
                                    selector: @selector(removeItem:)
                                      object: toDoItem];
    [self.undoManager setActionName: NSLocalizedString(@"Todo List Change", @"list undo")];
    
    [self.toDoItems addObject: toDoItem];
    
    [self.datastore createDocument: CBObjects.sharedInstance.database
                          withItem:toDoItem];
}

- (void) updateCompletedStatus:(ToDoItem *) toDoItem {
    
    [self.undoManager registerUndoWithTarget: self
                                    selector: @selector(updateCompletedStatus:)
                                      object: toDoItem];
    [self.undoManager setActionName: NSLocalizedString(@"Amend status", @"item status")];

    toDoItem.completed = !toDoItem.completed;
    
    [self.datastore updateToDoItem: CBObjects.sharedInstance.database withItem:toDoItem];
}


- (void) addItemsFromArray:(NSMutableArray*)toDoItem {
    [self.toDoItems addObjectsFromArray:toDoItem];
    
    for (ToDoItem *item in toDoItem){
        [ self.datastore createDocument: CBObjects.sharedInstance.database withItem:item];
    }
}

- (void) removeItem:(ToDoItem *) toDoItem {
    [self.toDoItems removeObjectIdenticalTo:toDoItem];
    
    [self.datastore deleteToDoItem: CBObjects.sharedInstance.database item:toDoItem];
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
        for (ToDoItem* item in removedItems) {
            [ self.datastore deleteToDoItem:CBObjects.sharedInstance.database item:item];
        }
    }
    
    self.toDoItems = remainingItems;
}

- (void)loadInitialData {
    NSArray *items = [ self.datastore fetchItems: CBObjects.sharedInstance.database];
    
    if (!items){
        ToDoItem *item1 = [[ToDoItem alloc] init];
        item1.itemName = @"Buy Milk";
        [ self.datastore createDocument: CBObjects.sharedInstance.database withItem:item1];
        [ self.toDoItems addObject:item1];
    } else{
        for (ToDoItem *item in items) {
            [ self.toDoItems addObject:item];
        }
    }
}

@end
