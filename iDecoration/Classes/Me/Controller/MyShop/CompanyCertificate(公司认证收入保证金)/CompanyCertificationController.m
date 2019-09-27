//
//  CompanyCertificationController.m
//  iDecoration
//
//  Created by zuxi li on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CompanyCertificationController.h"
#import "CertificationPayController.h"
#import "ZCHPublicWebViewController.h"

@interface CompanyCertificationController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;

@property (weak, nonatomic) IBOutlet UITextField *certificateCodeTF;

@property (weak, nonatomic) IBOutlet UITextField *legalPersonTF;

@property (weak, nonatomic) IBOutlet UIButton *selectImageBtn;

@property (strong, nonatomic)  UIButton *nextBtn;

@property (nonatomic, strong) NSString *imageUrl;
// 选择图片的蒙层
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIButton *jumpBtn;
@end

@implementation CompanyCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请企业认证";
    self.selectImageBtn.layer.cornerRadius = 4;
    self.selectImageBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.jumpBtn];
    [self buildCoverView];
    if (self.isfromlogin) {
        
        [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(45);
            make.width.mas_offset(139);
            make.left.equalTo(self.view).with.offset(26);
            make.top.equalTo(self.view).with.offset(380);
        }];
        
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(45);
            make.width.mas_offset(139);
            make.left.equalTo(self.view).with.offset(kSCREEN_WIDTH/2+22);
            make.top.equalTo(self.view).with.offset(380);
        }];
        
        [self.jumpBtn setHidden:NO];
       
    }
    else
    {
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(45);
            make.width.mas_offset(139);
            make.left.equalTo(self.view).with.offset(26);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(380);
        }];
        
        [self.jumpBtn setHidden:YES];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildCoverView {
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:coverView];
    self.coverView = coverView;
    coverView.hidden = YES;
    coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidCoverViewTapAction)];
    [coverView addGestureRecognizer:tapGR];
    UIView *bgView = [[UIView alloc] init];
    [coverView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(292);
        make.height.equalTo(490);
        make.centerY.equalTo(-kNaviBottom/2.0);
    }];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"certificate_bg"]];
    //    531  774
    bgImageView.frame = CGRectMake(0, 0, 265, 387);
    [bgView addSubview:bgImageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(bgImageView.mas_bottom).equalTo(27);
        make.width.equalTo(241);
        make.height.equalTo(46);
    }];
    btn.backgroundColor = kCustomColor(50, 219, 123);
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"上传照片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(selectImageAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hidCoverViewTapAction {
    self.coverView.hidden = YES;
}

- (void)selectImageAction {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([TTHelper checkPhotoLibraryAuthorizationStatus]) {
            
            //初始化UIImagePickerController
            UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc]init];
            // 获取方式1：通过相册（呈现全部相册) UIImagePickerControllerSourceTypePhotoLibrary
            // 获取方式2，通过相机              UIImagePickerControllerSourceTypeCamera
            // 获取方法3，通过相册（呈现全部图片）UIImagePickerControllerSourceTypeSavedPhotosAlbum
            pickerImageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 允许编辑，即放大裁剪
            pickerImageVC.allowsEditing = NO;
            // 自代理
            pickerImageVC.delegate = self;
            // 页面跳转
            [self presentViewController:pickerImageVC animated:YES completion:nil];
        }
    }];
    [alertC addAction:action];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([TTHelper checkCameraAuthorizationStatus]) {
            
            // 通过相机的方式
            UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc] init];
            // 获取方式:通过相机
            pickerImageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImageVC.allowsEditing = NO;
            pickerImageVC.delegate = self;
            pickerImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:pickerImageVC animated:YES completion:^{
                
                [pickerImageVC.view layoutIfNeeded];
            }];
            
        }
    }];
    [alertC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action3];
    
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)selectImageBtnAction:(id)sender {
    [self.view endEditing:YES];
    self.coverView.hidden = NO;
}

#pragma mark - PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.coverView.hidden = YES;
    __block UIImage*image = [self turnImageWithInfo:info];
    

    // 上传图片
    NSData *imageData = [NSObject imageData:image];
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    MJWeakSelf;
    [self uploadImageWithBase64Str:imageStr completion:^(bool isSuccess) {
        if (isSuccess) {
            [weakSelf.selectImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}


-(void)uploadImageWithBase64Str:(NSString*)base64Str completion:(void(^)(bool))completion{
    [[UIApplication sharedApplication].keyWindow hudShow:@"正在上传图片"];
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    [[PublicTool defaultTool] publicToolsHUDStr:@"" controller:self sleep:1.0];
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"1000"]) {
            completion(YES);
            // 上传成功后返回的URL
            NSString *photoUrl = dic[@"imageUrl"];
            YSNLog(@"-------url: %@", photoUrl);
            self.imageUrl = photoUrl;
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        } else {
            completion(NO);
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传失败" controller:self sleep:1.5];
    }];
}

- (void)nextBtnActionsender {
    if ([self.companyNameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入企业全称"];
        return;
    }
    if ([self.certificateCodeTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入工商执照注册码"];
        return;
    }
    if ([self.legalPersonTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入法定代表人"];
        return;
    }
    if (self.imageUrl == nil || self.imageUrl.length == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请添加营业执照照片"];
        return;
    }
    [self isCertificated:^{
        UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSDictionary *paramDic = @{@"companyId":@(self.companyId.integerValue),
                                   @"companyName": self.companyNameTF.text,
                                   @"regCode": self.certificateCodeTF.text,
                                   @"personName": self.legalPersonTF.text,
                                   @"licenseImg": self.imageUrl,
                                   @"agencysId": @(userModel.agencyId),
                                   };
        CertificationPayController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateViewControllerWithIdentifier:@"CertificationPayController"];
        VC.companyId = self.companyId;
        VC.dicData = paramDic;
        VC.successBlock = ^{
            if (self.CertificatSuccessBlock) {
                self.CertificatSuccessBlock();
            }
            NSNotification *notification = [NSNotification notificationWithName:@"Viptongzhi" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:VC animated:true];
    }];
}

//判断是否认证过
- (void)isCertificated:(void(^)(void))successBlock {
    NSMutableDictionary *parameters = @{}.mutableCopy;
    parameters[@"regCode"] = self.certificateCodeTF.text;
    [NetWorkRequest getJSONWithUrl:@"companyAuthentication/selByCompany.do" parameters:parameters success:^(id result) {
        if ([result[@"code"] integerValue] == 1002) {//已经注册过
            SHOWMESSAGE(@"该公司已被注册")
        }else if ([result[@"code"] integerValue] == 1000) {
            successBlock();
        }else
            SHOWMESSAGE(result[@"msg"])
    } fail:^(id error) {
    }];
}

- (void)popAction {
    
    //创建通知对象

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)explainAction:(id)sender {
    ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
    managerMustReadVC.titleStr = @"公司认证说明";
    managerMustReadVC.webUrl = @"resources/html/renzhengshuoming.html";
    [self.navigationController pushViewController:managerMustReadVC animated:YES];
}

-(UIButton *)jumpBtn
{
    if(!_jumpBtn)
    {
        _jumpBtn = [[UIButton alloc] init];
        [_jumpBtn setTitle:@"跳过" forState:normal];
        [_jumpBtn addTarget:self action:@selector(jumpbtnclick)
           forControlEvents:UIControlEventTouchUpInside];
        _jumpBtn.backgroundColor = [UIColor hexStringToColor:@"23B665"];
        [_jumpBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        _jumpBtn.layer.masksToBounds = YES;
        _jumpBtn.layer.cornerRadius = 4;
    }
    return _jumpBtn;
}

-(UIButton *)nextBtn
{
    if(!_nextBtn)
    {
        _nextBtn = [[UIButton alloc] init];
        _nextBtn.backgroundColor = [UIColor hexStringToColor:@"23B665"];
        [_nextBtn setTitle:@"下一步" forState:normal];
        [_nextBtn addTarget:self action:@selector(nextBtnActionsender)
           forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 4;
    }
    return _nextBtn;
}


#pragma mark - getters

-(void)jumpbtnclick
{
    NSNotification *notification = [NSNotification notificationWithName:@"Viptongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
