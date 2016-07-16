///
//  AppUtil.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "AppUtil.h"
#include <iconv.h>

@implementation AppUtil
/*!
 *  手机号码验证，包括133/153/18/177开头的号码验证
 *
 *  @param mobileNum
 *
 *  @return
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length < 11 || mobileNum.length > 11) {
        return NO;
    }
    NSString * MOBILE = @"^1[3-8]+\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";//移动
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";//联通
//    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";//电信
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}

/*！
 *
 *
 *  @param 昵称不能有特殊字符
 *
 *  @return
 */
+ (BOOL)isRightNickName:(NSString *)nickName
{
    // 编写正则表达式：只能是数字或英文，或两者都存在
    NSString *regex = @"^[A-Za-z0-9\u4E00-\u9FA5_-]+$";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 对字符串进行判断
    if (![predicate evaluateWithObject:nickName]) {
//        [self showAlert:@"昵称不能包含特殊字符" andDisAppearAfterDelay:1.];
        return NO;
    }
    return YES;
}

/*!
 *  1、长度为6-16个字符；
 *  2、只能有数字和英文、特殊字符组成。
 *  3、特殊字符包含`、-、=、\、[、]、;、'、,、.、/、~、!、@、#、$、%、^、&、*、(、)、_、+、|、?、>、<、"、:、{、}
 *
 *  @param password
 *
 *  @return
 */
+ (BOOL)isPasswordString:(NSString*)password
{
    
    NSString *pattern = @"^[a-zA-Z]\\w{5,17}$ ";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
//    if (password.length < 6 || password.length > 16) {
//        return NO;
//    }
//    NSString *PWD = @"((?=.*\\d)(?=.*[a-zA-Z]).{8,16})";
//    NSPredicate *regextestPassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PWD];
//    return [regextestPassword evaluateWithObject:password];
    
    // 特殊字符包含`、-、=、\、[、]、;、'、,、.、/、~、!、@、#、$、%、^、&、*、(、)、_、+、|、?、>、<、"、:、{、}
    // 必须包含数字和字母，可以包含上述特殊字符。
    // 依次为（如果包含特殊字符）
    // 数字           (\\d+)
    // 字母           ([a-zA-Z]+)
    // 特殊           ([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)
    // 数字 字母 特殊
    // 字母 数字 特殊
    // 数字 特殊 字母
    // 字母 特殊 数字
    // 特殊 数字 字母
    // 特殊 字母 数字
//    NSString *passWordRegex = @"(\\d+[a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|([a-zA-Z]+\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|(\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+)|([a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+[a-zA-Z]+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+\\d+)";
//    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
//    return [passWordPredicate evaluateWithObject:password];
}

/**
 *  Email验证
 *  ^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$
 *
 *  @param emailString
 *
 *  @return
 */
+ (BOOL)isEmailString:(NSString*)emailString
{
    NSString *email = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    NSPredicate *regextestEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", email];
    if ([regextestEmail evaluateWithObject:emailString] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//dispay time
+ (NSString *)convertStringFromInterval:(NSTimeInterval)timeInterval
{
    int hour = timeInterval/3600;
    int min = (int)timeInterval%3600/60;
    int second = (int)timeInterval%3600%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, second];
}

+ (int )getTaken:(NSString *)num
{
    int checksum = 0xaa;
    NSDateFormatter * fomater = [NSDateFormatter new];
    [fomater setDateFormat:@"yyyy-MM-dd"];
    NSString * nowstr1 = OCSTR(@"%@%@",[fomater stringFromDate:[NSDate date]],num);
    const char* bytes = nowstr1.UTF8String;
    for (int i = 0; i < strlen(bytes); i++){
        checksum += bytes[i];
    }
    return checksum;
}

+ (NSMutableDictionary *)getDataWithPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSDictionary * areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        
        [provinceTmp addObject: [tmp objectAtIndex:0]];
        
    }
    
    
    
    NSArray * province = [NSArray arrayWithArray:provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    NSArray * city = [NSArray arrayWithArray:[cityDic allKeys]];
    
     NSMutableDictionary *addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   province,@"province",
                   city,@"city",nil];
    return addressDict;
}

+ (NSString *)getHexstring:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr;
}

+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

+ (NSString *)getDateTime
{
    NSDateFormatter * fomater = [NSDateFormatter new];
    [fomater setDateFormat:@"yyyyMMddhhmmss"];
    return [fomater stringFromDate:[NSDate date]];
}
@end
