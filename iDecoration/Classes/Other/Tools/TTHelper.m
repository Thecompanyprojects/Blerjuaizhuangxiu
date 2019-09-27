//
//  TTHelper.m
//  TTBasicProject
//
//  Created by 赵春浩 on 16/9/18.
//  Copyright © 2016年 Mr Zhao. All rights reserved.
//

#import "TTHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


// alertView的宏 只进行提示(标题 + 提示信息 + 按钮是确定)
#define kAlertView(title,msg); \
{\
UIAlertView *_alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];\
    _alert.transform=CGAffineTransformMakeTranslation(0, 80);\
    [_alert show];\
}

@interface TTHelper ()<UIAlertViewDelegate>

@property (strong, nonatomic) TTHelper *helper;

@end

@implementation TTHelper

#pragma mark - 检查用户是否打开了照片权限
+ (BOOL)checkPhotoLibraryAuthorizationStatus {
    
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (ALAuthorizationStatusDenied == authStatus ||
        ALAuthorizationStatusRestricted == authStatus) {
        
        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - 检查用户是否打开了相机权限
+ (BOOL)checkCameraAuthorizationStatus {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kAlertView(nil, @"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 根据用户系统版本, iOS8+的直接跳转到设置权限的界面
+ (void)showSettingAlertStr:(NSString *)tipStr {
    
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {

        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"提示" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL];
                }
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];

        [alertView show];
    }else{
        
        kAlertView(@"提示", tipStr);
    }
}






@end
