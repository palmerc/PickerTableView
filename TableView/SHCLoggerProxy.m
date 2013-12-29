//
//  SHCLoggerProxy.m
//  Generic
//
//  Created by Cameron Palmer on 29.12.13.
//  Copyright (c) 2013 Shortcut AS. All rights reserved.
//

#import "SHCLoggerProxy.h"



@interface SHCLoggerProxy ()
@property (strong, nonatomic) id proxiedObject;

@end



@implementation SHCLoggerProxy

- (id)initWithObject:(id)anObject
{
    self = [super init];
    if (self != nil) {
        _proxiedObject = anObject;
    }
    
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:selector];
    if (!methodSignature)
    {
        methodSignature = [self.proxiedObject methodSignatureForSelector:selector];
    }
    
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSLog(@"[%@ %@] %@ %@", self.proxiedObject, invocation, [invocation methodSignature],
          NSStringFromSelector([invocation selector]));
    [invocation invokeWithTarget:self.proxiedObject];
}

@end
