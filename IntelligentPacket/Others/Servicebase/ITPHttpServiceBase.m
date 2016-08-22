//
//  ITPHttpServiceBase.m
//  XKRW
//
//  Created by Seth Chen on 15/12/7.
//  Copyright © 2015年 xikang. All rights reserved.
//

#import "ITPHttpServiceBase.h"
#import "AFNetworking.h"



#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation ITPHttpServiceBase
{
    id   _target;
    SEL  _targetResponse;
    SEL  _selfResponse;
}

- (BOOL)registerTarget:(id)target andResponseMethod:(SEL)method
{
    @try {
        if (target && method) {
            _target = target;
            _targetResponse = method;
            return YES;
        }else return NO;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (void)startAsynchronizedGetMethodwithCompleteUrl:(inout NSString *)cCompleteUrl andParamer:(NSDictionary *)paramers andResponseMethod:(SEL)response
{
    
    if (response) {
        _selfResponse = response;
    }
    
    __weak typeof(self) weakSelf = self;
    id __block _targetResponseObject = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:cCompleteUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        SuppressPerformSelectorLeakWarning
        (
         [strongSelf handleOperation:[strongSelf josnWithData:responseObject]];
         _targetResponseObject =  [strongSelf performSelector:_selfResponse withObject:[strongSelf josnWithData:responseObject]];
         
         if ([_target respondsToSelector:_targetResponse])
         {
             [_target performSelector:_targetResponse withObject:_targetResponseObject];
         }
         );
    }
     
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf handleHttpError:operation andError:error];
        
    }];
}

- (void)startAsynchronizedPostMethodwithCompleteUrl:(NSString *)cCompleteUrl andParamer:(NSDictionary *)paramers andResponseMethod:(SEL)response
{
    if (response) {
        _selfResponse = response;
    }
    
    __weak typeof(self) weakSelf = self;
    id __block _targetResponseObject = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:cCompleteUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
         __strong typeof(weakSelf) strongSelf = weakSelf;
         
         SuppressPerformSelectorLeakWarning
         (
          [strongSelf handleOperation:[strongSelf josnWithData:responseObject]];
          _targetResponseObject =  [strongSelf performSelector:_selfResponse withObject:[strongSelf josnWithData:responseObject]];
          
          if ([_target respondsToSelector:_targetResponse])
          {
              [_target performSelector:_targetResponse withObject:_targetResponseObject];
          }
          );
         
     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
         
         __strong typeof(weakSelf) strongSelf = weakSelf;
         //        [strongSelf handleHttpError:operation andError:error];
         
     }];
}

- (NSData *)startSynchronizedGetMethodwithCompleteUrl:(NSString *)cCompleteUrl andParamer:(NSDictionary *)paramers
{
    dispatch_semaphore_t semp = dispatch_semaphore_create(0);
    
    //    __weak typeof(self) weakSelf = self;
    id __block _targetResponseObject = nil;
    NSError __block *_error = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:cCompleteUrl parameters:paramers progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         _targetResponseObject = responseObject;
         
         dispatch_semaphore_signal(semp);
         
     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
         
         _error = error;
         
         dispatch_semaphore_signal(semp);
     }];
    
    dispatch_semaphore_wait(semp, DISPATCH_TIME_FOREVER);
    
    return _targetResponseObject;
}


- (NSData *)startSynchronizedPostMethodwithCompleteUrl:(NSString *)cCompleteUrl andParamer:(NSDictionary *)paramers
{
    dispatch_semaphore_t semp = dispatch_semaphore_create(0);
    
//    __weak typeof(self) weakSelf = self;
    id __block _targetResponseObject = nil;
    NSError __block *_error = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:cCompleteUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         _targetResponseObject = responseObject;
         
         dispatch_semaphore_signal(semp);
         
     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
         
         _error = error;
         
         dispatch_semaphore_signal(semp);
     }];
    
    dispatch_semaphore_wait(semp, DISPATCH_TIME_FOREVER);
    
    return _targetResponseObject;
}



#if 0
- (void)handleHttpError:(AFHTTPRequestOperation *)operation andError:(NSError *)error
{
    if (error) {
        NSLog(@"error is ... %@",error.localizedDescription);
//        [XKRWCui showInformationHudWithText:@"网络连接有问题,请稍后再试"];
    }else if (operation)
    {
        
        if (operation.error) {
//            NSLog(@"error is ... %@",operation.error.localizedDescription);
        }else if (operation.response.statusCode != 200)
        {
            NSInteger statuCode = operation.response.statusCode;
            NSLog(@"http status code is %ld",(long)statuCode);
            [XKRWCui showInformationHudWithText:@"网络连接有问题,请稍后再试"];
            
            switch (statuCode) {
                case 400://Bad request
                    
                    break;
                case 403://Forbidden
                    
                    break;
                case 404://Not found
                    
                    break;
                case 408://Time out
                    
                    break;
                case 500://Server error
                    
                    break;
                case 502://Error gateway
                    
                    break;
                case 504://网关超时
                    
                    break;
                default://未知错误
                    
                    break;
            }
        }
    }
}

#endif

- (void)handleOperation:(NSDictionary *)resultDic
{
//    if ([resultDic[@"success"] intValue] == 0) {
//        
//        if (resultDic[@"error"]) {
//            
//            NSString * code = resultDic[@"error"][@"code"];
//            if ([code isEqualToString:@"015"] ||
//                [code isEqualToString:@"019"]
//                )
//            {
//                NSString * msg = nil;
//                if ([code isEqualToString:@"015"]) {
//                    msg = @"您的帐号曾经在其他设备上登录，请您重新登录。";
//                } else {
//                    msg = @"身份验证过期，请重新登录";
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[XKRWLoginVC class] showLoginVCWithTarget:_target loginSuccess:^{
//                        
//                    } failed:^(BOOL isFailed) {
//                        
//                    } alertMessage:msg];
//                });
//            }
//            else if ([code isEqualToString:@"erPerson20103"]){
//                
//                [XKRWCui showInformationHudWithText:resultDic[@"error"][@"msg"]];
//            }
//            else if ([code isEqualToString:@"004"]) {
//                
//                [XKRWCui showInformationHudWithText:resultDic[@"error"][@"msg"]];
//            }
//            else {
//
//                [XKRWCui showInformationHudWithText:resultDic[@"error"][@"msg"]];
//            }
//        }
//        else {
//
//            [XKRWCui showInformationHudWithText:@"网络异常,请稍后再试"];
//        }
//    }
//    // if success, check whether need to show exp hint
//    else {
//        if ([resultDic isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dictionary = resultDic;
//            
//            if (dictionary[@"exp"]) {
//                id exp = dictionary[@"exp"];
//                
//                NSString *expString;
//                if ([exp isKindOfClass:[NSString class]]) {
//                    expString = [NSString stringWithFormat:@"获得%@点经验值!", exp];
//                } else if ([exp isKindOfClass:[NSNumber class]]) {
//                    expString = [NSString stringWithFormat:@"获得%d点经验值!", [((NSNumber *)exp) intValue]];
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
//                    notification.notificationLabelBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//                    notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
//                    notification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
//                    [notification displayNotificationWithMessage:expString forDuration:2];
//                });
//            }
//        }
//    }
}

- (NSDictionary *)josnWithData:(id )data
{
    if ([NSJSONSerialization isValidJSONObject:data]) {
        return data;
    }
    NSError * error;
    NSDictionary * callDict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        return nil;
    }
    return callDict;
}

@end

