//
//  ToDoItem.h
//  ToDoList
//
//  Created by James Morris on 22/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

- (id) initFromDictionary: (NSDictionary *) dict;

- (NSDictionary *) exportToDictionary;

@property NSString *identifier;

@property NSString *itemName;

@property BOOL completed;

@property NSDate *creationDate;

@end
