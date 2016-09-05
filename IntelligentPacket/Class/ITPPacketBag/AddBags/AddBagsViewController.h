//
//  AddBagsViewController.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPBaseViewController.h"
#import "ITPPacketBagModel.h"
/*
 * 添加箱包
 */
@interface AddBagsViewController : ITPBaseViewController<UITextFieldDelegate>


@property (nonatomic, strong) ITPPacketBagModel * model;


@end
