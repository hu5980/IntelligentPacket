//
//  Macros.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/14.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

// debug相关
#if DEBUG
#define NSLog(...)  NSLog(__VA_ARGS__)
#else
#define NSLog(...)  
#endif

// 工具
#define OCSTR(...)                      [NSString stringWithFormat:__VA_ARGS__]


// 屏幕相关
#define UI_WIDTH    [UIScreen mainScreen].bounds.size.width
#define UI_HEIGHT   [UIScreen mainScreen].bounds.size.height


// 色调相关

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define mainSchemeColor RGB(60,135,234) 

#define viewColor    RGB(230, 230, 230)

// 国际化
#define AppLanguage @"appLanguage"

#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]



#define L(key) CustomLocalizedString(key, nil)

#define refreshLangugeNotification @"refreshLangugeNotification"
