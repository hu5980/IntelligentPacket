//
//  UIManager.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIManager : NSObject

+ (instancetype)shareInstance;

- (void)configUI;
@end
