//
//  ITPPacketbagWeightVeiwController.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/6.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPBaseViewController.h"
#import "ITPPacketBagModel.h"
/*
 * 箱包称重
 */
@interface ITPPacketbagWeightVeiwController : ITPBaseViewController

@property (nonatomic, copy) void (^weighingBlock)(float weight);

@property (nonatomic, strong) ITPPacketBagModel * model;
@end
