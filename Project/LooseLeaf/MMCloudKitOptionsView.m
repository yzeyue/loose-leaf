//
//  MMCloudKitOptionsView.m
//  LooseLeaf
//
//  Created by Adam Wulf on 8/20/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import "MMCloudKitOptionsView.h"
#import "MMCloudKitDeclinedPermissionState.h"
#import "MMCloudKitWaitingForLoginState.h"
#import "MMCloudKitLoggedInState.h"
#import "MMCloudKitFetchFriendsState.h"
#import "MMCloudKitOfflineState.h"
#import "MMCloudKitFriendCollectionViewCell.h"
#import "MMCloudKitInviteCollectionViewCell.h"
#import "MMCloudKitShareListVerticalLayout.h"
#import "MMCloudKitShareListHorizontalLayout.h"
#import "MMCloudKitShareItem.h"
#import "MMOfflineIconView.h"
#import "MMCloudKeyIconView.h"
#import "Constants.h"
#import "MMRotationManager.h"
#import "NSThread+BlockAdditions.h"

@implementation MMCloudKitOptionsView{
    UILabel* cloudKitLabel;
    UICollectionView* listOfFriendsView;
    MMOfflineIconView* offlineView;
    MMCloudKeyIconView* needLoginView;
    
    UIButton* loginButton;
    
    NSArray* allKnownFriends;
    NSArray* allFriendsExceptSender;
}

@synthesize shareItem;

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGRect lblFr = self.bounds;
        lblFr.origin.y = kWidthOfSidebarButtonBuffer;
        
        cloudKitLabel = [[UILabel alloc] initWithFrame:lblFr];
        cloudKitLabel.backgroundColor = [UIColor clearColor];
        cloudKitLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cloudKitLabel.text = @"cloudkit!";
        cloudKitLabel.numberOfLines = 0;
        [self addSubview:cloudKitLabel];
        
        offlineView = [[MMOfflineIconView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        offlineView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        offlineView.center = CGPointMake(self.bounds.size.width/2, offlineView.bounds.size.height * 2 / 3);
        [self addSubview:offlineView];
        
        needLoginView = [[MMCloudKeyIconView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        needLoginView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        needLoginView.center = CGPointMake(self.bounds.size.width/2, needLoginView.bounds.size.height * 2 / 3);
        [self addSubview:needLoginView];
        
        
        
        loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        CGRect buttonFr = lblFr;
        buttonFr.origin.y = lblFr.origin.y + lblFr.size.height + kWidthOfSidebarButtonBuffer;
        loginButton.frame = buttonFr;
        [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        [loginButton sizeToFit];
        [self addSubview:loginButton];
        
        
        CGRect frForTable = self.bounds;
        frForTable.origin.y = kWidthOfSidebarButtonBuffer;
        frForTable.size.height -= kWidthOfSidebarButtonBuffer;
        listOfFriendsView = [[UICollectionView alloc] initWithFrame:frForTable collectionViewLayout:[[MMCloudKitShareListVerticalLayout alloc] init]];
        listOfFriendsView.backgroundColor = [UIColor clearColor];
        listOfFriendsView.opaque = NO;
        listOfFriendsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [listOfFriendsView registerClass:[MMCloudKitFriendCollectionViewCell class] forCellWithReuseIdentifier:@"MMCloudKitFriendCollectionViewCell"];
        [listOfFriendsView registerClass:[MMCloudKitInviteCollectionViewCell class] forCellWithReuseIdentifier:@"MMCloudKitInviteCollectionViewCell"];
        listOfFriendsView.showsHorizontalScrollIndicator = NO;
        listOfFriendsView.showsVerticalScrollIndicator = NO;
        listOfFriendsView.dataSource = self;
        listOfFriendsView.delegate = self;
        listOfFriendsView.delaysContentTouches = NO;
        [self addSubview:listOfFriendsView];

        [self cloudKitDidChangeState:[MMCloudKitManager sharedManager].currentState];
        
        [self updateInterfaceBasedOniCloudStatus];
    }
    return self;
}

-(void) loginButtonPressed{
    [[MMCloudKitManager sharedManager] userRequestedToLogin];
}

#pragma mark - MMShareOptionsView

-(void) reset{
    [super reset];
}

-(void) show{
    [super show];
    UICollectionViewLayout* layout = [self idealLayoutForOrientation:(UIInterfaceOrientation)[MMRotationManager sharedInstance].lastBestOrientation];
    [self updateDataSource];
    [listOfFriendsView setCollectionViewLayout:layout animated:NO];
    [self updateInterfaceBasedOniCloudStatus];
}

-(void) hide{
    [super hide];
    NSLog(@"hiding cloudkit view");
}

-(void) updateDataSource{
    allKnownFriends = [MMCloudKitManager sharedManager].currentState.friendList;
    allFriendsExceptSender = [allKnownFriends filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![[evaluatedObject objectForKey:@"recordId"] isEqual:[shareItem.cloudKitSenderInfo objectForKey:@"recordId"]];
    }]];
    
    #ifdef DEBUG
        [self addExtraUsers];
    #endif
    
    allFriendsExceptSender = [allFriendsExceptSender sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult lastResult = [[obj1 objectForKey:@"lastName"] compare:[obj2 objectForKey:@"lastName"] options:NSCaseInsensitiveSearch];
        if(lastResult != NSOrderedSame) return lastResult;
        return [[obj1 objectForKey:@"firstName"] compare:[obj2 objectForKey:@"firstName"] options:NSCaseInsensitiveSearch];
    }];
    [listOfFriendsView reloadData];
    
}

#pragma mark - CloudKit UI

BOOL hasSent = NO;
-(void) updateInterfaceBasedOniCloudStatus{
    NSString* cloudKitInfo = [[MMCloudKitManager sharedManager] description];
    
    cloudKitLabel.text = cloudKitInfo;
    [cloudKitLabel sizeToFit];
    
    CGRect lblFr = cloudKitLabel.frame;
    lblFr.origin.y = kWidthOfSidebarButtonBuffer;
    lblFr.size.width = self.bounds.size.width;
    cloudKitLabel.frame = lblFr;
    
    CGRect buttonFr = lblFr;
    buttonFr.origin.y = lblFr.origin.y + lblFr.size.height;
    loginButton.frame = buttonFr;
    [loginButton sizeToFit];
    
//    NSLog(@"settings url: %@", UIApplicationOpenSettingsURLString);
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
//    
//    [[NSThread mainThread] performBlock:^{
//        if(!hasSent){
//            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication] canOpenURL:appSettings]) {
//                // make sure to use in iOS8, not iOS7
//                [[UIApplication sharedApplication] openURL:appSettings];
//            }            hasSent = YES;
//        }
//    }afterDelay:3];
    
}

#pragma mark - MMCloudKitManagerDelegate

-(void) cloudKitDidChangeState:(MMCloudKitBaseState *)currentState{
    if([currentState isKindOfClass:[MMCloudKitWaitingForLoginState class]]){
//        loginButton.hidden = NO;
    }else{
        loginButton.hidden = YES;
    }
    if([currentState isKindOfClass:[MMCloudKitWaitingForLoginState class]]){
        listOfFriendsView.hidden = YES;
        cloudKitLabel.hidden = YES;
        offlineView.hidden = YES;
        needLoginView.hidden = NO;
    }else if([currentState isKindOfClass:[MMCloudKitOfflineState class]]){
        listOfFriendsView.hidden = YES;
        cloudKitLabel.hidden = YES;
        offlineView.hidden = NO;
        needLoginView.hidden = YES;
    }else if(currentState.friendList){
        [self updateDataSource];
        listOfFriendsView.hidden = NO;
        cloudKitLabel.hidden = YES;
        offlineView.hidden = YES;
        needLoginView.hidden = YES;
    }else{
        listOfFriendsView.hidden = YES;
        cloudKitLabel.hidden = NO;
        offlineView.hidden = YES;
        needLoginView.hidden = YES;
    }
    [self updateInterfaceBasedOniCloudStatus];
}

-(void) willFetchMessage:(SPRMessage*)message{
    // noop
}

-(void) didFetchMessage:(SPRMessage *)message{
    // noop
}

-(void) didFailToFetchMessage:(SPRMessage *)message{
    // noop
}

#pragma mark - UICollectionViewDataSource

-(BOOL) friendListContainsSender{
    if(!shareItem.cloudKitSenderInfo){
        return NO;
    }
    MMCloudKitBaseState* currentState = [MMCloudKitManager sharedManager].currentState;
    for (NSDictionary* friend in currentState.friendList) {
        if([[shareItem.cloudKitSenderInfo objectForKey:@"recordId"] isEqual:[friend objectForKey:@"recordId"]]){
            return YES;
        }
    }
    return NO;
}

-(NSDictionary*) userInfoForIndexPath:(NSIndexPath*)indexPath{
    if(shareItem.cloudKitSenderInfo && indexPath.section == 0){
        return shareItem.cloudKitSenderInfo;
    }
    if([allFriendsExceptSender count] > indexPath.row){
        return [allFriendsExceptSender objectAtIndex:indexPath.row];
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(shareItem.cloudKitSenderInfo && section == 0){
        return 1;
    }
    return [allFriendsExceptSender count] + 1; // add 1 for the invite button
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(shareItem.cloudKitSenderInfo){
        return 2;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(!shareItem.cloudKitSenderInfo || indexPath.section == 1){
        // if we're in the firend list
        if(indexPath.row == [allFriendsExceptSender count]){
            // invite button
            MMCloudKitInviteCollectionViewCell* invite = [collectionView dequeueReusableCellWithReuseIdentifier:@"MMCloudKitInviteCollectionViewCell" forIndexPath:indexPath];
            invite.delegate = self;
            return invite;
        }
    }
    MMCloudKitFriendCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MMCloudKitFriendCollectionViewCell" forIndexPath:indexPath];
    [cell setUserInfo:[self userInfoForIndexPath:indexPath] forIndex:indexPath.row];
    if(shareItem.cloudKitSenderInfo && indexPath.section == 0){
        cell.shouldShowReplyIcon = YES;
    }else{
        cell.shouldShowReplyIcon = NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MMCloudKitFriendCollectionViewCell* cell = (MMCloudKitFriendCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    MMAvatarButton* avatarButton = [cell stealAvatarButton];
    [shareItem userIsAskingToShareTo:[self userInfoForIndexPath:indexPath] fromButton:avatarButton];
    [cell bounce];
}

#pragma mark - Rotation

-(UICollectionViewLayout*) idealLayoutForOrientation:(UIInterfaceOrientation)orientation{
    if(orientation == UIDeviceOrientationLandscapeLeft){
        return [[MMCloudKitShareListHorizontalLayout alloc] initWithFlip:YES];
    }else if(orientation == UIDeviceOrientationLandscapeRight){
        return [[MMCloudKitShareListHorizontalLayout alloc] initWithFlip:NO];
    }else if(orientation == UIDeviceOrientationPortraitUpsideDown){
        return [[MMCloudKitShareListVerticalLayout alloc] initWithFlip:YES];
    }else{
        return [[MMCloudKitShareListVerticalLayout alloc] initWithFlip:NO];
    }
}

-(void) updateInterfaceTo:(UIInterfaceOrientation)orientation{
    [listOfFriendsView setCollectionViewLayout:[self idealLayoutForOrientation:orientation] animated:YES];
}


#pragma mark - Debug

-(void) addExtraUsers{
    NSArray* extra = @[@{@"firstName" : @"Tim",
                         @"lastName" : @"Cook",
                         @"initials" : @"TC"},
                       @{@"firstName" : @"Angela",
                         @"lastName" : @"Ahrendts",
                         @"initials" : @"AA"},
                       @{@"firstName" : @"Eddy",
                         @"lastName" : @"Cue",
                         @"initials" : @"EC"},
                       @{@"firstName" : @"Craig",
                         @"lastName" : @"Federighi",
                         @"initials" : @"CF"},
                       @{@"firstName" : @"Jonny",
                         @"lastName" : @"Ive",
                         @"initials" : @"JI"},
                       @{@"firstName" : @"Luca",
                         @"lastName" : @"Maestri",
                         @"initials" : @"LM"},
                       @{@"firstName" : @"Dan",
                         @"lastName" : @"Riccio",
                         @"initials" : @"DR"},
                       @{@"firstName" : @"Phil",
                         @"lastName" : @"Schiller",
                         @"initials" : @"PS"},
                       @{@"firstName" : @"Bruce",
                         @"lastName" : @"Sewell",
                         @"initials" : @"BS"},
                       @{@"firstName" : @"Jeff",
                         @"lastName" : @"Williams",
                         @"initials" : @"JW"}];
    
    allKnownFriends = [allKnownFriends arrayByAddingObjectsFromArray:extra];;
    allFriendsExceptSender = [allFriendsExceptSender arrayByAddingObjectsFromArray:extra];;
}

#pragma mark - MMInviteUserButtonDelegate

-(void) didTapInviteButton{
    [shareItem didTapInviteButton];
    [shareItem.delegate didShare:shareItem];
}

@end
