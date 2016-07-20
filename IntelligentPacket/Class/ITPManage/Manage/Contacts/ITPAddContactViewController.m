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
    
    
    RAC(saveButton, enabled) =
    [RACSignal combineLatest:@[phoneTextFeild.rac_textSignal,
                               nameTextField.rac_textSignal,passwordTextField.rac_textSignal]
                      reduce:^(NSString *phone, NSString *username, NSString *password) {
                          return @(phone.length && username.length && password.length);
                      }];
    
}

- (IBAction)saveAction:(id)sender {
 
    [[ITPScoketManager shareInstance]phbWithEmail:nameTextField.text phone:phoneTextFeild.text withTimeout:10 tag:102 success:^(NSData *data, long tag) {
        
        if (data) {
            
        }
    } faillure:^(NSError *error) {
        if (error) {
            
        }
        
        
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
