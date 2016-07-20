//
//  ITPManageVC.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPManageVC.h"
#import "ITPContactViewController.h"
#import "ITPAddBabWithIDViewController.h"
#import "SafeAreaViewController.h"
#import "FeedBackViewController.h"
#import "ITPManageCell.h"
#import "ITPHeadAndNameViewController.h"

@interface ITPManageVC ()<UITableViewDelegate, UITableViewDataSource>
{

    UISwitch * __languageSwitch;
    ITPManageCell * headerCell ;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton * loginOutButton;

@end

@implementation ITPManageVC

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __languageSwitch.on = ![[ITPLanguageManager sharedInstance]isChinese];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTable];
}

- (void)configTable {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = viewColor;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }else [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"ITPManageCell" bundle:nil] forCellReuseIdentifier:@"ITPManageCell"];

    
    __languageSwitch = [UISwitch new];
    __languageSwitch.thumbTintColor = [UIColor redColor];

    @weakify(self)
    [__languageSwitch.rac_newOnChannel subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
            
        }else {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performBlock:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:refreshLangugeNotification object:nil];
        } afterDelay:.1];
        
    }];
    
}

#pragma mark - action

- (void)refreshLanguge {
    
    [self.tableView reloadData];
    self.title = L(@"Manage");
    [_loginOutButton setTitle:L(@"Sign out") forState:UIControlStateNormal];
}


#pragma mark - UITableViewDelegate
const int manageDataCount___ = 5;
NSString * manageData[manageDataCount___] = {
    @"contacts",
    @"Add bags",
    @"Safe area",
    @"Language selection",
    @"Complaints and suggestions"
};

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * backgroudView = [UIView new];
    backgroudView.frame = (CGRect){0, 0, UI_WIDTH, 110};
    backgroudView.backgroundColor  = viewColor;
    UIView * topline = [UIView new];
    [backgroudView addSubview:topline];
    topline.backgroundColor = [UIColor lightGrayColor];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    _loginOutButton = ({
        UIButton * loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
        loginOut.backgroundColor  = [UIColor whiteColor];
        [loginOut setTitle:L(@"Sign out") forState:UIControlStateNormal];
        [loginOut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        loginOut;
    });
   
    [backgroudView addSubview:_loginOutButton];
    
    
    @weakify(backgroudView)
    [_loginOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(backgroudView)
        make.left.equalTo(@15);
        make.centerY.equalTo(backgroudView.mas_centerY);
        make.right.equalTo(@-15);
        make.height.equalTo(@44);
    }];
    
    _loginOutButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        [ITPUserManager ShareInstanceOne].userEmail = nil;
//        [[ITPScoketManager shareInstance] disConnect];
        return [RACSignal empty];
    }];
    
    return backgroudView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return manageDataCount___+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }else return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        ITPManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITPManageCell"];
        cell.headerImage.image = [UIImage imageNamed:@"已注册商标"];
        
        cell.nickName.text = @"Seth Chen";
        UIImageView  * arrow  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"展开去到"]];
        cell.accessoryView = arrow;

        return cell;
    }else {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell  = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"UITableViewCell"];
        }
        
        cell.textLabel.text = L(manageData[indexPath.row-1]);
        
        if (indexPath.row == 4) {
            cell.accessoryView = __languageSwitch;
        }else {
            UIImageView  * arrow  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"展开去到"]];
            cell.accessoryView = arrow;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = L(manageData[indexPath.row - 1]);
    
    switch (indexPath.row) {
        case 0:
        {
            
            ITPHeadAndNameViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"headername"];
            vc.title = L(@"Head and nickname");
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
        
            ITPContactViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contacts"];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            
            ITPAddBabWithIDViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addbagwithid"];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            SafeAreaViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"safearea"];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 5:
        {   
            FeedBackViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"feedback"];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


@end