//
//  SHCMoveTableViewController.m
//  TableView
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCMoveTableViewController.h"

#import "SHCTableViewDataStorage.h"
#import "SHCTableViewCell.h"
#import "SHCPickerTableView.h"

static NSString *kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";



@interface SHCMoveTableViewController ()

@end



@implementation SHCMoveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Move the cell", @"Move the cell");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.pickerTableView.selectedIndexPath = self.selectedIndexPath;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHCTableViewDataStorage *dataStorage = [self.tableViewData objectAtIndex:indexPath.row];
    
    SHCTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    
    if (indexPath.row % 2 == 0) {
        tableViewCell.backgroundColor = [UIColor whiteColor];
    } else {
        tableViewCell.backgroundColor = [UIColor lightGrayColor];
    }
    
    tableViewCell.textLabel.font = dataStorage.font;
    tableViewCell.textLabel.text = dataStorage.text;
    
    return tableViewCell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = tableView.frame.size.width - 2.0f * 8.0f;
    
    SHCTableViewDataStorage *dataStorage = [self.tableViewData objectAtIndex:indexPath.row];
    NSString *text = dataStorage.text;
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : dataStorage.font} context:nil];
    CGFloat height = ceilf(boundingRect.size.height) + 16.0f;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
}



#pragma mark - IBActions

- (IBAction)didPressDoneBarButtonItem:(id)sender
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
}

@end
