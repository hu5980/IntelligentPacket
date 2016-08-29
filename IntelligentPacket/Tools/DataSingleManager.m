//
//  DataSingleManager.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/8/28.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "DataSingleManager.h"

@implementation DataSingleManager

+ (instancetype)sharedInstance
{
    static DataSingleManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DataSingleManager new];
        instance.bags = [NSMutableArray new];
    });

    return instance;
}


- (NSMutableArray<ITPPacketBagModel *> *)safeBags {

    if (!_safeBags) {
        _safeBags = [NSMutableArray new];
    }
    [_safeBags removeAllObjects];
    for (ITPPacketBagModel * _M in self.bags) {
        if (_M.safeRadius.intValue != 0 && _M.safeLatitude.intValue != 0 && _M.safeLongitude.intValue != 0 && [[ITPUserManager ShareInstanceOne].userEmail isEqualToString:_M.bagEmail]) {
            [_safeBags addObject:_M];
        }
    }
    
    return _safeBags;
}

- (NSMutableArray<ITPPacketBagModel *> *)noneSafeBags {

    if (!_noneSafeBags) {
        _noneSafeBags = [NSMutableArray new];
    }
    [_noneSafeBags removeAllObjects];
    for (ITPPacketBagModel * _M in self.bags) {
        if (!(_M.safeRadius.intValue != 0 && _M.safeLatitude.intValue != 0 && _M.safeLongitude.intValue != 0)&& [[ITPUserManager ShareInstanceOne].userEmail isEqualToString:_M.bagEmail]) {
            [_noneSafeBags addObject:_M];
        }
    }
    
    return _noneSafeBags;
}

- (CGFloat)distanceCurentPoint:(CLLocationCoordinate2D)curent ToSafepoint:(CLLocationCoordinate2D)safePoint {

    
    return 1.;
}


#pragma mark - // 两点求距离
- (CGFloat )calculationDistance:(ITPPacketBagModel *)model {
    
    if (model.safeRadius.integerValue == 0 || model.safeRadius.length == 0 || model.lastLatitude.length == 0 || model.lastLongitude.length == 0) {
        return 0;
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:model.safeLongitude.doubleValue longitude:model.safeLatitude.doubleValue];
    NSLog(@"%f\n%f",location.coordinate.latitude,location.coordinate.longitude);
    
    CLLocation * centerlocation = [location locationMarsFromEarth];
    
    CLLocation *teplocation = [[CLLocation alloc] initWithLatitude:model.lastLongitude.doubleValue longitude:model.lastLatitude.doubleValue];
    NSLog(@"%f\n%f",location.coordinate.latitude,location.coordinate.longitude);
    
    CLLocation * lastlocation = [teplocation locationMarsFromEarth];
    
    CGFloat distance = [lastlocation distanceFromLocation:centerlocation];
    return distance;
}

@end
