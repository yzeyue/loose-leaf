//
//  MMUndoRedoAddScrapItem.h
//  LooseLeaf
//
//  Created by Adam Wulf on 7/5/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import "MMUndoRedoPageItem.h"
#import "MMScrapView.h"

@interface MMUndoRedoAddScrapItem : MMUndoRedoPageItem

@property (readonly) MMScrapView* scrap;

+(id) itemForPage:(MMUndoablePaperView*)_page andScrap:(MMScrapView*)scrap withUndoManager:(MMPageUndoRedoManager*)undoManager;

-(id) initForPage:(MMUndoablePaperView*)page andScrap:(MMScrapView*)scrap withUndoManager:(MMPageUndoRedoManager*)undoManager;

@end