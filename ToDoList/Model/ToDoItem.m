//
//  ToDoItem.m
//  ToDoList
//
//  Created by James Morris on 22/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

static NSString * const DATE_FORMAT = @"yyyy-MM-dd hh:mm:ss a";

- (id) init {
    self = [ super init ];
    
    if (self) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        self.identifier = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        self.creationDate = [[ NSDate alloc] init];
    }
    return self;
}


- (id) initFromDictionary:(NSDictionary *)dict {
    self = [ super init ];
    
    if (self) {
        self.itemName = [ dict objectForKey:@"itemName"];
        self.completed =  [ [ dict objectForKey:@"completed"] boolValue];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat: DATE_FORMAT];
        
        self.creationDate = [ df dateFromString: (NSString *)[ dict objectForKey:@"creationDate"]];
        
        self.identifier = [ dict objectForKey:@"identifier"];
    }
    return self;
}


- (NSDictionary *) exportToDictionary {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = DATE_FORMAT;
    
    
    NSDictionary *dict = @{ @"identifier" : self.identifier,
                            @"itemName" : self.itemName,
                            @"creationDate" : [ df stringFromDate: self.creationDate],
                            @"completed" : [NSNumber numberWithBool: self.completed]
                            };
    
    return dict;
}

@end
