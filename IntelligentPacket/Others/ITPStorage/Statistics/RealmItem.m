//
//  RealmItem.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "RealmItem.h"

@implementation RealmItem

- (void)update:(void (^)(RealmItem *instance))updateBlock
{
    @try {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        updateBlock(self);
        [realm commitWriteTransaction];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{
             @"pageName" : @"",
             @"prevPageName" : @"",
             @"toPageName" : @"",
             @"stype" : @"",
             @"project" : @"", 
             @"ptag" : @"", 
             @"visitPageTime" : @0,
             @"leavePageTime" : @0,
             @"groupID" : @"",
             @"topicID" : @"",
             @"dap" : @"",
             @"pvID" : @"",
             @"latitude" : @"",
             @"longtitude" : @"",
             };
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
