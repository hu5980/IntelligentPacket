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


@interface ITPPacketBagVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation ITPPacketBagVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configTable];
    
    [self configOther];
    
    self.dataSource = [NSMutableArray arrayWithArray:@[@"", @"", @"", @""]];
}

- (void)configOther {
    [self setNavBarBarItemWithTitle:@"编辑" target:self action:@selector(edit) atRight:YES];
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
    
//    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    
    ITPAddBabWithIDViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addbagwithid"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    AddBagsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addbags"];
//    [self.navigationController pushViewController:vc animated:YES];
    
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
    cell.indexPath_ = (int)indexPath.row;
    
    @weakify(self);
    cell.phoneBlcok = ^(int indexPath){
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18617108096"]];
    };
    
    cell.locationBlcok = ^(int indexPath){
        @strongify(self)
        self.tabBarController.selectedIndex = 1;
    };
    
    cell.weightBlcok = ^(int indexPath){
        @strongify(self)
        
        ITPPacketBagModel * _model = [ITPPacketBagModel new];
        _model.bagType = indexPath/2 == 0?1:0;
        ITPPacketbagWeightVeiwController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"weight"];
        vc.model = _model;
        [self.navigationController pushViewController:vc animated:YES];
        vc.weighingBlock = ^(float weight){
            NSLog(@"weight back");
        };
    };
    
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
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 首先改变model
        [self.dataSource removeObjectAtIndex:indexPath.row];
        // 接着刷新view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 不需要主动退出编辑模式，上面更新view的操作完成后就会自动退出编辑模式
    }];
    
    return @[deleteAction];
}

@end
