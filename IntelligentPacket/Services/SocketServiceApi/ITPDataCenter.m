//
//  ITPDataCenter.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/1.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPDataCenter.h"
#include "StdDes.h"


@interface ITPDataCenter()

@property (nonatomic, assign) uint32_t index;

@end

@implementation ITPDataCenter

+ (instancetype)sharedInstance
{
    static ITPDataCenter* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ITPDataCenter new];
        instance.index = 0x00;
    });
    
    instance.index ++;
    
    if (instance.index >= 0x270F) {
        instance.index = 0x00;
    }
    
    return instance;
}

- (NSData *)paramData :(NSArray *)param command:(NSString *)command{
  
    @try
    {
        NSString * paramStr = @"";
        
        for (int i = 0; i < param.count; i ++) {
            if (i == 0) {
                paramStr = [paramStr stringByAppendingString:param[i]];
            }else paramStr = [paramStr stringByAppendingString:OCSTR(@",%@", param[i])];
        }
        
        NSString * indata = OCSTR(@"%@*%@*%04X*%04lX*%@,%@", APPID, KM, self.index, (command.length + paramStr.length + 1), command, paramStr);
        
        char outData[16] = "0C9D8AD545B0C5F4";
        
        EncryptDate((char *)indata.UTF8String, outData);
        
        NSString * outstr = [NSString stringWithUTF8String:outData];
        
        indata = OCSTR(@"[%@*%@]", outstr, indata);//[0C9D8AD545B0C5F4*APP1*KM*0001*001D*LOGIN,355567207@qq.com,123456]
        
        NSData * data = [indata dataUsingEncoding:NSUTF8StringEncoding];
        
        return data;

    }
    @catch (NSException* exception)
    {
        NSLog(@"Uncaught exception: %@, %@", [exception description],
              [exception callStackSymbols]);
        @throw exception;
    }
    
    return nil;

}


/*
验证数据算法
比如:[94E595B120ED0965*APP1*KM*0001*0014*REG,443564333@qq.com]
需要加密的数据为:APP1*KM*0001*0014*REG,443564333@qq.com
然后每八个字符为一组使用约定密钥和DES算法进行加密，得出的结果与下一组数据异或作为下一次加密的数据,最终的结果就是验证数据.
*/

unsigned char _TAK[16]={0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88};

void Xor(char *InA, const char *InB, int len)
{
    for(int i=0; i<len; ++i)
        InA[i] ^= InB[i];
}

int EncryptDate(char* indate,char* OutDate)
{
    unsigned char MacBlock[32] = {0}, aryTmp[32] = {0};
    int iPos;
    int p_len = (int)strlen(indate);
    iPos=0;
    while (iPos<p_len)
    {
        memset((char*)aryTmp,0,8);
        if(iPos+8>p_len)
            memcpy((char*)aryTmp,indate+iPos,p_len-iPos);
        else
            memcpy((char*)aryTmp,indate+iPos,8);
        iPos+=8;
        Xor((char*)aryTmp,(char*)MacBlock,8);
        RunDes(1,1,(char *)aryTmp,(char *)MacBlock,8,(const char *)_TAK,8);
    }
    for(int i=0;i<8;i++)
    {
        sprintf(OutDate+i*2,"%02X", MacBlock[i]);
//        int len = snprintf(OutDate+i*2, sizeof(OutDate+i*2), "%02X", MacBlock[i]);
//        int a = len;
    }
    return 0;
}

@end
