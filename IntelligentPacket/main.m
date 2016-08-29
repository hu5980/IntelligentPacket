 //
//  main.m
//  IntelligentPacket
//
//  Created by Seth on 16/6/13.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
//}
int main(int argc, char* argv[])
{
    @autoreleasepool
    {
        int returnValue;
        @try
        {
            returnValue = UIApplicationMain(argc, argv, nil,
                                            NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException* exception)
        {
            NSLog(@"Uncaught exception: %@, %@", [exception description],
                     [exception callStackSymbols]);
            @throw exception;
        }
        return returnValue;
    }
}