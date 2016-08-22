//
//  NetServiceApi.h
//  XKRW
//
//  Created by Seth Chen on 15/12/11.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "ITPHttpServiceBase.h"

#define  HostServer  @"http://box.jsscom.com/"  // host

#define  UplaodHearPortain  @"http://box.jsscom.com/upload_user_pic.php?"
#define  GetHearPortain  @"http://box.jsscom.com/get_user_pic.php?"
#define  Feedback  @"http://box.jsscom.com/send_question.php?" // feedback

@interface NetServiceApi : ITPHttpServiceBase

/**
 *  FitnessRecommend
 *
 *  @param page page
 */
- (NSString *)getHearPortain:(NSString *)email ;

/**
 *  feedback
 *
 *  @param content
 */
- (void )getFeedbackServerWithcontent:(NSString *)content;

///**
// *  post image
// *
// *  @param imgData
// */
//+ (void)postImage:(NSData*)imgData;

@end
