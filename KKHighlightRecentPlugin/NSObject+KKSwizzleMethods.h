//
//  NSObject+KKSwizzleMethods.h
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-09.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KKSwizzleMethods)

+ (void)kk_swizzleMethodWithOriginalSelector:(SEL)originalSelector;

@end
