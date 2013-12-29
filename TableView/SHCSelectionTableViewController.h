//
//  SHCViewController.h
//  TableView
//
//  Created by Cameron Palmer on 23.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCSelectionTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
