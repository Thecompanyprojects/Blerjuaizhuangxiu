//
//  CreateCompanyViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CreateCompanyViewController.h"
#import "DecorationAreaViewController.h"
#import "CompanyHomeViewController.h"
#import "CompanyLogoApi.h"
#import "CreateCompanyApi.h"
#import "GTMBase64.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "CompanyModel.h"
#import "NSObject+CompressImage.h"

@interface CreateCompanyViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *addressNameStr;
@property (nonatomic, strong) NSArray *districtArr;
@property (nonatomic, copy) NSString *SloganStr;
@property (nonatomic, copy) NSString *companyStr;


@end

@implementation CreateCompanyViewController

-(NSArray*)districtArr{
    
    if (!_districtArr) {
        _districtArr = [NSArray array];
    }
    return _districtArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
}

-(void)createUI{
    
    self.title = @"创建公司";
    self.view.backgroundColor = White_Color;
    
    [self.view addSubview:self.backSrcV];
    [self.backSrcV addSubview:self.defaultName];
    [self.backSrcV addSubview:self.LOGOImageView];
    [self.backSrcV addSubview:self.lineVOne];
    
    [self.backSrcV addSubview:self.companyDeName];
    [self.backSrcV addSubview:self.CompanyNameTF];
    [self.backSrcV addSubview:self.lineVTwo];
    
    [self.backSrcV addSubview:self.NumberDeName];
    [self.backSrcV addSubview:self.CompanyNumberLabel];
    [self.backSrcV addSubview:self.lineVThree];
    
    [self.backSrcV addSubview:self.defaultSolganL];
    [self.backSrcV addSubview:self.SloganTV];
    [self.SloganTV addSubview:self.RemarkLabel];
    [self.backSrcV addSubview:self.FinishBtn];
    
    self.backSrcV.contentSize = CGSizeMake(kSCREEN_WIDTH, self.FinishBtn.bottom+20);
    
    
    self.SloganStr = @"";
//    头像点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    
    [self.LOGOImageView addGestureRecognizer:tap];
    
    self.SloganTV.delegate = self;
    self.CompanyNameTF.delegate = self;
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    self.CompanyNumberLabel.text = user.phone;
}

//设置头像
-(void)tapped:(UITapGestureRecognizer*)sender{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = YES;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];

    [self uploadImageWithImage:chooseImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

//上传公司LOGO
-(void)uploadImageWithImage:(UIImage*)image{
    
    NSDictionary *dict = [NSDictionary dictionary];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASEURL,CompanyLogoUrl] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
//        NSData *imageData = UIImageJPEGRepresentation(image, PHOTO_COMPRESS);
        NSData *imageData = [NSObject imageData:image];
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"12345.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
//        YSNLog(@"%lf",1.5 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"上传成功" controller:self sleep:2];
            
            self.imgStr = [[[responseObject objectForKey:@"imgList"] objectAtIndex:0] objectForKey:@"imgUrl"];
            
            NSURL *imgUrl = [NSURL URLWithString:self.imgStr];

            [self.LOGOImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"jia1"]];
            self.LOGOImageView.layer.borderColor = Clear_Color.CGColor;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//区域
//- (IBAction)areaClick:(id)sender {
//    
//    DecorationAreaViewController *areaVC = [[DecorationAreaViewController alloc]init];
//    [areaVC setRegionViewShow];
//    [self.navigationController pushViewController:areaVC animated:YES];
//}

//完成
- (void)finishClick:(id)sender {
    [self.view endEditing:YES];
    
//    CompanyHomeViewController *homeVC = [[CompanyHomeViewController alloc]init];
//    homeVC.imgStr = self.imgStr;
//    [self.navigationController pushViewController:homeVC animated:YES];
    
    if (!self.imgStr||self.imgStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司logo不能为空" controller:self sleep:1.5];
        return;
    }
    
    self.companyStr = [self.companyStr ew_removeSpacesAndLineBreaks];
    self.companyStr = [self.companyStr ew_removeSpaces];
    if (!self.companyStr||self.companyStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司名称不能为空" controller:self sleep:1.5];
        return;
    }
    
//    self.SloganStr = [self.SloganStr ew_removeSpacesAndLineBreaks];
//    self.SloganStr = [self.SloganStr ew_removeSpaces];
    if (!self.SloganStr||self.SloganStr.length<=0) {
        self.SloganStr = @"";
    }
    
    if (self.SloganStr.length>50) {
       [[PublicTool defaultTool] publicToolsHUDStr:@"公司标语字数不能超过50个" controller:self sleep:1.5];
        return;
    }
    
    
    UserInfoModel *user = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
//    最后需要提交的地点json
    NSMutableArray *areaArray = [NSMutableArray array];
    
    for (NSDictionary *dict in self.districtArr) {
        
        NSString *Did = [dict objectForKey:@"id"];
        NSString *dname = [dict objectForKey:@"name"];
        
        NSMutableDictionary *selectDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectArea"];
        NSDictionary *pdic = [selectDic objectForKey:@"pmodel"];
        NSDictionary *cdic = [selectDic objectForKey:@"cmodel"];
        
        NSMutableArray *regionArr = [NSMutableArray array];
        
        [regionArr addObject:[pdic objectForKey:@"name"]];
        [regionArr addObject:[cdic objectForKey:@"name"]];
        [regionArr addObject:dname];
        
        NSString *regionStr = [regionArr componentsJoinedByString:@" "];
        
        NSMutableDictionary *areaDict = [NSMutableDictionary dictionary];
        
        [areaDict setObject:[pdic objectForKey:@"id"] forKey:@"province"];
        [areaDict setObject:[cdic objectForKey:@"id"] forKey:@"city"];
        [areaDict setObject:Did forKey:@"county"];
        [areaDict setObject:regionStr forKey:@"retion"];
        
        [areaArray addObject:areaDict];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:areaArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    self.FinishBtn.userInteractionEnabled = NO;
//    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/saveHeadquarters.do"];
//    NSString *str = @"http://192.168.0.137:8080/blej-api-blej/api/";
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/saveHeadquarters.do"];
    NSDictionary *paramDic = @{
                               @"companyLogo":self.imgStr,
                               @"companyName":self.companyStr,
                               @"companyNumber":self.CompanyNumberLabel.text,
                               @"companySlogan":self.SloganStr,
                               @"headQuarters":@(1),
//                               @"areaList":jsonStr,
                               @"createPerson":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        self.FinishBtn.userInteractionEnabled = YES;
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:1.5];
                    [self performSelector:@selector(popView) withObject:nil afterDelay:1.5];
                }
                    break;
                    
                case 1002:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"装修区域为空" controller:self sleep:1.5];
//                    [self performSelector:@selector(popView) withObject:nil afterDelay:1.5];
                }
                    break;
                    
                case 1003:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"本市已存在该公司名" controller:self sleep:1.5];
//                    [self performSelector:@selector(popView) withObject:nil afterDelay:1.5];
                }
                    break;
                    
                case 1004:
                    
                {
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
                }
                    break;
                    
                case 2000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"创建失败" controller:self sleep:1.5];
//                    [self performSelector:@selector(popView) withObject:nil afterDelay:1.5];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        self.FinishBtn.userInteractionEnabled = YES;
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] > 0) {
        
        self.RemarkLabel.hidden = YES;
    }else{
        self.RemarkLabel.hidden = NO;
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text length] > 0) {
        
        self.RemarkLabel.hidden = YES;
    }else{
        self.RemarkLabel.hidden = NO;
    }
    self.SloganStr = textView.text;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.companyStr = textField.text;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    self.districtArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"areaList"];
//    
//    if (self.districtArr.count != 0) {
//        
//        NSMutableArray *nameArr = [NSMutableArray array];
//        
//        for (NSDictionary *dic in self.districtArr) {
//            
//            NSString *name = [dic objectForKey:@"name"];
//            [nameArr addObject:name];
//        }
//        self.addressNameStr = [nameArr componentsJoinedByString:@" "];
//        
//        [self.AreaBtn setTitle:self.addressNameStr forState:UIControlStateNormal];
//        
//    }else{
//        [self.AreaBtn setTitle:@"" forState:UIControlStateNormal];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter

-(UIScrollView *)backSrcV{
    if (!_backSrcV) {
        _backSrcV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
//        _backSrcV.backgroundColor = Red_Color;
    }
    return _backSrcV;
}

-(UILabel *)defaultName{
    if (!_defaultName) {
        _defaultName = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kSCREEN_WIDTH-20*2, 20)];
        _defaultName.textColor = COLOR_BLACK_CLASS_3;
        _defaultName.font = [UIFont systemFontOfSize
                         :14];
        //        companyJob.backgroundColor = Red_Color;
        _defaultName.text = @"公司LOGO";
        _defaultName.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultName;
}

-(UIImageView *)LOGOImageView{
    if (!_LOGOImageView) {
        _LOGOImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3, self.defaultName.bottom+5, kSCREEN_WIDTH/3, kSCREEN_WIDTH/3)];
        _LOGOImageView.layer.cornerRadius = 5;
        _LOGOImageView.layer.masksToBounds = YES;
        _LOGOImageView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        _LOGOImageView.layer.borderWidth = 1.5;
        _LOGOImageView.image = [UIImage imageNamed:@"jia1"];
        
        _LOGOImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
        [_LOGOImageView addGestureRecognizer:ges];
    }
    return _LOGOImageView;
}

-(UIView *)lineVOne{
    if (!_lineVOne) {
        _lineVOne = [[UIView alloc]initWithFrame:CGRectMake(0, self.LOGOImageView.bottom+5, kSCREEN_WIDTH, 1)];
        _lineVOne.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineVOne;
}

-(UILabel *)companyDeName{
    if (!_companyDeName) {
        _companyDeName = [[UILabel alloc]initWithFrame:CGRectMake(15, self.lineVOne.bottom, 80, 40)];
        _companyDeName.textColor = COLOR_BLACK_CLASS_3;
        _companyDeName.font = [UIFont systemFontOfSize
                             :14];
        //        companyJob.backgroundColor = Red_Color;
        _companyDeName.text = @"公司名称";
        _companyDeName.textAlignment = NSTextAlignmentLeft;
    }
    return _companyDeName;
}

-(UITextField *)CompanyNameTF{
    if (!_CompanyNameTF) {
        _CompanyNameTF = [[UITextField alloc]initWithFrame:CGRectMake(self.companyDeName.right+10, self.companyDeName.top, kSCREEN_WIDTH-self.companyDeName.right-10, self.companyDeName.height)];
        _CompanyNameTF.textColor = COLOR_BLACK_CLASS_3;
        _CompanyNameTF.font = [UIFont systemFontOfSize
                               :14];
        //        companyJob.backgroundColor = Red_Color;
//        _CompanyNameTF.text = @"公司名称";
        _CompanyNameTF.textAlignment = NSTextAlignmentLeft;
    }
    return _CompanyNameTF;
}

-(UIView *)lineVTwo{
    if (!_lineVTwo) {
        _lineVTwo = [[UIView alloc]initWithFrame:CGRectMake(0, self.CompanyNameTF.bottom, kSCREEN_WIDTH, 1)];
        _lineVTwo.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineVTwo;
}

-(UILabel *)NumberDeName{
    if (!_NumberDeName) {
        _NumberDeName = [[UILabel alloc]initWithFrame:CGRectMake(15, self.lineVTwo.bottom, 80, 40)];
        _NumberDeName.textColor = COLOR_BLACK_CLASS_3;
        _NumberDeName.font = [UIFont systemFontOfSize
                               :14];
        //        companyJob.backgroundColor = Red_Color;
        _NumberDeName.text = @"公司号";
        _NumberDeName.textAlignment = NSTextAlignmentLeft;
    }
    return _NumberDeName;
}

-(UILabel *)CompanyNumberLabel{
    if (!_CompanyNumberLabel) {
        _CompanyNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.NumberDeName.right+10, self.NumberDeName.top, kSCREEN_WIDTH-self.NumberDeName.right-10, self.NumberDeName.height)];
        _CompanyNumberLabel.textColor = COLOR_BLACK_CLASS_3;
        _CompanyNumberLabel.font = [UIFont systemFontOfSize
                               :14];
        //        companyJob.backgroundColor = Red_Color;
        //        _CompanyNameTF.text = @"公司名称";
        _CompanyNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _CompanyNumberLabel;
}

-(UIView *)lineVThree{
    if (!_lineVThree) {
        _lineVThree = [[UIView alloc]initWithFrame:CGRectMake(0, self.NumberDeName.bottom, kSCREEN_WIDTH, 1)];
        _lineVThree.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineVThree;
}

-(UILabel *)defaultSolganL{
    if (!_defaultSolganL) {
        _defaultSolganL = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lineVThree.bottom+20, kSCREEN_WIDTH, 20)];
        _defaultSolganL.textColor = COLOR_BLACK_CLASS_3;
        _defaultSolganL.font = [UIFont systemFontOfSize
                               :14];
        //        companyJob.backgroundColor = Red_Color;
        _defaultSolganL.text = @"公司标语";
        _defaultSolganL.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultSolganL;
}

-(UITextView *)SloganTV{
    if (!_SloganTV) {
        _SloganTV = [[UITextView alloc]initWithFrame:CGRectMake(15, self.defaultSolganL.bottom+20, kSCREEN_WIDTH-30, 120)];
        _SloganTV.textColor = COLOR_BLACK_CLASS_3;
        _SloganTV.font = NB_FONTSEIZ_SMALL;
        _SloganTV.backgroundColor = RGB(230, 230, 230);
    }
    return _SloganTV;
}

-(UILabel *)RemarkLabel{
    if (!_RemarkLabel) {
        _RemarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 5, self.SloganTV.width-4, 20)];
        _RemarkLabel.textColor = COLOR_BLACK_CLASS_9;
        _RemarkLabel.font = NB_FONTSEIZ_SMALL;
        //        companyJob.backgroundColor = Red_Color;
        _RemarkLabel.text = @"请填写公司服务宗旨或者口号,标语等(不能超过50个)";
        _RemarkLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _RemarkLabel;
}

-(UIButton *)FinishBtn{
    if (!_FinishBtn) {
        _FinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _FinishBtn.frame = CGRectMake(kSCREEN_WIDTH/8, self.SloganTV.bottom+60, kSCREEN_WIDTH/4*3, 44);
        [_FinishBtn setTitle:@"完  成" forState:UIControlStateNormal];
        _FinishBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_FinishBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _FinishBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _FinishBtn.layer.masksToBounds = YES;
        _FinishBtn.layer.cornerRadius = 5;
        
//        _FinishBtn.layer.borderWidth = 1.5;
//        _FinishBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
                    _FinishBtn.backgroundColor = Main_Color;
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        [_FinishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _FinishBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
