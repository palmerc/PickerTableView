//
//  SHCTableViewDataStorage.m
//  TableView
//
//  Created by Cameron Palmer on 23.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCTableViewDataStorage.h"

@implementation SHCTableViewDataStorage

+ (instancetype)tableViewDataStorage
{
    return [[self alloc] initWithRandomValues:YES];
}

- (id)initWithRandomValues:(BOOL)randomValues
{
    self = [super init];
    if (self != nil) {
        int toSize = 54;
        int fromSize = 8;
        int range = (toSize - fromSize);
        CGFloat fontSize = (CGFloat)(arc4random() % range) + fromSize;
        _font = [UIFont systemFontOfSize:fontSize];
    }
    
    return self;
}

@end
