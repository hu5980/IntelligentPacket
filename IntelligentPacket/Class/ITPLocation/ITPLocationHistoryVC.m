//
//  ITPLocationHistoryVC.m
//  IntelligentPacket
//
//  Created by 忘、 on 16/7/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPLocationHistoryVC.h"
#import "KMCalendar.h"
#import "ITPScoketManager.h"
#import "ITPLocationHistoryViewModel.h"
#import "MBProgressHUD.h"
@interface ITPLocationHistoryVC ()<KMCalendarDelegate,MKMapViewDelegate> {
    MKMapView *mapView;
    KMCalendar *calendar;
    UILabel *dateLabel;
    UIImageView *arrowImageView;
    NSDate *historyDate;
    
    NSString *startDate;
    NSString *endDate;
    
    NSMutableArray *pointsArray;
    MKPolyline* routeLine;
    MKPolylineView* routeLineView;
    
//    MBProgressHUD *hud;

}

@end

@implementation ITPLocationHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史轨迹";
    
    historyDate =[NSDate date];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, XKAppWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15, (40-30)/2, 80, 30);
    leftButton.layer.cornerRadius = 5;
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.borderColor = [UIColor colorFromHexString:@"#999999"].CGColor;
    leftButton.layer.borderWidth = 0.5;
    [leftButton setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = XKDefaultFontWithSize(14.f);
    [leftButton addTarget:self action:@selector(preDayAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"前一天" forState:UIControlStateNormal];
    [view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(XKAppWidth -15-80, (40-30)/2, 80, 30);
    rightButton.layer.cornerRadius = 5;
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.borderColor = [UIColor colorFromHexString:@"#999999"].CGColor;
    [rightButton setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    rightButton.layer.borderWidth = 0.5;
    rightButton.titleLabel.font = XKDefaultFontWithSize(14.f);
    [rightButton addTarget:self action:@selector(nextDayAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"后一天" forState:UIControlStateNormal];
    [view addSubview:rightButton];
    
    [self.view addSubview:view];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 104, XKAppWidth, XKAppHeight - 104)];
    mapView.mapType = MKMapTypeStandard;
    mapView.zoomEnabled = YES;//支持缩放
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake((XKAppWidth-105)/2, 0, 105, 40);
    [dateButton addTarget:self action:@selector(showCalender:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:dateButton];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    dateLabel.font = XKDefaultFontWithSize(14);
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor= [UIColor colorFromHexString:@"#666666"];
    dateLabel.text = @"今天";
    [dateButton addSubview:dateLabel];
    
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, (40-10)/2, 15, 10)];
    arrowImageView.image = [UIImage imageNamed:@"向上"];
    [dateButton addSubview:arrowImageView];
    
    calendar = [[KMCalendar alloc] initWithOrigin:CGPointMake(0.f, -204.f)
                                       recordDateArray:nil
                                        andResizeBlock:^{
                                            // do UI Resize
                                            
                                        }];
    calendar.delegate = self;
    [self.view addSubview:calendar];
    
    
    [self getDataFromNetwork];
    
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
    

    // Do any additional setup after loading the view.
}

- (void)preDayAction:(UIButton *)button {
    historyDate = [KMCalendarHelper getPrevisionDate:historyDate];
    dateLabel.text = [historyDate dateFormate:@"yyyy-MM-dd"];
    [self getDataFromNetwork];
}

- (void)nextDayAction:(UIButton *)button {
    historyDate = [KMCalendarHelper getNextDate:historyDate];
    dateLabel.text = [historyDate dateFormate:@"yyyy-MM-dd"];
    [self getDataFromNetwork];
}

- (void)showCalender:(UIButton *)button {
    if (calendar.origin.y == -204) {
        [UIView animateWithDuration:0.5 animations:^{
            calendar.origin = CGPointMake(0, 104);
        }];
        arrowImageView.image = [UIImage imageNamed:@"向下"];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            calendar.origin = CGPointMake(0, -204);
        }];
        arrowImageView.image = [UIImage imageNamed:@"向上"];
    }
}


- (void)getDataFromNetwork {
    
    if (!self.model) {
        return;
    }
   
    if ([KMCalendarHelper compareDateIsToday:historyDate]) {
        startDate = [[KMCalendarHelper beginingOfDate:[NSDate date]] dateFormate:@"yyyy-MM-dd HH:mm:ss"];
        endDate = [[NSDate date] dateFormate:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        startDate = [[KMCalendarHelper beginingOfDate:historyDate] dateFormate:@"yyyy-MM-dd HH:mm:ss"];
        endDate = [[KMCalendarHelper endingOfDate:historyDate] dateFormate:@"yyyy-MM-dd HH:mm:ss"];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ITPScoketManager shareInstance] getHistoryRecordWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:_model.bagId startDate:startDate endDate:endDate withTimeout:10 tag:112 success:^(NSData *data, long tag) {
        
         dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         });
        
        BOOL success = [ITPLocationHistoryViewModel isSuccesss:data];
        if (success) {
            pointsArray =  [ITPLocationHistoryViewModel getLocationData:data];
            if(pointsArray .count > 0){
                MKUserLocation *userLocation =[pointsArray objectAtIndex:0];
                CLLocationCoordinate2D pos = userLocation.coordinate;
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pos,1000, 1000);//以pos为中心，显示2000米
                MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];//适配map view的尺寸
                [mapView setRegion:adjustedRegion animated:YES];
                
                [self setMapRoutes];
            }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self showAlert:@"获取数据失败" WithDelay:1];

            });
        }
        
    } faillure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
      
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
        
    }];
    
   
}


- (void)showAlert:(NSString *)message WithDelay:(NSTimeInterval)d
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeCustomView;
//    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:d];
}

#pragma mark - KMCalendarDelegate

- (void)calendarSelectedDate:(NSDate *)date {
    if ([KMCalendarHelper compareDateIsToday:date]) {
        historyDate = [NSDate date];
    }else{
        historyDate = date;
    }
    dateLabel.text = [historyDate dateFormate:@"yyyy-MM-dd"];
    [self getDataFromNetwork];
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
        [mapView removeOverlay:routeLine];
    }
    
    routeLine = [MKPolyline polylineWithPoints:pointArray count:pointsArray.count];
    if (nil != routeLine) {
        [mapView addOverlay:routeLine];
    }
    
    free(pointArray);
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer=[[MKPolylineRenderer alloc]initWithOverlay:overlay];
        renderer.strokeColor=[[UIColor blueColor]colorWithAlphaComponent:0.5];
        renderer.lineWidth=5;
        return renderer;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
