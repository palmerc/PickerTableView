//
//  SHCMoveTableViewController.h
//  TableView
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCMoveTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *tableViewData;
@property (copy, nonatomic) NSIndexPath *selectedIndexPath;

- (IBAction)didPressDoneBarButtonItem:(id)sender;

@end
