//
//  ITPContactsCell.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/9.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPContactsCell.h"

@implementation ITPContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
