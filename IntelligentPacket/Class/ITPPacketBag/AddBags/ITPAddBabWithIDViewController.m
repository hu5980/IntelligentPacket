//
//  ITPAddBabWithIDViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/14.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPAddBabWithIDViewController.h"
#import "AddBagsViewController.h"
#import "QRCodeReaderViewController.h"

@interface ITPAddBabWithIDViewController ()
{
    QRCodeReaderViewController * _reader;
}
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
   
    NSArray *types = @[AVMetadataObjectTypeQRCode];
    _reader = [QRCodeReaderViewController readerWithMetadataObjectTypes:types];
    
    // Using delegate methods
    _reader.delegate = (id)self;
    
    // Or by using blocks
    @weakify(self);
    [_reader setCompletionWithBlock:^(NSString *resultAsString) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            [self performBlock:^{
                self.IDtextfield.text = resultAsString;
                [self idhaschanged:self.IDtextfield];
            } afterDelay:.1];
        }];
    }];
    
    [self presentViewController:_reader animated:YES completion:NULL];
}

- (IBAction)idhaschanged:(UITextField *)sender {
   
    if (sender.text.length >= 10) {
        
        [sender.text substringToIndex:10];
        
        ITPPacketBagModel * model = [ITPPacketBagModel new];
        model.bagType = [sender.text substringToIndex:1].intValue;
        model.bagId = sender.text;
        AddBagsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addbags"];
        vc.model = model;
        vc.title = L(@"Add bags");
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
