//
//  DVLanguageManager.h
//  detuvr
//
//  Created by David on 16/5/31.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

//语言选择
@interface ITPLanguageManager : NSObject

+ (instancetype)sharedInstance;

- (void) config;

//- (NSString *)languagePram;

- (NSString *)currentLanguage;
//
//-(NSString*)url_agreement;

- (BOOL)isChinese;//是否为中文
//
//-(NSString*)url_service;
//
//-(NSString*)url_qa;
//
//-(NSString*)url_camera_use;
//
//- (NSString *)url_F4_help;

@end
