//
//  ITPContactsCell.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/9.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITPContactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end
