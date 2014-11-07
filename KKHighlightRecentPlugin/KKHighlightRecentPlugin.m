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
#import "IDEWorkspaceWindowController.h"


@implementation KKHighlightRecentPlugin

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    [self setup];
}

+ (void)setup
{
    [[KKFileUsageCounter sharedInstance] setup];
    [[KKNavigatorItemHighlighter sharedInstance] setup];
    [[KKNavigatorItemHighlighter sharedInstance] setDataSource:[KKFileUsageCounter sharedInstance]];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

+ (void)update
{
    [[KKFileUsageCounter sharedInstance] update];
    [[KKNavigatorItemHighlighter sharedInstance] update];
}

@end
