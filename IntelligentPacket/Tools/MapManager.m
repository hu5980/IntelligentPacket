//
//  MapManager.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/14.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "MapManager.h"

#define BAIDU_KEY @"nQu12jgmbZnTrRcshw2fykkP3r6rCLAr"

@implementation MapManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baiduMapManager = [BMKMapManager new];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static MapManager * _sigton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sigton) {
            _sigton = [[MapManager alloc]init];
        }
    });
    return _sigton;
}




@end
