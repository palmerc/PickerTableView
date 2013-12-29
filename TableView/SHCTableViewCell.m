//
//  SHCCollectionViewCell.m
//  TableView
//
//  Created by Cameron Palmer on 23.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCTableViewCell.h"

@implementation SHCTableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
//    if (editing) {
//        UIView *scrollView = self.subviews[0];
//        for (UIView *view in scrollView.subviews) {
//            NSLog(@"Class: %@", NSStringFromClass([view class]));
//            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
//                for (UIView *subview in view.subviews) {
//                    if ([subview isKindOfClass:[UIImageView class]]) {
//                        ((UIImageView *)subview).image = [UIImage imageNamed:nil];
//                    }
//                }
//            }
//        }
//    }
}

@end
