//
//  ITPDataCenter.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/1.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define APPID   @"APP1"//[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

#define KM      @"LB"//@"IntelligentPacket"


#define ITP_REGISTER_REQUEST               @"REG"                   // 1. 申请注册
#define ITP_REGISTER_CONFIM                @"ENDREG"                // 2. 确认注册
#define ITP_LOGIN                          @"LOGIN"                 // 3. 登录BANGDING
#define ITP_CR                             @"CR"                    // 4. 实时查询
#define ITP_PHB                            @"PHB"                   // 5. 设置亲情号码
#define ITP_MONITOR                        @"MONITOR"               // 6. 亲情号码监听
#define ITP_ACT                            @"ACT"                   // 7. 请求终端操作
#define ITP_GPS                            @"GPS"                   // 8. GPS开关功能
#define ITP_LXR                            @"LXR"                   // 9. 获取联系人
#define ITP_DELETEBINDDEV                  @"DELETEBINDDEV"         // 10. DELETEBINDDEV
#define ITP_DELETELXR                      @"DELETELXR"             // 11. 删除联系人
#define ITP_BANGDING                       @"BANGDING"              // 12. 箱子绑定
#define ITP_BAGLIST                        @"POSTITIONMODULELIST"   // 13. 箱子列表

#define ITP_GETHISTORYRECORD               @"GETHISTORYRECORD"      // 15. 箱子历史位置

#define ITP_SETSAFEREGION                  @"SETSAFEREGION"         // 14. 提交安全栏


#define ITP_MODIFYPERSONALDATA             @"MODIFYPERSONALDATA"    // 18. 修改用户资料

#define ITP_MCUDATA                        @"MCUDATA"               // 19. 箱子称重开锁



//////// tag
#define ITP_REGISTER_REQUEST_TAG               10000                    // 1. 申请注册
#define ITP_REGISTER_CONFIM_TAG                10001                    // 2. 确认注册
#define ITP_LOGIN_TAG                          10002                    // 3. 登录BANGDING
#define ITP_CR_TAG                             10003                    // 4. 实时查询
#define ITP_PHB_TAG                            10004                    // 5. 设置亲情号码
#define ITP_MONITOR_TAG                        10005                    // 6. 亲情号码监听
#define ITP_ACT_TAG                            10006                    // 7. 请求终端操作
#define ITP_GPS_TAG                            10007                    // 8. GPS开关功能
#define ITP_LXR_TAG                            10008                    // 9. 获取联系人
#define ITP_DELETEBINDDEV_TAG                  10009                    // 10. DELETEBINDDEV
#define ITP_DELETELXR_TAG                      10010                    // 11. 删除联系人
#define ITP_BANGDING_TAG                       10011                    // 12. 箱子绑定
#define ITP_BAGLIST_TAG                        10012                    // 13. 箱子列表
#define ITP_GETHISTORYRECORD_TAG               10013                    // 15. 箱子历史位置
#define ITP_SETSAFEREGION_TAG                  10014                    // 14. 提交安全栏
#define ITP_MODIFYPERSONALDATA_TAG             10015                    // 18. 修改用户资料
#define ITP_MCUDATA_TAG                        10016                    // 19. 箱子称重开锁





@interface ITPDataCenter : NSObject

+ (instancetype)sharedInstance;

- (NSString *)Ulock:(BOOL)ulock AndWeight:(BOOL)weight;

- (NSData *)paramData :(NSArray *)param command:(NSString *)command;

extern int EncryptDate(char* indate,char* OutDate);

@end
