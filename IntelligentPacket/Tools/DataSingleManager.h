//
//  DataSingleManager.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/8/28.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITPPacketBagModel.h"

@interface DataSingleManager : NSObject


@property (nonatomic, strong) NSMutableArray<ITPPacketBagModel *> * bags;

@property (nonatomic, strong) NSMutableArray<ITPPacketBagModel *> * safeBags;

@property (nonatomic, strong) NSMutableArray<ITPPacketBagModel *> * noneSafeBags;


+ (instancetype)sharedInstance;

- (NSMutableArray<ITPPacketBagModel *> *)safeBags;

- (NSMutableArray<ITPPacketBagModel *> *)noneSafeBags;


#pragma mark - // 两点求距离
- (CGFloat )calculationDistance:(ITPPacketBagModel *)model;

@end
