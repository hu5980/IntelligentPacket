//
//  LoginWithRegisterViewModel.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "LoginWithRegisterViewModel.h"

@implementation LoginWithRegisterViewModel

+ (NSArray *)paraserData:(NSData *)data {
    
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray * dataArr = [dataStr componentsSeparatedByString:@","];
    return dataArr;
}


+ (BOOL)isLoginSuccess:(NSData *)data {

    NSArray * dataArr = [self paraserData:data];
    
    if (((NSString *)dataArr[1]).intValue == 1) {
        [ITPUserManager ShareInstanceOne].userName = OCSTR(@"%@", dataArr[2]);
        return YES;
    }
    return NO;
    
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
