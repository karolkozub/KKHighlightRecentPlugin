//
//  KKNavigatorItemHighlighter.h
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-07.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <AppKit/AppKit.h>


@class KKNavigatorItemHighlighter, IDENavigableItem;


@protocol KKNavigatorItemHighlighterDataSource <NSObject>

- (double)navigatorItemHighlighter:(KKNavigatorItemHighlighter *)navigatorItemHighlighter highlightForItem:(IDENavigableItem *)item;

@end


@interface KKNavigatorItemHighlighter : NSObject

@property (nonatomic, weak) id<KKNavigatorItemHighlighterDataSource> dataSource;

+ (instancetype)sharedInstance;
- (void)setup;
- (void)update;

@end
