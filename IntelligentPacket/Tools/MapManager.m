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

- (void)configParameter {
    
    if (self) {
        BOOL ret = [_baiduMapManager start:BAIDU_KEY generalDelegate:nil];
        if (!ret) {
            NSLog(@"MapManager start failed!");
        }
    }
    
    // 定位失败的原因
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
//        
//        //由于IOS8中定位的授权机制改变 需要进行手动授权
//        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
//        //获取授权认证
//        [locationManager requestAlwaysAuthorization];
//        [locationManager requestWhenInUseAuthorization];
//    }
}

@end
