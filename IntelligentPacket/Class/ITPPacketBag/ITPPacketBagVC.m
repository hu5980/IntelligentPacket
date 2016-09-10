//
//  ITPPacketBagVC.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPPacketBagVC.h"
#import "ITPPacketBagCell.h"
#import "ITPScoketManager.h"

#import "ITPDataCenter.h"

#import "ITPPacketbagWeightVeiwController.h"
#import "AddBagsViewController.h"
#import "ITPAddBabWithIDViewController.h"
#import "ITPBagViewModel.h"

#import "DataSingleManager.h"

@interface ITPPacketBagVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSIndexPath * _Nonnull __selectIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<ITPPacketBagModel *> *dataSource;
@end

@implementation ITPPacketBagVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     [self loaddata];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configTable];
    
    [self configOther];
    
   
    
//    @weakify(self)
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:ITPacketAddbags object:nil]subscribeNext:^(id x) {
        
//        @strongify(self)
        shouldRefresh = true;
    }];
    
    // 退出登录 用重新刷新 初始化
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:ITPacketRefreshAddSafebags object:nil]subscribeNext:^(id x) {
        
        shouldRefresh = true;
        previousTimeSamp = 0;
        currentTimeSamp = 0;
    }];

    
}
bool shouldRefresh = true;

long long previousTimeSamp = 0;
long long currentTimeSamp = 0;

- (void)loaddata {
   
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    currentTimeSamp = CFAbsoluteTimeGetCurrent();
    if (currentTimeSamp - previousTimeSamp < 10) {
        return;
    }
    previousTimeSamp = currentTimeSamp;
    
    if (!shouldRefresh) {
        return;
    }
    shouldRefresh = false;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[ITPScoketManager shareInstance] bagListWithTimeout:10 tag:106 success:^(NSData *data, long tag) {
        @strongify(self);
        if (tag != 106) {
            return ;
        }
        BOOL abool = [ITPBagViewModel isSuccesss:data];
        if (abool) {
            
            [self performBlock:^{
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                self.dataSource = [ITPBagViewModel bags:data];
                [DataSingleManager sharedInstance].bags = [ITPBagViewModel bags:data];
                
                [self.tableView reloadData];
                NSLog(@"%@", self.dataSource);
                
            } afterDelay:0.1];
        
        }else {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [self showAlert:@"获取数据失败" WithDelay:1];
        }
        
    } faillure:^(NSError *error) {
    
        if (error) {
            [self performBlock:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } afterDelay:.1];
        }
        
    }];
    [self performBlock:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } afterDelay:2];
    
}

- (void)configOther {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(edit)];
}

- (void)configTable {
//    self.view.layer
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }else [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ITPPacketBagCell" bundle:nil] forCellReuseIdentifier:@"ITPPacketBagCell"];
}


#pragma mark - action & response



- (void)refreshLanguge {
    
//    [self.tableView reloadData];
    self.title = L(@"Luggage and bags");
    
}

- (void)edit {

    ITPAddBabWithIDViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addbagwithid"];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ITPPacketBagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITPPacketBagCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // UI
    // ==================================================================
    cell.indexPath_ = (int)indexPath.row;
    cell.bagName.text = self.dataSource[indexPath.row].bagName;
    cell.bagNum.text = self.dataSource[indexPath.row].bagPhoneNum;
        
    if (self.dataSource[indexPath.row].status.safetype == IS_SAFE) {
        cell.warning.hidden = YES;
    }else {
        cell.warning.hidden = NO;
    }
    
    if (self.dataSource[indexPath.row].bagType == 1) {  //箱子
        
        if (self.dataSource[indexPath.row].status.onlinetype == IS_ONLINE) {
            [cell.bagheadImage setImage:[UIImage imageNamed:@"组-2"]];
        }else{
            [cell.bagheadImage setImage:[UIImage imageNamed:@"xiangzi_dontonline"]];
        }
        
        cell.bagweight.hidden = NO;
        [cell.bagPhone setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [cell.bagPhone setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
        
    }else {
        
        if (self.dataSource[indexPath.row].status.onlinetype == IS_ONLINE) {
            [cell.bagheadImage setImage:[UIImage imageNamed:@"组-1"]];
        }else{
            [cell.bagheadImage setImage:[UIImage imageNamed:@"bag_dontonline"]];
        }
        
        cell.bagweight.hidden = YES;
        [cell.bagPhone setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    }
    
    if ([self.dataSource[indexPath.row].bagEmail isEqualToString:[ITPUserManager ShareInstanceOne].userEmail])
            cell.manangerImage.hidden = NO;
    else    cell.manangerImage.hidden = YES;
    // ==================================================================
    
    
    // fouction =========================================================
    
    @weakify(self);
    cell.phoneBlcok = ^(int indexPath, UIButton * but){
        if (self.dataSource[indexPath].bagType == 1) {  //箱子  开锁
            @weakify(but);
            // selected = yes  是开锁状态
            if (!but.selected) {
               [self performBlock:^{
                   [[ITPScoketManager shareInstance] setLockAndWeightWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:self.dataSource[indexPath].bagId isWeight:NO isUlock:YES withTimeout:10 tag:115 success:^(NSData *data, long tag) {
                       
                       BOOL abool = [ITPBagViewModel isSuccesss:data];
                       if (abool) {
                           [self performBlock:^{
                               but.selected = YES;
                               [self showAlert:L(@"Successfully unlock automatically shut down after ten seconds") WithDelay:1.3];
                               // 十秒之后自动关闭。
                               [self performBlock:^{
                                   but.selected = NO;
                               } afterDelay:10];
                           } afterDelay:.01];
                       }
                   } faillure:^(NSError *error) {
                       @strongify(but);
                       but.selected = NO;
                   }];
               } afterDelay:0];
            } else {
                [self performBlock:^{
                    [self showAlert:L(@"Lock has been turned on") WithDelay:1.3];
                } afterDelay:.01];
            }
        }
        else {
            [self showCallPhone:self.dataSource[indexPath]];
        }
    };
    
    cell.locationBlcok = ^(int indexPath){
        @strongify(self)
        self.tabBarController.selectedIndex = 1;
        [self performBlock:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketLocation object:self.dataSource[indexPath]];
        } afterDelay:.3];
        
    };
    
    cell.weightBlcok = ^(int indexPath){
        @strongify(self)
        ITPPacketbagWeightVeiwController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"weight"];
        vc.model = self.dataSource[indexPath];
        [self.navigationController pushViewController:vc animated:YES];
        vc.weighingBlock = ^(float weight){
            NSLog(@"weight back");
        };
    };
    
    // ==================================================================
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UIViewController * vc = [UIViewController new];
    
//    [self.navigationController pushViewController:vc animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"喜欢" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        // 实现相关的逻辑代码
//        // ...
//        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
//        tableView.editing = NO;
//    }];
    @weakify(self);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:L(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    @strongify(self);
        __selectIndexPath = indexPath;
        if (![self.dataSource[indexPath.row].bagEmail isEqualToString:[ITPUserManager ShareInstanceOne].userEmail]) {
            [self showAlert:L(@"Can't delete someone else's bags") WithDelay:1.];
            tableView.editing = NO;
            return ;
        }
        [self deleteBags];
    }];
    
    return @[deleteAction];
}

- (void)deleteBags {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[ITPScoketManager shareInstance]deleteBagWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:self.dataSource[__selectIndexPath.row].bagId withTimeout:10 tag:109 success:^(NSData *data, long tag) {
        @strongify(self);
        if (tag != 109) {return ;}
        [self performBlock:^{
            BOOL abool = [ITPBagViewModel isSuccesss:data];
            if (abool) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // 首先改变model
                [self.dataSource removeObjectAtIndex:__selectIndexPath.row];
                // 接着刷新view
                [self.tableView deleteRowsAtIndexPaths:@[__selectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showAlert:L(@"Delete error") WithDelay:1];
            }
        } afterDelay:0.1];
    } faillure:^(NSError *error) {}];
}

- (void)showCallPhone:(ITPPacketBagModel *)model {
    
    @weakify(self);
    
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
    titleLabel.text = OCSTR(@"%@%@",L(@"Whether to dial"),model.bagName);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backGoundView addSubview:titleLabel];
    
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, backGoundView.width, 0.5)];
    topLine.backgroundColor = RGB(210, 210, 210);
    [backGoundView addSubview:topLine];
    
    
    UIImageView * phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"callphone"]];
    [backGoundView addSubview:phoneImageView];
    phoneImageView.centerX = backGoundView.width/2;
    phoneImageView.centerY = 90;
    
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, phoneImageView.bottom + 10, backGoundView.width, 65)];
    phoneLabel.text = model.bagPhoneNum;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [backGoundView addSubview:phoneLabel];

    
    UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, phoneLabel.bottom, backGoundView.width, 0.5)];
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:OCSTR(@"tel://%@",model.bagPhoneNum)]];
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
}

@end
