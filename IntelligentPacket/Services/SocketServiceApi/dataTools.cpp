//
//  dataTools.cpp
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/28.
//  Copyright © 2016年 detu. All rights reserved.
//

#include "dataTools.hpp"



//备注
//
//验证数据算法
//比如:[94E595B120ED0965*APP1*KM*0001*0014*REG,443564333@qq.com]
//需要加密的数据为:APP1*KM*0001*0014*REG,443564333@qq.com
//然后每八个字符为一组使用约定密钥和DES算法进行加密，得出的结果与下一组数据异或作为下一次加密的数据,最终的结果就是验证数据.
//
//下面是c++的算法例子
unsigned char _TAK[16]={0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88};

void Xor(char *InA, const char *InB, int len)
{
    for(int i=0; i<len; ++i)
        InA[i] ^= InB[i];
}

int EncryptDate(char* indate,char* OutDate)
{
    unsigned char MacBlock[32]={0},aryTmp[32]={0};
    int iPos;
    unsigned long p_len = strlen(indate);
    iPos=0;
    while (iPos<p_len)
    {
        memset((char*)aryTmp,0,8);
        if(iPos+8>p_len)
            memcpy((char*)aryTmp,indate+iPos,p_len-iPos);
        else
            memcpy((char*)aryTmp,indate+iPos,8);
        iPos+=8;
        Xor((char*)MacBlock,(char*)aryTmp,8);
//        CStdDes::RunDes(1,1,(char *)aryTmp,(char *)MacBlock,8,(const char *)_TAK,8);
    }
    for(int i=0;i<8;i++)
    {
        sprintf(OutDate+i*2,"%02X",MacBlock[i]);
    }
    return 0;
}

