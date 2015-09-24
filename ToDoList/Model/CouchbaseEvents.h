//
//  CouchbaseEvents.h
//  ToDoList
//
//  Created by James Morris on 24/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import "ToDoItem.h"

@interface CouchbaseEvents : NSObject

- (void) createDocument: (CBLDatabase *)database withItem: (ToDoItem *) toDoItem;

- (void) updateToDoItem: (CBLDatabase *)database withItem: (ToDoItem *) toDoItem;

- (void) deleteToDoItem: (CBLDatabase *) database item: (ToDoItem *) toDoItem;

- (NSArray*) fetchItems: (CBLDatabase *) database;

- (ToDoItem *) fetch: (CBLDatabase *) database item: (ToDoItem *) toDoItem;

- (void) init: (CBLDatabase *) database;

@end
