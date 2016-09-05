//
//  ITPFeedBackItem.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/9/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPFeedBackItem : NSObject

@property (nonatomic, assign) NSInteger imageIndex;     //坐标

@property (nonatomic, strong) UIImage * originalImage;  //原图

@property (nonatomic, strong) UIImage * smallImage;     //缩略图

@end
