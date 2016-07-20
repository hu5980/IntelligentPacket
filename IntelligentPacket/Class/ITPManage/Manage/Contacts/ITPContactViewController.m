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
#import "ITPContactViewModel.h"

@interface ITPContactViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<ITPContactModel *> *dataSource;
@end


@implementation ITPContactViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self laodData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self laodData];
    
    [self configTable];
    
    [self setNavBarBarItemWithTitle:@"➕" target:self action:@selector(addContacts) atRight:YES];
}

- (void)laodData {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
   [[ITPScoketManager shareInstance]lxrWithEmail:[ITPUserManager ShareInstanceOne].userEmail withTimeout:10 tag:103 success:^(NSData *data, long tag) {
       
       @strongify(self);
       if ([ITPContactViewModel isSuccesss:data]) {
          [self performBlock:^{
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              
              self.dataSource = [ITPContactViewModel contacts:data];
              [self.tableView reloadData];
              NSLog(@"%@", self.dataSource);
              
          } afterDelay:0.1];
       }
       
   } faillure:^(NSError *error) {
       
       if (error) {
           [self performBlock:^{
               [MBProgressHUD hideHUDForView:self.view animated:YES];
           } afterDelay:.1];
       }
       
   } ];
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
    cell.name.text = self.dataSource[indexPath.row].contactName;
    cell.phoneNum.text = self.dataSource[indexPath.row].contactPhoneNum;
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
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:L(@"edit") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            // 实现相关的逻辑代码
            // ...
            // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
            ITPContactEditorVeiwController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactedit"];
            [self.navigationController pushViewController:vc animated:YES];
            
            tableView.editing = NO;
        }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:L(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 首先改变model
        [self.dataSource removeObjectAtIndex:indexPath.row];
        // 接着刷新view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 不需要主动退出编辑模式，上面更新view的操作完成后就会自动退出编辑模式
    }];
    
    return @[deleteAction, editAction];
}

@end