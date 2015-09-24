//
//  CouchbaseEvents.m
//  ToDoList
//
//  Created by James Morris on 24/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import "CouchbaseEvents.h"
#import "CBObjects.h"

@interface CouchbaseEvents()
    @property CBObjects* datastore;
@end

@implementation CouchbaseEvents

static NSString * const TRACKING_KEY = @"ToDoItems";
static NSString * const KEYS = @"keys";

- (id) init {
    self = [super init];
    self.datastore = [ CBObjects sharedInstance ];
    return self;
}

// creates A Document
- (void)createDocument: (CBLDatabase *)database withItem:(ToDoItem *)toDoItem {
    
    CBLRevision *newRevision = [self replaceDocument:database item:toDoItem];
    
    if (newRevision) {
        NSLog(@"Document created and written to database, ID = %@", toDoItem.identifier);
        [self trackAddition: database withItem: toDoItem];
    }
}

// creates A Document
- (void)updateToDoItem: (CBLDatabase *)database withItem:(ToDoItem *)toDoItem {
    
    CBLRevision* doc = [ self replaceDocument: database item: toDoItem];
    
    if (doc) {
        NSLog(@"Document created and written to database, ID = %@", toDoItem.identifier);
    }
}

- (void) deleteToDoItem: (CBLDatabase *) database item: (ToDoItem *) toDoItem {
    
    BOOL deleted = [ self deleteDocument: database item: toDoItem];
    
    if (deleted){
        [ self trackRemoval:database withItem:toDoItem];
    }
}

- (BOOL) deleteDocument: (CBLDatabase *) database item: (ToDoItem *) toDoItem {
    CBLDocument * document = [ database documentWithID:toDoItem.identifier];
    NSError* error;
    
    [ document deleteDocument: &error];
    
    if (!error){
        NSLog(@"Deleted document, deletion status is %d", [document isDeleted]);
        return YES;
    }
    return NO;
}


- (NSMutableArray*) fetchItems: (CBLDatabase *) database {
    NSMutableArray *result;
    
    CBLDocument *doc = [database documentWithID: TRACKING_KEY];
    NSDictionary *dict = doc.properties;
    NSMutableArray *keys = [ dict valueForKey: KEYS];
    
    // Only init if required
    if (keys){
        result = [[ NSMutableArray alloc] init];
    }
    
    for (NSString *key in keys) {
        ToDoItem *item = [ self fetchUsingKey:database key:key];
        [ result addObject:item];
    }
    
    return result;
}

- (ToDoItem*) fetch: (CBLDatabase *) database item: (ToDoItem *) toDoItem {
    return [ self fetchUsingKey:database key:toDoItem.identifier];
}

- (ToDoItem*) fetchUsingKey: (CBLDatabase *) database key: (NSString *) key {
    CBLDocument *document = [database documentWithID: key];
    NSDictionary *dict = document.properties;
    return [[ ToDoItem alloc] initFromDictionary:dict];
}


- (void) init:(CBLDatabase *)database {
    NSError *error;
    CBLDocument *doc = [database documentWithID: TRACKING_KEY];
    NSMutableDictionary *dict = [ doc.properties mutableCopy];
    NSMutableArray *keys = [ dict valueForKey: @"keys"];
    
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    if (!keys) {
        keys = [[NSMutableArray alloc] init];
        [ dict setObject:keys forKey: TRACKING_KEY];
    }
    
    CBLSavedRevision *newRev = [doc putProperties:dict error:&error];
    if (!newRev) {
        NSLog(@"Cannot initialise keys document. Error message: %@", error.localizedDescription);
    }
}

// Private methods


- (CBLRevision *) replaceDocument: (CBLDatabase *) database item: (ToDoItem *) toDoItem {
    NSError* error;
    
    // create an object that contains data for the new document
    NSDictionary *myDictionary = [toDoItem exportToDictionary];
    
    // Create an empty document
    CBLDocument *doc = [database documentWithID: toDoItem.identifier];
    
    // Write the document to the database
    CBLRevision *newRevision = [doc putProperties: myDictionary error:
                                &error];
    return newRevision;
}

- (void) trackAddition: (CBLDatabase *) database withItem: (ToDoItem *) toDoItem {
    
    CBLDocument *doc = [database documentWithID: TRACKING_KEY];
    NSMutableDictionary *dict = [ doc.properties mutableCopy];
    NSMutableArray *keys = [ dict valueForKey: KEYS];
    
    if (!keys) {
        keys = [[NSMutableArray alloc] init];
        [ dict setObject:keys forKey: TRACKING_KEY];
    } else{
        keys = [NSMutableArray arrayWithArray:keys];
    }
    
    NSLog(@"Keys before addition: %d", keys.count);
    [ keys addObject: toDoItem.identifier ];
    NSLog(@"Keys after addition: %d", keys.count);

    dict[KEYS] = keys;
    
    NSError *error;
    CBLSavedRevision *newRev = [doc putProperties:dict error:&error];
    if (!newRev) {
        NSLog(@"Cannot update document. Error message: %@", error.localizedDescription);
    }
    NSLog(@"The new revision of the document contains: %@", newRev.properties);
}

- (void) trackRemoval: (CBLDatabase *) database withItem: (ToDoItem *) toDoItem {
    
    CBLDocument *doc = [database documentWithID: TRACKING_KEY];
    NSMutableDictionary *dict = [ doc.properties mutableCopy];
    NSMutableArray *keys = [ dict valueForKey: KEYS];
    
    if (!keys) {
        keys = [[NSMutableArray alloc] init];
        [ dict setObject:keys forKey: TRACKING_KEY];
    } else{
        keys = [NSMutableArray arrayWithArray:keys];
    }
    
    NSLog(@"Keys before removal: %d", keys.count);
    [ keys removeObject: toDoItem.identifier ];
    NSLog(@"Keys after removal: %d", keys.count);
    [ dict setObject:keys forKey:KEYS];
    
    NSError *error;
    CBLSavedRevision *newRev = [doc putProperties:dict error:&error];
    if (!newRev) {
        NSLog(@"Cannot update document. Error message: %@", error.localizedDescription);
    }
    NSLog(@"The new revision of the document contains: %@", newRev.properties);
}



@end
