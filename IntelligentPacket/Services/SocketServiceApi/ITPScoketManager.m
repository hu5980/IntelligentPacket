//
//  ITPScoketManager.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPScoketManager.h"

@implementation ITPScoketManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (ITPSocketSDK *)ITPSocket {
    return [ITPSocketSDK shareInstance];
}

+ (instancetype)shareInstance
{
    static ITPScoketManager * _sigton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sigton) {
            _sigton = [[ITPScoketManager alloc]init];
            [_sigton startConnect];
        }
    });
    if (!_sigton.ITPSocket.socket.isConnected) {
        [_sigton startConnect];
    }
    return _sigton;
}

- (BOOL)startConnect {
    BOOL abool = [self.ITPSocket socketConnectToHost:@"www.jsscom.com" port:23000];
    return abool;
}

- (void)disConnect {
    
    [self.ITPSocket disConnect];
}

//  申请注册
- (void)registerAuthWith:(NSString *)nickName
             withTimeout:(NSTimeInterval)timeout
                     tag:(long)tag
                 success:(void(^)(NSData *data, long tag))success
                faillure:(void(^)(NSError *error))faillure
{
    //    NSString * str = @"[F1AC526E1BA4EECB*APP1*KM*0001*0014*REG,443564333@qq.com]";
    //    char * chars = "[F1AC526E1BA4EECB*APP1*KM*0001*0014*REG,443564333@qq.com]"; [NSData dataWithBytes:chars length:strlen(chars)]
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[nickName] command:ITP_REGISTER_REQUEST];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
//    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:^(NSData *data, long tag) {
//        
//    } faillure:^(NSError *error) {
//        
//    }];
}


// 注册
- (void)registerWith:(NSString *)emailName
            password:(NSString *)password
            authCode:(NSString *)authCode
            nickName:(NSString *)nickName
               phone:(NSString *)phone
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure;

{
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[emailName, password, authCode, nickName, phone] command:ITP_REGISTER_CONFIM];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}

// 登录
- (void)loginWith:(NSString *)nickName
            password:(NSString *)password
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure
{
    NSString *isChinese = @"zh_CN";
    if (![ITPLanguageManager sharedInstance].isChinese) {
        isChinese = @"en";
    }
    
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[nickName, password, isChinese] command:ITP_LOGIN];
       
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}

// 绑定箱子
- (void)bingWithEmail:(NSString *)email
              bagId:(NSString *)bagId
               bagNum:(NSString *)bagNum
              bagName:(NSString *)bagName
        withTimeout:(NSTimeInterval)timeout
                tag:(long)tag
            success:(void(^)(NSData *data, long tag))success
           faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, bagNum, bagName] command:ITP_BANGDING];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}

// 箱子列表
- (void)bagListWithTimeout:(NSTimeInterval)timeout
                       tag:(long)tag
                   success:(void(^)(NSData *data, long tag))success
                  faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[[ITPUserManager ShareInstanceOne].userEmail] command:ITP_BAGLIST];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}


// 实时查询
- (void)crWithEmail:(NSString *)email
              bagId:(NSString *)bagId
        withTimeout:(NSTimeInterval)timeout
                tag:(long)tag
            success:(void(^)(NSData *data, long tag))success
           faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId] command:ITP_CR];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}

// 设置亲情号码
- (void)phbWithEmail:(NSString *)email
               phone:(NSString *)phone
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[[ITPUserManager ShareInstanceOne].userEmail/*@"355567207@qq.com"*/, email, phone] command:ITP_PHB];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}

// 亲情号码监听
- (void)monitorWithEmail:(NSString *)email
                   bagId:(NSString *)bagId
                   phone:(NSString *)phone
             withTimeout:(NSTimeInterval)timeout
                     tag:(long)tag
                 success:(void(^)(NSData *data, long tag))success
                faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, phone] command:ITP_MONITOR];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}

// 请求终端操作
- (void)actWithEmail:(NSString *)email
               bagId:(NSString *)bagId
            weighton:(NSString *)weighton
              lockon:(NSString *)lockon
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, weighton, lockon] command:ITP_ACT];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
    
}

// GPS
- (void)gpsWithEmail:(NSString *)email
               bagId:(NSString *)bagId
             onORoff:(NSString *)onORoff
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, onORoff] command:ITP_GPS];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
    
}

// 获取联系人
- (void)lxrWithEmail:(NSString *)email
//               bagId:(NSString *)bagId
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             success:(void(^)(NSData *data, long tag))success
            faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email] command:ITP_LXR];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
}

// 删除绑定箱子
- (void)deleteBagWithEmail:(NSString *)email
                      bagId:(NSString *)bagId
              withTimeout:(NSTimeInterval)timeout
                      tag:(long)tag
                  success:(void(^)(NSData *data, long tag))success
                 faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId] command:ITP_DELETEBINDDEV];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
    
}

// 删除联系人
- (void)deleteContactWithEmail:(NSString *)email
                         phone:(NSString *)phone
                   withTimeout:(NSTimeInterval)timeout
                           tag:(long)tag
                       success:(void(^)(NSData *data, long tag))success
                      faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, phone] command:ITP_DELETELXR];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
    
}

// 提交安全栏
- (void)setSafeRegion:(NSString *)email
                bagId:(NSString *)bagId
            longitude:(NSString *)longitude     //经度
             latitude:(NSString *)latitude      //纬度
               radius:(NSString *)radius        //半径
          withTimeout:(NSTimeInterval)timeout
                  tag:(long)tag
                       success:(void(^)(NSData *data, long tag))success
                      faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, longitude, latitude, radius] command:ITP_SETSAFEREGION];
    
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
    
}

//邮箱号,原密码,新密码,原电话号码,新电话号码,新昵称
// 修改用户信息
- (void)modifyUserInformationWithEmail:(NSString *)email
                              password:(NSString *)password
                                 phone:(NSString *)phone                //电话
                              nickName:(NSString *)nickName             //昵称
                           withTimeout:(NSTimeInterval)timeout
                                   tag:(long)tag
                               success:(void(^)(NSData *data, long tag))success
                              faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, [ITPUserManager ShareInstanceOne].userPassword, password, [ITPUserManager ShareInstanceOne].userPhone, phone, nickName] command:ITP_MODIFYPERSONALDATA];
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
    
}

// 获取箱子定位历史信息
- (void)getHistoryRecordWithEmail:(NSString *)email
                            bagId:(NSString *)bagId
                        startDate:(NSString *)startDate           //开始时间
                          endDate:(NSString *)endDate             //结束时间
                      withTimeout:(NSTimeInterval)timeout
                              tag:(long)tag
                          success:(void(^)(NSData *data, long tag))success
                         faillure:(void(^)(NSError *error))faillure {
    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, startDate, endDate] command:ITP_GETHISTORYRECORD];
    [self.ITPSocket writeData:data withTimeout:timeout tag:tag success:success faillure:faillure];
    
}


@end
