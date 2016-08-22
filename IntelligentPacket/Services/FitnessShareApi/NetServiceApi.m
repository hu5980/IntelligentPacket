//
//  NetServiceApi.m
//  XKRW
//
//  Created by Seth Chen on 15/12/11.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "NetServiceApi.h"
//#import <XKRW-Swift.h>






@implementation NetServiceApi


- (NSString *)getHearPortain:(NSString *)email {

    //[ITPUserManager ShareInstanceOne].userEmail
    NSData * data = [self startSynchronizedGetMethodwithCompleteUrl:[NSString stringWithFormat:@"%@uid=%@", GetHearPortain,email] andParamer:nil];
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return dataStr;
}

- (NSMutableArray *)getFeedbackServerRes:(NSDictionary *)blogRecommendDic
{
    NSMutableArray *mutArray = [NSMutableArray array];
    
    for (NSDictionary *temp in blogRecommendDic[@"data"]) {

    }
    return mutArray;
}

//feedback
- (void )getFeedbackServerWithcontent:(NSString *)content {
    
    NSString *fitnessShareUrl = [NSString stringWithFormat:@"%@%@",HostServer,Feedback];//uid=%@&email=%@&content=%@
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ITPUserManager ShareInstanceOne].userEmail,@"uid",[ITPUserManager ShareInstanceOne].userEmail,@"email",[content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceCharacterSet]],@"content", nil];
    [self startAsynchronizedPostMethodwithCompleteUrl:fitnessShareUrl andParamer:parm andResponseMethod:@selector(getFeedbackServerRes:)];
}

//+ (void)postImage:(NSData*)imgData
//{
//    
//    NSString * uploadURL = UplaodHearPortain;
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uploadURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
//    request.HTTPMethod = @"POST";
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imgData length]];
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:imgData];
//    NSError* error = nil;
//    NSHTTPURLResponse* respnse = nil;
//    NSData* result = [NSURLConnection sendSynchronousRequest:request
//                                           returningResponse:&respnse
//                                                       error:&error];
//    
//    /* 网络失败了 ,打断 */
//    if (error) {
//        NSLog(@"网络错误,上传失败");
//    }
//    else{
//        NSDictionary* r = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        NSString *path = nil;
//        if (r == nil) {
//            NSString* string = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//            NSLog(@"结果解析出错:%@",string);
//        }
//        else{
//            path = [r objectForKey:@"path"];
//            NSLog(@"%@",r);
//        }
//    }
//}

@end
