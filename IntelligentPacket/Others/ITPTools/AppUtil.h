//
//  AppUtil.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<CommonCrypto/CommonCryptor.h>

@interface AppUtil : NSObject

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isRightNickName:(NSString *)nickName;

+ (BOOL)isPasswordString:(NSString*)password;

+ (BOOL)isEmailString:(NSString*)emailString;

+ (NSString *)convertStringFromInterval:(NSTimeInterval)timeInterval;

+ (int )getTaken:(NSString *)num;

+ (NSMutableDictionary *)getDataWithPlist;

//普通字符串转换为十六进制的。
+ (NSString *)getHexstring:(NSString *)string;

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString;

+ (NSString *)getDateTime;
@end
