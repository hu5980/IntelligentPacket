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
    
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (!dataStr) {
        dataStr = [[NSString alloc]initWithData:data encoding:encode];
    }
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSArray * dataArr = [dataStr componentsSeparatedByString:@","];
    return dataArr;
}

+ (BOOL )isSuccesss:(NSData *)data {
    
    if (!data) {
        return NO;
    }
    
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
    if (contactstr.length == 0) return contacts;
    for (NSString * contact in contactsTemp) {
        NSArray * temp = [contact componentsSeparatedByString:@"/"];
       
        ITPContactModel * model = [ITPContactModel new];
        if (temp.count < 3) {  //数据不合法跳过 去下一个
            goto Next;
        }
        model.contactName = (NSString *)temp[0];
        model.contactEmail = (NSString *)temp[1];
        model.contactPhoneNum = (NSString *)temp[2];
    Next:
        [contacts addObject:model];
    }
    
    return contacts;
}

+ (BOOL)isRegisterSuccess:(NSData *)data {
    
    if (!data) {
        return NO;
    }
    
    NSArray * dataArr = [self paraserData:data];
    if (((NSString *)dataArr[1]).intValue == 1) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAuthRegisterSuccess:(NSData *)data {
    
    if (!data) {
        return NO;
    }
    
    NSArray * dataArr = [self paraserData:data];
    if (((NSString *)dataArr[1]).intValue == 1) {
        return YES;
    }
    return NO;
}

@end
