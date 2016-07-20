//
//  ITPLocationHistoryVC.m
//  IntelligentPacket
//
//  Created by 忘、 on 16/7/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPLocationHistoryVC.h"
#import "KMCalendar.h"

@interface ITPLocationHistoryVC ()<KMCalendarDelegate> {
    MKMapView *mapView;
    
    KMCalendar *calendar;
}

@end

@implementation ITPLocationHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史轨迹";
    
    calendar = [[KMCalendar alloc] initWithOrigin:CGPointMake(0.f, 64.f)
                                       recordDateArray:nil
                                        andResizeBlock:^{
                                            // do UI Resize
                                            
                                        }];
    calendar.delegate = self;
    [self.view addSubview:calendar];

    
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - KMCalendarDelegate

- (void)calendarSelectedDate:(NSDate *)date {
    KMLog(@"%@", date);
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
