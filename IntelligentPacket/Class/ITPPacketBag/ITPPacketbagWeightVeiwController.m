//
//  ITPPacketbagWeightVeiwController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/6.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPPacketbagWeightVeiwController.h"

@implementation ITPPacketbagWeightVeiwController
{

    __weak IBOutlet UITextField *weightTextFiled;
    
    __weak IBOutlet UIButton *confimButton;

    __weak IBOutlet UIImageView *bagPacketImageView;
}
#pragma mark - lyfe Cycle
- (void)refreshLanguge {

    self.title = L(@"Bag weighing");
    [confimButton setTitle:L(@"confim") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshLanguge];
    
    if (self.model.bagType == 1) {
        [bagPacketImageView setImage:[UIImage imageNamed:@"箱子"]];
    }else
        [bagPacketImageView setImage:[UIImage imageNamed:@"背包"]];
    
    @weakify(self)
    RAC(confimButton, enabled) = [RACSignal combineLatest:@[weightTextFiled.rac_textSignal]
                                                         reduce:^(NSString *weight) {
                                                             return @(weight.length );
                                                         }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        self.view.transform = CGAffineTransformMakeTranslation(0, -50);
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        [self performBlock:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);;
            
        } afterDelay:.1];
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - action


- (IBAction)confimAction:(UIButton *)sender {
    if (self.weighingBlock) {
        self.weighingBlock(11.1);
    }
}


@end
