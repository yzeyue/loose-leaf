//
//  MMSingleStackManager.m
//  LooseLeaf
//
//  Created by Adam Wulf on 6/4/13.
//  Copyright (c) 2013 Milestone Made, LLC. All rights reserved.
//

#import "MMSingleStackManager.h"
#import "NSThread+BlockAdditions.h"
#import "NSArray+Map.h"
#import "MMBlockOperation.h"
#import "MMExportablePaperView.h"
#import "Mixpanel.h"
#import "NSString+UUID.h"
#import "NSArray+Extras.h"
#import "NSFileManager+DirectoryOptimizations.h"
#import "MMAllStacksManager.h"
#import <JotUI/UIImage+Alpha.h>

@implementation MMSingleStackManager

@synthesize uuid;

-(id) initWithUUID:(NSString*)_uuid visibleStack:(UIView*)_visibleStack andHiddenStack:(UIView*)_hiddenStack andBezelStack:(UIView*)_bezelStack{
    if(self = [super init]){
        uuid = _uuid;
        visibleStack = _visibleStack;
        hiddenStack = _hiddenStack;
        bezelStack = _bezelStack;
        
        opQueue = [[NSOperationQueue alloc] init];
        [opQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

-(NSString*) visiblePlistPath{
    return [MMSingleStackManager visiblePlistPathForStackUUID:self.uuid];
}

-(NSString*) hiddenPlistPath{
    return [MMSingleStackManager hiddenPlistPathForStackUUID:self.uuid];
}

-(void) saveStacksToDisk{
    [NSThread performBlockOnMainThread:^{
        // must use main thread to get the stack
        // of UIViews to save to disk
        
        NSArray* visiblePages = [NSArray arrayWithArray:visibleStack.subviews];
        NSMutableArray* hiddenPages = [NSMutableArray arrayWithArray:hiddenStack.subviews];
        NSMutableArray* bezelPages = [NSMutableArray arrayWithArray:bezelStack.subviews];
        while([bezelPages count]){
            id obj = [bezelPages lastObject];
            [hiddenPages addObject:obj];
            [bezelPages removeLastObject];
        }
        
        [opQueue addOperation:[[MMBlockOperation alloc] initWithBlock:^{
            // now that we have the views to save,
            // we can actually write to disk on the background
            //
            // the opqueue makes sure that we will always save
            // to disk in the order that [saveToDisk] was called
            // on the main thread.
            NSArray* visiblePagesToWrite = [visiblePages mapObjectsUsingSelector:@selector(dictionaryDescription)];
            NSArray* hiddenPagesToWrite = [hiddenPages mapObjectsUsingSelector:@selector(dictionaryDescription)];
            
            NSArray* allPagesToWrite = [visiblePagesToWrite arrayByAddingObjectsFromArray:[hiddenPagesToWrite reversedArray]];
            
            [[MMAllStacksManager sharedInstance] updateCachedPages:allPagesToWrite forStackUUID:uuid];

            [visiblePagesToWrite writeToFile:[self visiblePlistPath] atomically:YES];
            [hiddenPagesToWrite writeToFile:[self hiddenPlistPath] atomically:YES];
        }]];
    }];
}

-(BOOL) hasStateToLoad{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self visiblePlistPath]];
}

-(NSDictionary*) loadFromDiskWithBounds:(CGRect)bounds{
    NSDictionary* plist = [MMSingleStackManager loadFromDiskForStackUUID:self.uuid];
    
    NSArray* allPagesToWrite = [plist[@"visiblePages"] arrayByAddingObjectsFromArray:[plist[@"hiddenPages"] reversedArray]];
    [[MMAllStacksManager sharedInstance] updateCachedPages:allPagesToWrite forStackUUID:uuid];

    
    //    DebugLog(@"starting up with %d visible and %d hidden", (int)[visiblePagesToCreate count], (int)[hiddenPagesToCreate count]);
    
    NSMutableArray* visiblePages = [NSMutableArray array];
    NSMutableArray* hiddenPages = [NSMutableArray array];
    
    int hasFoundDuplicate = 0;
    NSMutableSet* seenPageUUIDs = [NSMutableSet set];
    
    for(NSDictionary* pageDict in plist[@"visiblePages"]){
        NSString* pageuuid = [pageDict objectForKey:@"uuid"];
        if(![seenPageUUIDs containsObject:pageuuid]){
            MMPaperView* page = [[MMExportablePaperView alloc] initWithFrame:bounds andUUID:pageuuid];
            [visiblePages addObject:page];
            [seenPageUUIDs addObject:pageuuid];
        }else{
            DebugLog(@"found duplicate page: %@", pageuuid);
            hasFoundDuplicate++;
        }
    }
    
    for(NSDictionary* pageDict in plist[@"hiddenPages"]){
        NSString* pageuuid = [pageDict objectForKey:@"uuid"];
        if(![seenPageUUIDs containsObject:pageuuid]){
            MMPaperView* page = [[MMExportablePaperView alloc] initWithFrame:bounds andUUID:pageuuid];
            [hiddenPages addObject:page];
            [seenPageUUIDs addObject:pageuuid];
        }else{
            DebugLog(@"found duplicate page: %@", pageuuid);
            hasFoundDuplicate++;
        }
    }
    
    if(hasFoundDuplicate){
        [[[Mixpanel sharedInstance] people] increment:kMPNumberOfDuplicatePages by:@(hasFoundDuplicate)];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:visiblePages, @"visiblePages",
            hiddenPages, @"hiddenPages", nil];
}

#pragma mark - Class methods

+(NSString*) visiblePlistPathForStackUUID:(NSString*)stackUUID{
    return [[[[MMAllStacksManager sharedInstance] stackDirectoryPathForUUID:stackUUID] stringByAppendingPathComponent:@"visiblePages"] stringByAppendingPathExtension:@"plist"];
}

+(NSString*) hiddenPlistPathForStackUUID:(NSString*)stackUUID{
    return [[[[MMAllStacksManager sharedInstance] stackDirectoryPathForUUID:stackUUID] stringByAppendingPathComponent:@"hiddenPages"] stringByAppendingPathExtension:@"plist"];
}

+(NSDictionary*) loadFromDiskForStackUUID:(NSString*)stackUUID{
    NSArray* visiblePagesToCreate = [[NSArray alloc] initWithContentsOfFile:[MMSingleStackManager visiblePlistPathForStackUUID:stackUUID]];
    NSArray* hiddenPagesToCreate = [[NSArray alloc] initWithContentsOfFile:[MMSingleStackManager hiddenPlistPathForStackUUID:stackUUID]];

    return [NSDictionary dictionaryWithObjectsAndKeys:visiblePagesToCreate, @"visiblePages",
            hiddenPagesToCreate, @"hiddenPages", nil];
}

+(UIImage*) hasThumbail:(BOOL*)thumbExists forPage:(NSString*)pageUUID forStack:(NSString*)stackUUID{
    NSString* stackPath = [[MMAllStacksManager sharedInstance] stackDirectoryPathForUUID:stackUUID];
    NSString* pagePath = [[stackPath stringByAppendingPathComponent:@"Pages"] stringByAppendingPathComponent:pageUUID];
    NSString* thumbPath = [pagePath stringByAppendingPathComponent:@"scrapped.thumb.png"];
    
    NSString* bundledDocsPath = [[NSBundle mainBundle] pathForResource:@"Documents" ofType:nil];
    NSString* bundledPagePath = [[bundledDocsPath stringByAppendingPathComponent:@"Pages"] stringByAppendingPathComponent:pageUUID];
    NSString* bundledThumbPath = [bundledPagePath stringByAppendingPathComponent:@"scrapped.thumb.png"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:thumbPath] || [[NSFileManager defaultManager] fileExistsAtPath:bundledThumbPath]){
        UIImage* thumb = [UIImage imageWithContentsOfFile:thumbPath];
        if(!thumb){
            thumb = [UIImage imageWithContentsOfFile:bundledThumbPath];
        }
        if(thumb){
            *thumbExists = YES;
            return thumb;
        }else{
            *thumbExists = YES;
            return nil;
        }
    }else if([[NSFileManager defaultManager] fileExistsAtPath:pagePath]){
        *thumbExists = YES;
        return nil;
    }else{
        *thumbExists = NO;
        return nil;
    }
    *thumbExists = NO;
    return nil;
}

@end
