//
//  ITPPacketBagCell.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPPacketBagCell.h"

@implementation ITPPacketBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)phoneAction:(UIButton *)sender {
    if (self.phoneBlcok) {
        self.phoneBlcok (self.indexPath_, sender);
    }
}

- (IBAction)locationAction:(id)sender {
    if (self.locationBlcok) {
        self.locationBlcok (self.indexPath_);
    }
}
- (IBAction)weightAction:(id)sender {
    if (self.weightBlcok) {
        self.weightBlcok (self.indexPath_);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
