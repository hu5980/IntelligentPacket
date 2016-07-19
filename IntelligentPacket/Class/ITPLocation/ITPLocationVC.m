//
//  ITPLocationVC.m
//  IntelligentPacket
//
//  Created by Seth on 16/6/13.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPLocationVC.h"
#import <CoreMotion/CoreMotion.h>
#import <MapKit/MapKit.h>
#import "ITPLocationHistoryVC.h"

@interface ITPLocationVC () <CLLocationManagerDelegate,MKMapViewDelegate> {
    CLLocationManager * locationmanager;
    
    NSMutableArray  *pointsArray;
    MKPolyline* routeLine;
    MKPolylineView* routeLineView;
    
    CLGeocoder *geocoder;
//    NSString *plistPath;
    NSMutableArray *locationArray;
 
}


@property (nonatomic) CMMotionManager *motionManager;

@end

@implementation ITPLocationVC

//设置顶部20的部分字体颜色变为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    locationArray = [NSMutableArray array];
    pointsArray = [NSMutableArray array];
    
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;//支持缩放
    _mapView.delegate = self;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"定位"] style:UIBarButtonItemStylePlain target:self action:@selector(entryHistoryLocationAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self getCurPosition];
}

#pragma --mark Action

- (void) getCurPosition
{
    if (locationmanager==nil)
    {
        locationmanager =[[CLLocationManager alloc] init];
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationmanager.delegate=self;
        locationmanager.desiredAccuracy=kCLLocationAccuracyBest;
        locationmanager.distanceFilter=0.5f;
        [locationmanager requestAlwaysAuthorization];
        [locationmanager startUpdatingLocation];
        [locationmanager startUpdatingHeading];
    }
}



- (void)refreshLanguge {
    self.title = L(@"Location");
    
}


- (void) entryHistoryLocationAction {
    ITPLocationHistoryVC *historyVC = [[ITPLocationHistoryVC alloc] init];
    [historyVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:historyVC animated:YES];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error.description);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    /**
     * magneticHeading 表示磁北极偏转的角度
     ＊trueHeading  磁北极的真实角度
     ＊0.0 - 359.9 度, 0 being true North
     */
    
    NSLog(@"%f",newHeading.magneticHeading);
    
    //将我们的角度转换为弧度
    CGFloat angle=newHeading.magneticHeading/180.0*M_PI;
    
    [UIView animateWithDuration:0.2 animations:^{
        //旋转我们的指南针
      //  self.imgView.transform=CGAffineTransformMakeRotation(-angle);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
   // CLLocation *location=[locations firstObject];//取出第一个位置
    
    
    
    
}


- (void)setMapRoutes
{
    MKMapPoint *pointArray = malloc(sizeof(CLLocationCoordinate2D) *pointsArray.count);
    for(int idx = 0; idx < pointsArray.count; idx++)
    {
        CLLocation *location = [pointsArray objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        pointArray[idx] = point;
    }
    
    if (routeLine) {
        [self.mapView removeOverlay:routeLine];
    }
    
    routeLine = [MKPolyline polylineWithPoints:pointArray count:pointsArray.count];
    if (nil != routeLine) {
        [self.mapView addOverlay:routeLine];
    }
    
    free(pointArray);
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer=[[MKPolylineRenderer alloc]initWithOverlay:overlay];
        renderer.strokeColor=[[UIColor blueColor]colorWithAlphaComponent:0.5];
        renderer.lineWidth=5.0;
        return renderer;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(userLocation.coordinate.latitude == 0.0f || userLocation.coordinate.longitude == 0.0f)    return;
    [pointsArray addObject:userLocation];
    
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc]init];
    [locationDic setValue:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] forKey:@"longitude"];
    [locationDic setValue:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] forKey:@"latitude"];
    
    [locationArray addObject:locationDic];
    
//    BOOL isSuccess =  [locationArray writeToFile:plistPath atomically:YES];
//    
//    if (isSuccess) {
//        NSLog(@"写入成功");
//    }else{
//        NSLog(@"写入失败");
//    }
    
    CLLocationCoordinate2D pos = userLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,500, 500);//以pos为中心，显示2000米
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self setMapRoutes];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"%@", placemarks[0]);
    }];
    
}




@end
