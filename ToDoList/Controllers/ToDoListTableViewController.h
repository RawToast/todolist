//
//  ToDoListTableViewController.h
//  ToDoList
//
//  Created by James Morris on 21/09/2015.
//  Copyright © 2015 testorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItemManager.h"

@interface ToDoListTableViewController : UITableViewController

@property ToDoItemManager *itemManager;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

- (IBAction)removeCompleted:(id)sender;

- (IBAction)undo:(id)sender;

@end
