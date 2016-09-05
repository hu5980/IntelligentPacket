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
#import "NetServiceApi.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"

@interface ITPheadViewController ()
{
        NSData * imageData;
}
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@property (nonatomic, strong) UIImagePickerController * imagePickerController;

@end

@implementation ITPheadViewController

- (void)refreshLanguge {


}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _imagePickerController  =[[UIImagePickerController alloc]init];
    
    [self.headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[ITPUserManager ShareInstanceOne].userheardStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
    

}

- (IBAction)confim:(UIButton *)sender {

    if (!imageData) {
        return;
    }
    [self postImage:imageData];
}

- (IBAction)modifyHeadimage:(UIButton *)sender {
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
    imageData = data;
    [self.headerButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
}

- (void)postImage:(NSData*)imgData
{
    @weakify(self);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    [manager POST:[NSString stringWithFormat:@"%@uid=%@", UplaodHearPortain, [ITPUserManager ShareInstanceOne].userEmail] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                     // 上传的参数名
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/png"];
        
//        NSData * temp = [@"355567207@qq.com" dataUsingEncoding:NSUTF8StringEncoding];
//        [formData appendPartWithFormData:temp name:@"uid"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"完成 %@", result);
        [self performBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([result rangeOfString:@"00|"].location != NSNotFound) {
                [self showAlert:L(@"upload success!") WithDelay:1.];
            }else [self showAlert:L(@"upload falied!") WithDelay:1.];
        } afterDelay:.1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        [self performBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showAlert:L(@"upload falied!") WithDelay:1.];
        } afterDelay:.1];
         NSLog(@"错误 %@", error.localizedDescription);
    }];
}



// 以前老版post 表单
-(void)oldPostImage:(NSData*)imgData
{
    NSMutableURLRequest *request = nil;

    request = formPost([NSURL URLWithString:UplaodHearPortain], imgData, nil);
    [request setValue:[ITPUserManager ShareInstanceOne].userEmail forKey:@"uid"];
    if (request == nil) {
        return ;
    }
    //模拟表单上传
    NSError* error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:nil];
    
    if (error) {
        return;
    }else{
        
        
        NSString* string = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"结果解析出错:%@",string);
        
    }
}


NSMutableURLRequest *formPost(NSURL* URL,NSData*data,NSDictionary* form)
{
    //分界线的标识符body
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL:URL
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]initWithFormat:@"Content-type: multipart/form-data, boundary=%@\r\n",TWITTERFON_FORM_BOUNDARY];
    //参数的集合的所有key的集合
    
    for (NSString* formKey in form) {
        if(![formKey isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",formKey];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[form objectForKey:formKey]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //    [request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",body);
    return request;
}


@end
