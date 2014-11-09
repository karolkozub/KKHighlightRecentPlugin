//
//  KKXcodeRuntime.h
//  KKHighlightRecentPlugin
//
//  Created by Karol Kozub on 2014-11-09.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DVTViewController : NSViewController
@end


@interface IDEViewController : DVTViewController
@end


@interface IDEEditorContext : IDEViewController

- (int)_openNavigableItem:(id)item documentExtension:(id)documentExtension document:(id)document shouldInstallEditorBlock:(id)block;

@end


@interface DVTTheme : NSObject

- (NSColor *)greenEmphasisBoxStrokeColor;
- (NSColor *)greenEmphasisBoxBackgroundColor;

@end


@interface _IDENavigatorOutlineViewDataSource : NSObject
@end


@interface DVTImageAndTextCell : NSTextFieldCell

- (void)setDrawsEmphasizeMarker:(BOOL)drawsEmphasizeMarker;

@end
