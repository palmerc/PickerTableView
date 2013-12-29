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

static NSString *kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";



@interface SHCMoveTableViewController ()

@end



@implementation SHCMoveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Move the cell", @"Move the cell");
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
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
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
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    static CGFloat previousYPostion = 0.0f;
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat yPosition = contentOffset.y;
    if (yPosition > previousYPostion) {
        DDLogVerbose(@"Scrolling up.");
    } else {
        DDLogVerbose(@"Scrolling down.");
    }
    
    previousYPostion = yPosition;
}



#pragma mark - IBActions

- (IBAction)didPressDoneBarButtonItem:(id)sender
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
}

@end
