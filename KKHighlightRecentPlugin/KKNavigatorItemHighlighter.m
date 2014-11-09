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
#import "IDENavigatorOutlineView.h"
#import "_IDENavigatorOutlineViewDataSource.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>


static NSColor *sHighlightedItemStrokeColor;
static NSColor *sHighlightedItemBackgroundColor;


@interface KKNavigatorItemHighlighter ()

@property (nonatomic, strong) NSMapTable *highlightedItemsForUrls;
@property (nonatomic, weak) IDENavigatorOutlineView *outlineView;

@end

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

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.highlightedItemsForUrls = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    
    return self;
}

- (void)setup
{
    [DVTTheme kk_swizzleMethods];
    [_IDENavigatorOutlineViewDataSource kk_swizzleMethods];
}

- (double)highlightForFileUrl:(NSURL *)fileUrl
{
    return [self.dataSource navigatorItemHighlighter:self highlightForFileUrl:fileUrl];
}

#pragma mark - API for _IDENavigatorOutlineViewDataSource

- (void)outlineView:(IDENavigatorOutlineView *)outlineView didHighlightItem:(IDENavigableItem *)item withFileUrl:(NSURL *)fileUrl
{
    [self setOutlineView:outlineView];
    [self.highlightedItemsForUrls setObject:item forKey:fileUrl];
}

- (void)outlineView:(IDENavigatorOutlineView *)outlineView didUnhighlightItem:(IDENavigableItem *)item withFileUrl:(NSURL *)fileUrl
{
    [self setOutlineView:outlineView];
    [self.highlightedItemsForUrls removeObjectForKey:fileUrl];
}

#pragma mark - KKFileUsageCounterDelegate

- (void)fileUsageCounter:(KKFileUsageCounter *)fileUsageCounter didUpdateHighlightForFileUrl:(NSURL *)fileUrl
{
    id item = [self.highlightedItemsForUrls objectForKey:fileUrl];
    
    if (item) {
        [self.outlineView reloadItem:item];
    }
}

@end


@implementation DVTTheme (KKHighlightRecentPlugin)

- (NSColor *)kk_greenEmphasisBoxStrokeColor
{
    NSColor *color = sHighlightedItemStrokeColor ?: [NSColor clearColor];
    
    sHighlightedItemStrokeColor = nil;
    
    return color;}

- (NSColor *)kk_greenEmphasisBoxBackgroundColor
{
    NSColor *color = sHighlightedItemBackgroundColor ?: [NSColor clearColor];
    
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

- (void)kk_outlineView:(id)outlineView willDisplayCell:(id)cell forTableColumn:(id)column item:(id)item
{
    [self kk_outlineView:outlineView willDisplayCell:cell forTableColumn:column item:item];
    
    BOOL cellCannotBeHighlighted = ![cell respondsToSelector:@selector(setDrawsEmphasizeMarker:)];
    BOOL itemDoesNotRepresentAFile = ![item respondsToSelector:@selector(fileURL)];
    
    if (cellCannotBeHighlighted || itemDoesNotRepresentAFile) {
        return;
    }
    
    BOOL outlineViewIsFocused = [[outlineView window] isMainWindow];
    BOOL cellIsNotSelected = ![cell isHighlighted];
    NSURL *fileUrl = [item fileURL];
    double highlightForItem = [[KKNavigatorItemHighlighter sharedInstance] highlightForFileUrl:fileUrl];
    
    if (outlineViewIsFocused && cellIsNotSelected && highlightForItem > 0) {
        NSColor *color = [[NSColor yellowColor] colorWithAlphaComponent:highlightForItem];
        
        sHighlightedItemStrokeColor = color;
        sHighlightedItemBackgroundColor = color;
        
        [cell setDrawsEmphasizeMarker:YES];
        [[KKNavigatorItemHighlighter sharedInstance] outlineView:self.outlineView didHighlightItem:item withFileUrl:fileUrl];
    
    } else {
        [[KKNavigatorItemHighlighter sharedInstance] outlineView:self.outlineView didUnhighlightItem:item withFileUrl:fileUrl];
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
