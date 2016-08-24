//
//  ITPLocationViewModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/8/21.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITPLocationModel.h"

@interface ITPLocationViewModel : NSObject

+ (NSArray *)paraserData:(NSData *)data ;

+ (BOOL )isSuccesss:(NSData *)data ;

+ (ITPLocationModel *)Locations:(NSData *)data ;


@end
