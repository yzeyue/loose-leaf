//
//  MMUndoRedoRemoveScrapItem.h
//  LooseLeaf
//
//  Created by Adam Wulf on 7/5/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import "MMUndoRedoPageItem.h"
#import "MMScrapView.h"


@interface MMUndoRedoRemoveScrapItem : MMUndoRedoPageItem

@property (readonly) NSString* scrapUUID;

+ (id)itemForPage:(MMUndoablePaperView*)_page andScrapUUID:(NSString*)scrapUUID andProperties:(NSDictionary*)scrapProperties;

- (id)initForPage:(MMUndoablePaperView*)page andScrapUUID:(NSString*)scrapUUID andProperties:(NSDictionary*)scrapProperties;

@end
