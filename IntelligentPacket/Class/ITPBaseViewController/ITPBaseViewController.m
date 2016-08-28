//
//  ITPBaseViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//



#import "ITPBaseViewController.h"

@interface ITPBaseViewController ()

@end

@implementation ITPBaseViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshLanguge];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLanguge) name:refreshLangugeNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)refreshLanguge {

}

- (void)showAlert:(NSString *)message WithDelay:(NSTimeInterval)d
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:d];
}

- (void)setNavBarBarItemWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)aAction atRight:(BOOL)aRight
{
    UIButton *_barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _barButton.frame = CGRectMake(0, 0, 40, 27);
    [_barButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_barButton addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    [_barButton setTitle:aTitle forState:UIControlStateNormal];
    _barButton.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *_buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_barButton];
    if (aRight) {
        self.navigationItem.rightBarButtonItem = _buttonItem;
    }else{
        self.navigationItem.leftBarButtonItem = _buttonItem;
    }
}

#pragma mark - 火星转地球

- (CLLocationCoordinate2D)earthFromMars:(MKUserLocation *)userLocation {
    // 火星转地球
    CLLocation * location = [[CLLocation alloc] initWithCoordinate:userLocation.coordinate
                                                          altitude:userLocation.location.altitude
                                                horizontalAccuracy:userLocation.location.horizontalAccuracy
                                                  verticalAccuracy:userLocation.location.verticalAccuracy
                                                            course:userLocation.location.course
                                                             speed:userLocation.location.speed
                                                         timestamp:userLocation.location.timestamp];
    CLLocation * newlocation = [location locationEarthFromMars];
    return newlocation.coordinate;
}

#pragma mark - 地球转火星
- (CLLocationCoordinate2D)marsFromEarth:(MKUserLocation *)userLocation {
    // 地球转火星
    CLLocation * location = [[CLLocation alloc] initWithCoordinate:userLocation.coordinate
                                                          altitude:userLocation.location.altitude
                                                horizontalAccuracy:userLocation.location.horizontalAccuracy
                                                  verticalAccuracy:userLocation.location.verticalAccuracy
                                                            course:userLocation.location.course
                                                             speed:userLocation.location.speed
                                                         timestamp:userLocation.location.timestamp];
    CLLocation * newlocation = [location locationMarsFromEarth];
    return newlocation.coordinate;
}

@end
