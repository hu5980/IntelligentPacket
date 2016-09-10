//
//  ITPPacketbagWeightVeiwController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/6.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPPacketbagWeightVeiwController.h"
#import "ITPBagViewModel.h"

@interface ITPPacketbagWeightVeiwController()
@property (weak, nonatomic) IBOutlet UITextField *weightTextFiled;

@end

@implementation ITPPacketbagWeightVeiwController
{
    
    __weak IBOutlet UIButton *confimButton;

    __weak IBOutlet UIImageView *bagPacketImageView;
}
#pragma mark - lyfe Cycle
- (void)refreshLanguge {

    self.title = L(@"Bag weighing");
    [confimButton setTitle:L(@"Start") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshLanguge];
    
    if (self.model.bagType == 1) {
        [bagPacketImageView setImage:[UIImage imageNamed:@"箱子"]];
    }else
        [bagPacketImageView setImage:[UIImage imageNamed:@"背包"]];
    
    @weakify(self)
    self.weightTextFiled.enabled = NO;
//    RAC(confimButton, enabled) = [RACSignal combineLatest:@[self.weightTextFiled.rac_textSignal]
//                                                         reduce:^(NSString *weight) {
//                                                             return @(weight.length );
//                                                         }];
    
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
//    if (self.weighingBlock) {
//        self.weighingBlock(11.1);
//    }
    [self getWieghtfromService];
}


- (void)getWieghtfromService {
    @weakify(self);
    [[ITPScoketManager shareInstance] setLockAndWeightWithEmail:[ITPUserManager ShareInstanceOne].userEmail bagId:self.model.bagId isWeight:YES isUlock:NO withTimeout:10 tag:115 success:^(NSData *data, long tag) {
        @strongify(self);
        BOOL abool = [ITPBagViewModel isSuccesss:data];
        if (abool) {
            
            [self performBlock:^{
                float weight = [ITPBagViewModel weight:data];
                self.weightTextFiled.text = OCSTR(@"%f",weight);
            } afterDelay:.01];
            
            [self performBlock:^{
                @strongify(self);
                [self getWieghtfromService];
            } afterDelay:.5];
        }
    } faillure:^(NSError *error) {
        @strongify(self);
        [self performBlock:^{
            @strongify(self);
            [self getWieghtfromService];
        } afterDelay:.5];
    }];
}

@end
