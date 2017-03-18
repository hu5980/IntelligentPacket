//
//  ITPRegisterViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/1.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPRegisterViewController.h"
#import "LoginWithRegisterViewModel.h"

@interface ITPRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@end

@implementation ITPRegisterViewController

- (void)refreshLanguge {
    
    self.title = L(@"register") ;
    self.phoneTF.placeholder = L(@"Please enter phone number");
    self.emailTextField.placeholder = L(@"Please enter your email address");
    self.passwordTextField.placeholder = L(@"Please enter your password");
    self.nickNameTextField.placeholder = L(@"Please enter your nickName");
    self.codeTextFeild.placeholder = L(@"Please enter your code");
    [self.registerButton setTitle:L(@"register") forState:UIControlStateNormal];
    [self.getCodeButton setTitle:L(@"get code") forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RAC(self.registerButton, enabled) = [RACSignal combineLatest:@[self.phoneTF.rac_textSignal,
                                                                   self.emailTextField.rac_textSignal,
                                                                   self.passwordTextField.rac_textSignal,
                                                                   self.nickNameTextField.rac_textSignal,
                                                                   self.codeTextFeild.rac_textSignal]
                                                          reduce:^(NSString *phone, NSString *username, NSString *password, NSString *nickName, NSString *code) {
                                                              return @(phone.length && username.length && password.length && nickName.length && code.length);
                                                          }];
    
    
    RAC(self.getCodeButton, enabled) = [RACSignal combineLatest:@[self.emailTextField.rac_textSignal]
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
- (IBAction)getCode:(UIButton *)sender {
    
    if (![AppUtil isEmailString:self.emailTextField.text]) {
        [self showAlert:L(@"email error") WithDelay:1.0];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[ITPScoketManager shareInstance]registerAuthWith:self.emailTextField.text withTimeout:10 tag:101 result:^(NSData *data, long tag, NSError *error) {
        @strongify(self);
        // 提交注册
        [self performBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!error&&[LoginWithRegisterViewModel isAuthRegisterSuccess:data]) {
                [self showAlert:L(@"To get the verification code, please check the mailbox.") WithDelay:1.0];
            } else [self showAlert:L(@"get the verification code failed.") WithDelay:1.0];
        } afterDelay:.1];
    }];
    
}

- (IBAction)registerAction:(UIButton *)sender {
    
    if (self.codeTextFeild.text.length != 4) {
        [self showAlert:L(@"code error") WithDelay:1.0];
        return;
    }
    
    if (![AppUtil isEmailString:self.emailTextField.text]) {
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
    @weakify(self);
    [[ITPScoketManager shareInstance]registerWith:self.emailTextField.text password:self.passwordTextField.text authCode:self.codeTextFeild.text nickName:self.nickNameTextField.text  phone:self.phoneTF.text withTimeout:10 tag:101 result:^(NSData *data, long tag, NSError *error) {
        @strongify(self);
        [self performBlock:^{
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            BOOL abool = [LoginWithRegisterViewModel isAuthRegisterSuccess:data];
            if (!error&&abool) {
                
                [self showAlert:L(@"register success") WithDelay:1.0];
                
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:.5];
                
            } else [self showAlert:L(@"register failed") WithDelay:1.0];
            
        } afterDelay:.1];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
