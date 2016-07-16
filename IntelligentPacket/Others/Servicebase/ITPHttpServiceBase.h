//
//  ITPHttpServiceBase.h
//  XKRW
//
//  Created by Seth Chen on 15/12/7.
//  Copyright © 2015年 xikang. All rights reserved.
//


#import <Foundation/Foundation.h>



@interface ITPHttpServiceBase : NSObject

/**
 注册网络请求返回的方法
 */

- (BOOL)registerTarget:(nonnull id)target andResponseMethod:(nonnull SEL)method;

/**
 异步get网络请求
 */
- (void)startAsynchronizedGetMethodwithCompleteUrl:(nonnull NSString *)cCompleteUrl
                                        andParamer:(nullable NSDictionary *)paramers
                                 andResponseMethod:(nonnull SEL)response;

/**
 异步post网络请求
 */
- (void)startAsynchronizedPostMethodwithCompleteUrl:(nonnull NSString *)cCompleteUrl
                                         andParamer:(nonnull NSDictionary *)paramers
                                  andResponseMethod:(nonnull SEL)response;


- (nonnull NSData *)startSynchronizedGetMethodwithCompleteUrl:(nonnull NSString *)cCompleteUrl andParamer:(nullable NSDictionary *)paramers;
- (nonnull NSData *)startSynchronizedPostMethodwithCompleteUrl:(nonnull NSString *)cCompleteUrl andParamer:(nonnull NSDictionary *)paramers;

- (nonnull NSDictionary *)josnWithData:(nonnull NSData *)data;

@end


