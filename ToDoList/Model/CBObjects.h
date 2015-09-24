//
//  CBObjects.h
//  ToDoList
//
//  Created by James Morris on 24/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@interface CBObjects : NSObject

+ (CBObjects*)sharedInstance;

@property (nonatomic, strong) CBLDatabase *database;
@property (nonatomic, strong) CBLManager *manager;

@end
