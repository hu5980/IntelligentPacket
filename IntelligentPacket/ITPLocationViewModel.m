//
//  ITPLocationViewModel.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/8/21.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPLocationViewModel.h"
#import "ITPLocationModel.h"

@implementation ITPLocationViewModel

+ (NSArray *)paraserData:(NSData *)data {
    
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSArray * dataArr = [dataStr componentsSeparatedByString:@","];
    return dataArr;
}

+ (BOOL )isSuccesss:(NSData *)data {
    
    NSArray * dataArr = [self paraserData:data];
    if (dataArr.count >= 2) {
        if (((NSString *)dataArr[1]).intValue == 1) {
            return YES;
        }
    }
    
    return NO;
}

+ (ITPLocationModel *)Locations:(NSData *)data {
    
    ITPLocationModel * model = [ITPLocationModel new];
    
    NSArray * dataArr = [self paraserData:data];
    if (dataArr.count < 7)
        return model;
    
    model.result = dataArr[1];
    model.latitude = dataArr[2];
    model.longitude = dataArr[3];
    model.accuracy = dataArr[4];
    model.electric = dataArr[5];
    model.time = dataArr[6];
    
    return model;
}


@end
