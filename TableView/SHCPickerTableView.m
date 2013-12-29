//
//  SHCPickerTableView.m
//  TableView
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCPickerTableView.h"



@interface SHCPickerTableView ()
@end



@implementation SHCPickerTableView

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    _selectedIndexPath = selectedIndexPath;
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:self.selectedIndexPath];
    
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *draggingView = [[UIImageView alloc] initWithImage:cellImage];
    [self addSubview:draggingView];
    CGRect rect = [self rectForRowAtIndexPath:self.selectedIndexPath];
    draggingView.frame = CGRectOffset(draggingView.bounds, rect.origin.x, rect.origin.y);
    
    // add drop shadow to image and lower opacity
    draggingView.layer.masksToBounds = NO;
    draggingView.layer.shadowColor = [[UIColor blackColor] CGColor];
    draggingView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    draggingView.layer.shadowRadius = 4.0f;
    draggingView.layer.shadowOpacity = 0.8f;
    draggingView.layer.opacity = 1.0f;
    
    // zoom image towards user
    [UIView animateWithDuration:0.20f animations:^{
        draggingView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        draggingView.center = CGPointMake(cell.center.x * 1.1f, cell.center.y);
    }];
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

@end
