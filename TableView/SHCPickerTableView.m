//
//  SHCPickerTableView.m
//  TableView
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCPickerTableView.h"



@interface SHCPickerTableView ()
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
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *draggingView = [[UIImageView alloc] initWithImage:cellImage];
    [self addSubview:draggingView];
    CGRect rect = [self rectForRowAtIndexPath:indexPath];
    draggingView.frame = CGRectOffset(draggingView.bounds, rect.origin.x, rect.origin.y);
    
    draggingView.layer.masksToBounds = NO;
    draggingView.layer.shadowColor = [[UIColor blackColor] CGColor];
    draggingView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    draggingView.layer.shadowRadius = 6.0f;
    draggingView.layer.shadowOpacity = 0.8f;
    draggingView.layer.opacity = 0.5f;
    
    [UIView animateWithDuration:0.25f animations:^{
        draggingView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        draggingView.center = CGPointMake(cell.center.x * 1.1f, cell.center.y);
    }];
}



#pragma mark - UIScrollViewDelegate

- (void)displayDidRefresh:(CADisplayLink *)displayLink
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    DDLogVerbose(@"%@", displayLink);

    
    static CGFloat previousYPostion = 0.0f;
    
    CGPoint contentOffset = self.contentOffset;
    
    CGFloat currentYPosition = contentOffset.y;
    if (currentYPosition > previousYPostion) {
        DDLogVerbose(@"Scrolling up.");
        previousYPostion = currentYPosition;
    } else if (currentYPosition < previousYPostion) {
        DDLogVerbose(@"Scrolling down.");
        previousYPostion = currentYPosition;
    }
}

@end
