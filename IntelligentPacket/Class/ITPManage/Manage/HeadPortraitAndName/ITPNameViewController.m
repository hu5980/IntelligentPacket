//
//  ITPNameViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/17.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPNameViewController.h"
#import "ITPContactViewModel.h"


@interface ITPNameViewController ()
{
    __weak IBOutlet UIButton *saveButton;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@end

@implementation ITPNameViewController

- (void)refreshLanguge {
    
    self.phoneTF.placeholder = L(@"Please enter phone number");
    self.emailTextField.placeholder = L(@"Please enter your email address");
    self.passwordTextField.placeholder = L(@"Please enter your password");
    self.nickNameTextField.placeholder = L(@"Please enter your nickName");

    [saveButton setTitle:L(@"save") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTF.text = [ITPUserManager ShareInstanceOne].userPhone;
    self.emailTextField.text = [ITPUserManager ShareInstanceOne].userEmail;
    self.passwordTextField.text = [ITPUserManager ShareInstanceOne].userPassword;
    self.nickNameTextField.text = [ITPUserManager ShareInstanceOne].userName;
    
}

- (IBAction)saveAction:(id)sender {
    
    if ([self.phoneTF.text isEqualToString: [ITPUserManager ShareInstanceOne].userPhone] &&
        [self.emailTextField.text isEqualToString: [ITPUserManager ShareInstanceOne].userEmail]&&
        [self.passwordTextField.text isEqualToString: [ITPUserManager ShareInstanceOne].userPassword]&&
        [self.nickNameTextField.text isEqualToString: [ITPUserManager ShareInstanceOne].userName]) {
        [self showAlert:L(@"Slightly modified?") WithDelay:1.];
        return;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    @weakify(self);
    
    [[ITPScoketManager shareInstance] modifyUserInformationWithEmail:[ITPUserManager ShareInstanceOne].userEmail password:self.passwordTextField.text phone:self.phoneTF.text nickName:self.nickNameTextField.text withTimeout:10 tag:113 success:^(NSData *data, long tag) {
        @strongify(self);
                [self performBlock:^{
        
                    BOOL abool = [ITPContactViewModel isSuccesss:data];
                    if (abool) {
        
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self showAlert:L(@"Modify success") WithDelay:1.];
        
        
                        [ITPUserManager ShareInstanceOne].userPhone = self.phoneTF.text;
                        [ITPUserManager ShareInstanceOne].userEmail = self.emailTextField.text;
                        [ITPUserManager ShareInstanceOne].userPassword = self.passwordTextField.text;
                        [ITPUserManager ShareInstanceOne].userName = self.nickNameTextField.text;
        
                        [self performBlock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        } afterDelay:1.5];
                        
                    }else {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self showAlert:L(@"Modify falied") WithDelay:1.];
                    }
                    
                } afterDelay:.1];

    } faillure:^(NSError *error) {
        
    }];
    
//    [[ITPScoketManager shareInstance]phbWithEmail:nameTextField.text phone:phoneTextFeild.text withTimeout:10 tag:102 success:^(NSData *data, long tag) {
//       //
//    } faillure:^(NSError *error) {
//        
//        [self performBlock:^{
//            if (error) {
//                [self showAlert:L(@"add contacts failure") WithDelay:1.];
//            }
//        } afterDelay:.1];
//        
//    }];
    
}

@end
