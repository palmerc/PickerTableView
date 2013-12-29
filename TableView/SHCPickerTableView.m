//
//  SHCPickerTableView.m
//  TableView
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCPickerTableView.h"



@interface SHCPickerTableView ()
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic, getter = isFirstRefresh) BOOL firstRefresh;

@end



@implementation SHCPickerTableView

- (void)dealloc
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    [self.displayLink invalidate];
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);

    _firstRefresh = YES;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayDidRefresh:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink = displayLink;
}



- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    [self scrollToCellAtIndexPath:selectedIndexPath];
    [self highlightCellAtIndexPath:selectedIndexPath];
    
    _selectedIndexPath = selectedIndexPath;
}

- (void)scrollToCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
}

- (void)highlightCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedImageView != nil) {
        [self.selectedImageView removeFromSuperview];
        self.selectedImageView = nil;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    UIColor *originalColor = cell.backgroundColor;
    cell.backgroundColor = [UIColor yellowColor];
    if (cell != nil) {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:cellImage];
        [self addSubview:selectedImageView];
        CGRect rect = [self rectForRowAtIndexPath:indexPath];
        selectedImageView.frame = CGRectOffset(selectedImageView.bounds, rect.origin.x, rect.origin.y);
        
        selectedImageView.layer.masksToBounds = NO;
        selectedImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        selectedImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        selectedImageView.layer.shadowRadius = 6.0f;
        selectedImageView.layer.shadowOpacity = 0.8f;
        selectedImageView.layer.opacity = 1.0f;
        
        [UIView animateWithDuration:0.25f animations:^{
            selectedImageView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            selectedImageView.center = CGPointMake(cell.center.x * 1.1f, cell.center.y);
        }];
        
        self.selectedImageView = selectedImageView;
    }
    cell.backgroundColor = originalColor;
    
}

- (void)didScrollTableView:(CGFloat)points
{
    int direction = points > 0.0f ? 1 : -1;

    static CGFloat currentLeftoverPoints = 0.0f;
    currentLeftoverPoints += fabsf(points);

    NSIndexPath *currentIndexPath = self.selectedIndexPath;
    UITableViewCell *currentCell = [self cellForRowAtIndexPath:currentIndexPath];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + direction inSection:currentIndexPath.section];
    UITableViewCell *nextCell = [self cellForRowAtIndexPath:newIndexPath];
    CGFloat nextCellHeight = CGRectGetHeight(nextCell.frame);
    
    [self beginUpdates];
    while (currentLeftoverPoints > nextCellHeight) {
        DDLogVerbose(@"MoveRowAtIndexPathRow:%d toIndexPathRow:%d", currentIndexPath.row, newIndexPath.row);
        if ([self.dataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
            [self.dataSource tableView:self moveRowAtIndexPath:currentIndexPath toIndexPath:newIndexPath];
        }
        currentLeftoverPoints -= nextCellHeight;
        
        [self highlightCellAtIndexPath:newIndexPath];
        _selectedIndexPath = newIndexPath;
        
        currentIndexPath = self.selectedIndexPath;
        currentCell = [self cellForRowAtIndexPath:currentIndexPath];
        
        newIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + direction inSection:currentIndexPath.section];
        nextCell = [self cellForRowAtIndexPath:newIndexPath];
        nextCellHeight = CGRectGetHeight(nextCell.frame);
    }
    [self endUpdates];
}



#pragma mark - CADisplayLink callback

- (void)displayDidRefresh:(CADisplayLink *)displayLink
{
    static CGFloat previousContentOffsetY = 0.0f;
    UIEdgeInsets contentInsets = self.contentInset;
    CGFloat currentContentOffsetY = self.contentOffset.y + contentInsets.top;
    
    if (previousContentOffsetY != currentContentOffsetY) {
        CGFloat points = currentContentOffsetY - previousContentOffsetY;
        if (!self.isFirstRefresh) {
            [self didScrollTableView:points];
        } else {
            self.firstRefresh = NO;
        }
        
        previousContentOffsetY = currentContentOffsetY;
    }
 }

@end
