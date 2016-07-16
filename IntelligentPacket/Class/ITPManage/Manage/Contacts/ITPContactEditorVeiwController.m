//
//  ITPContactEditorVeiwController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/10.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPContactEditorVeiwController.h"

@interface ITPContactEditorVeiwController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ITPContactEditorVeiwController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configTable];
}

- (void)refreshLanguge {
    self.title = L(@"contacts editing");
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
    self.tableView.tableFooterView = [UIView new];
}


const int editcontactDataCount___ = 2;
NSString * editcontactData[editcontactDataCount___] = {
    @"numberPhone",
    @"email"//    @"",
//    @"Head Portrait",
//    @"",
//    @"Phone Number",
//    @""
};

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return editcontactDataCount___;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell  = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = L(editcontactData[indexPath.row]);
    
    UIImageView  * arrow  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"展开去到"]];
    cell.accessoryView = arrow;
    
    
    cell.detailTextLabel.text = @"18017108096";
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIViewController * vc = [UIViewController new];
//    
//    //    [self.navigationController pushViewController:vc animated:YES];
}



@end
