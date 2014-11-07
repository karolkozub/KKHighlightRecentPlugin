//
//  KKFileUsageCounter.m
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-07.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import "KKFileUsageCounter.h"
#import "DVTDocumentLocation.h"


static NSString * const kFileTransitionNotificationName = @"transition from one file to another";
static NSString * const kFileTransitionNotificationNextFileKey = @"next";


@interface KKFileUsageCounter ()

@property (nonatomic, strong) NSMutableDictionary *highlightsForFileURLs;
@property (nonatomic, strong) NSURL *focusedFileURL;
@property (nonatomic, assign) double increment;
@property (nonatomic, assign) double decayFactor;
@property (nonatomic, assign) double highlightRemovalThreshold;

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

- (void)setup
{
    self.highlightsForFileURLs = [NSMutableDictionary new];
    self.focusedFileURL = nil;
    self.increment = 0.02;
    self.decayFactor = 0.95;
    self.highlightRemovalThreshold = 0.001;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileTransitionNotification:) name:kFileTransitionNotificationName object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)update
{
    for (NSURL *fileURL in self.highlightsForFileURLs.allKeys) {
        double highlight = [self.highlightsForFileURLs[fileURL] doubleValue];
        double updatedHighlight = (highlight + ([fileURL isEqual:self.focusedFileURL] ? self.increment : 0)) * self.decayFactor;
        
        if (updatedHighlight < self.highlightRemovalThreshold) {
            [self.highlightsForFileURLs removeObjectForKey:fileURL];
        
        } else {
            [self.highlightsForFileURLs setObject:@(updatedHighlight) forKey:fileURL];
        }
    }
}

- (void)fileTransitionNotification:(NSNotification *)notification
{
    DVTDocumentLocation *documentLocation = notification.object[kFileTransitionNotificationNextFileKey];
    
    self.focusedFileURL = documentLocation.documentURL;
    
    if (self.focusedFileURL && !self.highlightsForFileURLs[self.focusedFileURL]) {
        self.highlightsForFileURLs[self.focusedFileURL] = @(0);
    }
}

#pragma mark - KKNavigatorItemHighlighterDataSource

- (double)navigatorItemHighlighter:(KKNavigatorItemHighlighter *)navigatorItemHighlighter highlightForItem:(id)item
{
    if ([item respondsToSelector:@selector(fileURL)]) {
        return [self.highlightsForFileURLs[[item fileURL]] doubleValue];
    
    } else {
        return 0;
    }
}

@end
