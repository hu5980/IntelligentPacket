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
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *conifmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@end

@implementation ITPNameViewController

- (void)refreshLanguge {
    
    self.phoneTF.placeholder = L(@"Please enter phone number");
    self.oldPasswordTextField.placeholder = L(@"Please enter your old password");
    self.conifmPasswordTextField.placeholder = L(@"Please enter your new password");
    self.nickNameTextField.placeholder = L(@"Please enter your nickName");

    [saveButton setTitle:L(@"save") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.phoneTF.text = [ITPUserManager ShareInstanceOne].userPhone;
//    self.emailTextField.text = [ITPUserManager ShareInstanceOne].userEmail;
//    self.oldPasswordTextField.text = [ITPUserManager ShareInstanceOne].userPassword;
//    self.nickNameTextField.text = [ITPUserManager ShareInstanceOne].userName;
    
}

- (IBAction)saveAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self.phoneTF.text isEqualToString: [ITPUserManager ShareInstanceOne].userPhone] &&
        [self.oldPasswordTextField.text isEqualToString: [ITPUserManager ShareInstanceOne].userPassword]&&
        [self.nickNameTextField.text isEqualToString: [ITPUserManager ShareInstanceOne].userName]) {
        [self showAlert:L(@"Slightly modified?") WithDelay:1.];
        return;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    @weakify(self);
    
    [[ITPScoketManager shareInstance] modifyUserInformationWithEmail:[ITPUserManager ShareInstanceOne].userEmail oldPassword:self.oldPasswordTextField.text newPassword:self.conifmPasswordTextField.text phone:self.phoneTF.text nickName:self.nickNameTextField.text withTimeout:10 tag:113 result:^(NSData *data, long tag, NSError *error) {
        @strongify(self);
        [self performBlock:^{
            @strongify(self);
            
            BOOL abool = [ITPContactViewModel isSuccesss:data];
            if (!error&&abool) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self showAlert:L(@"Modify success") WithDelay:1.];
                
                
                [ITPUserManager ShareInstanceOne].userPhone = self.phoneTF.text;
                [ITPUserManager ShareInstanceOne].userPassword = self.conifmPasswordTextField.text;
                [ITPUserManager ShareInstanceOne].userName = self.nickNameTextField.text;
                
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1.5];
                
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self showAlert:L(@"Modify falied") WithDelay:1.];
            }
            
        } afterDelay:.1];
    }];
    
}

@end
