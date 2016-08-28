
//
//  ViewController.h
//  IntelligentPacket
//
//  Created by Seth on 16/6/13.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPBaseViewController.h"


@interface ITPLocationVC : ITPBaseViewController


@property (strong,nonatomic) CLLocation *location;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) ITPPacketBagModel * currentModel;
@end

