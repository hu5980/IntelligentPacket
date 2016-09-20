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
#import "CLLocation+SethSwitch.h"

@interface ITPLocationVC () <CLLocationManagerDelegate,MKMapViewDelegate> {
    CLLocationManager * locationmanager;
    
    NSMutableArray  *pointsArray;
    MKPolyline* routeLine;
    MKPolylineView* routeLineView;
    
    CLGeocoder *geocoder;
    NSMutableArray *locationArray;
    
    UIImageView *arrowImageView;
    
    UILabel *updateTimeLabel;
    
    UIImageView *electricImageView;
    
    UIButton *refreshButton;
    
    //计算2点之间的距离
    CLLocation  * newLocation;
    CLLocation  * oldLocation;
    
    UIStepper *stepper ;
    
    MKUserLocation *bagLocation;
    
    NSArray *rangeArray;
    
    BOOL  ishandRefresh;
    UIView * rightTopbackView;
}


@property (nonatomic) CMMotionManager *motionManager;

//@property (nonatomic) NSTimer *locationTimer;

@end

@implementation ITPLocationVC

//设置顶部20的部分字体颜色变为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    if (locationmanager)
    {
        [locationmanager stopUpdatingLocation];
    }
//    if (self.locationTimer) {
//        [self.locationTimer setFireDate:[NSDate date]];
//    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (locationmanager)
    {
        [locationmanager stopUpdatingLocation];
    }
//    if (self.locationTimer) {
//         [self.locationTimer setFireDate:[NSDate distantFuture]];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationArray = [NSMutableArray array];
    pointsArray = [NSMutableArray array];
    ishandRefresh = NO;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;//支持缩放
    _mapView.delegate = self;
    _mapView .showsUserLocation = YES;
    
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 20, 40)];
    arrowImageView.image = [UIImage imageNamed:@"icon_cellphone"];
  //  [_mapView addSubview:arrowImageView];
    
    geocoder = [[CLGeocoder alloc] init];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"定位"] style:UIBarButtonItemStylePlain target:self action:@selector(entryHistoryLocationAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self queryLocation];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:ITPacketLocation object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSNotification * notification = (NSNotification *)x;
        self.currentModel = notification.object;
        
        if (!self.currentModel.bagId || !self.currentModel.lastOnlineTime )
            self.mapView .showsUserLocation = YES;
        else
            self.mapView .showsUserLocation = NO;
        
        NSString * name = [NSString stringWithFormat:@"%@ %@",self.currentModel.bagName?self.currentModel.bagName:@"", L(@"Location")];
        self.navigationItem.title = name;
//        self.locationTimer.fireDate = [NSDate distantPast]; // start
        NSLog(@"%@", x);
        [self queryLocation];
        
    }];
//    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(aotoQueryLocation) userInfo:nil repeats:YES];
//    self.locationTimer.fireDate = [NSDate distantFuture]; // pause
    
    updateTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    updateTimeLabel.textColor = [UIColor blueColor];
    updateTimeLabel.font = XKDefaultFontWithSize( 14.f);
    updateTimeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:updateTimeLabel];
    
    // top right
    rightTopbackView = [[UIView alloc]initWithFrame:CGRectMake(UI_WIDTH - 65, 20, 50, 105)];
    rightTopbackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"locback"]];
    [_mapView addSubview:rightTopbackView];
    
    electricImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 15, 15, 30)];
    electricImageView.image = [UIImage imageNamed:@"bat5"];
    [rightTopbackView addSubview:electricImageView];
    
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(7.5, electricImageView.bottom + 10, 35, 50);
    [refreshButton setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [rightTopbackView addSubview:refreshButton];
    refreshButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self refreshAction];
        return [RACSignal empty];
    }];
    
    [RACObserve(self, currentModel)subscribeNext:^(id x) {
        ITPPacketBagModel * model = x;
            if (model.bagId&&model.bagPhoneNum) {
                updateTimeLabel.hidden = NO;
                rightTopbackView.hidden = NO;
                electricImageView.hidden = NO;
                refreshButton.hidden = NO;
            }
            else {
                rightTopbackView.hidden = YES;
                updateTimeLabel.hidden = YES;
                electricImageView.hidden = YES;
                refreshButton.hidden = YES;
            }
    }];
    
//    rangeArray = @[@5,@10,@20,@50,@100,@200,@500,@1000,@2000,@5000,@10000,@20000,@50000,@100000,@200000,@500000,@1000000,@2000000];
    rangeArray = @[@2000000,@1000000,@500000,@200000,@100000,@50000,@20000,@10000,@5000,@2000,@1000,@500,@200,@100,@50,@20,@10,@5];
    
    stepper = [[UIStepper alloc] initWithFrame:CGRectMake(XKAppWidth -120, XKAppHeight - 200, 120, 60)];
   
    stepper.backgroundColor =[UIColor whiteColor];
    stepper.minimumValue = 0;
    stepper.maximumValue = rangeArray.count - 1;
    stepper.value = 6;
    [stepper addTarget:self action:@selector(changRange:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mapView addSubview:stepper];
    
    
}

#pragma --mark Action

// 查询地址返回


- (void)changRange:(UIStepper *)steper {
    NSLog(@"%f",[[rangeArray objectAtIndex:stepper.value] floatValue]);
    [_mapView removeAnnotations:_mapView.annotations];
    
    CLLocationCoordinate2D pos = _mapView.centerCoordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,[[rangeArray objectAtIndex:stepper.value] floatValue],[[rangeArray objectAtIndex:stepper.value] floatValue]);//以pos为中心，显示2000米
//    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:viewRegion animated:YES];
    
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:bagLocation.coordinate];
    [_mapView addAnnotation:annotation];
    
    [self showCurrentLocationInfo:bagLocation];
}


//- (void)aotoQueryLocation {
//    if (!self.currentModel ) {
//        [self getCurPosition];
//        return;
//    }
//    
//    [[ITPScoketManager shareInstance] crWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:self.currentModel.bagId withTimeout:10 tag:107 success:^(NSData *data, long tag) {
//        if (tag != 107) {
//            return ;
//        }
//        BOOL abool = [ITPLocationViewModel isSuccesss:data];
//        if (abool) {
//            ITPLocationModel * model = [ITPLocationViewModel Locations:data];
//            updateTimeLabel.text = [NSString stringWithFormat:@"更新时间%@",model.time];
//            [self setelectricImage:model.electric];
//            NSLog(@"longitude = %@   latitude = %@", model.electric, model.latitude);
//            
//            MKUserLocation *userLocation = [[MKUserLocation alloc] init];
//            userLocation.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude  doubleValue]);
//            
//            bagLocation = userLocation;
//            
//            // 地球转火星
//            CLLocation * location = [[CLLocation alloc] initWithCoordinate:userLocation.coordinate
//                                                                  altitude:userLocation.location.altitude
//                                                        horizontalAccuracy:userLocation.location.horizontalAccuracy
//                                                          verticalAccuracy:userLocation.location.verticalAccuracy
//                                                                    course:userLocation.location.course
//                                                                     speed:userLocation.location.speed
//                                                                 timestamp:userLocation.location.timestamp];
//            CLLocation * newlocation = [location locationMarsFromEarth];
//            // =========================
//            userLocation.coordinate = newlocation.coordinate;
//            
//            [self showLocationInMapView:userLocation andisAoto:YES];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketAddbags object:nil];
//        }
//    } faillure:^(NSError *error) {
//        if (error) {
//            
//        }
//    }];
//
//}

- (void)queryLocation {
    
    if (!self.currentModel ) {
        [self getCurPosition];
        return;
    }
    @weakify(self);
    [[ITPScoketManager shareInstance] crWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:self.currentModel.bagId withTimeout:10 tag:107 result:^(NSData *data, long tag, NSError *error) {
        @strongify(self);
        BOOL abool = [ITPLocationViewModel isSuccesss:data];
        if (!error&&abool) {
            ITPLocationModel * model = [ITPLocationViewModel Locations:data];
            updateTimeLabel.text = [NSString stringWithFormat:@"更新时间%@",model.time];
            [self setelectricImage:model.electric];
            NSLog(@"longitude = %@   latitude = %@", model.electric, model.latitude);
            
            MKUserLocation *userLocation = [[MKUserLocation alloc] init];
            userLocation.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude  doubleValue]);
            
            bagLocation = userLocation;
            
            // 地球转火星
            CLLocation * location = [[CLLocation alloc] initWithCoordinate:userLocation.coordinate
                                                                  altitude:userLocation.location.altitude
                                                        horizontalAccuracy:userLocation.location.horizontalAccuracy
                                                          verticalAccuracy:userLocation.location.verticalAccuracy
                                                                    course:userLocation.location.course
                                                                     speed:userLocation.location.speed
                                                                 timestamp:userLocation.location.timestamp];
            CLLocation * newlocation = [location locationMarsFromEarth];
            // =========================
            userLocation.coordinate = newlocation.coordinate;
            NSLog(@"+++++++%f,%f",newlocation.coordinate.latitude,newlocation.coordinate.longitude);
            
            if(newlocation.coordinate.latitude > 180 || newlocation.coordinate.latitude < -180 || newlocation.coordinate.longitude > 180 || newlocation.coordinate.longitude < -180){
                [self queryLocation];
                return;
            }
            
            [self showLocationInMapView:userLocation andisAoto:!ishandRefresh];
            [self showAnnotationInMapView:userLocation];
            if(ishandRefresh){
                ishandRefresh = NO;
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketAddbags object:nil];
        }
    }];
}

- (void)refreshAction { //:(UIButton *)buton
    ishandRefresh = YES;
    [self queryLocation];
}

- (void) getCurPosition
{
    if (locationmanager==nil)
    {
        locationmanager =[[CLLocationManager alloc] init];
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationmanager.delegate = self;
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = .5f;
        
        [locationmanager requestAlwaysAuthorization];
        [locationmanager startUpdatingLocation];
    }
}



- (void)refreshLanguge {
    
    NSString * name = [NSString stringWithFormat:@"%@ %@",self.currentModel.bagName?self.currentModel.bagName:@"", L(@"Location")];
    self.navigationItem.title = name;

}


- (void)setelectricImage:(NSString *)electric {
    if ([electric doubleValue] >= 100.0) {
        electricImageView.image =[UIImage imageNamed:@"bat5" ];
    }else if ([electric doubleValue] < 100.0 && [electric doubleValue]>= 75.0){
        electricImageView.image =[UIImage imageNamed:@"bat4" ];
    }else if ([electric doubleValue] < 75.0 && [electric doubleValue]>= 50.0){
        electricImageView.image =[UIImage imageNamed:@"bat3" ];
    }else if ([electric doubleValue] < 50.0 && [electric doubleValue]>= 25.0){
        electricImageView.image =[UIImage imageNamed:@"bat2" ];
    }else {
        electricImageView.image =[UIImage imageNamed:@"bat0" ];
    }
}

- (void) entryHistoryLocationAction {
    ITPLocationHistoryVC *historyVC = [[ITPLocationHistoryVC alloc] init];
    historyVC.model = self.currentModel;
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

long long _previousTimeSamp = 0;
long long _currentTimeSamp = 0;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    if (!self.currentModel ) {
        CLLocation *location=[locations firstObject];//取出第一个位置
        
        CLLocationCoordinate2D pos = location.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,1000, 1000);//以pos为中心，显示2000米
      //  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
        
        [_mapView setRegion:viewRegion animated:YES];

    } else { // 最少5s 间隔
        _currentTimeSamp = CFAbsoluteTimeGetCurrent();
        if (_currentTimeSamp - _previousTimeSamp < 5) {
            return;
        }
        _previousTimeSamp = _currentTimeSamp;
        [self queryLocation];
    }
    
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
//    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:viewRegion animated:YES];
    
    [self setMapRoutes];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPointAnnotation"];
        aView.image = self.currentModel.bagType != 1?[UIImage imageNamed:@"ico_bag"]:[UIImage imageNamed:@"ico_suitcases"];
        aView.frame =  CGRectMake(0, 0, 25, 33); 
        aView.canShowCallout = YES;
        
        return aView;
    }
    return nil;
}

#pragma mark - // 显示大头针
- (void)showAnnotationInMapView:(MKUserLocation *)userLocation {
    
    if (_mapView.annotations.count > 0) {
        [_mapView removeAnnotations:_mapView.annotations];
    }
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:userLocation.coordinate];
    [_mapView addAnnotation:annotation];
    
    [self showCurrentLocationInfo:userLocation];
}

- (void)showCurrentLocationInfo:(MKUserLocation *)location {
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    NSLog(@"%f\n%f",location.coordinate.latitude,location.coordinate.longitude);
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        if (placemarks.count > 0){
            //显示最前面的地标信息
            CLPlacemark *placemark = [placemarks firstObject];
            
            
            //            NSDictionary *addressDictionary = [placemark addressDictionary];
            //            NSString *name = placemark.name;
            NSString *thoroughfare = placemark.thoroughfare;
            NSString *subThoroughfare = placemark.subThoroughfare;
            NSString *locality = placemark.locality;
            NSString *subLocality = placemark.subLocality;
            NSString *administrativeArea = placemark.administrativeArea;
            //            NSString *subAdministrativeArea = placemark.subAdministrativeArea;
            //            NSString *ISOcountryCode = placemark.ISOcountryCode;
            NSString *country = placemark.country;
            //            NSString *inlandWater = placemark.inlandWater;
            //            NSString *ocean = placemark.ocean;
            //            NSArray *areasOfInterest = placemark.areasOfInterest;
            
            
            NSArray * arr = [[placemark addressDictionary] objectForKey:@"FormattedAddressLines"];
            //            NSDictionary * dic = [arr firstObject];
            //            NSArray * _arr = [dic objectForKey:@"FormattedAddressLines"];
            NSString *locationString = [arr firstObject];
            if (locationString.length <= 0) {
                locationString = [NSString stringWithFormat:@"%@%@%@%@%@%@附近",country.length==0?@"":country, administrativeArea.length==0?@"":administrativeArea, locality.length==0?@"":locality, subLocality.length==0?@"":subLocality, thoroughfare.length==0?@"":thoroughfare, subThoroughfare.length==0?@"":subThoroughfare];
            }
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

- (void)showLocationInMapView:(MKUserLocation *)userLocation andisAoto:(BOOL) aoto {
    if (!aoto) {
        [_mapView removeAnnotations:_mapView.annotations];
        CLLocationCoordinate2D pos = userLocation.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,500, 500);//以pos为中心，显示2000米
//        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
        [_mapView setRegion:viewRegion animated:YES];
        stepper.value = 6;
    }else{
        if (_mapView.annotations.count>0) {
            [_mapView removeAnnotations:_mapView.annotations];
        }
        CLLocationCoordinate2D pos = userLocation.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,500, 500);//以pos为中心，显示2000米
//        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
        [_mapView setRegion:viewRegion animated:YES];
        stepper.value = 6;
    }
}

//计算2点之间的距离
- (CGFloat)calculationDistance {
    
    CGFloat distance = [newLocation distanceFromLocation:oldLocation];
    NSLog(@"distance = %f", distance);
    return distance;
}
@end
