//
//  LoginWithRegisterViewModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginWithRegisterViewModel : NSObject


+ (NSArray *)paraserData:(NSData *)data ;

+ (BOOL)isLoginSuccess:(NSData *)data ;

+ (BOOL)isRegisterSuccess:(NSData *)data ;

+ (BOOL)isAuthRegisterSuccess:(NSData *)data ;
@end
