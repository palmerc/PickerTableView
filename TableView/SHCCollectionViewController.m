//
//  SHCViewController.m
//  TableView
//
//  Created by Cameron Palmer on 23.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCCollectionViewController.h"

#import "SHCCollectionViewCell.h"
#import "SHCTableViewDataStorage.h"

static NSString *kCollectionViewTableCellReuseIdentifier = @"CollectionViewTableCellReuseIdentifier";



@interface SHCCollectionViewController ()
@property (strong, nonatomic) NSArray *tableViewData;

@end



@implementation SHCCollectionViewController

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



#pragma mark - Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tableViewData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHCTableViewDataStorage *dataStorage = [self.tableViewData objectAtIndex:indexPath.row];

    SHCCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewTableCellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        collectionViewCell.backgroundColor = [UIColor whiteColor];
    } else {
        collectionViewCell.backgroundColor = [UIColor lightGrayColor];
    }

    collectionViewCell.textLabel.font = dataStorage.font;
    collectionViewCell.textLabel.text = dataStorage.text;
    
    return collectionViewCell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    NSLog(@"%@", attributes);
    
    CGFloat width = 320.0f;
    SHCTableViewDataStorage *dataStorage = [self.tableViewData objectAtIndex:indexPath.row];
    NSString *text = dataStorage.text;
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : dataStorage.font} context:nil];
    CGFloat height = ceilf(boundingRect.size.height) + 16.0f;
    return CGSizeMake(width, height);
}



#pragma mark -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected: %@", indexPath);
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%@", scrollView);
//}

@end
