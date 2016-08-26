//
//  ITPLocationHistoryViewModel.m
//  IntelligentPacket
//
//  Created by 忘、 on 16/8/25.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPLocationHistoryViewModel.h"
#import <MapKit/MapKit.h>

@implementation ITPLocationHistoryViewModel

+ (NSArray *)paraserData:(NSData *)data {
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray * dataArr = [dataStr componentsSeparatedByString:@"\n"];
    return dataArr;
}

+ (BOOL )isSuccesss:(NSData *)data {
    
    NSArray * dataArr = [self paraserData:data];
    NSString *headString = (NSString *)dataArr[0];
    NSArray *headDataArr =  [headString componentsSeparatedByString:@","];
    if(headDataArr.count > 2){
        if (((NSString *)headDataArr[1]).intValue == 1) {
            return YES;
        }
    }
    return NO;
}

+ (NSMutableArray *)getLocationData:(NSData *)data {
    NSMutableArray *muatbleArr =[NSMutableArray array];
    NSArray *array =  [self paraserData:data];
    for (int i = 1; i < array.count; i++) {
        
        NSString *str = [array objectAtIndex:i];
        NSArray *arr = [str componentsSeparatedByString:@","];
        if(arr.count > 2){
            MKUserLocation *userlocation =[[MKUserLocation alloc] init];
            userlocation.coordinate = CLLocationCoordinate2DMake([[arr objectAtIndex:0] doubleValue], [[arr objectAtIndex:1] doubleValue]);
            [muatbleArr addObject:userlocation];
        }
    }
    
    return muatbleArr;
}

@end
