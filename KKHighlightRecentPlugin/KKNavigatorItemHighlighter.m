//
//  KKNavigatorItemHighlighter.m
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-07.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import "KKNavigatorItemHighlighter.h"
#import "DVTTheme.h"
#import "DVTImageAndTextCell.h"
#import "_IDENavigatorOutlineViewDataSource.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>


static NSColor *sHighlightedItemStrokeColor;
static NSColor *sHighlightedItemBackgroundColor;


@interface DVTTheme (KKHighlightRecentPlugin)

+ (void)kk_swizzleMethods;

@end

@interface _IDENavigatorOutlineViewDataSource (KKHighlightRecentPlugin)

+ (void)kk_swizzleMethods;

@end


@implementation KKNavigatorItemHighlighter

+ (instancetype)sharedInstance
{
    static KKNavigatorItemHighlighter *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (void)setup
{
    [DVTTheme kk_swizzleMethods];
    [_IDENavigatorOutlineViewDataSource kk_swizzleMethods];
}

- (void)update
{
}

- (double)highlightForItem:(IDENavigableItem *)item
{
    return [self.dataSource navigatorItemHighlighter:self highlightForItem:item];
}

@end


@implementation DVTTheme (KKHighlightRecentPlugin)

- (NSColor *)kk_greenEmphasisBoxStrokeColor
{
    NSColor *color = sHighlightedItemStrokeColor ?: [self kk_greenEmphasisBoxStrokeColor];
    
    sHighlightedItemStrokeColor = nil;
    
    return color;
}

- (NSColor *)kk_greenEmphasisBoxBackgroundColor
{
    NSColor *color = sHighlightedItemBackgroundColor ?: [self kk_greenEmphasisBoxBackgroundColor];
    
    sHighlightedItemBackgroundColor = nil;
    
    return color;
}

+ (void)kk_swizzleMethods
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (NSString *originalSelectorString in @[@"greenEmphasisBoxStrokeColor", @"greenEmphasisBoxBackgroundColor"]) {
            SEL originalSelector = NSSelectorFromString(originalSelectorString);
            SEL swizzledSelector = NSSelectorFromString([@[@"kk_", originalSelectorString] componentsJoinedByString:@""]);
        
            Method originalMethod = class_getInstanceMethod([self class], originalSelector);
            Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

@end


@implementation _IDENavigatorOutlineViewDataSource (KKHighlightRecentPlugin)

- (void)kk_outlineView:(id)outlineView willDisplayCell:(DVTImageAndTextCell *)cell forTableColumn:(id)column item:(IDENavigableItem *)item
{
    double highlightForItem = [[KKNavigatorItemHighlighter sharedInstance] highlightForItem:item];
    
    if ([cell isKindOfClass:[DVTImageAndTextCell class]]) {
        cell.drawsEmphasizeMarker = NO;
    }
    
    [self kk_outlineView:outlineView willDisplayCell:cell forTableColumn:column item:item];
    
    if ([cell isKindOfClass:[DVTImageAndTextCell class]] && highlightForItem > 0 && !cell.drawsEmphasizeMarker) {
        NSColor *color = [[NSColor yellowColor] colorWithAlphaComponent:highlightForItem];
        
        cell.drawsEmphasizeMarker = !cell.isHighlighted;
        sHighlightedItemStrokeColor = color;
        sHighlightedItemBackgroundColor = color;
    }
}

+ (void)kk_swizzleMethods
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(outlineView:willDisplayCell:forTableColumn:item:);
        SEL swizzledSelector = @selector(kk_outlineView:willDisplayCell:forTableColumn:item:);
        
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

@end
