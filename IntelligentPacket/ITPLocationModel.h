//
//  ITPLocationModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/8/21.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPLocationModel : NSObject

@property (nonatomic, copy) NSString * result;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * electric;
@property (nonatomic, copy) NSString * accuracy;
@property (nonatomic, copy) NSString * time;

@end
