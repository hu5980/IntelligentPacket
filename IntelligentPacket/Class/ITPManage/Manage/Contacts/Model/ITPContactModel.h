//
//  ITPContactModel.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/18.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPContactModel : NSObject

@property (nonatomic, copy) NSString * contactName;
@property (nonatomic, copy) NSString * contactPhoneNum;
@property (nonatomic, copy) NSString * contactEmail;
@property (nonatomic, copy) UIImage * contactImage;

@end
