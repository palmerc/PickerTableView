//
//  SHCMoveTableViewController.m
//  TableView
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCMoveTableViewController.h"

#import "SHCTableViewDataStorage.h"


@interface SHCMoveTableViewController ()

@end



@implementation SHCMoveTableViewController

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

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return UITableViewCellEditingStyleNone;
}

/**
 * This locks the selected cell in place.
 */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canMoveRowAtIndexPath = NO;
    if (![indexPath isEqual:self.selectedIndexPath]) {
        canMoveRowAtIndexPath = YES;
    }
    
    return canMoveRowAtIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    static CGFloat previousYPostion = 0.0f;
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat yPosition = contentOffset.y;
    if (yPosition > previousYPostion) {
        NSLog(@"Scrolling up.");
    } else {
        NSLog(@"Scrolling down.");
    }
    
    previousYPostion = yPosition;
}

@end
