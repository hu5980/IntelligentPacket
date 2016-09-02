//
//  SearchResultTableVC.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMapPOI;

@protocol SearchResultTableVCDelegate <NSObject>

- (void)setSelectedLocationWithLocation:(AMapPOI *)poi;

@end

@interface SearchResultTableVC : UITableViewController 

- (void)setSearchCity:(NSString *)city;

@property (nonatomic, weak) id<SearchResultTableVCDelegate> delegate;

@end
