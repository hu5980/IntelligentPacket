//
//  ITPBagViewModel.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPBagViewModel.h"

@implementation ITPBagViewModel

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


+ (NSMutableArray *)bags:(NSData *)data {
    
    NSMutableArray * bags = [NSMutableArray array];
    NSArray * dataArr = [self paraserData:data];
    NSString * bagstr = dataArr[2];
    NSArray * bagTemp = [bagstr componentsSeparatedByString:@"\n"];
    
    for (NSString * bag in bagTemp) {
        
        NSString * _bag = [bag stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (_bag.length == 0) break;
        
        NSArray * temp = [bag componentsSeparatedByString:@"/"];
        
        ITPPacketBagModel * model = [ITPPacketBagModel new];
        model.bagId = (NSString *)temp[0];
        model.bagEmail = (NSString *)temp[1];
        model.bagName = (NSString *)temp[2];
        model.bagPhoneNum = (NSString *)temp[3];
        model.bagType = [model.bagId substringToIndex:1].intValue;
        [bags addObject:model];
    }
    
    return bags;
}

@end