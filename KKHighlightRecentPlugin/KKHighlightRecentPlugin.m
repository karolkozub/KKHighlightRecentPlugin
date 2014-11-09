//
//  KKHighlightRecentPlugin.m
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-01.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import "KKHighlightRecentPlugin.h"
#import "KKFileUsageCounter.h"
#import "KKNavigatorItemHighlighter.h"


@implementation KKHighlightRecentPlugin

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    KKFileUsageCounter *fileUsageCounter = [KKFileUsageCounter sharedInstance];
    KKNavigatorItemHighlighter *navigatorItemHighlighter = [KKNavigatorItemHighlighter sharedInstance];
    
    [fileUsageCounter setDelegate:navigatorItemHighlighter];
    [navigatorItemHighlighter setDataSource:fileUsageCounter];
    
    [fileUsageCounter start];
}

@end
