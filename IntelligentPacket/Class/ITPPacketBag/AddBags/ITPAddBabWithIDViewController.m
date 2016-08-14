//
//  ITPAddBabWithIDViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/14.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPAddBabWithIDViewController.h"
#import "AddBagsViewController.h"

@interface ITPAddBabWithIDViewController ()
@property (weak, nonatomic) IBOutlet UITextField *IDtextfield;
@property (weak, nonatomic) IBOutlet UIButton *QRcodeButton;

@end

@implementation ITPAddBabWithIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshLanguge];
}

- (void)refreshLanguge {
    
    self.title = L(@"Add bags");
    [_QRcodeButton setTitle:L(@"By two dimensional code scanning") forState:UIControlStateNormal];
    _IDtextfield.placeholder = L(@"Manual input box ID");
    
}

- (IBAction)QRButtonAction:(UIButton *)sender {

}

- (IBAction)idhaschanged:(UITextField *)sender {
   
    if (sender.text.length >= 10) {
        
        [sender.text substringToIndex:10];
        
        ITPPacketBagModel * model = [ITPPacketBagModel new];
        model.bagType = [sender.text substringToIndex:1].intValue;
        model.bagId = sender.text;
        AddBagsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addbags"];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
