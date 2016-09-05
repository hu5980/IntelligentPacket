//
//  FeedBackViewController.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/7/4.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NetServiceApi.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Fit.h"
#import "ITPFeedBackItem.h"

@interface FeedBackViewController() <UITextViewDelegate>

@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation FeedBackViewController
{
    __weak IBOutlet UIButton *feedbackImage1;
    __weak IBOutlet UIButton *feedbackImage2;
    __weak IBOutlet UIButton *feedbackImage3;
    __weak IBOutlet UIButton *feedbackImage4;
    
    __weak IBOutlet NSLayoutConstraint *contact1;
    __weak IBOutlet NSLayoutConstraint *contact2;
    __weak IBOutlet NSLayoutConstraint *contact0;
    __weak IBOutlet NSLayoutConstraint *contact3;

    
    __weak IBOutlet UILabel *textViewPlaceholder;
    __weak IBOutlet UILabel *contentnumber;
    
    __weak IBOutlet UIButton *confimButton;
    
    NSData * imageData;
    
    NetServiceApi * feedbackApi;
    
    NSMutableArray <ITPFeedBackItem*>* imagesDataSource;
    
}


- (void)refreshLanguge {
    [confimButton setTitle:L(@"confim") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    
    contact1.constant = contact2.constant = contact3.constant = contact0.constant = ([UIScreen mainScreen].bounds.size.width - 40 - 60*4)/5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    feedbackApi = [NetServiceApi new];
    imagesDataSource = [NSMutableArray array];
    _imagePickerController  =[[UIImagePickerController alloc]init];
    self.feedbackTextView.delegate = self;
    
    [self refreshLanguge];
    
    @weakify(self)
    RAC(confimButton, enabled) = [RACSignal combineLatest:@[self.feedbackTextView.rac_textSignal]
                                                   reduce:^(NSString *weight) {
                                                       return @(weight.length );
                                                   }];
    
//    [RACObserve(self.feedbackTextView, text)subscribeNext:^(id x) {
//        NSString * _text = x;
//        if (_text.length > 0) {
//            textViewPlaceholder.hidden = YES;
//        }else textViewPlaceholder.hidden = NO;
//    }];
    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
//        @strongify(self)
//        NSLog(@"%@", x);
//        self.view.transform = CGAffineTransformMakeTranslation(0, -30);
//    }];
//    
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
//        @strongify(self)
//        NSLog(@"%@", x);
//        [self performBlock:^{
//            self.view.transform = CGAffineTransformMakeTranslation(0, 0);;
//        } afterDelay:.1];
//    }];
}

#pragma mark - action
- (IBAction)feedbackAction:(UIButton *)sender {
    if (!imageData) {
        [self showAlert:L(@"please input a image") WithDelay:1.]; return;
    }
    if (self.feedbackTextView.text.length == 0) {
        [self showAlert:L(@"please input some words") WithDelay:1.]; return;
    }
    [self feedback:self.feedbackTextView.text.base64EncodedString];
}

- (IBAction)feedbackImageAction:(UIButton *)sender {
    
    if (sender.tag == 10) {
        
    }
    else if (sender.tag == 11) {
    
    }
    else if (sender.tag == 12) {
        
    }
    else if (sender.tag == 13) {
        
    }
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
#pragma mark - UITextView Change

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textViewPlaceholder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        textViewPlaceholder.hidden = YES;
    }else textViewPlaceholder.hidden = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    contentnumber.text = OCSTR(@"%lu/200", (unsigned long)textView.text.length);
    if (textView.text.length > 200 && range.location > 200) {
        [textView.text substringToIndex:200];
        contentnumber.text = OCSTR(@"%lu/200", (unsigned long)textView.text.length);
        return NO;
    }else return YES;
}

#pragma mark - 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ITPFeedBackItem * item = [ITPFeedBackItem new];
    item.originalImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    CGSize size = CGSizeMake(200,200);// 切图
    item.smallImage = [UIImage createRoundedRectImage:item.originalImage size:size radius:0];//切角处理
    @weakify(self)
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        [self saveThePhotoToiPhone:item.originalImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveThePhotoToiPhone:(UIImage *)img{
    NSData *data;
    if (UIImagePNGRepresentation(img) == nil) {
        data = UIImageJPEGRepresentation(img, 1);
    }
    else {
        data = UIImagePNGRepresentation(img);
    }
    imageData = data;
    [feedbackImage1 setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
}



- (void)feedback:(NSString *)base64Str
{
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@uid=%@&email=%@&content=%@", Feedback, [ITPUserManager ShareInstanceOne].userEmail, [ITPUserManager ShareInstanceOne].userEmail, base64Str] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"完成 %@", result);
        [self performBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([result rangeOfString:@"00|"].location != NSNotFound) {
                [self showAlert:L(@"Submit success!") WithDelay:1.];
            }else [self showAlert:L(@"Submit falied!") WithDelay:1.];
        } afterDelay:.1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        [self performBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:L(@"Submit falied!") WithDelay:1.];
        } afterDelay:.1];
        NSLog(@"错误 %@", error.localizedDescription);
    }];
}

// 多图拼接
- (UIImage *)imageApend {

    CGSize size = CGSizeMake(300, imagesDataSource.count * 300);
    UIGraphicsBeginImageContext(size);
    for (int index; index < imagesDataSource.count; index++) {
        [[UIImage createRoundedRectImage:imagesDataSource[index].originalImage size:CGSizeMake(300, 300) radius:0] drawInRect:CGRectMake(0, index*300, 300, 300)];
    }
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
