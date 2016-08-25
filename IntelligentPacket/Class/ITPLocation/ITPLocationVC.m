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
#import "ITPPacketBagModel.h"
#import "ITPLocationViewModel.h"
#import "ITPLocationModel.h"

@interface ITPLocationVC () <CLLocationManagerDelegate,MKMapViewDelegate> {
    CLLocationManager * locationmanager;
    
    NSMutableArray  *pointsArray;
    MKPolyline* routeLine;
    MKPolylineView* routeLineView;
    
    CLGeocoder *geocoder;
//    NSString *plistPath;
    NSMutableArray *locationArray;
    
    UIImageView *arrowImageView;
    
    ITPPacketBagModel * currentModel;
}


@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) NSTimer *locationTimer;

@end

@implementation ITPLocationVC

//设置顶部20的部分字体颜色变为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    locationArray = [NSMutableArray array];
    pointsArray = [NSMutableArray array];
    
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;//支持缩放
    _mapView.delegate = self;
//    _mapView .showsUserLocation = YES;
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 20, 40)];
    arrowImageView.image = [UIImage imageNamed:@"icon_cellphone"];
  //  [_mapView addSubview:arrowImageView];
    
    geocoder = [[CLGeocoder alloc] init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"定位"] style:UIBarButtonItemStylePlain target:self action:@selector(entryHistoryLocationAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    [self getCurPosition];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:ITPacketLocation object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSNotification * notification = (NSNotification *)x;
        currentModel = notification.object;
        NSString * name = [NSString stringWithFormat:@"%@ Location",currentModel.bagName];
        self.title = L(name);
        self.locationTimer.fireDate = [NSDate distantPast]; // start
        NSLog(@"%@", x);
        
    }];
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(queryLocation) userInfo:nil repeats:YES];
    self.locationTimer.fireDate = [NSDate distantFuture]; // pause
}

#pragma --mark Action

// 查询地址返回
- (void)queryLocation {
    
    [[ITPScoketManager shareInstance] crWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:currentModel.bagId withTimeout:10 tag:107 success:^(NSData *data, long tag) {
        
        BOOL abool = [ITPLocationViewModel isSuccesss:data];
        if (abool) {
            ITPLocationModel * model = [ITPLocationViewModel Locations:data];
            NSLog(@"longitude = %@   latitude = %@", model.longitude, model.latitude);
            MKUserLocation *userLocation = [[MKUserLocation alloc] init];
            userLocation.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude  doubleValue]);
            [self showLocationInMapView:userLocation];
        }
    } faillure:^(NSError *error) {
        if (error) {
            
        }
    }];
}

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
        arrowImageView.transform=CGAffineTransformMakeRotation(-angle);
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
    if(userLocation.coordinate.latitude == 0.0f || userLocation.coordinate.longitude == 0.0f){
        return;
    }
    [self showCurrentLocationInfo:userLocation];
    [pointsArray addObject:userLocation];
    
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc]init];
    [locationDic setValue:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] forKey:@"longitude"];
    [locationDic setValue:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] forKey:@"latitude"];
    
    [locationArray addObject:locationDic];

    CLLocationCoordinate2D pos = userLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,500, 500);//以pos为中心，显示2000米
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self setMapRoutes];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPointAnnotation"];
        aView.image = [UIImage imageNamed:@"ico_bag"];
        aView.frame =  CGRectMake(0, 0, 25, 33); 
        aView.canShowCallout = YES;
        
        return aView;
    }
    return nil;
}


- (void)showCurrentLocationInfo:(MKUserLocation *)location {
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    NSLog(@"%f\n%f",location.coordinate.latitude,location.coordinate.longitude);
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        if (placemarks.count > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *locationString = [NSString stringWithFormat:@"%@%@%@附近",[[placemark addressDictionary] objectForKey:@"City"],[[placemark addressDictionary] objectForKey:@"SubLocality"],[[placemark addressDictionary] objectForKey:@"Thoroughfare"]];
            
            self.locationLabel.text = locationString;
      
        }
        else if (error == nil && [placemarks count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}



- (void)showLocationInMapView:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D pos = userLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,1000, 1000);//以pos为中心，显示2000米
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:adjustedRegion animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:userLocation.coordinate];
    [_mapView addAnnotation:annotation];
    
    [self showCurrentLocationInfo:userLocation];
}

@end
