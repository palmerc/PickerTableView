//
//  SHCViewController.m
//  TableView
//
//  Created by Cameron Palmer on 23.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCSelectionTableViewController.h"

#import "SHCLoggerProxy.h"
#import "SHCTableViewCell.h"
#import "SHCTableViewDataStorage.h"

static NSString *kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";



@interface SHCSelectionTableViewController ()
@property (strong, nonatomic) NSArray *tableViewData;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end



@implementation SHCSelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *mutableTableViewData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++) {
        SHCTableViewDataStorage *dataStorage = [SHCTableViewDataStorage tableViewDataStorage];
        dataStorage.text = [NSString stringWithFormat:@"%d", i];
        [mutableTableViewData addObject:dataStorage];
        
    }
    
    self.tableViewData = [mutableTableViewData copy];
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
    CGFloat width = self.tableView.frame.size.width - 2.0f * 8.0f;
    
    SHCTableViewDataStorage *dataStorage = [self.tableViewData objectAtIndex:indexPath.row];
    NSString *text = dataStorage.text;
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : dataStorage.font} context:nil];
    CGFloat height = ceilf(boundingRect.size.height) + 16.0f;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isEditing) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
}

@end
