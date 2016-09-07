//
//  ITPPacketBagModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/6.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    IS_ONLINE,
    DIS_ONLINE
} ONLINE_TYPE;

typedef enum
{
    IS_SAFE,
    DIS_SAFE
} SAFETYPE;

typedef struct
{
    ONLINE_TYPE  onlinetype;
    SAFETYPE   safetype;
} BAGSTATUS;


@interface ITPPacketBagModel : NSObject

@property (nonatomic, copy) NSString * bagName;
@property (nonatomic, copy) NSString * bagEmail;
@property (nonatomic, copy) NSString * bagId;
@property (nonatomic, copy) NSString * bagPhoneNum;

@property (nonatomic, copy) NSString * lastOnlineTime;  ///< 最后在线时间
@property (nonatomic, copy) NSString * lastLongitude;   ///< 最后经度
@property (nonatomic, copy) NSString * lastLatitude;    ///< 最后纬度
@property (nonatomic, copy) NSString * lastAccuracy;    ///< 最后精度


@property (nonatomic, copy) NSString * safeLongitude;   ///< 安全栏经度
@property (nonatomic, copy) NSString * safeLatitude;    ///< 安全栏纬度
@property (nonatomic, copy) NSString * safeRadius;      ///< 安全栏半径

@property (nonatomic, assign) int   bagType; // 其他是 书包          1 是箱子
@property (nonatomic, assign) int   bagWeight;

@property (nonatomic, assign) BAGSTATUS status;
@end
