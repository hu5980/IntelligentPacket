//
//  DVLanguageManager.m
//  detuvr
//
//  Created by David on 16/5/31.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPLanguageManager.h"


@implementation ITPLanguageManager

+ (instancetype) sharedInstance{
    static id obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (void) config{
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *current = [languages objectAtIndex:0];
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
    if (!currentLanguage) {
        NSString *language;
        if ([current isEqualToString:@"zh-Hans-CN"] || [current isEqualToString:@"zh-Hant-CN"] || [current isEqualToString:@"en-CN"]) {
            language = [current substringToIndex:current.length-3];
        } else  if([current isEqualToString:@"zh-Hans"] || [current isEqualToString:@"zh-Hant"] || [current isEqualToString:@"en"]){
            language = current;
        } else {
            language = @"en";
            
        }
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:AppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (BOOL)isChinese {
    NSString *currLang = [self currentLanguage];
    if ([currLang isEqualToString:@"zh-Hans-CN"] ||
        [currLang isEqualToString:@"zh-Hant-CN"]||
        [currLang isEqualToString:@"zh-Hans"] ||
        [currLang isEqualToString:@"zh-Hant"]) {
        return YES;
    } else {
        return NO;
    }
    
}

- (NSString *)currentLanguage {
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
    
}
//-(NSString*)url_agreement{
//    NSString *url_agreement = [F4OnlineConfigManager sharedInstance].url_agreement;
//    return [self appendingString:url_agreement];
//}
//
//-(NSString*)url_service{
//    NSString *url_service = [F4OnlineConfigManager sharedInstance].url_service;
//    return [self appendingString:url_service];
//}
//
//-(NSString*)url_qa{
//    NSString *url_qa = [F4OnlineConfigManager sharedInstance].url_qa;
//    return [self appendingString:url_qa];
//}
//
//-(NSString*)url_camera_use{
//    NSString *url_camera_use = [F4OnlineConfigManager sharedInstance].url_camera_use;
//    return [self appendingString:url_camera_use];
//}
//
//- (NSString *)url_F4_help {
//    NSString *url_camera_use = [F4OnlineConfigManager sharedInstance].url_F4_help;
//    return [self appendingString:url_camera_use];
//
//}

//- (NSString *)languagePram {
//    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
//    NSString *pram;
//    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
//        pram = @"lang=zh-cn";
//    } else if([currentLanguage isEqualToString:@"zh-Hant"]){
//        pram = @"lang=zh-tw";
//    } else if([currentLanguage isEqualToString:@"en"]) {
//        pram = @"lang=en-us";
//    }
//    
//    return pram;
//    
//}
//
//
//- (NSString *)appendingString:(NSString *)str {
//    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
//    NSString *pram;
//    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
//        pram = @"&lang=zh-cn";
//    } else if([currentLanguage isEqualToString:@"zh-Hant"]){
//        pram = @"&lang=zh-tw";
//    } else if([currentLanguage isEqualToString:@"en"]) {
//        pram = @"&lang=en-us";
//    }
//    
//    return [str stringByAppendingString:pram];
//    
//    
//}

@end
