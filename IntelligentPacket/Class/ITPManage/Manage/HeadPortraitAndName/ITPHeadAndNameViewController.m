//
//  ITPHeadAndNameViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/17.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPHeadAndNameViewController.h"
#import "ITPheadViewController.h"
#import "ITPNameViewController.h"

@interface ITPHeadAndNameViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ITPHeadAndNameViewController

- (void)refreshLanguge {


}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configTable];
}

- (void)configTable {
    
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = (id)self;
    self.tableView.backgroundColor = viewColor;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }else [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [UIView new];
}


const int headAndNametDataCount___ = 4;
NSString * headAndNameData[headAndNametDataCount___] = {
    @"",
    @"Head portrait",
    @"",
    @"Modify user information"
};

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return headAndNametDataCount___;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (headAndNameData[indexPath.row].length == 0) {
        return 10;
    }
    
    if (indexPath.row == 1) {
        return 80;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell  = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = L(headAndNameData[indexPath.row]);
    
    if (headAndNameData[indexPath.row].length == 0) {
        cell.accessoryView = nil;
        cell.backgroundColor = viewColor;
    }else {
        UIImageView  * arrow  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"展开去到"]];
        cell.accessoryView = arrow;
        cell.backgroundColor = [UIColor whiteColor];
    }

    cell.detailTextLabel.text = @"18017108096";
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    UIViewController * vc = [UIViewController new];
    //
    //    //    [self.navigationController pushViewController:vc animated:YES];
    switch (indexPath.row) {
        case 1:
        {
            ITPheadViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"headmodify"];
            vc.title = L(@"Modify head portrait");
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            ITPNameViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"namemodify"];
            vc.title = L(@"Modify user information");
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
