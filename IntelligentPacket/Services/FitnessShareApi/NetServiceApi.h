//
//  NetServiceApi.h
//  XKRW
//
//  Created by Seth Chen on 15/12/11.
//  Copyright © 2015年 XiKang. All rights reserved.
//

#import "ITPHttpServiceBase.h"


//http://box.jsscom.com/send_question.php?uid=user1&email=123456@qq.com&content=5Lit5Zu9MTIzNDU2
//http://box.jsscom.com/get_user_pic.php?uid=user1
//http://box.jsscom.com/upload_user_pic.php?uid=user1

#define  HostServer  @"http://box.jsscom.com/"  // host

#define  UplaodHearPortain  @"http://box.jsscom.com/upload_user_pic.php?"
#define  GetHearPortain  @"http://box.jsscom.com/get_user_pic.php?"
#define  Feedback  @"http://box.jsscom.com/send_question.php?" // feedback

@interface NetServiceApi : ITPHttpServiceBase

/**
 *  getHearPortain
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
