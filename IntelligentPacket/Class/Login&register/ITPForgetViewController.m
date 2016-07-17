//
//  ITPForgetViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/2.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPForgetViewController.h"
#import "LoginWithRegisterViewModel.h"

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
    
    
    
    RAC(self.confimButton, enabled) = [RACSignal combineLatest:@[self.emaiTF.rac_textSignal,
                                                                   self.firstpasswordTF.rac_textSignal,
                                                                   self.seconpasswordTF.rac_textSignal,
                                                                   self.codeTF.rac_textSignal]
                                                          reduce:^(NSString *username, NSString *password, NSString *nickName, NSString *code) {
                                                              return @(username.length && password.length && nickName.length && code.length);
                                                          }];
    
    
    RAC(self.getCode, enabled) = [RACSignal combineLatest:@[self.emaiTF.rac_textSignal]
                                                         reduce:^(NSString *username) {
                                                             return @(username.length );
                                                         }];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        self.view.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        [self performBlock:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);;
            
        } afterDelay:.1];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


#pragma mark - action

- (IBAction)confimAction:(UIButton *)sender {
    if (self.codeTF.text.length != 4) {
        [self showAlert:L(@"code error") WithDelay:1.0];
        return;
    }
    
    if (![AppUtil isEmailString:self.emaiTF.text]) {
        [self showAlert:L(@"email error") WithDelay:1.0];
        return;
    }
    
    //    if (![AppUtil isPasswordString:self.passwordTextField.text]) {
    //        [self showAlert:@"密码格式不正确" WithDelay:1.0];
    //        return;
    //    }
    //
    //    if (![AppUtil isRightNickName:self.passwordTextField.text]) {
    //        [self showAlert:@"昵称格式不正确" WithDelay:1.0];
    //        return;
    //    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (IBAction)getCodeAction:(UIButton *)sender {
    if (![AppUtil isEmailString:self.emaiTF.text]) {
        [self showAlert:L(@"email error") WithDelay:1.0];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[ITPScoketManager shareInstance]registerAuthWith:self.emaiTF.text withTimeout:10 tag:101 success:^(NSData *data, long tag) {
        // 提交注册
        [self performBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([LoginWithRegisterViewModel isAuthRegisterSuccess:data]) {
                [self showAlert:L(@"To get the verification code, please check the mailbox.") WithDelay:1.0];
            } else [self showAlert:L(@"get the verification code failed.") WithDelay:1.0];
        } afterDelay:.1];
        
    } faillure:^(NSError *error) {
        
        [self performBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showAlert:L(@"get the verification code failed.") WithDelay:1.0];
            
        } afterDelay:.1];
        
    }];

}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
