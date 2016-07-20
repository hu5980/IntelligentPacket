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
               phone:(NSString *)phone
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


// 设置亲情号码
- (void)phbWithEmail:(NSString *)email
               phone:(NSString *)phone
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure;

// 获取联系人
- (void)lxrWithEmail:(NSString *)email
//               bagId:(NSString *)bagId
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure;


/*!
 * 绑定箱子
 */
- (void)bingWithEmail:(NSString *)email
                bagId:(NSString *)bagId
               bagNum:(NSString *)bagNum
              bagName:(NSString *)bagName
          withTimeout:(NSTimeInterval)timeout
                  tag:(long)tag
              success:(void(^)(NSData *data, long tag))success
             faillure:(void(^)(NSError *error))faillure;

/*!
 * 箱子列表
 */
- (void)bagListWithTimeout:(NSTimeInterval)timeout
                       tag:(long)tag
                   success:(void(^)(NSData *data, long tag))success
                  faillure:(void(^)(NSError *error))faillure;
@end
