//
//  FitnessShareApi5_1_2.h
//  XKRW
//
//  Created by Seth Chen on 15/12/11.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "ITPHttpServiceBase.h"

@interface FitnessShareApi5_1_2 : ITPHttpServiceBase

/**
 *  FitnessRecommend
 *
 *  @param page page
 */
- (void )getFitnessRecommendFromServerWithPage:(NSNumber *)page;

/**
 *  feedback
 *
 *  @param content
 */
- (void )getFeedbackServerWithcontent:(NSString *)content;


@end
