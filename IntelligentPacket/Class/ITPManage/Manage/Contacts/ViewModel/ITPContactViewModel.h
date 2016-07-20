//
//  ITPContactViewModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/18.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPContactViewModel : NSObject

+ (NSArray *)paraserData:(NSData *)data ;

+ (BOOL )isSuccesss:(NSData *)data ;

+ (NSMutableArray *)contacts:(NSData *)data ;

@end
