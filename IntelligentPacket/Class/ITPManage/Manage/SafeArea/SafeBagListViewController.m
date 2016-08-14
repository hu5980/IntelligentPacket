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


@interface SafeBagListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<ITPPacketBagModel *> *dataSource;

@end

@implementation SafeBagListViewController

- (void)refreshLanguge {
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    __languageSwitch.on = ![[ITPLanguageManager sharedInstance]isChinese];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTools];
    [self loaddata];
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

-(void)loaddata {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[ITPScoketManager shareInstance]bagListWithTimeout:10 tag:106 success:^(NSData *data, long tag) {
        @strongify(self);
        if (tag != 106) {
            return ;
        }
        BOOL abool = [ITPBagViewModel isSuccesss:data];
        if (abool) {
            
            [self performBlock:^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.dataSource = [ITPBagViewModel managerBags:data];
                [self.tableView reloadData];
                NSLog(@"%@", self.dataSource);
                
            } afterDelay:0.1];
            
        }else {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showAlert:@"获取数据失败" WithDelay:1];
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

    cell.textLabel.text = self.dataSource[indexPath.row].bagName;
    
    if (self.dataSource[indexPath.row].bagType == 1) {
        [cell.imageView setImage:[UIImage imageNamed:@"组-2"]];
    }else {
        [cell.imageView setImage:[UIImage imageNamed:@"组-1"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SafeAreaViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"safearea"];
    vc.title = L(@"Set Safe area");
    vc.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
