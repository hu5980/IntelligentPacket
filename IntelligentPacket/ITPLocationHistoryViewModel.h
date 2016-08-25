//
//  ITPLocationHistoryViewModel.h
//  IntelligentPacket
//
//  Created by 忘、 on 16/8/25.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPLocationHistoryViewModel : NSObject

+ (BOOL )isSuccesss:(NSData *)data;


+ (NSMutableArray *)getLocationData:(NSData *)data;

@end
