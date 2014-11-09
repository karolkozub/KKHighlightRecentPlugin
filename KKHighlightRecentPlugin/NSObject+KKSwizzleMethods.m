//
//  NSObject+KKSwizzleMethods.m
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-09.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+KKSwizzleMethods.h"


@implementation NSObject (KKSwizzleMethods)

+ (void)kk_swizzleMethodWithOriginalSelector:(SEL)originalSelector
{
    SEL swizzledSelector = NSSelectorFromString([@"kk_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
    
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    
    NSAssert(originalMethod, nil);
    NSAssert(swizzledMethod, nil);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end
