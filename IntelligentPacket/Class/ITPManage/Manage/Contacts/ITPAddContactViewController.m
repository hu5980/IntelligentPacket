//
//  ITPAddContactViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/10.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPAddContactViewController.h"
#import "ITPContactViewModel.h"

@interface ITPAddContactViewController ()
{
    
    
    __weak IBOutlet UIView *phoneBackView;
    __weak IBOutlet UIView *emailBackView;
    __weak IBOutlet UIView *passwordBackView;
    
    
    __weak IBOutlet UITextField *phoneTextFeild;
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UIButton *saveButton;
}
@end

@implementation ITPAddContactViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self refreshLanguge];
    passwordBackView.hidden = YES;
    
    RAC(saveButton, enabled) =
    [RACSignal combineLatest:@[phoneTextFeild.rac_textSignal,
                               nameTextField.rac_textSignal]//,passwordTextField.rac_textSignal
                      reduce:^( NSString *phone , NSString *username) {
                          return @(phone.length > 0&&username.length > 0);
                      }];
    
}

- (IBAction)saveAction:(id)sender {
 
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[ITPScoketManager shareInstance]phbWithEmail:nameTextField.text phone:phoneTextFeild.text withTimeout:10 tag:102 result:^(NSData *data, long tag, NSError *error) {
        @strongify(self);
        [self performBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            BOOL abool = [ITPContactViewModel isSuccesss:data];
            if (!error&&abool) {
                
                [self showAlert:L(@"add contacts success") WithDelay:1.];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ITPacketAddcontacts object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:ITPacketAddbags object:nil];
                
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1.5];
                
            }else {
                [self showAlert:L(@"add contacts failure") WithDelay:1.];
            }
        } afterDelay:.1];
        
    }];
    
}

- (void)refreshLanguge {
    self.title = L(@"add contacts");
    
    phoneTextFeild.placeholder = L(@"Please enter phone number");
    passwordTextField.placeholder = L(@"Please enter password");
    nameTextField.placeholder = L(@"Please enter your email address");
    [saveButton setTitle:L(@"save") forState:UIControlStateNormal];
}

@end
