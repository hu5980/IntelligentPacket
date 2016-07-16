//
//  ITPContactViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPContactViewController.h"
#import "ITPAddContactViewController.h"
#import "ITPContactEditorVeiwController.h"
#import "ITPContactsCell.h"

@interface ITPContactViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end


@implementation ITPContactViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configTable];
    
    self.dataSource = [NSMutableArray arrayWithArray:@[@"", @"", @"", @""]];
    
    [self setNavBarBarItemWithTitle:@"➕" target:self action:@selector(addContacts) atRight:YES];
}

- (void)addContacts {
    
    ITPAddContactViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addcontact"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ITPContactsCell" bundle:nil] forCellReuseIdentifier:@"ITPContactsCell"];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ITPContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITPContactsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.indexPath_ = (int)indexPath.row;
//    
//    @weakify(self);
//    cell.phoneBlcok = ^(int indexPath){
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18617108096"]];
//    };
//    
//    cell.locationBlcok = ^(int indexPath){
//        @strongify(self)
//        self.tabBarController.selectedIndex = 1;
//    };
//    
//    cell.weightBlcok = ^(int indexPath){
//        @strongify(self)
//        
//        ITPPacketBagModel * _model = [ITPPacketBagModel new];
//        _model.bagType = indexPath/2 == 0?1:0;
//        ITPPacketbagWeightVeiwController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"weight"];
//        vc.model = _model;
//        [self.navigationController pushViewController:vc animated:YES];
//        vc.weighingBlock = ^(float weight){
//            NSLog(@"weight back");
//        };
//    };
//    
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
    @weakify(self)
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            // 实现相关的逻辑代码
            // ...
            // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
            ITPContactEditorVeiwController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactedit"];
            [self.navigationController pushViewController:vc animated:YES];
            
            tableView.editing = NO;
        }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 首先改变model
        [self.dataSource removeObjectAtIndex:indexPath.row];
        // 接着刷新view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 不需要主动退出编辑模式，上面更新view的操作完成后就会自动退出编辑模式
    }];
    
    return @[deleteAction, editAction];
}

@end
