//
//  SHCTableViewDataStorage.h
//  TableView
//
//  Created by Cameron Palmer on 23.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHCTableViewDataStorage : NSObject
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIFont *font;

+ (instancetype)tableViewDataStorage;
- (id)initWithRandomValues:(BOOL)randomValues;

@end
