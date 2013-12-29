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
        selectedImageView.layer.opacity = 0.5f;
        
        [UIView animateWithDuration:0.25f animations:^{
            selectedImageView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            selectedImageView.center = CGPointMake(cell.center.x * 1.1f, cell.center.y);
        }];
        
        self.selectedImageView = selectedImageView;
    }
    
}

- (void)didScrollTableView:(CGFloat)points
{
    static CGFloat currentLeftoverPoints = 0.0f;
    currentLeftoverPoints += points;
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:self.selectedIndexPath];
    CGFloat cellHeight = CGRectGetHeight(cell.frame);

    int numberOfCellsCrossed = floorf(fabsf(currentLeftoverPoints) / cellHeight);
    
    [self beginUpdates];
    for (int i = 0; i < numberOfCellsCrossed; i++) {
        CGFloat distance = cellHeight * numberOfCellsCrossed;
        CGFloat direction = currentLeftoverPoints < 0.0f ? -1.0f : 1.0f;
        
        NSIndexPath *currentIndexPath = self.selectedIndexPath;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row + numberOfCellsCrossed inSection:currentIndexPath.section];
        DDLogVerbose(@"MoveRowAtIndexPath:%@ toIndexPath:%@", currentIndexPath, newIndexPath);
        [self moveRowAtIndexPath:currentIndexPath toIndexPath:newIndexPath];
        currentLeftoverPoints += direction * distance;
        
        [self highlightCellAtIndexPath:newIndexPath];
        _selectedIndexPath = newIndexPath;
    }
    [self endUpdates];
}



#pragma mark - CADisplayLink callback

- (void)displayDidRefresh:(CADisplayLink *)displayLink
{
    static CGFloat previousContentOffsetY;
    UIEdgeInsets contentInsets = self.contentInset;
    CGFloat currentContentOffsetY = self.contentOffset.y + contentInsets.top;
    
    if (previousContentOffsetY != currentContentOffsetY) {
        CGFloat points = currentContentOffsetY - previousContentOffsetY;
        if (!self.isFirstRefresh) {
            DDLogVerbose(@"offset: %f", points);
            
            [self didScrollTableView:points];
        } else {
            self.firstRefresh = NO;
        }
        
        previousContentOffsetY = currentContentOffsetY;
    }
 }

@end
