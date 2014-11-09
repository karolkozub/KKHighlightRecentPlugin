//
//  KKFileUsageCounter.h
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-07.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "KKNavigatorItemHighlighterDataSource.h"
#import "KKFileUsageCounterDelegate.h"


@interface KKFileUsageCounter : NSObject<KKNavigatorItemHighlighterDataSource>

@property (nonatomic, weak) id<KKFileUsageCounterDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)start;

@end
