//
//  UIManager.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "UIManager.h"

@implementation UIManager

+ (instancetype)shareInstance
{
    static UIManager * _sigton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sigton) {
            _sigton = [[UIManager alloc]init];
        }
    });
    return _sigton;
}


- (void)configUI {
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UINavigationBar appearance] setBarTintColor:mainSchemeColor];
    
#warning 这一辈子都记住这个方法了  太坑了，把整个项目拆了 才找到它  他妈的 操死你个龟儿子
//    [UIBarButtonItem appearance].image = [[UIBarButtonItem appearance].image
//                                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:mainSchemeColor} forState:UIControlStateSelected];
    
}

@end
