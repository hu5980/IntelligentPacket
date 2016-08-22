//
//  FeedBackViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NetServiceApi.h"

@implementation FeedBackViewController
{

    __weak IBOutlet UITextView *feedbackTextView;
    
    __weak IBOutlet UIButton *confimButton;
    
    NetServiceApi * feedbackApi;
}


- (void)refreshLanguge {
    [confimButton setTitle:L(@"confim") forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    feedbackApi = [NetServiceApi new];
    
    [self refreshLanguge];
    
    @weakify(self)
    RAC(confimButton, enabled) = [RACSignal combineLatest:@[feedbackTextView.rac_textSignal]
                                                   reduce:^(NSString *weight) {
                                                       return @(weight.length );
                                                   }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        self.view.transform = CGAffineTransformMakeTranslation(0, -30);
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"%@", x);
        [self performBlock:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);;
            
        } afterDelay:.1];
    }];
}

- (IBAction)feedbackAction:(UIButton *)sender {
    if (feedbackTextView.text.length == 0) {
        [self showAlert:L(@"please input some words") WithDelay:1.]; return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([feedbackApi registerTarget:self andResponseMethod:@selector(feedbackRes:)]) {
        [feedbackApi getFeedbackServerWithcontent:feedbackTextView.text];
    }
}

- (void)feedbackRes:(id)some {
   [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

@end
