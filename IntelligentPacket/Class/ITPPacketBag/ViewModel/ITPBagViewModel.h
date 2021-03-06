//
//  ITPBagViewModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPBagViewModel : NSObject

+ (NSArray *)paraserData:(NSData *)data ;

+ (BOOL )isSuccesss:(NSData *)data callback:(void(^)(int statu, NSString *rec))call ;

+ (NSMutableArray *)bags:(NSData *)data ;

+ (NSMutableArray *)managerBags:(NSData *)data ;

+ (float)weight:(NSData *)data ;

+(BAGSTATUS)isONline:(ITPPacketBagModel *)model ;
@end
