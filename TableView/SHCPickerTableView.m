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

@end



@implementation SHCPickerTableView

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
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayDidRefresh:)];
    displayLink.frameInterval = 60.0f;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;
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



#pragma mark - UIScrollViewDelegate

- (void)displayDidRefresh:(CADisplayLink *)displayLink
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    DDLogVerbose(@"%@", displayLink);
 
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = contentOffset.y + floorf(CGRectGetHeight(self.frame) / 2.0f);
    NSIndexPath *newIndexPath = [self indexPathForRowAtPoint:self.contentOffset];
    if (![self.selectedIndexPath isEqual:newIndexPath]) {
        [self moveRowAtIndexPath:self.selectedIndexPath toIndexPath:newIndexPath];
        [self highlightCellAtIndexPath:newIndexPath];
        self.selectedIndexPath = newIndexPath;
    }
 }

@end
