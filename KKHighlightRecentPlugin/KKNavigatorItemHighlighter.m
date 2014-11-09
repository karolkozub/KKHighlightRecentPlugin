//
//  KKNavigatorItemHighlighter.m
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-07.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import "KKNavigatorItemHighlighter.h"
#import "KKXcodeRuntime.h"
#import "NSObject+KKSwizzleMethods.h"


static NSColor *sHighlightedItemStrokeColor;
static NSColor *sHighlightedItemBackgroundColor;


@interface KKNavigatorItemHighlighter ()

@property (nonatomic, strong) NSMapTable *highlightedItemsForUrls;
@property (nonatomic, weak) NSOutlineView *outlineView;

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

#pragma mark - API for _IDENavigatorOutlineViewDataSource

- (double)highlightForFileUrl:(NSURL *)fileUrl
{
    return [self.dataSource navigatorItemHighlighter:self highlightForFileUrl:fileUrl];
}

- (void)outlineView:(NSOutlineView *)outlineView didHighlightItem:(IDENavigableItem *)item withFileUrl:(NSURL *)fileUrl
{
    [self setOutlineView:outlineView];
    [self.highlightedItemsForUrls setObject:item forKey:fileUrl];
}

- (void)outlineView:(NSOutlineView *)outlineView didUnhighlightItem:(IDENavigableItem *)item withFileUrl:(NSURL *)fileUrl
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

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DVTTheme kk_swizzleMethodWithOriginalSelector:@selector(greenEmphasisBoxStrokeColor)];
        [DVTTheme kk_swizzleMethodWithOriginalSelector:@selector(greenEmphasisBoxBackgroundColor)];
    });
}

- (NSColor *)kk_greenEmphasisBoxStrokeColor
{
    NSColor *color = sHighlightedItemStrokeColor ?: [NSColor clearColor];
    
    sHighlightedItemStrokeColor = nil;
    
    return color;
}

- (NSColor *)kk_greenEmphasisBoxBackgroundColor
{
    NSColor *color = sHighlightedItemBackgroundColor ?: [NSColor clearColor];
    
    sHighlightedItemBackgroundColor = nil;
    
    return color;
}

@end


@implementation _IDENavigatorOutlineViewDataSource (KKHighlightRecentPlugin)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_IDENavigatorOutlineViewDataSource kk_swizzleMethodWithOriginalSelector:@selector(outlineView:willDisplayCell:forTableColumn:item:)];
    });
}

- (void)kk_outlineView:(id)outlineView willDisplayCell:(id)cell forTableColumn:(id)column item:(id)item
{
    [self kk_outlineView:outlineView willDisplayCell:cell forTableColumn:column item:item];
    
    BOOL cellCannotBeHighlighted = ![cell respondsToSelector:@selector(setDrawsEmphasizeMarker:)];
    BOOL itemDoesNotRepresentAFile = ![item respondsToSelector:@selector(fileURL)];
    
    if (cellCannotBeHighlighted || itemDoesNotRepresentAFile) {
        return;
    }
    
    NSURL *fileUrl = [item fileURL];
    BOOL outlineViewIsFocused = [[outlineView window] isMainWindow];
    BOOL cellIsNotSelected = ![cell isHighlighted];
    double highlight = [[KKNavigatorItemHighlighter sharedInstance] highlightForFileUrl:fileUrl];
    
    if (outlineViewIsFocused && cellIsNotSelected && highlight > 0) {
        NSColor *color = [[NSColor yellowColor] colorWithAlphaComponent:highlight];
        
        sHighlightedItemStrokeColor = color;
        sHighlightedItemBackgroundColor = color;
        
        [cell setDrawsEmphasizeMarker:YES];
        [[KKNavigatorItemHighlighter sharedInstance] outlineView:outlineView didHighlightItem:item withFileUrl:fileUrl];
    
    } else {
        [[KKNavigatorItemHighlighter sharedInstance] outlineView:outlineView didUnhighlightItem:item withFileUrl:fileUrl];
    }
}

@end
