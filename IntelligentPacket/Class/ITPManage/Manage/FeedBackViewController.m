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
    __weak IBOutlet UILabel  *numberImages;
    
    UIButton     *indictorImageButton;
    NSInteger    imageIndex;
    
    __weak IBOutlet UIView *secondBackGroudView;
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    switch (imageIndex) {
        case 0:
            indictorImageButton.frame = feedbackImage1.frame;
            break;
        case 1:
            indictorImageButton.frame = feedbackImage2.frame;
            break;
        case 2:
            indictorImageButton.frame = feedbackImage3.frame;
            break;
        case 3:
            indictorImageButton.frame = feedbackImage4.frame;
            break;
        case 4:
            indictorImageButton.hidden = YES;
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageIndex = 0;
    feedbackApi = [NetServiceApi new];
    imagesDataSource = [NSMutableArray array];
    numberImages.text = OCSTR(@"%lu/4",(unsigned long)(int)imagesDataSource.count);
    
    indictorImageButton = [[UIButton alloc]initWithFrame:feedbackImage1.frame];
    [indictorImageButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [secondBackGroudView addSubview:indictorImageButton];
    [indictorImageButton addTarget:self action:@selector(changeHeadimage) forControlEvents:UIControlEventTouchUpInside];
    _imagePickerController  =[[UIImagePickerController alloc]init];
    self.feedbackTextView.delegate = self;
    
    [self refreshLanguge];

//    @weakify(self)
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
    [self imageTodata:[self imageApend]];
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
                                            cancelButtonTitle:L(@"cancel")
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:L(@"Take a picture"),L(@"Select from album"), nil ];
    [choose showInView:self.view];
    
}
- (IBAction)buttonClickAction:(id)sender {

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
                                            cancelButtonTitle:L(@"cancel")
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:L(@"Take a picture"),L(@"Select from album"), nil ];
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
        [self showAlert:L(@"The device does not support the camera function") WithDelay:1.];
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
        [self showAlert:L(@"The device could not access the album") WithDelay:1.];
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

- (void)textViewDidChange:(UITextView *)textView {
    contentnumber.text = OCSTR(@"%lu/200", (unsigned long)textView.text.length);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textViewPlaceholder.hidden = YES;
    contentnumber.text = OCSTR(@"%lu/200", (unsigned long)textView.text.length);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        textViewPlaceholder.hidden = YES;
    }else textViewPlaceholder.hidden = NO;
    contentnumber.text = OCSTR(@"%lu/200", (unsigned long)textView.text.length);
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
        [imagesDataSource addObject:item];
        [self showWithButton];
//        [self saveThePhotoToiPhone:item.originalImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showWithButton {
    imageIndex = imagesDataSource.count;
    switch (imageIndex) {
        case 0:
        {
            [feedbackImage1 setBackgroundImage:nil forState:UIControlStateNormal];
            [self imageIndictorAnimation:feedbackImage1.frame];
            break;
        }
        case 1:
        {
            [feedbackImage1 setBackgroundImage:imagesDataSource[0].smallImage forState:UIControlStateNormal];
            [self imageIndictorAnimation:feedbackImage2.frame];
            break;
        }
        case 2:
        {
            [feedbackImage2 setBackgroundImage:imagesDataSource[1].smallImage forState:UIControlStateNormal];
            [self imageIndictorAnimation:feedbackImage3.frame];
            break;
        }
        case 3:
        {
            [feedbackImage3 setBackgroundImage:imagesDataSource[2].smallImage forState:UIControlStateNormal];
            [self imageIndictorAnimation:feedbackImage4.frame];
            break;
        }
        case 4:
        {
            [feedbackImage4 setBackgroundImage:imagesDataSource[3].smallImage forState:UIControlStateNormal];
            indictorImageButton.hidden = YES;
            break;
        }
        default:
            break;
    }
    numberImages.text = OCSTR(@"%lu/4",(unsigned long)(int)imagesDataSource.count);
}

- (void)imageIndictorAnimation:(CGRect)toFrame {
    [UIView animateWithDuration:.1 animations:^{
        indictorImageButton.frame = toFrame;
    }];
}

- (void)imageTodata:(UIImage *)img{
    NSData *data;
    if (UIImagePNGRepresentation(img) == nil) {
        data = UIImageJPEGRepresentation(img, 1);
    }
    else {
        data = UIImagePNGRepresentation(img);
    }
    imageData = data;
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

    CGSize size = CGSizeMake(300, imagesDataSource.count * 250);
    UIGraphicsBeginImageContext(size);
    for (int index = 0; index < imagesDataSource.count; index++) {
        [[UIImage createRoundedRectImage:imagesDataSource[index].originalImage size:CGSizeMake(300, 250) radius:0] drawInRect:CGRectMake(0, index*250, 300, 250)];
    }
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
