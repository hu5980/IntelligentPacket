//
//  SafeAreaViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "SafeAreaViewController.h"
#import "ITPBagViewModel.h"
#import <CoreMotion/CoreMotion.h>
#import <MapKit/MapKit.h>

@interface SafeAreaViewController () <CLLocationManagerDelegate,MKMapViewDelegate> {
    CLLocationManager * locationmanager;
    
    NSMutableArray  *pointsArray;
    MKPolyline* routeLine;
    MKPolylineView* routeLineView;
    
    CLGeocoder *geocoder;
    //    NSString *plistPath;
    NSMutableArray *locationArray;
    
    UILabel * curlocationLabel;
    UIButton * selCycleRadiuBtn;
}

@property (nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) MKCircle *circle;
@property (nonatomic, strong) MKUserLocation * userLocation;
@property (nonatomic, assign) int circleRadiu;

@end

@implementation SafeAreaViewController

//设置顶部20的部分字体颜色变为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}



- (void)refreshLanguge {
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    __languageSwitch.on = ![[ITPLanguageManager sharedInstance]isChinese];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTools];
    self.circleRadiu = 1000;
    locationArray = [NSMutableArray array];
    pointsArray = [NSMutableArray array];
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;//支持缩放
    _mapView.delegate = self;
    _mapView .showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    [self getBagsLocatinDetail];
    [self getCurPosition];
}

- (void)getBagsLocatinDetail {
    
    UIView *bagsLocatinDetailView = [UIView new];
    bagsLocatinDetailView.backgroundColor = [UIColor darkGrayColor];
    bagsLocatinDetailView.alpha = .8;
    [self.view addSubview:bagsLocatinDetailView];
    [bagsLocatinDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.equalTo(@(UI_WIDTH));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(44));
    }];
    
    
    UIImageView * locImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位_P"]];
    [bagsLocatinDetailView addSubview:locImg];
    [locImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(@0);
    }];
    UILabel * bagNameLab = [UILabel new];
    bagNameLab.text = self.model.bagName;
//    bagNameLab.backgroundColor = [UIColor redColor];
    [bagsLocatinDetailView addSubview:bagNameLab];
    [bagNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locImg.mas_right).offset(10);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@(-UI_WIDTH/2));
    }];
    
    curlocationLabel = [UILabel new];
    curlocationLabel.text = self.model.bagName;
    curlocationLabel.numberOfLines = 0;
    curlocationLabel.textAlignment = NSTextAlignmentLeft;
    curlocationLabel.font = [UIFont systemFontOfSize:12];
    [bagsLocatinDetailView addSubview:curlocationLabel];
    [curlocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bagNameLab.mas_right);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
    }];
    curlocationLabel.text = OCSTR(@"当前经度:%f\n当前纬度:%f",self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    
    @weakify(self)
    [RACObserve(self, userLocation)subscribeNext:^(id x) {
        @strongify(self)
        curlocationLabel.text = OCSTR(@"当前经度:%f\n当前纬度:%f",self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    }];
    
    selCycleRadiuBtn = [UIButton new];
    selCycleRadiuBtn.backgroundColor = mainSchemeColor;
    selCycleRadiuBtn.alpha = .8;
    [self.view addSubview:selCycleRadiuBtn];
    [selCycleRadiuBtn setTitle:OCSTR(@"安全区域半径为:%dm",self.circleRadiu) forState:UIControlStateNormal];
    [selCycleRadiuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@44);
    }];
    [RACObserve(self, circleRadiu)subscribeNext:^(id x) {
        @strongify(self)
        [selCycleRadiuBtn setTitle:OCSTR(@"安全区域半径为:%dm",self.circleRadiu) forState:UIControlStateNormal];
    }];
    
    [selCycleRadiuBtn addTarget:self action:@selector(showRadiuSelect) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTools {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:L(@"save") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

#pragma mark - action

- (void)save {
    
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
        locationmanager.distanceFilter = 0.5f;
        
        [locationmanager requestAlwaysAuthorization];
        [locationmanager startUpdatingLocation];
        //        [locationmanager startUpdatingHeading];
    }
}

- (void)showRadiuSelect {
    @weakify(self);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * firstAction = [UIAlertAction actionWithTitle:@"1000m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.circleRadiu = 1000;
//        [self updateCycleOverlay:self.userLocation];
        [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
    }];
    UIAlertAction * secondAction = [UIAlertAction actionWithTitle:@"2000m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.circleRadiu = 2000;
//        [self updateCycleOverlay:self.userLocation];
        [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
    }];
    UIAlertAction * thirdAction = [UIAlertAction actionWithTitle:@"3000m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.circleRadiu = 3000;
//        [self updateCycleOverlay:self.userLocation];
        [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
    }];
    UIAlertAction * forthAction = [UIAlertAction actionWithTitle:@"4000m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.circleRadiu = 4000;
//        [self updateCycleOverlay:self.userLocation];
        [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
    }];
    UIAlertAction * fifthAction = [UIAlertAction actionWithTitle:@"5000m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.circleRadiu = 5000;
//        [self updateCycleOverlay:self.userLocation];
        [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:firstAction];[alert addAction:secondAction];
    [alert addAction:thirdAction];[alert addAction:forthAction];
    [alert addAction:fifthAction];[alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)updateCycleOverlay:(MKUserLocation *)userLocation {
    [self.mapView removeOverlay:self.circle];
    self.circle = nil;
    if (!self.circle) {
        self.circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) radius:_circleRadiu];
        [_mapView addOverlay:self.circle];
    }
}

#pragma mark - CLLocationManager

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
        //   arrowImageView.transform=CGAffineTransformMakeRotation(-angle);
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

// 覆盖物
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer=[[MKPolylineRenderer alloc]initWithOverlay:overlay];
        renderer.strokeColor=[[UIColor blueColor]colorWithAlphaComponent:0.5];
        renderer.lineWidth=5.0;
        return renderer;
    }else if([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer * render=[[MKCircleRenderer alloc]initWithCircle:overlay];
        render.lineWidth = .5;
        render.fillColor = [[UIColor redColor]colorWithAlphaComponent:.2];    //填充颜色
        render.strokeColor = [[UIColor redColor]colorWithAlphaComponent:0.5]; //线条颜色
        return render;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(userLocation.coordinate.latitude == 0.0f || userLocation.coordinate.longitude == 0.0f){
        return;
    }
    self.userLocation = userLocation;
    [self updateCycleOverlay:userLocation];
    
//    [self showCurrentLocationInfo:userLocation];
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
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,self.circleRadiu * 3, self.circleRadiu * 3);//以pos为中心，显示2000米
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self setMapRoutes];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"%@", placemarks[0]);
    }];
    
}


//- (void)showCurrentLocationInfo:(MKUserLocation *)location {
//    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    NSLog(@"%f\n%f",location.coordinate.latitude,location.coordinate.longitude);
//    
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
//        if (placemarks.count > 0){
//            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            //将获得的所有信息显示到label上
////            self.locationLabel.text = placemark.name;
//            //获取城市
//            NSString *city = placemark.locality;
//            if (!city) {
//                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                city = placemark.administrativeArea;
//            }
//            NSLog(@"city = %@", city);
////            self.locationLabel.text = city;
//            
//        }
//        else if (error == nil && [placemarks count] == 0)
//        {
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil)
//        {
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];
//}


//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
//    MKCircleRenderer * render=[[MKCircleRenderer alloc]initWithCircle:overlay];
//    render.lineWidth=3;    //填充颜色
//    render.fillColor=[UIColor greenColor];    //线条颜色
//    render.strokeColor=[UIColor redColor];
//    return render;
//}

@end
