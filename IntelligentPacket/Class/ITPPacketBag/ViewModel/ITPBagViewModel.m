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
    if (bagstr.length == 0 ) return bags;
    for (NSString * bag in bagTemp) {
        
        NSString * _bag = [bag stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (_bag.length == 0) break; //数据不合法跳出
        
        NSArray * temp = [bag componentsSeparatedByString:@"/"];
        ITPPacketBagModel * model = [ITPPacketBagModel new];
        if (temp.count < 11) {  //数据不合法跳过 去下一个
            goto Next;
        }
        model.bagId = (NSString *)temp[0];
        model.bagEmail = (NSString *)temp[1];
        model.bagName = (NSString *)temp[2];
        model.bagPhoneNum = (NSString *)temp[3];
        model.bagType = [model.bagId substringToIndex:1].intValue;
        model.lastOnlineTime = (NSString *)temp[4];
        model.lastLongitude = (NSString *)temp[5];
        model.lastLatitude = (NSString *)temp[6];
        model.lastAccuracy = (NSString *)temp[7];
        model.safeLongitude = (NSString *)temp[8];
        model.safeLatitude = (NSString *)temp[9];
        model.safeRadius = (NSString *)temp[10];
        model.status = [self isONline:model];
    Next:
        [bags addObject:model];
    }
    
    return bags;
}

+ (NSMutableArray *)managerBags:(NSData *)data {
    
    NSMutableArray * bags = [NSMutableArray array];
    NSArray * dataArr = [self paraserData:data];
    if (dataArr.count <3) {
        return bags;
    }
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
        model.lastOnlineTime = (NSString *)temp[4];
        model.lastLongitude = (NSString *)temp[5];
        model.lastLatitude = (NSString *)temp[6];
        model.lastAccuracy = (NSString *)temp[7];
        model.safeLongitude = (NSString *)temp[8];
        model.safeLatitude = (NSString *)temp[9];
        model.safeRadius = (NSString *)temp[10];
        model.status = [self isONline:model];
        [bags addObject:model];
    }
    
    return bags;
}

+(BAGSTATUS)isONline:(ITPPacketBagModel *)model {
    BAGSTATUS status;
    CGFloat distance = [[DataSingleManager sharedInstance]calculationDistance:model];
    if (distance > model.safeRadius.floatValue) {
        status.safetype = DIS_SAFE;
    } else {
        status.safetype = IS_SAFE;
    }
    
    NSDate * date = [NSDate date];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate * nowDate = [date dateByAddingTimeInterval:interval];
    long currentTimeStamp = [nowDate timeIntervalSince1970];
    long timeStamp = [self getLastTimeStamp:model.lastOnlineTime];
    
    if (currentTimeStamp - timeStamp >300) { // > 5 min
        status.onlinetype = DIS_ONLINE;
    } else {
        status.onlinetype = IS_ONLINE;
    }
    return status;
}

+ (float)weight:(NSData *)data {
    
    NSArray * arr = [self paraserData:data];
    NSString * weightStr = arr.lastObject;
    NSMutableArray * temp = [NSMutableArray array];
    NSLog(@"%@", weightStr);
    for (int i = 0; i < weightStr.length; i=i+2) {
        
        NSString * str = [weightStr substringWithRange:NSMakeRange(i, 2)];
        unsigned long int red = strtoul([str UTF8String],0,16);
        [temp addObject:OCSTR(@"%ld",red)];
    }
    
    float weight = ((NSString *)temp[1]).floatValue*0x10000 + ((NSString *)temp[2]).floatValue*0x100 + ((NSString *)temp[3]).floatValue; //单位10g.
    if (weight >10000) {
        return 0;
    }
    weight = weight*10/1000.0; // 转为kg.
    return weight;
}

+ (long)getLastTimeStamp:(NSString *)time {
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-M-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:time];
    
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate * nowDate = [date dateByAddingTimeInterval:interval];
   
    long timeStamp = [nowDate timeIntervalSince1970];
    return timeStamp;
}

@end
