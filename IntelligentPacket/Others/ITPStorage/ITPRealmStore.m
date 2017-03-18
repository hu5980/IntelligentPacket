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









////
//NSString * systemMessageKey = @"systemMessage";
//
//+ (instancetype)shareInstance {
//    static ITPRealmStore * sigle = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sigle = [[ITPRealmStore alloc] init];
//        [sigle check];
//    });
//    return sigle;
//}
//
//- (void)addItem:(RealmItem*)item {
//    [self.stores addObject:item];
//    [self update];
//}
//
//- (void)deleteItem:(RealmItem*)item {
//    [self.stores removeObject:item];
//    [self update];
//}
//
//- (NSMutableArray *)stores {
//    
//    NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:systemMessageKey];
//    if (!dic)
//        return nil;
//    NSString * userEmail = [ITPUserManager ShareInstanceOne].userEmail;
//    _stores = [NSMutableArray arrayWithArray:dic[userEmail]];
//    if (!_stores)
//        _stores = [NSMutableArray array];
//    return _stores;
//}
//
//- (void)update {
//    NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:systemMessageKey];
//    if (!dic) {
//        dic = [NSMutableDictionary dictionary];
//    }
//    NSString * userEmail = [ITPUserManager ShareInstanceOne].userEmail;
//    [dic setObject:_stores forKey:userEmail];
//    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:systemMessageKey];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}
//
//- (void)check {
//    NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults]objectForKey:systemMessageKey];
//    if (!dic) {
//        dic = [NSMutableDictionary dictionary];
//        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:systemMessageKey];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//}

@end
