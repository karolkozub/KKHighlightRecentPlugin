/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */


#import "DVTProgressIndicatorProvidingView-Protocol.h"

@class DVTMapTable, NSArray, NSEvent, NSIndexSet, NSString, NSTextField, NSTextFieldCell, NSTrackingArea;

@interface DVTOutlineView : NSOutlineView <DVTProgressIndicatorProvidingView>
{
    NSTextField *_emptyContentLabel;
    NSTextField *_emptyContentSublabel;
    NSIndexSet *_draggedRows;
    NSEvent *_event;
    DVTMapTable *_progressIndicatorsByItem;
    long long _maxAlternatingRowBackgroundLevelInGroupRow;
    id _timer;
    id _itemUnderHoveredMouse;
    NSEvent *_stashedMouseMovedEvent;
    NSTrackingArea *_mouseHoverTrackingArea;
    NSTextFieldCell *_dataCellForGroupRow;
    int _dvt_groupRowStyle;
    int _indentationStyle;
    struct {
        unsigned int breaksCyclicSortDescriptors:1;
        unsigned int delegateRespondsToShouldMouseHover:1;
        unsigned int hasSetCustomNonLocalDraggingSourceOperationMask:1;
        unsigned int hasSetCustomLocalDraggingSourceOperationMask:1;
        unsigned int revealsOutlineCellUnderHoveredMouseAfterDelay:1;
        unsigned int allowsSizingShorterThanClipView:1;
        unsigned int reserved:2;
    } _dvtOVFlags;
    BOOL _groupRowBreaksAlternatingRowBackgroundCycle;
    unsigned long long _gridLineStyleBeforeEmptyContentStringShown;
    BOOL _skipGridLinesOnLastRow;
    BOOL _skipGridLinesOnCollapsedGroupRows;
    int _emptyContentStringStyle;
    NSString *_emptyContentString;
    NSString *_emptyContentSubtitle;
}

@property(retain) NSEvent *event; // @synthesize event=_event;
@property BOOL skipGridLinesOnCollapsedGroupRows; // @synthesize skipGridLinesOnCollapsedGroupRows=_skipGridLinesOnCollapsedGroupRows;
@property BOOL skipGridLinesOnLastRow; // @synthesize skipGridLinesOnLastRow=_skipGridLinesOnLastRow;
@property(retain) id itemUnderHoveredMouse; // @synthesize itemUnderHoveredMouse=_itemUnderHoveredMouse;
@property int indentationStyle; // @synthesize indentationStyle=_indentationStyle;
@property int dvt_groupRowStyle; // @synthesize dvt_groupRowStyle=_dvt_groupRowStyle;
@property(nonatomic) long long maxAlternatingRowBackgroundLevelInGroupRow; // @synthesize maxAlternatingRowBackgroundLevelInGroupRow=_maxAlternatingRowBackgroundLevelInGroupRow;
@property(nonatomic) BOOL groupRowBreaksAlternatingRowBackgroundCycle; // @synthesize groupRowBreaksAlternatingRowBackgroundCycle=_groupRowBreaksAlternatingRowBackgroundCycle;
@property(copy) NSIndexSet *draggedRows; // @synthesize draggedRows=_draggedRows;
@property int emptyContentStringStyle; // @synthesize emptyContentStringStyle=_emptyContentStringStyle;
@property(copy, nonatomic) NSString *emptyContentSubtitle; // @synthesize emptyContentSubtitle=_emptyContentSubtitle;
@property(copy, nonatomic) NSString *emptyContentString; // @synthesize emptyContentString=_emptyContentString;
- (unsigned long long)draggingSourceOperationMaskForLocal:(BOOL)arg1;
- (void)setDraggingSourceOperationMask:(unsigned long long)arg1 forLocal:(BOOL)arg2;
- (id)dragImageForRowsWithIndexes:(id)arg1 tableColumns:(id)arg2 event:(id)arg3 offset:(struct CGPoint *)arg4;
- (void)concludeDragOperation:(id)arg1;
- (void)draggingEnded:(id)arg1;
- (unsigned long long)draggingUpdated:(id)arg1;
- (unsigned long long)draggingEntered:(id)arg1;
- (void)mouseExited:(id)arg1;
- (void)mouseMoved:(id)arg1;
- (void)delayedProcessMouseMovedEvent;
- (void)restartMouseHoverTimer;
- (void)invalidateMouseHoverTimer;
- (void)updateDisplayOfItemUnderMouse:(id)arg1;
- (void)setItemUnderMouseAndMarkForRedisplay:(id)arg1;
- (void)updateTrackingAreas;
@property BOOL revealsOutlineCellUnderHoveredMouseAfterDelay;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)insertText:(id)arg1;
- (void)doCommandBySelector:(SEL)arg1;
- (void)keyDown:(id)arg1;
- (void)viewWillMoveToSuperview:(id)arg1;
- (void)viewWillDraw;
- (BOOL)_shouldRemoveProgressIndicator:(id)arg1 forItem:(id)arg2 andVisibleRect:(struct CGRect)arg3;
- (void)_showEmptyContentSublabel;
- (void)_hideEmptyContentSublabel;
- (void)_showEmptyContentLabel;
- (void)_hideEmptyContentLabel;
- (id)preparedCellAtColumn:(long long)arg1 row:(long long)arg2;
- (Class)groupRowCellClassForDataCell:(id)arg1;
- (id)_dataCellForGroupRowWithClass:(Class)arg1;
- (id)groupRowFont;
- (void)_drawRowHeaderSeparatorInClipRect:(struct CGRect)arg1;
- (void)drawGridInClipRect:(struct CGRect)arg1;
- (void)_drawBackgroundForGroupRow:(long long)arg1 clipRect:(struct CGRect)arg2 isButtedUpRow:(BOOL)arg3;
- (void)drawBackgroundInClipRect:(struct CGRect)arg1;
- (struct CGRect)frameOfOutlineCellAtRow:(long long)arg1;
- (struct CGRect)frameOfCellAtColumn:(long long)arg1 row:(long long)arg2;
@property(readonly) NSArray *contextMenuSelectedItems;
@property(retain) NSArray *selectedItems;
- (id)_itemsAtIndexes:(id)arg1;
@property(readonly) NSIndexSet *contextMenuSelectedRowIndexes;
@property(readonly) NSIndexSet *clickedRowIndexes;
- (void)setSortDescriptors:(id)arg1;
- (struct CGSize)_adjustFrameSizeToFitSuperview:(struct CGSize)arg1;
@property BOOL allowsSizingShorterThanClipView;
@property BOOL breaksCyclicSortDescriptors;
- (id)progressIndicatorForItem:(id)arg1 createIfNecessary:(BOOL)arg2 progressIndicatorStyle:(unsigned long long)arg3;
- (void)clearProgressIndicators;
- (void)setDelegate:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)dvt_commonInit;

@end
