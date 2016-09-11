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
#import "NetServiceApi.h"
#import "SafeBagListViewController.h"

@interface ITPManageVC ()<UITableViewDelegate, UITableViewDataSource>
{

    UISwitch * __languageSwitch;
    ITPManageCell * headerCell ;
    NetServiceApi * __api;
    UIImageView * headerImageView;
    
    BOOL isEnglish;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton * loginOutButton;

@end

@implementation ITPManageVC

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __languageSwitch.on = ![[ITPLanguageManager sharedInstance]isChinese];
    isEnglish = ![[ITPLanguageManager sharedInstance]isChinese];
    [self refreshHeadimage];
    
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
        
        [self performBlock:^{
            [self refresh:[x boolValue]];
        } afterDelay:.1];
        
    }];
    
}

- (void)refresh:(BOOL )abool {
    
    [[ITPScoketManager shareInstance]loginWith:[ITPUserManager ShareInstanceOne].userEmail password:[ITPUserManager ShareInstanceOne].userPassword withTimeout:10 tag:108 result:^(NSData *data, long tag, NSError *error) {
        __languageSwitch.on = abool;
        if (error) {
            __languageSwitch.on = !abool; return ;
        }
        
        if (abool) {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:refreshLangugeNotification object:nil];
    }];
   
}

#pragma mark - action

- (void)refreshLanguge {
    
    [self.tableView reloadData];
    self.title = L(@"Manage");
    [_loginOutButton setTitle:L(@"Sign out") forState:UIControlStateNormal];
}


- (void)showLanguage {

    @weakify(self);
    isEnglish = ![[ITPLanguageManager sharedInstance]isChinese];
    
    UIButton * backWindowGoundView = [[UIButton alloc]initWithFrame:[[UIApplication sharedApplication].delegate window].bounds];
    backWindowGoundView.backgroundColor = [UIColor blackColor];
    backWindowGoundView.alpha = 0.4;
    [[[UIApplication sharedApplication].delegate window] addSubview:backWindowGoundView];
   
    UIView * backGoundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH - 40, 300)];
    backGoundView.backgroundColor = [UIColor whiteColor];
    backGoundView.alpha = 1;
    backGoundView.center = [[UIApplication sharedApplication].delegate window].center;
    [[[UIApplication sharedApplication].delegate window] addSubview:backGoundView];
    
   
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backGoundView.width, 50)];
    titleLabel.text = L(@"Select Language");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backGoundView addSubview:titleLabel];
    
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, backGoundView.width, 0.5)];
    topLine.backgroundColor = RGB(210, 210, 210);
    [backGoundView addSubview:topLine];
    
    // 中文
    UIButton * ChineseCtl = [[UIButton alloc]initWithFrame:CGRectMake(0, topLine.bottom, backGoundView.width, 65)];
    ChineseCtl.backgroundColor = RGB(230, 230, 230);
    [backGoundView addSubview:ChineseCtl];
    UIImageView * indictorOne = [[UIImageView alloc]initWithFrame:CGRectMake(30, (ChineseCtl.height - 25)/2, 25, 25)];
    indictorOne.image = [UIImage imageNamed:@"select"];
    [ChineseCtl addSubview:indictorOne];
    UILabel * ChineseLable = [[UILabel alloc]initWithFrame:CGRectMake(indictorOne.right + 20, 0, backGoundView.width - (indictorOne.right + 20), ChineseCtl.height)];
    ChineseLable.text = @"中文";
    ChineseLable.font = [UIFont systemFontOfSize:16];
    [ChineseCtl addSubview:ChineseLable];
    
    
    UIView * middleLine = [[UIView alloc]initWithFrame:CGRectMake(0, ChineseCtl.bottom, backGoundView.width, 0.5)];
    middleLine.backgroundColor = RGB(210, 210, 210);
    [backGoundView addSubview:middleLine];
    
    // English
    UIButton * EnglishCtl = [[UIButton alloc]initWithFrame:CGRectMake(0, middleLine.bottom, backGoundView.width, 65)];
    EnglishCtl.backgroundColor = RGB(230, 230, 230);
    [backGoundView addSubview:EnglishCtl];
    UIImageView * indictorTwo = [[UIImageView alloc]initWithFrame:CGRectMake(30, (EnglishCtl.height - 25)/2, 25, 25)];
    indictorTwo.image = [UIImage imageNamed:@"select"];
    [EnglishCtl addSubview:indictorTwo];
    UILabel * EnglishLable = [[UILabel alloc]initWithFrame:CGRectMake(indictorTwo.right + 20, 0, backGoundView.width - (indictorTwo.right + 20), EnglishCtl.height)];
    EnglishLable.text = @"English";
    EnglishLable.font = [UIFont systemFontOfSize:16];
    [EnglishCtl addSubview:EnglishLable];
    
    
    ChineseCtl.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        indictorOne.hidden = NO;
        indictorTwo.hidden = YES;
        isEnglish = NO;
        return [RACSignal empty];
    }];
    
    EnglishCtl.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        indictorTwo.hidden = NO;
        indictorOne.hidden = YES;
        isEnglish = YES;
        return [RACSignal empty];
    }];
    
    if (isEnglish) {
        indictorTwo.hidden = NO;
        indictorOne.hidden = YES;
    }
    else {
        indictorOne.hidden = NO;
        indictorTwo.hidden = YES;   
    }
    
    UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, EnglishCtl.bottom, backGoundView.width, 0.5)];
    bottomLine.backgroundColor = RGB(210, 210, 210);
    [backGoundView addSubview:bottomLine];
    
    UIButton * cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, bottomLine.bottom, backGoundView.width/2-.25, 50)];
    [cancleButton setTitle:L(@"Cancel") forState:UIControlStateNormal];
    [backGoundView addSubview:cancleButton];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [backWindowGoundView removeFromSuperview];
        [backGoundView removeFromSuperview];
        return [RACSignal empty];
    }];
    
    UIView * hLine = [[UIView alloc]initWithFrame:CGRectMake(cancleButton.right, bottomLine.bottom, .5, cancleButton.height)];
    hLine.backgroundColor = RGB(210, 210, 210);
    [backGoundView addSubview:hLine];
    
    UIButton * okButton = [[UIButton alloc]initWithFrame:CGRectMake(backGoundView.width/2+.25, bottomLine.bottom, backGoundView.width/2-.25, 50)];
    [okButton setTitle:L(@"OK") forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backGoundView addSubview:okButton];
    okButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [backWindowGoundView removeFromSuperview];
        [backGoundView removeFromSuperview];
        
        [self performBlock:^{
            [self refresh:isEnglish];
        } afterDelay:.1];

        return [RACSignal empty];
    }];
    
    backWindowGoundView.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [backWindowGoundView removeFromSuperview];
        [backGoundView removeFromSuperview];
        return [RACSignal empty];
    }];
    
    backGoundView.height = cancleButton.bottom;
    backGoundView.center = [[UIApplication sharedApplication].delegate window].center;
    
    [UIView animateWithDuration:1 animations:^{
        [[[UIApplication sharedApplication].delegate window] addSubview:backWindowGoundView];
        [[[UIApplication sharedApplication].delegate window] addSubview:backGoundView];
    }];
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
        [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketAddbags object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketRefreshAddSafebags object:nil];
        
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
        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:[ITPUserManager ShareInstanceOne].userheardStr] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        headerImageView = cell.headerImage;
        headerImageView.layer.cornerRadius = headerImageView.width/2;
        headerImageView.layer.masksToBounds = YES;
        
        cell.nickName.text = [ITPUserManager ShareInstanceOne].userName;
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
            cell.accessoryView = nil;//__languageSwitch;
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
            vc.title = L(@"User information");
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
            SafeBagListViewController * vc = [SafeBagListViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = title;   vc.isSafebagList = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4:
        {
            [self showLanguage];
        }
            break;
        case 5:
        {   
            FeedBackViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"feedback"];
            vc.title = title;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)refreshHeadimage {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@uid=%@", GetHearPortain, [ITPUserManager ShareInstanceOne].userEmail] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){
         
     }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"%@", responseObject);
         NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         
         if ([[ITPUserManager ShareInstanceOne].userheardStr isEqualToString:str]) return ;
         
         [ITPUserManager ShareInstanceOne].userheardStr = str;
         [headerImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@", error.description);
      
     }];
}


@end
