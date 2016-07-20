//
//  ITPContactViewModel.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/18.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPContactViewModel.h"

@implementation ITPContactViewModel

+ (NSArray *)paraserData:(NSData *)data {
    
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSArray * dataArr = [dataStr componentsSeparatedByString:@","];
    return dataArr;
}

+ (BOOL )isSuccesss:(NSData *)data {
    
    NSArray * dataArr = [self paraserData:data];
    
    if (((NSString *)dataArr[1]).intValue == 1) {
        return YES;
    }
    return NO;
    
}


+ (NSMutableArray *)contacts:(NSData *)data {
    
    NSMutableArray * contacts = [NSMutableArray array];
    NSArray * dataArr = [self paraserData:data];
    NSString * contactstr = dataArr[2];
    NSArray * contactsTemp = [contactstr componentsSeparatedByString:@"\n"];
    
    for (NSString * contact in contactsTemp) {
        NSArray * temp = [contact componentsSeparatedByString:@"/"];
        ITPContactModel * model = [ITPContactModel new];
        model.contactName = (NSString *)temp[0];
        model.contactEmail = (NSString *)temp[1];
        model.contactPhoneNum = (NSString *)temp[2];
        [contacts addObject:model];
    }
    
    return contacts;
}

+ (BOOL)isRegisterSuccess:(NSData *)data {
    
    NSArray * dataArr = [self paraserData:data];
    if (((NSString *)dataArr[1]).intValue == 1) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAuthRegisterSuccess:(NSData *)data {
    
    NSArray * dataArr = [self paraserData:data];
    if (((NSString *)dataArr[1]).intValue == 1) {
        return YES;
    }
    return NO;
}

@end