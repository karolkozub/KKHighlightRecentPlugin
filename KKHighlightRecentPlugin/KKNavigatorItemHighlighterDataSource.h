//
//  KKNavigatorItemHighlighterDataSource.h
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-08.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <AppKit/AppKit.h>


@class KKNavigatorItemHighlighter, IDENavigableItem;


@protocol KKNavigatorItemHighlighterDataSource <NSObject>

- (double)navigatorItemHighlighter:(KKNavigatorItemHighlighter *)navigatorItemHighlighter highlightForFileUrl:(NSURL *)fileUrl;

@end
