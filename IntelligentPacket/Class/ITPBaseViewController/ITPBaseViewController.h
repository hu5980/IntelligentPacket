//
//  ITPBaseViewController.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKFoundation.h>
#import <MapKit/MKAnnotation.h>

@interface ITPBaseViewController : UIViewController

- (void)showAlert:(nonnull NSString *)message WithDelay:(NSTimeInterval)d;

- (void)setNavBarBarItemWithTitle:(NSString  * _Nullable )aTitle target:(nonnull id)aTarget action:(nonnull SEL)aAction atRight:(BOOL)aRight;

// 语言切换通知
- (void)refreshLanguge ;

- (CLLocationCoordinate2D)earthFromMars:(MKUserLocation * _Nullable)userLocation;
- (CLLocationCoordinate2D)marsFromEarth:(MKUserLocation * _Nullable)userLocation;
@end
