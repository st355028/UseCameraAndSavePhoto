//
//  ViewController.m
//  UseCameraAndSavePicture
//
//  Created by MinYeh on 2016/8/15.
//  Copyright © 2016年 MINYEH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *showPhoto;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)openCamera:(UIButton *)sender {
    [self openCamera];
}


#pragma mark 開啟相機方法實作
-(void) openCamera{
    
    //檢查是否支援此Source Type(相機)
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        //設定影像來源為相機
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        //設定delegate給自己
        imagePicker.delegate = self;
        //是否可以編輯照片
        imagePicker.allowsEditing = true;
        //使用後置鏡頭
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //設定擷取影像方式是使用拍照
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //擷取影像資料型態為照片
        imagePicker.mediaTypes = @[@"public.image"];
        //顯示相機
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else {
        [self showAlert:@"本裝置沒有支援相機"];
    }

}
#pragma mark 使用者按下拍攝時
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:image];
    
    //將相機釋放掉
    [picker dismissViewControllerAnimated:true completion:nil];
}

#pragma mark 將相片存入使用者手機裡的相簿

-(void)saveImage:(UIImage*)image{
    
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSave:ContentInfo:), nil);
}

#pragma mark 存好照片時發出通知
-(void)image:(UIImage*)image didFinishSave:(NSError*)error ContentInfo:(NSDictionary*) info{
    
    if(error != nil){
        [self showAlert:[NSString stringWithFormat:@"Error :%@",error]];
    }else{
        self.showPhoto.image = image;
        [self showAlert:@"相片儲存成功！"];
    }
    
}

#pragma mark 使用者按下取消時
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //一般情況下沒有什麼特別要做的事情
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

#pragma mark 警告視窗
-(void)showAlert:(NSString*)message{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
