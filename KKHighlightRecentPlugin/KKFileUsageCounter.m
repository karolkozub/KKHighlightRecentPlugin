//
//  KKFileUsageCounter.m
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-07.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import "KKFileUsageCounter.h"
#import "DVTDocumentLocation.h"
#import "IDEEditorContext.h"
#import "IDENavigableItem.h"
#import <objc/runtime.h>


@interface IDEEditorContext (KKHighlightRecentPlugin)

+ (void)kk_swizzleMethods;

@end


@interface KKFileUsageCounter ()

@property (nonatomic, strong) NSMutableDictionary *highlightsForFileUrls;
@property (nonatomic, strong) NSURL *focusedFileUrl;
@property (nonatomic, assign) double focusedFileHighlightIncrement;
@property (nonatomic, assign) double highlightDecayFactor;
@property (nonatomic, assign) double highlightRemovalThreshold;
@property (nonatomic, assign) double highlightPrecision;
@property (nonatomic, assign) NSTimeInterval updateInterval;

@end


@implementation KKFileUsageCounter

+ (instancetype)sharedInstance
{
    static KKFileUsageCounter *sharedInstance;
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
        self.highlightsForFileUrls = [NSMutableDictionary dictionary];
        self.focusedFileUrl = nil;
        self.focusedFileHighlightIncrement = 0.001;
        self.highlightDecayFactor = 0.999;
        self.highlightPrecision = 0.05;
        self.highlightRemovalThreshold = 0.01;
        self.updateInterval = 0.1;
    }
    
    return self;
}

- (void)setup
{
    [IDEEditorContext kk_swizzleMethods];
}

- (void)start
{
    [NSTimer scheduledTimerWithTimeInterval:self.updateInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)update
{
    for (NSURL *fileUrl in [self.highlightsForFileUrls.keyEnumerator allObjects]) {
        double highlight = [self.highlightsForFileUrls[fileUrl] doubleValue];
        double increment = [fileUrl isEqual:self.focusedFileUrl] ? self.focusedFileHighlightIncrement : 0;
        double updatedHighlight = (highlight + increment) * self.highlightDecayFactor;
        
        if ([self roundedHighlightForHighlight:updatedHighlight] < self.highlightRemovalThreshold) {
            [self.highlightsForFileUrls removeObjectForKey:fileUrl];
            
        } else {
            [self.highlightsForFileUrls setObject:@(updatedHighlight) forKey:fileUrl];
        }
        
        if ([self isHighlightChangeSignificantForHighlight:highlight updatedHighlight:updatedHighlight]) {
            [self.delegate fileUsageCounter:self didUpdateHighlightForFileUrl:fileUrl];
        }
    }
}

- (BOOL)isHighlightChangeSignificantForHighlight:(double)highlight updatedHighlight:(double)updatedHighlight
{
    return [self roundedHighlightForHighlight:highlight] != [self roundedHighlightForHighlight:updatedHighlight];
}

- (double)roundedHighlightForHighlight:(double)highlight
{
    return MAX(0, MIN(1, ceil(highlight / self.highlightPrecision) * self.highlightPrecision));
}

#pragma mark - API for IDEEditorContext

- (void)editorContext:(IDEEditorContext *)editorContext didOpenItem:(id)item
{
    if ([item respondsToSelector:@selector(fileURL)]) {
        self.focusedFileUrl = [item fileURL];

        if (self.focusedFileUrl && ![self.highlightsForFileUrls objectForKey:self.focusedFileUrl]) {
            [self.highlightsForFileUrls setObject:@(self.highlightRemovalThreshold) forKey:self.focusedFileUrl];
        }
    }
}

#pragma mark - KKNavigatorItemHighlighterDataSource

- (double)navigatorItemHighlighter:(KKNavigatorItemHighlighter *)navigatorItemHighlighter highlightForFileUrl:(NSURL *)fileUrl
{
    return [self roundedHighlightForHighlight:[self.highlightsForFileUrls[fileUrl] doubleValue]];
}

@end


@implementation IDEEditorContext (KKHighlightRecentPlugin)

- (int)kk__openNavigableItem:(id)item documentExtension:(id)documentExtension document:(id)document shouldInstallEditorBlock:(id)block
{
    [[KKFileUsageCounter sharedInstance] editorContext:self didOpenItem:item];
    
    return [self kk__openNavigableItem:item documentExtension:documentExtension document:document shouldInstallEditorBlock:block];
}

+ (void)kk_swizzleMethods
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(_openNavigableItem:documentExtension:document:shouldInstallEditorBlock:);
        SEL swizzledSelector = @selector(kk__openNavigableItem:documentExtension:document:shouldInstallEditorBlock:);
        
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

@end
