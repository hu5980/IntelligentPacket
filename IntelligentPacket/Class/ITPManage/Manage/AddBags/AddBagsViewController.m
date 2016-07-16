//
//  AddBagsViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "AddBagsViewController.h"

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
    nicknameTF.placeholder = L(@"nickname");

}

- (void)viewDidLoad {
    [super viewDidLoad];
    confimImage.hidden = YES;
    
    [self refreshLanguge];
    
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
    
    if (self.model.bagType == 0) {
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
//    if (confimImage.hidden) {
//        [self showAlert:L(@"Please select type") WithDelay:1];
//        return;
//    }
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    confimImage.hidden = YES;
}

@end
