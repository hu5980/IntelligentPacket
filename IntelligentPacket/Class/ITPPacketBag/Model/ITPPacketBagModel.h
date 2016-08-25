//
//  ITPPacketBagModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/6.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPPacketBagModel : NSObject

@property (nonatomic, copy) NSString * bagName;
@property (nonatomic, copy) NSString * bagEmail;
@property (nonatomic, copy) NSString * bagId;
@property (nonatomic, copy) NSString * bagPhoneNum;
@property (nonatomic, assign) int   bagType; // 0 书包 1 箱子
@property (nonatomic, assign) int   bagWeight;

@end
