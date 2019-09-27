//
//  ZZPhotoController.m
//  ZZFramework
//
//  Created by Yuan on 15/12/16.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZPhotoController.h"
#import "PickerViewController.h"

@interface ZZPhotoController()

@property (nonatomic ,strong) PickerViewController *pickerViewCotroller;
@end

@implementation ZZPhotoController

- (PickerViewController*)pickerViewCotroller{

    if (!_pickerViewCotroller) {
        
        _pickerViewCotroller = [[PickerViewController alloc]init];
    }
    
    return _pickerViewCotroller;
}


#pragma mark ---- 弹出控制器
-(void)showIn:(UIViewController *)controller result:(ZZPhotoResult)result{
    
    //相册权限判断
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        //相册权限未开启
        [self showAlertViewToController:controller];
        
    }else if(status == PHAuthorizationStatusNotDetermined){
        //相册进行授权
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showController:controller result:result];
                });
 
            }
        }];
    }else if (status == PHAuthorizationStatusAuthorized){
        [self showController:controller result:result];
    }

}

-(void)showController:(UIViewController *)controller result:(ZZPhotoResult)result
{
    //授权完成，打开相册
    
    
    
    //Block传值
    self.pickerViewCotroller.PhotoResult = result;
//    self.pickerViewCotroller.isAlubSeclect = NO;
//    /* * *   同时设定最多选择照片的张数  * * */
    self.pickerViewCotroller.selectNum = _selectPhotoOfMax;
    /* * *   同时设定返回图片的类型  * * */
    self.pickerViewCotroller.imageType = _imageType;
    
    //然后再执行pushViewController控制器ZZPhotoPickerViewController
    //此控制器为详情相册，显示某个相册中的详细照片
    //[self showPhotoPicker:self.pickerViewCotroller.navigationController];
    
    [self showPhotoList:controller];
}

-(void)showPhotoList:(UIViewController *)controller
{
    
    [controller.navigationController pushViewController:self.pickerViewCotroller animated:YES];
}

-(void)showPhotoPicker:(UINavigationController *)navigationController
{
    [navigationController pushViewController:self.pickerViewCotroller animated:NO];
}




-(void)showAlertViewToController:(UIViewController *)controller
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册",app_Name] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
