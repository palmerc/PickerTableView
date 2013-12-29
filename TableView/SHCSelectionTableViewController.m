//
//  SHCViewController.m
//  TableView
//
//  Created by Cameron Palmer on 23.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCSelectionTableViewController.h"

#import "SHCTableViewCell.h"
#import "SHCTableViewDataStorage.h"
#import "SHCMoveTableViewController.h"

static NSString *kMoveTableViewControllerSegue = @"MoveTableViewControllerSegue";
static NSString *kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";



@interface SHCSelectionTableViewController ()
@property (strong, nonatomic) NSArray *tableViewData;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end



@implementation SHCSelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    self.title = NSLocalizedString(@"Select a cell", @"Select a cell");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStylePlain target:nil action:nil];
    self.nextBarButtonItem.title = NSLocalizedString(@"Next", @"Next");
    self.nextBarButtonItem.enabled = NO;
    
    NSMutableArray *mutableTableViewData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++) {
        SHCTableViewDataStorage *dataStorage = [SHCTableViewDataStorage tableViewDataStorage];
        dataStorage.text = [NSString stringWithFormat:@"%d", i];
        [mutableTableViewData addObject:dataStorage];
        
    }
    
    self.tableViewData = [mutableTableViewData copy];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMoveTableViewControllerSegue]) {
        NSIndexPath *indexPath = sender;
        SHCMoveTableViewController *moveTableViewController = segue.destinationViewController;
        moveTableViewController.selectedIndexPath = indexPath;
        moveTableViewController.tableViewData = self.tableViewData;
    }
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
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL enableNextButton;
    if (self.selectedIndexPath == nil) {
        enableNextButton = YES;
        
        DDLogVerbose(@"Reloading: %@", indexPath);
        self.selectedIndexPath = indexPath;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else if ([self.selectedIndexPath isEqual:indexPath]) {
        enableNextButton = NO;

        DDLogVerbose(@"Reloading: %@", indexPath);
        self.selectedIndexPath = nil;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        enableNextButton = YES;
        
        NSIndexPath *oldIndexPath = self.selectedIndexPath;
        self.selectedIndexPath = indexPath;

        DDLogVerbose(@"Reloading: %@ %@", oldIndexPath, self.selectedIndexPath);
        [tableView reloadRowsAtIndexPaths:@[oldIndexPath, self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
    self.nextBarButtonItem.enabled = enableNextButton;
}



#pragma mark - IBActions

- (IBAction)didPressNextBarButtonItem:(id)sender
{
    [self performSegueWithIdentifier:kMoveTableViewControllerSegue sender:self.selectedIndexPath];
}

@end
