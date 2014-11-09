//
//  KKFileUsageCounterDelegate.h
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-08.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KKFileUsageCounter, IDENavigableItem;


@protocol KKFileUsageCounterDelegate <NSObject>

- (void)fileUsageCounter:(KKFileUsageCounter *)fileUsageCounter didUpdateHighlightForFileUrl:(NSURL *)fileUrl;

@end
