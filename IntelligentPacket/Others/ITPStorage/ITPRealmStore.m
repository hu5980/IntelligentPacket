//
//  ITPRealmStore.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPRealmStore.h"

#import "RealmItem.h"

@interface ITPRealmStore ()

@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation ITPRealmStore

- (id)init
{
    if ((self = [super init]))
    {
        _realm = [RLMRealm defaultRealm];
    }
    
    return self;
}

- (void)addObject:(RLMObject *)object
{
    @try {
        [_realm beginWriteTransaction];
        [_realm addObject:object];
        [_realm commitWriteTransaction];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)removeObject:(RLMObject *)object
{
    @try {
        [_realm beginWriteTransaction];
        [_realm deleteObject:object];
        [_realm commitWriteTransaction];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)removeObjects:(id)objects
{
    @try {
        [_realm beginWriteTransaction];
        [_realm deleteObjects:objects];
        [_realm commitWriteTransaction];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)fetchStatPageEntriesWithCompletionBlock:(DataStoreFetchCompletionBlock)completionBlock
{
    RLMResults *results = [RealmItem allObjects];
    if (completionBlock) {
        completionBlock(results);
    }
}

@end
