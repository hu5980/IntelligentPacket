//
//  ITPRealmStore.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"

@class ITPRealmStore;
typedef void(^DataStoreFetchCompletionBlock)(RLMResults *results);

@interface ITPRealmStore : NSObject

- (void)addObject:(id)object;
- (void)removeObject:(RLMObject *)object;
- (void)removeObjects:(id)objects;

- (void)fetchStatPageEntriesWithCompletionBlock:(DataStoreFetchCompletionBlock)completionBlock;

@end