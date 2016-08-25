//
//  ITPDataCenter.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/1.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define APPID   @"APP1"//[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

#define KM      @"KM"//@"IntelligentPacket"


#define ITP_REGISTER_REQUEST               @"REG"           // 1. 申请注册
#define ITP_REGISTER_CONFIM                @"ENDREG"        // 2. 确认注册
#define ITP_LOGIN                          @"LOGIN"         // 3. 登录BANGDING
#define ITP_CR                             @"CR"            // 4. 实时查询
#define ITP_PHB                            @"PHB"           // 5. 设置亲情号码
#define ITP_MONITOR                        @"MONITOR"       // 6. 亲情号码监听
#define ITP_ACT                            @"ACT"           // 7. 请求终端操作
#define ITP_GPS                            @"GPS"           // 8. GPS开关功能
#define ITP_LXR                            @"LXR"           // 9. 获取联系人
#define ITP_DELETEBINDDEV                  @"DELETEBINDDEV" // 10. DELETEBINDDEV
#define ITP_DELETELXR                      @"DELETELXR"     // 11. 删除联系人
#define ITP_BANGDING                       @"BANGDING"      // 12. 箱子绑定
#define ITP_BAGLIST                        @"POSTITIONMODULELIST"  // 13. 箱子列表


#define ITP_SETSAFEREGION                  @"SETSAFEREGION"  // 14. 提交安全栏


#define ITP_MODIFYPERSONALDATA             @"MODIFYPERSONALDATA"  // 18. 修改用户资料


@interface ITPDataCenter : NSObject

+ (instancetype)sharedInstance;

- (NSData *)paramData :(NSArray *)param command:(NSString *)command;

extern int EncryptDate(char* indate,char* OutDate);

@end
