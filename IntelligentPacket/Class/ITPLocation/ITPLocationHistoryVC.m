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
    
    UILabel *dateLabel;
    UIImageView *arrowImageView;
    
    
    NSDate *historyDate;
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
    
    calendar = [[KMCalendar alloc] initWithOrigin:CGPointMake(0.f, 104.f)
                                       recordDateArray:nil
                                        andResizeBlock:^{
                                            // do UI Resize
                                            
                                        }];
    calendar.delegate = self;
    [self.view addSubview:calendar];

    // Do any additional setup after loading the view.
}

- (void)preDayAction:(UIButton *)button {
  
}

- (void)nextDayAction:(UIButton *)button {
    
}

- (void)showCalender:(UIButton *)button {

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
