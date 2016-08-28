//
//  SafeBagListViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/30.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "SafeBagListViewController.h"
#import "ITPBagViewModel.h"
#import "SafeAreaViewController.h"
#import "ITPLocationViewModel.h"

@interface SafeBagListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<ITPPacketBagModel *> *dataSource;

@end

@implementation SafeBagListViewController

- (void)refreshLanguge {
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loaddata];
    [self.tableView reloadData];
    //    __languageSwitch.on = ![[ITPLanguageManager sharedInstance]isChinese];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTools];
    [self loaddata];
    
    @weakify(self) //刷新全局的数据
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:ITPacketAddSafebags object:nil]subscribeNext:^(id x) {
        
        @strongify(self)
        [self loadNetdata];
        
    }];
}

- (void)loaddata {
    if (self.isSafebagList) {  // 从全局拿数据
        self.dataSource = [DataSingleManager sharedInstance].safeBags;
    }else self.dataSource = [DataSingleManager sharedInstance].noneSafeBags;
}

- (void)setupTools {
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"safeAreaCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(edit)];
}

#pragma mark - action

-(void)loadNetdata {
    
    @weakify(self);
    [[ITPScoketManager shareInstance]bagListWithTimeout:10 tag:106 success:^(NSData *data, long tag) {
        @strongify(self);
        if (tag != 106) {
            return ;
        }
        BOOL abool = [ITPBagViewModel isSuccesss:data];
        if (abool) {
            
            [self performBlock:^{
                
                [DataSingleManager sharedInstance].bags = [ITPBagViewModel managerBags:data];
                [self loaddata];
                [self.tableView reloadData];
                
            } afterDelay:0.1];
            
        }else {
            
        }
        
    } faillure:^(NSError *error) {
        
        if (error) {
            [self performBlock:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } afterDelay:.1];
        }
        
    }];
    
}

- (void)edit {
    SafeBagListViewController * vc = [SafeBagListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = L(@"No security zone set");   vc.isSafebagList = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - // 反地理编码
- (void)showCurrent:(UILabel *)label LocationInfo:(ITPPacketBagModel *)model {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:model.safeLongitude.doubleValue longitude:model.safeLatitude.doubleValue];
    NSLog(@"%f\n%f",location.coordinate.latitude,location.coordinate.longitude);
    
    CLLocation * newlocation = [location locationMarsFromEarth];
    
    //根据经纬度反向地理编译出地址信息
    [[CLGeocoder new] reverseGeocodeLocation:newlocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        if (error||placemarks.count == 0) {
            label.text = OCSTR(@"%@\n%@", model.bagName, L(@"the address you entered was not found, possibly on the moon"));
        }else//编码成功
        {
            //显示最前面的地标信息
            CLPlacemark *placemark = [placemarks firstObject];
            label.text = OCSTR(@"%@\n%@", model.bagName, placemark.name);
        }
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"safeAreaCell"];
    
//    cell.indexPath_ = (int)indexPath.row;
//    cell.bagName.text = self.dataSource[indexPath.row].bagName;
//    cell.bagNum.text = self.dataSource[indexPath.row].bagPhoneNum;

    if (self.isSafebagList) {
        cell.textLabel.text = L(@"get in...");
        [self showCurrent:cell.textLabel LocationInfo:self.dataSource[indexPath.row]];
    }else {
        cell.textLabel.text = self.dataSource[indexPath.row].bagName;
    }
    cell.textLabel.numberOfLines = 0;
    
    if (self.dataSource[indexPath.row].bagType == 1) {
        [cell.imageView setImage:[UIImage imageNamed:@"组-2"]];
    }else {
        [cell.imageView setImage:[UIImage imageNamed:@"组-1"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!self.isSafebagList) {
        SafeAreaViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"safearea"];
        vc.title = L(@"Set Safe area");
        vc.model = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isSafebagList) {
        return NO;
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self)
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:L(@"edit") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        tableView.editing = NO;
        
        
        SafeAreaViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"safearea"];
        vc.title = L(@"Set Safe area");
        vc.model = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:L(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
         @strongify(self)
        
        [self deleteAction:indexPath];
    }];
    
    return @[deleteAction, editAction];
}

- (void)deleteAction:(NSIndexPath *)indexPath {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[ITPScoketManager shareInstance] setSafeRegion:[ITPUserManager ShareInstanceOne].userEmail bagId:self.dataSource[indexPath.row].bagId longitude:OCSTR(@"%d",0) latitude:OCSTR(@"%d",0) radius:OCSTR(@"%d",0) withTimeout:10 tag:112 success:^(NSData *data, long tag) {
        @strongify(self);
        [self performBlock:^{
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            BOOL abool = [ITPLocationViewModel isSuccesss:data];
            if (abool) {
                [self showAlert:L(@"delete success") WithDelay:1.2];
                [self loadNetdata];
            }
            
        } afterDelay:.1];
        
    } faillure:^(NSError *error) {
        [self performBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:L(@"delete failure") WithDelay:1.2];
            
        } afterDelay:.1];
    }];

}

- (void)dealloc {

}

@end
