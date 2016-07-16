//
//  ITPForgetViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/2.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPForgetViewController.h"

@interface ITPForgetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@property (weak, nonatomic) IBOutlet UITextField *emaiTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *firstpasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *seconpasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UIButton *confimButton;

@end



@implementation ITPForgetViewController

- (void)refreshLanguge {

    self.titleLable.text = L(@"Find password");
    self.emaiTF.placeholder = L(@"Please enter your email address");
    self.firstpasswordTF.placeholder = L(@"Please enter your password");
    self.seconpasswordTF.placeholder = L(@"Please confim your password");
    self.codeTF.placeholder = L(@"Please enter your code");
    [self.confimButton setTitle:L(@"register") forState:UIControlStateNormal];
    [self.getCode setTitle:L(@"get code") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
