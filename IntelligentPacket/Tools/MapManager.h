//
//  MapManager.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/14.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaiduMapHeader.h"
#import <MapKit/MapKit.h>

@interface MapManager : NSObject

@property (nonatomic, strong) BMKMapManager *baiduMapManager;


+ (instancetype)shareInstance;

@end
