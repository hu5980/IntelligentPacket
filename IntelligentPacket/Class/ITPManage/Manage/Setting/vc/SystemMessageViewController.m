//
//  SystemMessageViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/11/29.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "RealmItem.h"
#import "ITPRealmStore.h"


@interface SystemMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (nonatomic, strong) NSMutableArray <RealmItem *>* dataSource;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewColor;
    self.dataSource = [NSMutableArray array];
    [self configTable];
    [self loadData];
}

- (void)configTable {
    
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.backgroundColor = [UIColor clearColor];
    if ([self.tabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tabelView setSeparatorInset:UIEdgeInsetsZero];
    }else [self.tabelView setSeparatorInset:UIEdgeInsetsZero];
    if ([self.tabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tabelView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tabelView.tableFooterView = [UIView new];
    [self.tabelView registerNib:[UINib nibWithNibName:@"ITPManageCell" bundle:nil] forCellReuseIdentifier:@"ITPManageCell"];
    
}

- (void)loadData {
    @weakify(self);

    ITPRealmStore * store = [[ITPRealmStore alloc] init];
    [store fetchStatPageEntriesWithCompletionBlock:^(RLMResults *results) {
        @strongify(self);
        NSLog(@"%lu", (unsigned long)results.count);

        for (int i = 0; i<results.count; i ++) {
            RealmItem * item = [results objectAtIndex:i];
            if ([item.email isEqualToString:[ITPUserManager ShareInstanceOne].userEmail]) {
                [self.dataSource addObject:item];
            }
        }
        [self performBlock:^{
            [self.tabelView reloadData];
        } afterDelay:.1];
    }];
    
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ITPMessageCell"];
    if (!cell) {
        cell  = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"ITPMessageCell"];
    }
//    cell.detailTextLabel.text = self.dataSource[indexPath.row].content;
    cell.textLabel.text = self.dataSource[indexPath.row].content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIViewController * vc = [UIViewController new];
    
    //    [self.navigationController pushViewController:vc animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:L(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        [self deleteMessage:indexPath];
    }];
    
    return @[deleteAction];
}

- (void)deleteMessage:(NSIndexPath*)index {
    
    ITPRealmStore * store = [[ITPRealmStore alloc] init];
    [store removeObject:self.dataSource[index.row]];
    // 首先改变model
    [self.dataSource removeObjectAtIndex:index.row];
    // 接着刷新view
    [self.tabelView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
