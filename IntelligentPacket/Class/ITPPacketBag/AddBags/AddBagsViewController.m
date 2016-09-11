//
//  AddBagsViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "AddBagsViewController.h"
#import "ITPBagViewModel.h"

@implementation AddBagsViewController
{
    __weak IBOutlet UIImageView *bag;
    __weak IBOutlet UIButton *beibao;
    __weak IBOutlet UIImageView *confimImage;
    __weak IBOutlet UIButton *confimButton;
    __weak IBOutlet UITextField *phoneTextFiled;
    
    __weak IBOutlet UITextField *nicknameTF;
    
    NSArray * animationImages;
}

- (void)refreshLanguge {
    self.title = L(@"Add bags");
    [confimButton setTitle:L(@"add") forState:UIControlStateNormal];
    phoneTextFiled.placeholder = L(@"phone number");
    nicknameTF.placeholder = L(@"Remarks");

}

- (void)viewDidLoad {
    [super viewDidLoad];
    confimImage.hidden = YES;
    
    [self refreshLanguge];
    phoneTextFiled.delegate = (id)self;
    nicknameTF.delegate = (id)self;
    
    @weakify(self)
    RAC(confimButton, enabled) = [RACSignal combineLatest:@[phoneTextFiled.rac_textSignal]
                                                   reduce:^(NSString *weight) {
                                                       return @(weight.length );
                                                   }];
    
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
    
    if (self.model.bagType == 1) {
        animationImages = @[[UIImage imageNamed:@"箱子点击00"],[UIImage imageNamed:@"箱子点击01"],[UIImage imageNamed:@"箱子点击02"],[UIImage imageNamed:@"箱子点击03"],[UIImage imageNamed:@"箱子点击04"],[UIImage imageNamed:@"箱子点击05"],[UIImage imageNamed:@"箱子点击06"]];
    }else {
        animationImages = @[[UIImage imageNamed:@"背包点击00"],[UIImage imageNamed:@"背包点击01"],[UIImage imageNamed:@"背包点击02"],[UIImage imageNamed:@"背包点击03"],[UIImage imageNamed:@"背包点击04"],[UIImage imageNamed:@"背包点击05"],[UIImage imageNamed:@"背包点击06"]];
    }
    
    bag.animationImages = animationImages;
    bag.animationDuration = .5;
    bag.animationRepeatCount = 0;
    [bag startAnimating];

}


- (IBAction)confimAction:(UIButton *)sender {

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[ITPScoketManager shareInstance]bingWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:self.model.bagId bagNum:phoneTextFiled.text bagName:nicknameTF.text withTimeout:10 tag:104 result:^(NSData *data, long tag, NSError *error) {
        @strongify(self);
        [self performBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            BOOL abool = [ITPBagViewModel isSuccesss:data];
            if (!error&&abool) {
                @strongify(self);
                [self showAlert:L(@"Add bags success") WithDelay:1.];
                [[NSNotificationCenter defaultCenter] postNotificationName:ITPacketAddbags object:nil];
                [self performBlock:^{
                    @strongify(self);
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1.5];
                
            }else {
                [self showAlert:L(@"Add bags failure") WithDelay:1.];;
            }
        } afterDelay:.1];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
   }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    confimImage.hidden = YES;
    [self performBlock:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);;
    } afterDelay:.1];

}

@end
