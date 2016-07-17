//
//  ITPheadViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/17.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPheadViewController.h"
#import "UIImage+Fit.h"
#import <AVFoundation/AVFoundation.h>

@interface ITPheadViewController ()

@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@end

@implementation ITPheadViewController

- (void)refreshLanguge {


}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _imagePickerController  =[[UIImagePickerController alloc]init];

}


- (IBAction)modifyHeadimage:(UIButton *)sender {
    [self changeHeadimage];
}

- (void)changeHeadimage
{
    
    UIActionSheet *choose=[[UIActionSheet alloc]initWithTitle:nil
                                                     delegate:(id)self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"拍照",@"从相册中选择", nil ];
    [choose showInView:self.view];
    
}

#pragma mark photo picker..
+ (BOOL)CameraPermissions/**<判断是否已授权*/
{
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusDenied){
        
        return NO;
    }
    return YES;
}

- (void)getHeaderIcon
{
    if ( [[self class] CameraPermissions]) {//检查授权
        [self chooseForStanrd:nil];
    }
    else return;
}

- (void)chooseForStanrd:(id)sender
{
    UIActionSheet *choose=[[UIActionSheet alloc]initWithTitle:nil
                                                     delegate:(id)self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"拍照",@"从相册中选择", nil ];
    [choose showInView:self.view];
}

-(void)photograph
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        _imagePickerController.sourceType = sourceType;
        _imagePickerController.delegate = (id)self;
        [_imagePickerController setAllowsEditing:YES];
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
    else
        [self showAlert:@"该设备不支持照相功能" WithDelay:1.];
}

-(void)selectPhoto
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        _imagePickerController.sourceType = sourceType;
        _imagePickerController.delegate = (id)self;
        [_imagePickerController setAllowsEditing:YES];
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:_imagePickerController animated:YES completion:^{
            _imagePickerController.navigationBar.barTintColor = mainSchemeColor;
            _imagePickerController.navigationBar.backgroundColor = mainSchemeColor;
        }];
    }
    else
        [self showAlert:@"该设备无法访问相册" WithDelay:1.];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照一张
        {
            [self photograph];
        }
            break;
        case 1://搞一张
        {
            [self selectPhoto];
            break;
        }
        default:
            break;
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    CGSize size = CGSizeMake(200,200);// 切图
    UIImage *__image = [UIImage createRoundedRectImage:image size:size radius:0];//切角处理
    @weakify(self)
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        [self saveThePhotoToiPhone:__image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveThePhotoToiPhone:(UIImage *)img
{
    
    NSData *data;
    if (UIImagePNGRepresentation(img) == nil) {
        
        data = UIImageJPEGRepresentation(img, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(img);
        
    }
    
    [self.headerButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
}


@end
