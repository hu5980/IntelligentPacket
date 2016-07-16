//
//  ITPPacketBagCell.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITPPacketBagCell : UITableViewCell

@property (nonatomic, assign) int indexPath_;

@property (nonatomic, copy) void (^phoneBlcok)(int indexPath);
@property (nonatomic, copy) void (^locationBlcok)(int indexPath);
@property (nonatomic, copy) void (^weightBlcok)(int indexPath);

@end
