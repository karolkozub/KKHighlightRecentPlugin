//
//  KKFileUsageCounter.h
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-07.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKNavigatorItemHighlighter.h"
#import "KKFileUsageCounterDelegate.h"


@interface KKFileUsageCounter : NSObject <KKNavigatorItemHighlighterDataSource>

@property (nonatomic, weak) id<KKFileUsageCounterDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)setup;
- (void)start;

@end
