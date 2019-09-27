//
//  CreatShopUnionController.m
//  iDecoration
//
//  Created by sty on 2017/10/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CreatShopUnionController.h"
#import "NSObject+CompressImage.h"

@interface CreatShopUnionController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *logoImgV;
@property (nonatomic, strong) UITextField *unionNameText;
@property (nonatomic, strong) UITextField *unionPasswordText;
@property (nonatomic, strong) UITextField *unionNumberText;

@property (nonatomic, copy) NSString *photoUrl;
@end

@implementation CreatShopUnionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建联盟";
    if (self.IsEdit == 1) {
        self.title = @"编辑联盟";
    }
    [self.view addSubview:self.scrollView];
    
    [self setUI];
    
}

-(void)setUI{
    UILabel *LogoName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    LogoName.text = @"联盟LOGO";
    LogoName.textColor = COLOR_BLACK_CLASS_3;
    LogoName.font = NB_FONTSEIZ_NOR;
    LogoName.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *logoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3, LogoName.bottom, kSCREEN_WIDTH/3, kSCREEN_WIDTH/3)];
    logoImgV.image = [UIImage imageNamed:@"jia_kuang"];
    logoImgV.layer.masksToBounds = YES;
    logoImgV.contentMode = UIViewContentModeScaleAspectFill;
    logoImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImg:)];
    [logoImgV addGestureRecognizer:ges];
    
    self.logoImgV = logoImgV;
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.logoImgV.bottom+10, kSCREEN_WIDTH, 1)];
    lineV.backgroundColor = COLOR_BLACK_CLASS_0;
    
    
    [self.scrollView addSubview:LogoName];
    [self.scrollView addSubview:self.logoImgV];
    [self.scrollView addSubview:lineV];
    
    CGFloat lineBottom = lineV.bottom;
    NSArray *leftArray = @[@"联盟名称",@"联盟密码",@"联盟编号"];
    NSArray *placeholdeArray = @[@"请输入联盟名称",@"请输入密码(6-16字符)",@"请输入编号（6-12字符,英文字母开头）"];
    for (int i = 0; i<3; i++) {
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(10, lineBottom, 70, 40)];
        leftL.text = leftArray[i];
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = NB_FONTSEIZ_NOR;
        leftL.textAlignment = NSTextAlignmentCenter;
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+10, leftL.top, kSCREEN_WIDTH-leftL.right-15, leftL.height)];
        textF.textColor = COLOR_BLACK_CLASS_3;
        textF.font = NB_FONTSEIZ_NOR;
        textF.placeholder = placeholdeArray[i];
        [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
        
        
        [self.scrollView addSubview:leftL];
        if (i==0) {
            self.unionNameText = textF;
            [self.scrollView addSubview:self.unionNameText];
        }
        else if (i==1) {
            self.unionPasswordText = textF;
            [self.scrollView addSubview:self.unionPasswordText];
        }
        else{
            self.unionNumberText = textF;
            [self.scrollView addSubview:self.unionNumberText];
        }
        
        UIView *templineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom, kSCREEN_WIDTH, 1)];
        templineV.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.scrollView addSubview:templineV];
        
        lineBottom = lineBottom+41;
        
    }
    
    
    if (self.IsEdit==1) {
        _photoUrl = self.unionLogo;
        [self.logoImgV sd_setImageWithURL:[NSURL URLWithString:_photoUrl] placeholderImage:[UIImage imageNamed:@"jia_kuang"]];
        
        self.unionNameText.text = self.unionName;
        self.unionPasswordText.text = self.unionPwd;
        self.unionNumberText.text = self.unionNumber;
    }
    
    UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    successBtn.frame = CGRectMake(30,lineBottom+20,kSCREEN_WIDTH-60,40);
    successBtn.backgroundColor = Main_Color;
    [successBtn setTitle:@"完  成" forState:UIControlStateNormal];
    successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    successBtn.titleLabel.font = NB_FONTSEIZ_BIG;
    successBtn.layer.masksToBounds = YES;
    successBtn.layer.cornerRadius = 5;
    [successBtn addTarget:self action:@selector(postdata) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:successBtn];
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height+1);
}

#pragma mark -action

-(void)postdata{
    [self.view endEditing:YES];
    if (!self.photoUrl||self.photoUrl.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请上传联盟logo" controller:self sleep:2.0];
        return;
    }
    
    self.unionNameText.text = [self.unionNameText.text ew_removeSpaces];
    if (self.unionNameText.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入联盟名称" controller:self sleep:2.0];
        return;
    }
    
    self.unionPasswordText.text = [self.unionPasswordText.text ew_removeSpaces];
    if (self.unionPasswordText.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入联盟密码" controller:self sleep:2.0];
        return;
    }
    if (self.unionPasswordText.text.length<6||self.unionPasswordText.text.length>16) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"联盟密码不满足6-16位!" controller:self sleep:2.0];
        return;
    }
    
    self.unionNumberText.text = [self.unionNumberText.text ew_removeSpaces];
    if (self.unionNumberText.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入联盟编号" controller:self sleep:2.0];
        return;
    }
    
    //判断位数6-12
    if (self.unionNumberText.text.length<6||self.unionNumberText.text.length>12) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"联盟编号不满足6-12位!" controller:self sleep:2.0];
        return;
    }
    
    
    
    //是否英文字母开头
    BOOL IsEnglishFirst = [self.unionNumberText.text ew_checkJustEnglishIsFisrt];
    if (!IsEnglishFirst) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"联盟编号请以字母开头!" controller:self sleep:2.0];
        return;
    }
    
    //是否包含中文
    BOOL isHan = [self includeChinese:self.unionNumberText.text];
    
    if (isHan) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"联盟编号不能输入中文!" controller:self sleep:2.0];
        return;
    }
    
//    BOOL Isbool = [self.unionNumberText.text ew_checkNumAndEnglishIsFisrt];
//    if (!Isbool) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"联盟编号不满足6-12位!" controller:self sleep:2.0];
//        return;
//    }
//    YSNLog(@"%@",Isbool);
    
    
    if (!self.IsEdit) {
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"union/save.do"];
        
        [[UIApplication sharedApplication].keyWindow hudShow];
        NSDictionary *paramDic = @{@"unionLogo":self.photoUrl, @"unionPwd":self.unionPasswordText.text,
                                   @"unionNumber":self.unionNumberText.text,
                                   @"companyId":@(self.companyId),
                                   @"agencysId":@(user.agencyId),
                                   @"unionName":self.unionNameText.text
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                if (statusCode==1000) {
                    //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                    [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:2.0];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if (statusCode==1003) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"联盟编号重复" controller:self sleep:2.0];
                }
                else if (statusCode==2000) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
                }
                
            }
            
            //        NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            YSNLog(@"%@",errorMsg);
        }];
    }
    else{
//        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"union/update.do"];
        
        [[UIApplication sharedApplication].keyWindow hudShow];
        NSDictionary *paramDic = @{@"unionLogo":self.photoUrl, @"unionPwd":self.unionPasswordText.text,
                                   @"unionNumber":self.unionNumberText.text,
                                   @"unionId":@(self.unionId),
                                   @"unionName":self.unionNameText.text
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                if (statusCode==1000) {
                    //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                    [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:2.0];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:self.photoUrl forKey:@"unionLogo"];
                    [dict setObject:self.unionNameText.text forKey:@"unionName"];
                    [dict setObject:self.unionPasswordText.text forKey:@"unionPwd"];
                    [dict setObject:self.unionNumberText.text forKey:@"unionNumber"];
                    if (self.creatUnionBlock) {
                        self.creatUnionBlock(dict);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if (statusCode==1003) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"联盟编号重复" controller:self sleep:2.0];
                }
                else if (statusCode==2000) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
                }
                
            }
            
            //        NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            YSNLog(@"%@",errorMsg);
        }];

    }
    
}

-(void)changeImg:(UITapGestureRecognizer *)ges{
    [self.view endEditing:YES];
    [self imagePicker];
}

-(void)imagePicker{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = YES;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    NSData *imageData = UIImageJPEGRepresentation(chooseImage, PHOTO_COMPRESS);
    NSData *imageData = [NSObject imageData:chooseImage];
    
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
    [self uploadImageWithBase64Str:imageStr];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            //            [[PublicTool defaultTool] publicToolsHUDStr:@"上传成功" controller:self sleep:2.0];
            self.photoUrl = [dic objectForKey:@"imageUrl"];
            
            [self.logoImgV sd_setImageWithURL:[NSURL URLWithString:_photoUrl] placeholderImage:[UIImage imageNamed:@"jia_kuang"]];
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"上传成功" controller:self sleep:2.0];
            
            
            //            [self.editInfoTableView reloadData];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"上传失败" controller:self sleep:2.0];
    }];
}

#pragma mark - 是否包含中文
- (BOOL)includeChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a =[str characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}



-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
    }
    return _scrollView;
}


@end
