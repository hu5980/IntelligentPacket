//
//  ITPScoketManager.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITPSocketSDK.h"
#import "ITPDataCenter.h"

@interface ITPScoketManager : NSObject

@property (nonatomic, strong) ITPSocketSDK *ITPSocket;

+ (instancetype)shareInstance;

- (BOOL)startConnect;

- (void)disConnect;

//  申请注册
- (void)registerAuthWith:(NSString *)nickName
             withTimeout:(NSTimeInterval)timeout
                     tag:(long)tag
                 success:(void(^)(NSData *data, long tag))success
                faillure:(void(^)(NSError *error))faillure;
///< 注册
- (void)registerWith:(NSString *)emailName
            password:(NSString *)password
            nickName:(NSString *)nickName
            authCode:(NSString *)authCode
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure;

// 登录
- (void)loginWith:(NSString *)nickName
         password:(NSString *)password
      withTimeout:(NSTimeInterval)timeout
              tag:(long)tag
          success:(void(^)(NSData *data, long tag))success
         faillure:(void(^)(NSError *error))faillure;

@end
