
//
//  LoginViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/3.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "LoginViewController.h"
#import "ITPRegisterViewController.h"
#import "ITPForgetViewController.h"

#import "LoginWithRegisterViewModel.h"

@interface LoginViewController()
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *fastRegisterBtn;

@property (weak, nonatomic) IBOutlet UIButton *findPassword;

@end

@implementation LoginViewController

- (void)refreshLanguge {
   
    self.emailTextField.placeholder = L(@"Please enter your email address");
    self.passwordTextField.placeholder = L(@"Please enter your password");
    [self.loginButton setTitle:L(@"login") forState:UIControlStateNormal];
    [self.fastRegisterBtn setTitle:L(@"fast register") forState:UIControlStateNormal];
    [self.findPassword setTitle:L(@"find password") forState:UIControlStateNormal];
}

- (UIStatusBarStyle )preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)awakeFromNib {
//    [self refreshLanguge];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.loginButton, enabled) =
    [RACSignal combineLatest:@[self.emailTextField.rac_textSignal,
                               self.passwordTextField.rac_textSignal]
                      reduce:^(NSString *username, NSString *password) {
                          return @(username.length && password.length);
                      }];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        self.view.transform = CGAffineTransformMakeTranslation(0, -70);
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        [self performBlock:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);;
            
        } afterDelay:.1];
    }];
}
//
//- (IBAction)emailValueChange:(UITextField *)sender {
//
//}
//
//
//- (IBAction)passwordValueChange:(UITextField *)sender {
//
//}

- (IBAction)loginAction:(UIButton *)sender {
    
    if (![AppUtil isEmailString:self.emailTextField.text]) {
        [self showAlert:L(@"email error") WithDelay:1.0];
        return;
    }
    
//    if (![AppUtil isPasswordString:self.passwordTextField.text]) {
//        [self showAlert:@"密码格式不正确" WithDelay:1.0];
//        return;
//    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ITPScoketManager shareInstance]loginWith:self.emailTextField.text password:self.passwordTextField.text withTimeout:10 tag:101 success:^(NSData *data, long tag) {
        
        [self performBlock:^{
            BOOL abool = [LoginWithRegisterViewModel isLoginSuccess:data];
            if (abool) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showAlert:L(@"Login Success!") WithDelay:1.5];
                
                [ITPUserManager ShareInstanceOne].userEmail = OCSTR(@"%@", self.emailTextField.text);
            }else {
             
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showAlert:L(@"Login error!") WithDelay:1.5];
                
            }
            
        } afterDelay:.1];
        
    } faillure:^(NSError *error) {
        
        [self performBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showAlert:L(@"Login error!") WithDelay:1.5];
            
        } afterDelay:.1];
    }];
}

- (IBAction)gotoRegister:(UIButton *)sender {
    
    ITPRegisterViewController *vc = [[UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)findPassword:(UIButton *)sender {
    
    ITPRegisterViewController *vc = [[UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"forget"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end