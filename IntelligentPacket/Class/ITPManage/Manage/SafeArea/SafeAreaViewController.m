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
#import "ITPLocationViewModel.h"

#import "SearchResultTableVC.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface SafeAreaViewController () <CLLocationManagerDelegate,MKMapViewDelegate,AMapSearchDelegate> {
    CLLocationManager * locationmanager;
    
    NSMutableArray  *pointsArray;
    MKPolyline* routeLine;
    MKPolylineView* routeLineView;
    
    CLGeocoder *geocoder;
    //    NSString *plistPath;
    NSMutableArray *locationArray;
    
    UILabel * curlocationLabel;
    UIButton * selCycleRadiuBtn;
    UILabel * curlocationDesLabel;
    
    CLLocationCoordinate2D _touchMapCoordinate;
    
    UISearchController *_searchController;
    UITableView *_searchTableView;
    SearchResultTableVC *_searchResultTableVC;
    AMapSearchAPI *_searchAPI;  // 搜索API
    NSInteger searchPage;       // 搜索页数
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
    self.userLocation = [MKUserLocation new];
    self.circleRadiu = 1000;
    locationArray = [NSMutableArray array];
    pointsArray = [NSMutableArray array];
    
    geocoder = [[CLGeocoder alloc] init];
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;//支持缩放
    _mapView.delegate = self;
    if (!_model.lastLongitude || !_model.lastLatitude)
        _mapView .showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];
    
    [self initSearch];
    [self getBagsLocatinDetail];
    [self getCurPosition];
}

- (void)initSearch
{
    _searchResultTableVC = [[SearchResultTableVC alloc] init];
    _searchResultTableVC.delegate = (id)self;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    _searchController.searchResultsUpdater = (id)_searchResultTableVC;
    
//    int SearchBarStyle = 1;
//    switch (SearchBarStyle) {
//        case 0:  // 放在NavigationBar底部
//            [self.view addSubview:_searchController.searchBar];
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//            break;
//        case 1:  // 点击搜索按钮显示SearchBar
//            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
//            self.navigationItem.rightBarButtonItem = nil;
//            _searchController.searchBar.delegate = (id)self;
//            break;
//        case 2:  // 放在NavigationBar内部
//            _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//            _searchController.hidesNavigationBarDuringPresentation = NO;
//            self.navigationItem.titleView = _searchController.searchBar;
//            self.definesPresentationContext = YES;
//        default:
//            break;
//    }
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
        make.height.equalTo(@(64));
    }];
    
    
    UIImageView * locImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位_P"]];
    [bagsLocatinDetailView addSubview:locImg];
    [locImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(@-10);
    }];
    UILabel * bagNameLab = [UILabel new];
    bagNameLab.text = self.model.bagName;
//    bagNameLab.backgroundColor = [UIColor redColor];
    [bagsLocatinDetailView addSubview:bagNameLab];
    [bagNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locImg.mas_right).offset(10);
        make.top.equalTo(@0);
        make.bottom.equalTo(@-20);
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
        make.bottom.equalTo(@-20);
        make.right.equalTo(@0);
    }];
    curlocationLabel.text = OCSTR(@"%@:%f\n%@:%f",L(@"current longitude"), self.userLocation.coordinate.latitude, L(@"current latitude"), self.userLocation.coordinate.longitude);
    
    @weakify(self)
    [RACObserve(self, userLocation)subscribeNext:^(id x) {
        @strongify(self)
        curlocationLabel.text = OCSTR(@"%@:%f\n%@:%f",L(@"current longitude"), self.userLocation.coordinate.latitude, L(@"current latitude"), self.userLocation.coordinate.longitude);
    }];
    
    curlocationDesLabel = [UILabel new];
    curlocationDesLabel.text = self.model.bagName;
    curlocationDesLabel.numberOfLines = 0;
    curlocationDesLabel.textAlignment = NSTextAlignmentLeft;
    curlocationDesLabel.font = [UIFont systemFontOfSize:15];
    [bagsLocatinDetailView addSubview:curlocationDesLabel];
    [curlocationDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.height.equalTo(@20);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
    }];
    curlocationDesLabel.text = OCSTR(@"%@%@",L(@"current Location:"), L(@"get in..."));
    
    [RACObserve(self, userLocation)subscribeNext:^(id x) {
        @strongify(self)
        curlocationDesLabel.text = OCSTR(@"%@%@",L(@"current Location:"), L(@"get in..."));
    }];

    
    selCycleRadiuBtn = [UIButton new];
    selCycleRadiuBtn.backgroundColor = mainSchemeColor;
    selCycleRadiuBtn.alpha = .8;
    [self.view addSubview:selCycleRadiuBtn];
    [selCycleRadiuBtn setTitle:OCSTR(@"%@:%dm",L(@"Safe zone radius"),self.circleRadiu) forState:UIControlStateNormal];
    [selCycleRadiuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@44);
    }];
    [RACObserve(self, circleRadiu)subscribeNext:^(id x) {
        @strongify(self)
        [selCycleRadiuBtn setTitle:OCSTR(@"%@:%dm",L(@"Safe zone radius"),self.circleRadiu) forState:UIControlStateNormal];
    }];
    
    [selCycleRadiuBtn addTarget:self action:@selector(showRadiuSelect) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTools {
    
    UIBarButtonItem * save = [[UIBarButtonItem alloc] initWithTitle:L(@"save") style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];;
    
    UIBarButtonItem * search = [[UIBarButtonItem alloc] initWithTitle:L(@"search") style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItems = @[search, save];

}

#pragma mark - action

- (void)searchAction {
    
    _searchController.searchBar.showsCancelButton = YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    [self presentViewController:_searchController animated:YES completion:^{
        
    }];
//    [self.navigationController.navigationBar addSubview:_searchController.searchBar];
    
}

- (void)saveAction {
    
    //转为地球坐标 提交
    CLLocationCoordinate2D coordinate = [self earthFromMars:self.userLocation];
    
    [[ITPScoketManager shareInstance] setSafeRegion:[ITPUserManager ShareInstanceOne].userEmail bagId:self.model.bagId longitude:OCSTR(@"%f",coordinate.longitude) latitude:OCSTR(@"%f",coordinate.latitude) radius:OCSTR(@"%d",self.circleRadiu) withTimeout:10 tag:112 success:^(NSData *data, long tag) {
        
        [self performBlock:^{
            
            BOOL abool = [ITPLocationViewModel isSuccesss:data];
            if (abool) {
                [self showAlert:L(@"Add success") WithDelay:1.2];
                [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketAddSafebags object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketAddbags object:nil];
            }
            
        } afterDelay:.1];
        
    } faillure:^(NSError *error) {
        [self performBlock:^{
            
            [self showAlert:L(@"Add failure") WithDelay:1.2];
            
        } afterDelay:.1];
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
        locationmanager.delegate = self;
        locationmanager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationmanager.distanceFilter = 50;
        
        [locationmanager requestAlwaysAuthorization];
        [locationmanager startUpdatingLocation];
//                [locationmanager startUpdatingHeading];
    }
}

// 停止地位
- (void) stopLoaction {
    [locationmanager stopUpdatingLocation];
}

- (void)updateCycleOverlay:(MKUserLocation *)userLocation {
    [self.mapView removeOverlay:self.circle];self.circle = nil;
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

// 定位机制 根据你的设置来刷新定位信息  交互到map map做出相应的反应
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if ((_model.safeLongitude.intValue != 0 &&  _model.safeLatitude.intValue != 0) || !_model.safeRadius) { // 手动显示  存在安全栏
        
        CLLocationCoordinate2D pos ;
        pos.longitude = _model.safeLatitude.doubleValue; pos.latitude = _model.safeLongitude.doubleValue;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,_model.safeRadius.longLongValue, _model.safeRadius.longLongValue);//以pos为中心，显示2000米
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
        
        [_mapView setRegion:adjustedRegion animated:YES];
        
        self.circleRadiu = (int)_model.safeRadius.longLongValue;
        self.userLocation.coordinate = pos;
        self.userLocation.coordinate = [self marsFromEarth:self.userLocation];
        [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
        [self showAnnotationInMapView:self.userLocation];
        [self showCurrentLocationInfo:self.userLocation];
        
        
    }else if (!_model.lastLongitude || !_model.lastLatitude) {              // 走用户定位
        CLLocation *location=[locations firstObject];//取出第一个位置
        
        CLLocationCoordinate2D pos = location.coordinate;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,1000, 1000);//以pos为中心，显示2000米
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
        
        [_mapView setRegion:adjustedRegion animated:YES];
        
    } else {                                                                // 手动显示 以最后的停留地点为起始点
        
        CLLocationCoordinate2D pos ;
        pos.longitude = _model.lastLatitude.doubleValue; pos.latitude = _model.lastLongitude.doubleValue;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,1000, 1000);//以pos为中心，显示2000米
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
        
        [_mapView setRegion:adjustedRegion animated:YES];
        
        self.userLocation.coordinate = pos;
        self.userLocation.coordinate = [self marsFromEarth:self.userLocation];
        [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
        [self showAnnotationInMapView:self.userLocation];
        [self showCurrentLocationInfo:self.userLocation];
    }
    
    
}

#pragma mark - mapview delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
//     If the annotation is the user location, just return nil.
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPointAnnotation"];
        aView.image = [UIImage imageNamed:@"ico_bag"];
        aView.frame =  CGRectMake(0, 0, 25, 33);
        aView.canShowCallout = YES;
        
        return aView;
    }
    return nil;
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

// 更新用户位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(userLocation.coordinate.latitude == 0.0f || userLocation.coordinate.longitude == 0.0f){
        return;
    }
    self.userLocation = userLocation;
    [self updateCycleOverlay:userLocation];
    
    [self showCurrentLocationInfo:userLocation];
    [pointsArray addObject:userLocation];
    
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc]init];
    [locationDic setValue:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] forKey:@"longitude"];
    [locationDic setValue:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] forKey:@"latitude"];
    
    [locationArray addObject:locationDic];
    
    
    CLLocationCoordinate2D pos = userLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,self.circleRadiu * 2.5, self.circleRadiu * 2.5);//以pos为中心，显示2000米
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self setMapRoutes];
}

#pragma mark - SearchResultTableVCDelegate
- (void)setSelectedLocationWithLocation:(AMapPOI *)poi {
    CLLocationCoordinate2D pos ;
    pos.longitude = poi.location.longitude; pos.latitude = poi.location.latitude;
    self.userLocation.coordinate = pos;
//    self.userLocation.coordinate = [self earthFromMars:self.userLocation];
    [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
    [self showAnnotationInMapView:self.userLocation];
    [self showCurrentLocationInfo:self.userLocation];
    
}

#pragma mark - // 显示大头针
- (void)showAnnotationInMapView:(MKUserLocation *)userLocation {
    
    if (_mapView.annotations.count > 0) {
        [_mapView removeAnnotations:_mapView.annotations];
    }
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:userLocation.coordinate];
    [_mapView addAnnotation:annotation];
    
//    [self showCurrentLocationInfo:userLocation];
}

#pragma mark - // 反地理编码
- (void)showCurrentLocationInfo:(MKUserLocation *)location {
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    NSLog(@"%f\n%f",location.coordinate.latitude,location.coordinate.longitude);
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        if (error||placemarks.count == 0) {
            curlocationDesLabel.text = L(@"the address you entered was not found, possibly on the moon");
        }else//编码成功
        {
            //显示最前面的地标信息
            CLPlacemark *placemark = [placemarks firstObject];
            curlocationDesLabel.text=placemark.name;
            
            // 拆分位置
            //            NSString *locationString = [NSString stringWithFormat:@"%@%@%@%@",([[placemark addressDictionary] objectForKey:@"City"] == nil?@"":[[placemark addressDictionary] objectForKey:@"City"]),([[placemark addressDictionary] objectForKey:@"SubLocality"] == nil?@"":[[placemark addressDictionary] objectForKey:@"SubLocality"]),([[placemark addressDictionary] objectForKey:@"Thoroughfare"] == nil?@"":[[placemark addressDictionary] objectForKey:@"Thoroughfare"]), ([[placemark addressDictionary] objectForKey:@"subThoroughfare"] == nil?@"":[[placemark addressDictionary] objectForKey:@"subThoroughfare"])];
            //经纬度
            //            CLLocationDegrees latitude=firstPlacemark.location.coordinate.latitude;
            //            CLLocationDegrees longitude=firstPlacemark.location.coordinate.longitude;
        }
    }];
}

//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
//    MKCircleRenderer * render=[[MKCircleRenderer alloc]initWithCircle:overlay];
//    render.lineWidth=3;    //填充颜色
//    render.fillColor=[UIColor greenColor];    //线条颜色
//    render.strokeColor=[UIColor redColor];
//    return render;
//}

#pragma mark - touches ....

// 触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

//    self.userLocation.coordinate = _mapView.centerCoordinate;
//    [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
//    [self showAnnotationInMapView:self.userLocation];
//
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    currentTimeSamp = CFAbsoluteTimeGetCurrent();
//    if (currentTimeSamp - previousTimeSamp < 1) {
//        return;
//    }
//    previousTimeSamp = currentTimeSamp;
//    
//    self.userLocation.coordinate = _mapView.centerCoordinate;
//    [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
//    [self showAnnotationInMapView:self.userLocation];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

// 点击

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    self.userLocation.coordinate = touchMapCoordinate;
    [self mapView:self.mapView didUpdateUserLocation:self.userLocation];
    [self showAnnotationInMapView:self.userLocation];
    [self showCurrentLocationInfo:self.userLocation];
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

#pragma mark 地理编码
-(void)location{
    //根据“北京市”进行地理编码
    [geocoder geocodeAddressString:@"北京市" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkplacemark=[[MKPlacemark alloc]initWithPlacemark:clPlacemark];//定位地标转化为地图的地标
        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
        MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:mkplacemark];
        [mapItem openInMapsWithLaunchOptions:options];
    }];
}

@end
