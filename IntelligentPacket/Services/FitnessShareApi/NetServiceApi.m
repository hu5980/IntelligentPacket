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


//从网络获取瘦身分享推荐内容
- (void )getFitnessRecommendFromServerWithPage:(NSNumber *)page
{
    NSString *fitnessShareUrl = @"";//[NSString stringWithFormat:@"%@%@",kNewServer,kGetBlogRecommendArticle];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",@"10",@"size", nil];
    [self startAsynchronizedPostMethodwithCompleteUrl:fitnessShareUrl andParamer:parm andResponseMethod:@selector(getFitnessRecommendRes:)];
}


- (NSMutableArray *)getFitnessRecommendRes:(NSDictionary *)blogRecommendDic
{
    NSMutableArray *mutArray = [NSMutableArray array];
    
    for (NSDictionary *temp in blogRecommendDic[@"data"]) {

    }
    return mutArray;
}

//从网络获取瘦身分享推荐内容
- (void )getFeedbackServerWithcontent:(NSString *)content {
    NSString *fitnessShareUrl = @"";//[NSString stringWithFormat:@"%@%@",kNewServer,kGetBlogRecommendArticle];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithObjectsAndKeys:,@"uid",@"size",@"10",@"size",[content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceCharacterSet]],@"content", nil];
    [self startAsynchronizedPostMethodwithCompleteUrl:fitnessShareUrl andParamer:parm andResponseMethod:@selector(getFitnessRecommendRes:)];
}

@end
