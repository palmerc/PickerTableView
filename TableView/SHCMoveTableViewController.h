//
//  SHCMoveTableViewController.h
//  TableView
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHCPickerTableView;



@interface SHCMoveTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet SHCPickerTableView *pickerTableView;

@property (copy, nonatomic) NSArray *tableViewData;
@property (copy, nonatomic) NSIndexPath *selectedIndexPath;

- (IBAction)didPressDoneBarButtonItem:(id)sender;

@end
