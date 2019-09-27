//
//  ModifyConstructionController.m
//  iDecoration
//
//  Created by Apple on 2017/5/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ModifyConstructionController.h"
#import "WWPickerView.h"
#import "SSPopup.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"

#import "PlaceHolderTextView.h"
#import "HKImageClipperViewController.h"
#import "NSObject+CompressImage.h"
#import "selectsitetagsVC.h"
#import "localcommunityVC.h"

@interface ModifyConstructionController ()<UITextFieldDelegate,SSPopupDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextViewDelegate,myTabVdelegate>
{
    NSInteger _selectTag;
    NSInteger _companyOrShop;
    NSInteger _companyTpye;
    
    
}

@property (nonatomic, strong) UIScrollView *srcV;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UIButton *signTimeBtn;
@property (nonatomic, strong) UIButton *beginTimeBtn;
@property (nonatomic, strong) UIButton *endTimeBtn;

@property (nonatomic, strong) UIImageView *coverImgV;//封面图

@property (nonatomic, strong) UIImageView *placeHolderImgV;//默认的展位图
@property (nonatomic, copy) NSString *userName;//户主
@property (nonatomic, copy) NSString *addressStr;//地址
@property (nonatomic, assign) CGFloat aPid;//省
@property (nonatomic, assign) CGFloat aCid;//市
@property (nonatomic, assign) CGFloat aDid;//区
@property (nonatomic, copy) NSString *socialName;//小区名称
@property (nonatomic, copy) NSString *shareTitle;//分享标题
@property (nonatomic, copy) NSString *ConstructionName;//施工单位
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *signStr;//签约日期
@property (nonatomic, copy) NSString *beginStr;//开工日期
@property (nonatomic, copy) NSString *endStr;//竣工日期

@property (nonatomic, copy)NSString *coverStr;//封面图地址

@property (nonatomic, copy) NSString *label;//标签

@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *area;



@property (nonatomic, strong) RegionView *regionView;
@property (nonatomic, strong) PModel *pmodel;
@property (nonatomic, strong) CModel *cmodel;
@property (nonatomic, strong) DModel *dmodel;

@property (nonatomic, copy) NSString *provinceStr;
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *areaStr;


@property (nonatomic, strong) UIButton *successBtn;

@property (nonatomic, strong) PlaceHolderTextView *shareTitleTv;
@property (nonatomic, strong) UIButton *labelBtn;
@property (nonatomic, strong) UIButton *xiaoquBtn;
@end

@implementation ModifyConstructionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    
}

-(void)createUI{
    self.title = @"编辑工地";
    self.view.backgroundColor = White_Color;
    
    [self.view addSubview:self.srcV];
    [self.srcV addSubview:self.coverImgV];
    [self.coverImgV addSubview:self.placeHolderImgV];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    if (!self.companyOrShop) {
        self.coverStr = self.siteModel.coverMap;
    }
    else{
        self.coverStr = self.mainSiteModel.coverMap;
    }
    if (!self.companyOrShop) {
        self.label = self.siteModel.label;
    }
    else
    {
        self.label = self.mainSiteModel.label;
    }
    if (!self.coverStr||self.coverStr.length<=0) {
        self.coverStr = @"";
        self.placeHolderImgV.hidden = NO;
    }
    else{
        self.placeHolderImgV.hidden = YES;
        [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:self.coverStr] placeholderImage:nil];
    }

    
    if (!self.companyOrShop) {
        self.userName = self.siteModel.ccHouseholderName;
    }
    else{
        self.userName = self.mainSiteModel.ccHouseholderName;
    }
    
    if (!self.userName||self.userName.length<=0) {
        self.userName = @"";
    }
    
    if (!self.companyOrShop) {
        self.addressStr = self.siteModel.ccAddress;
    }
    else{
        self.addressStr = self.mainSiteModel.ccAddress;
    }
    if (!self.addressStr||self.addressStr.length<=0) {
        self.addressStr = @"";
    }
    
    if (!self.companyOrShop) {
        self.socialName = self.siteModel.ccAreaName;
    }
    else{
        self.socialName = self.mainSiteModel.ccAreaName;
    }
    if (!self.socialName||self.socialName.length<=0) {
        self.socialName = @"";
    }
    
    if (!self.companyOrShop) {
        self.shareTitle = self.siteModel.ccShareTitle;
    }
    else{
        self.shareTitle = self.mainSiteModel.ccShareTitle;
    }
    if (!self.shareTitle||self.shareTitle.length<=0) {
        self.shareTitle = @"";
    }
    
    
    if (!self.companyOrShop) {
        self.ConstructionName = self.siteModel.ccBuilder;
    }
    else{
        self.ConstructionName = self.mainSiteModel.companyName;
    }
    if (!self.ConstructionName||self.ConstructionName.length<=0) {
        self.ConstructionName = @"";
    }
    
    if (!self.companyOrShop) {
        self.style = self.siteModel.style;
    }
    else{
        self.style = self.mainSiteModel.style;
    }
    if (!self.style||self.style.length<=0) {
        self.style = @"";
    }
    
    if (!self.companyOrShop) {
        self.provinceStr = self.siteModel.province;
    }
    else{
        self.provinceStr = self.mainSiteModel.province;
    }
    if (!self.provinceStr||self.provinceStr.length<=0) {
        self.provinceStr = @"";
    }
    
    
    if (!self.companyOrShop) {
        self.cityStr = self.siteModel.city;
    }
    else{
        self.cityStr = self.mainSiteModel.city;
    }
    if (!self.cityStr||self.cityStr.length<=0) {
        self.cityStr = @"";
    }
    
    if (!self.companyOrShop) {
        self.areaStr = self.siteModel.area;
    }
    else{
        self.areaStr = self.mainSiteModel.area;
    }
    if (!self.areaStr||self.areaStr.length<=0) {
        self.areaStr = @"";
    }
    
    if (!self.companyOrShop) {
        self.area = self.siteModel.ccAcreage;
    }
    else{
        self.area = self.mainSiteModel.ccAcreage;
    }
    self.area = [self.area stringByReplacingOccurrencesOfString:@"㎡" withString:@""];
    if (!self.area||self.area.length<=0) {
        self.area = @"";
    }
    
    if (!self.companyOrShop) {
        self.signStr = self.siteModel.ccCreateDate;
    }
    else{
        self.signStr = self.mainSiteModel.ccCreateDate;
    }
    if (!self.signStr||self.signStr.length<=0) {
        self.signStr = @"";
    }
    else{
        if (!self.companyOrShop){
            self.signStr = [self timeWithTimeIntervalString:self.signStr];
        }
        
    }
    
    
    if (!self.companyOrShop) {
        self.beginStr = self.siteModel.ccSrartTime;
    }
    else{
        self.beginStr = self.mainSiteModel.ccSrartTime;
    }
    if (!self.beginStr||self.beginStr.length<=0) {
        self.beginStr = @"";
    }
    else{
        if (!self.companyOrShop){
            self.beginStr = [self timeWithTimeIntervalString:self.beginStr];
        }
        
    }
    
    if (!self.companyOrShop) {
        self.endStr = self.siteModel.ccCompleteDate;
    }
    else{
        self.endStr = self.mainSiteModel.ccCompleteDate;
    }
    if (!self.endStr||self.endStr.length<=0) {
        self.endStr = @"";
    }
    else{
        if (!self.companyOrShop){
            self.endStr = [self timeWithTimeIntervalString:self.endStr];
        }
        
    }
    
    CGFloat h = self.coverImgV.bottom;
    
    if (!self.companyOrShop) {
        //company
        
        NSArray *leftArray = @[@"户主",@"地址",@"标签",@"选择小区",@"分享标题",@"施工单位",@"装修风格",@"房屋面积"];
        NSArray *rightArray = @[self.userName,self.addressStr,self.label?:@"",self.socialName,self.shareTitle,self.ConstructionName,self.style,self.area];
        for (int i = 0; i<8; i++) {
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 60, 40)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize
                          :14];

            leftL.textAlignment = NSTextAlignmentLeft;
            
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
           
            textF.font = NB_FONTSEIZ_NOR;
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            textF.text = rightArray[i];
            if (i==3) {
                textF.hidden = YES;
                self.xiaoquBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.xiaoquBtn.frame = textF.frame;
                if (self.socialName.length<=0) {
                    [self.xiaoquBtn setTitle:@"请选择小区" forState:UIControlStateNormal];
                }
                else{
                    [self.xiaoquBtn setTitle:self.socialName forState:UIControlStateNormal];
                }
                self.xiaoquBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.xiaoquBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.xiaoquBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                
                [self.xiaoquBtn addTarget:self action:@selector(chooseXiaoquClick) forControlEvents:UIControlEventTouchUpInside];
                
                [self.srcV addSubview:self.xiaoquBtn];
                
            }
            if (i==2) {
                textF.hidden = YES;
                self.labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.labelBtn.frame = textF.frame;
                if (self.self.label.length<=0) {
                    [self.labelBtn setTitle:@"请选择标签" forState:UIControlStateNormal];
                }
                else{
                    [self.labelBtn setTitle:self.label forState:UIControlStateNormal];
                }
                self.labelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.labelBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.labelBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                
                [self.labelBtn addTarget:self action:@selector(chooseXiaoquClick) forControlEvents:UIControlEventTouchUpInside];
                
                [self.srcV addSubview:self.labelBtn];
                
                [textF setHidden:YES];
                
            }
            
            if (i == 5) {
    
                textF.userInteractionEnabled = NO;
            }
            
            if (i == 7) {
                textF.frame = CGRectMake(leftL.right+20, leftL.top, 60, leftL.height);
                
                    textF.keyboardType = UIKeyboardTypeNumberPad;
                
                UILabel *areaL = [[UILabel alloc]initWithFrame:CGRectMake(textF.right, leftL.top+10, 20, 20)];
                areaL.text = @"㎡";
                areaL.textColor = COLOR_BLACK_CLASS_3;
                areaL.font = [UIFont systemFontOfSize
                              :14];

                areaL.textAlignment = NSTextAlignmentLeft;
                [self.srcV addSubview:areaL];
            }

            if (i == 1) {
                textF.hidden = YES;
  
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                if (self.addressStr.length<=0) {
                    [_addressBtn setTitle:@"请仔细填写至区县" forState:UIControlStateNormal];
                }
                else{
                    [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                }
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                
                [_addressBtn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
           
                [self.srcV addSubview:self.addressBtn];
            }
            
            if (i==3) {
                textF.hidden = YES;
//                if (!_shareTitleTv) {
//
//                    _shareTitleTv = [[PlaceHolderTextView alloc]initWithFrame:CGRectMake(15+60+20, h+5, kSCREEN_WIDTH-15-60-20, 25)];
//                    _shareTitleTv.placeHolderColor = [UIColor lightGrayColor];
//                    _shareTitleTv.font = [UIFont systemFontOfSize:14];
//                    _shareTitleTv.textColor = COLOR_BLACK_CLASS_3;
//                    _shareTitleTv.tag = i;
//                    _shareTitleTv.delegate = self;
//                    _shareTitleTv.text = self.shareTitle;
//                }
 
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:self.shareTitleTv];

            }
            else{
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:textF];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = COLOR_BLACK_CLASS_0;
            
            [self.srcV addSubview:lineV];
            
            h = h + 40;
            
            
        }
    }
    
    else{
        //shop
        
        NSArray *leftArray = @[@"户主",@"地址",@"标签",@"选择小区",@"分享标题",@"施工单位",@"房屋面积"];
        NSArray *rightArray = @[self.userName,self.addressStr,self.label?:@"",self.socialName,self.shareTitle,self.ConstructionName,self.area];
        for (int i = 0; i<6; i++) {
            UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 60, 40)];
            leftL.text = leftArray[i];
            leftL.textColor = COLOR_BLACK_CLASS_3;
            leftL.font = [UIFont systemFontOfSize
                          :14];
            //        companyJob.backgroundColor = Red_Color;
            leftL.textAlignment = NSTextAlignmentLeft;
            
            
            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height)];
            textF.textColor = COLOR_BLACK_CLASS_3;
            //        textF.placeholder = rightArray[i];
            textF.font = NB_FONTSEIZ_NOR;
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            
            [textF addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            [textF addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventAllEvents];
            textF.tag = i;
            textF.text = rightArray[i];
            if (i==3) {
                textF.hidden = YES;
                self.xiaoquBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.xiaoquBtn.frame = textF.frame;
                if (self.socialName.length<=0) {
                    [self.xiaoquBtn setTitle:@"请选择小区" forState:UIControlStateNormal];
                }
                else{
                    [self.xiaoquBtn setTitle:self.socialName forState:UIControlStateNormal];
                }
                self.xiaoquBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.xiaoquBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.xiaoquBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [self.xiaoquBtn addTarget:self action:@selector(chooseXiaoquClick) forControlEvents:UIControlEventTouchUpInside];
                [self.srcV addSubview:self.xiaoquBtn];
            }
            if (i==2) {
                textF.hidden = YES;
                self.labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.labelBtn.frame = textF.frame;
                if (self.self.label.length<=0) {
                    [self.labelBtn setTitle:@"请选择标签" forState:UIControlStateNormal];
                }
                else{
                    [self.labelBtn setTitle:self.label forState:UIControlStateNormal];
                }
                self.labelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [self.labelBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                self.labelBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [self.labelBtn addTarget:self action:@selector(chooselabelbtnclick) forControlEvents:UIControlEventTouchUpInside];
                [self.srcV addSubview:self.self.labelBtn];
                [textF setHidden:YES];
            }
            
            if (i == 4) {
                
                textF.userInteractionEnabled = NO;
            }

            if (i == 1) {
                textF.hidden = YES;
                _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _addressBtn.frame = textF.frame;
                if (self.addressStr.length<=0) {
                    [_addressBtn setTitle:@"请仔细填写至区县" forState:UIControlStateNormal];
                }
                else{
                    [_addressBtn setTitle:self.addressStr forState:UIControlStateNormal];
                }
                _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_addressBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [_addressBtn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
                [self.srcV addSubview:self.addressBtn];
            }
            if (i==4) {
                textF.hidden = YES;
                if (!_shareTitleTv) {
                    
                    _shareTitleTv = [[PlaceHolderTextView alloc]initWithFrame:CGRectMake(15+60+20, h+5, kSCREEN_WIDTH-15-60-20, 25)];
                    _shareTitleTv.placeHolderColor = [UIColor lightGrayColor];
                    _shareTitleTv.font = [UIFont systemFontOfSize:14];
                    _shareTitleTv.textColor = COLOR_BLACK_CLASS_3;
                    _shareTitleTv.tag = i;
                    _shareTitleTv.delegate = self;
                    _shareTitleTv.text = self.shareTitle;
                }

                [self.srcV addSubview:leftL];
                [self.srcV addSubview:self.shareTitleTv];
 
            }
            
            if (i == 6) {
                textF.frame = CGRectMake(leftL.right+20, leftL.top, 60, leftL.height);
                textF.keyboardType = UIKeyboardTypeNumberPad;
                UILabel *areaL = [[UILabel alloc]initWithFrame:CGRectMake(textF.right, leftL.top+10, 20, 20)];
                areaL.text = @"㎡";
                areaL.textColor = COLOR_BLACK_CLASS_3;
                areaL.font = [UIFont systemFontOfSize
                              :14];
                areaL.textAlignment = NSTextAlignmentLeft;
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:textF];
                [self.srcV addSubview:areaL];
            }
            
            else{
                [self.srcV addSubview:leftL];
                [self.srcV addSubview:textF];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
            lineV.backgroundColor = COLOR_BLACK_CLASS_0;
            
            [self.srcV addSubview:lineV];
            
            h = h + 40;
            
            
        }
    }

    //创建3个时间选择控件
    for (int i = 0; i<3; i++) {
        NSArray *leftArray = @[@"签约日期",@"开工日期",@"竣工日期"];
        NSArray *leftArrayTwo = @[@"测量日期",@"下单日期",@"安装日期"];
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, h, 60, 40)];
        if (!self.companyOrShop) {
            leftL.text = leftArray[i];
        }
        else{
            leftL.text = leftArrayTwo[i];
        }
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = [UIFont systemFontOfSize
                      :14];
        leftL.textAlignment = NSTextAlignmentLeft;
        [self.srcV addSubview:leftL];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, leftL.bottom-1, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = COLOR_BLACK_CLASS_0;
        
        [self.srcV addSubview:lineV];
        if (i == 0) {
            _signTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _signTimeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
            [_signTimeBtn setTitle:self.signStr forState:UIControlStateNormal];
            _signTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_signTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            _signTimeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
            _signTimeBtn.tag = i;
            [_signTimeBtn addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
            [self.srcV addSubview:self.signTimeBtn];
        }
        
        if (i == 1) {
            _beginTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _beginTimeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
            [_beginTimeBtn setTitle:self.beginStr forState:UIControlStateNormal];
            _beginTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_beginTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            _beginTimeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
            _beginTimeBtn.tag = i;
            [_beginTimeBtn addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
            [self.srcV addSubview:self.beginTimeBtn];
        }
        
        if (i == 2) {
            _endTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _endTimeBtn.frame = CGRectMake(leftL.right+20, leftL.top, kSCREEN_WIDTH-leftL.right-20, leftL.height);
            [_endTimeBtn setTitle:self.endStr forState:UIControlStateNormal];
            _endTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            _endTimeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
            _endTimeBtn.tag = i;
            [_endTimeBtn addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventTouchUpInside];
            [self.srcV addSubview:self.endTimeBtn];
        }
        
        h = h+40;
        
    }
    
    _successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _successBtn.frame = CGRectMake(30,h+30,kSCREEN_WIDTH-60,40);
    //            [_beginTimeBtn setTitle:@"请仔细填写至区县" forState:UIControlStateNormal];
    _successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    _successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
    //    _beginTimeBtn.tag = i;
    [_successBtn setTitle:@"完    成" forState:UIControlStateNormal];
    [_successBtn addTarget:self action:@selector(successTouch) forControlEvents:UIControlEventTouchUpInside];
    _successBtn.backgroundColor = Main_Color;
    [self.srcV addSubview:self.successBtn];
    [self.view addSubview:self.regionView];
    
    self.srcV.contentSize = CGSizeMake(kSCREEN_WIDTH, self.successBtn.bottom+20);
}

-(void)getRegion{
    [self.view endEditing:YES];
    self.regionView.hidden = NO;
    
    __weak ModifyConstructionController *weakSelf = self;
    
    self.regionView.selectBlock = ^(NSMutableArray *array){
        
        weakSelf.regionView.hidden = YES;
        weakSelf.pmodel = [array objectAtIndex:0];
        weakSelf.cmodel = [array objectAtIndex:1];
        weakSelf.dmodel = [array objectAtIndex:2];
        
        weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.pmodel.name,weakSelf.cmodel.name,weakSelf.dmodel.name];
        
        weakSelf.provinceStr = weakSelf.pmodel.regionId;
        weakSelf.cityStr = weakSelf.cmodel.regionId;
        weakSelf.areaStr = weakSelf.dmodel.regionId;
        
        NSInteger regionId = [weakSelf.pmodel.regionId integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
            weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@",weakSelf.pmodel.name,weakSelf.dmodel.name];
            weakSelf.areaStr = @"-1";
        }
        
        
        
        //        [weakSelf.editTableView reloadData];
        [weakSelf.addressBtn setTitle:weakSelf.addressStr forState:UIControlStateNormal];
        
    };
    
}

-(void)changeAddress{
    [self getRegion];
}

-(void)changeTime:(UIButton *)btn{
    self.regionView.hidden = YES;
    WWPickerView *pickerView = [[WWPickerView alloc] init];
    [self.view endEditing:YES];
    [pickerView setDateViewWithTitle:@[@"签约日期:",@"开工日期:",@"竣工日期:"][btn.tag] withMode:UIDatePickerModeDate];
    [pickerView showPickView:self];
    
    //block回调
    __weak typeof (self) wself = self;
    pickerView.block = ^(NSString *selectedStr)
    {
        //格式化当前日期,并作出比较
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
        if (btn.tag == 0) {
            [wself.signTimeBtn setTitle:selectedStr forState:UIControlStateNormal];
            wself.signStr = selectedStr;
        }
        else if (btn.tag == 1) {
            [wself.beginTimeBtn setTitle:selectedStr forState:UIControlStateNormal];
            wself.beginStr = selectedStr;
        }
        else{
            [wself.endTimeBtn setTitle:selectedStr forState:UIControlStateNormal];
            wself.endStr = selectedStr;
        }
        
        
    };
    
}

-(void)back{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑"
                                                    message:@"是否确定退出编辑？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)successTouch{
    [self.view endEditing:YES];
    
    
    if (self.coverStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"封面图不能为空" controller:self sleep:1.0];
        return;
    }
    self.userName = [self.userName ew_removeSpacesAndLineBreaks];
    self.userName = [self.userName ew_removeSpaces];
    if (self.userName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"姓名不能为空" controller:self sleep:1.0];
        return;
    }
    self.addressStr = [self.addressStr ew_removeSpacesAndLineBreaks];
    self.addressStr = [self.addressStr ew_removeSpaces];
    if (self.addressStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"地址不能为空" controller:self sleep:1.0];
        return;
    }
    self.socialName = [self.socialName ew_removeSpacesAndLineBreaks];
    self.socialName = [self.socialName ew_removeSpaces];
    if (self.socialName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"小区名称不能为空" controller:self sleep:1.0];
        return;
    }
    
    self.shareTitle = self.shareTitleTv.text;
    self.shareTitle = [self.shareTitle ew_removeSpaces];
    if (self.shareTitle.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"分享标题不能为空" controller:self sleep:1.0];
        return;
    }
    self.signStr = [self.signStr ew_removeSpacesAndLineBreaks];
    self.signStr = [self.signStr ew_removeSpaces];
    if (!self.signStr||self.signStr.length<=0) {
        self.signStr = @"";
    }
    
    self.style = [self.style ew_removeSpacesAndLineBreaks];
    self.style = [self.style ew_removeSpaces];
    self.area = [self.area ew_removeSpacesAndLineBreaks];
    self.area = [self.area ew_removeSpaces];
    if (!self.companyOrShop) {
        if (!self.style||self.style.length<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"装修风格不能为空" controller:self sleep:1.0];
            return;
        }

    }
    else{
        if (!self.style||self.style.length<=0) {
            self.style = @"";
        }

    }
    
    if (!self.area||self.area.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"房屋面积不能为空" controller:self sleep:1.0];
        return;
    }
    
    if (self.area &&self.area.length>0) {
        BOOL check = [self.area ew_checkNumber];
        if (!check) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"面积只能输入数字" controller:self sleep:1.0];
            return;
        }
    }
    
    self.beginStr = [self.beginStr ew_removeSpacesAndLineBreaks];
    self.beginStr = [self.beginStr ew_removeSpaces];
    self.endStr = [self.endStr ew_removeSpacesAndLineBreaks];
    self.endStr = [self.endStr ew_removeSpaces];
    if (self.beginStr.length<=0) {
        if (!self.companyOrShop) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"开工日期不能为空" controller:self sleep:1.0];
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"下单日期不能为空" controller:self sleep:1.0];
        }
        return;
    }
    if (self.endStr.length<=0) {
        if (!self.companyOrShop) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"竣工日期不能为空" controller:self sleep:1.0];
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"安装日期不能为空" controller:self sleep:1.0];
        }
        return;
    }
    
    
    NSString *ccConstructionNodeIdStr;
    if (!self.companyOrShop) {
        ccConstructionNodeIdStr = self.siteModel.ccConstructionNodeId;
    }
    else{
        ccConstructionNodeIdStr = self.mainSiteModel.ccConstructionNodeId;
    }
    
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!self.companyOrShop) {
        NSString *requestString = [BASEURL stringByAppendingString:@"construction/editConstruction.do"];
        NSDictionary *dic = @{@"houseHolderName":self.userName,
                              @"address":self.addressStr,
                              @"housingEstateName":self.socialName,
                              @"signingTime":self.signStr,
                              @"ccSrartTime":self.beginStr,
                              @"completionDate":self.endStr,
                              @"ccBuilder":self.ConstructionName,
                              @"ccShareTitle":self.shareTitle,
                              @"ccConstructionNodeId":ccConstructionNodeIdStr,
                              @"id":@(self.consID),
                              @"ccHouseholderId":@(user.agencyId),
                              @"ccComplete":@(self.ccComplete),
                              @"province":self.provinceStr,
                              @"city":self.cityStr,
                              @"area":self.areaStr,
                              @"ccAcreage":self.area,
                              @"coverMap":self.coverStr,
                              @"style":self.style,
                              @"label":self.label?:@""
                              };
        //    NSDictionary *dic = @{@"companyId":@267};
        [self.view hudShow];
        [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
            [self.view hiddleHud];
            NSLog(@"%@",responseObj);
            if ([responseObj[@"code"] isEqualToString:@"1000"]) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
                if (!self.companyOrShop) {
                    //修改施工日志的工地信息的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"modifyContrctInfo" object:nil];
                }
                else{
                    //修改主材日志的工地信息的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"modifyMatiralInfo" object:nil];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"修改失败，请重试" controller:self sleep:1.5];
            }
            //        [_mainTableView reloadData];
        } failed:^(NSString *errorMsg) {
            [self.view hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }];
    }
    else{
        NSString *requestString = [BASEURL stringByAppendingString:@"construction/updateById.do"];
        NSDictionary *dic = @{@"ccHouseholderName":self.userName,
                              @"ccAddress":self.addressStr,
                              @"province":self.provinceStr,
                              @"city":self.cityStr,
                              @"area":self.areaStr,
                              
                              @"ccAreaName":self.socialName,
                              @"ccShareTitle":self.shareTitle,
                              @"ccBuilder":self.ConstructionName,
                              @"ccCreateDate":self.signStr,
                              @"ccSrartTime":self.beginStr,
                              @"ccCompleteDate":self.endStr,
                              @"coverMap":self.coverStr,
                              @"id":@(self.consID),
                              @"ccAcreage":self.area,
                              @"label":self.label?:@""
                              };
        //    NSDictionary *dic = @{@"companyId":@267};
        [self.view hudShow];
        [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
            [self.view hiddleHud];
            NSLog(@"%@",responseObj);
            if ([responseObj[@"code"] isEqualToString:@"1000"]) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
                if (!self.companyOrShop) {
                    //修改施工日志的工地信息的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"modifyContrctInfo" object:nil];
                }
                else{
                    //修改主材日志的工地信息的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"modifyMatiralInfo" object:nil];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([responseObj[@"code"] isEqualToString:@"1002"]){
                [[PublicTool defaultTool] publicToolsHUDStr:@"工地不存在" controller:self sleep:1.5];
            }
            else if ([responseObj[@"code"] isEqualToString:@"2000"]){
                [[PublicTool defaultTool] publicToolsHUDStr:@"修改失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"修改失败" controller:self sleep:1.5];
            }
            //        [_mainTableView reloadData];
        } failed:^(NSString *errorMsg) {
            [self.view hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }];
    }
    
}

#pragma mark - textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.regionView.hidden = YES;
    YSNLog(@"%ld",textField.tag);
    if (!self.companyOrShop) {
        if (textField.tag == 3) {
            
            CGSize size = [self.shareTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
        }
    }
    else{
        if (textField.tag == 3) {
            CGSize size = [self.shareTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (!self.companyOrShop) {
        if (textField.tag == 3) {
            CGSize size = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
        }
    }
    else{
        if (textField.tag == 3) {
            CGSize size = [textField.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) withFont:NB_FONTSEIZ_NOR];
            if (size.width<=(kSCREEN_WIDTH-15-60-20)) {
                size.width = kSCREEN_WIDTH-15-60-20;
            }
        }
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        self.userName = textField.text;
    }
    if (textField.tag == 2) {
        self.socialName = textField.text;
    }
    if (textField.tag == 4) {
        self.shareTitle = textField.text;
    }
    if (textField.tag == 6) {
        if (self.companyOrShop) {
            self.style = textField.text;
        }
        
    }
    
    if (!self.companyOrShop){
        if (textField.tag == 6) {
            self.area = textField.text;
        }
    }
    else{
        if (textField.tag == 5) {
            self.area = textField.text;
        }
    }
    
}

#pragma mark - action

-(void)changePhoto{
//    isHavePhoto = YES;
    [self imagePicker];
}

-(void)setFirstPhoto{
//    isHavePhoto = NO;
    [self imagePicker];
}


#pragma mark - 上传图片相关

-(void)imagePicker{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = NO;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    //自定义裁剪方式
    UIImage*image = [self turnImageWithInfo:info];
    CGSize tempSize = CGSizeMake(kSCREEN_WIDTH, 200);
    HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                     resultImgSize:tempSize clipperType:ClipperTypeImgMove];
    
    __weak typeof(self)weakSelf = self;
    clipperVC.cancelClippedHandler = ^(){
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    clipperVC.successClippedHandler = ^(UIImage *clippedImage){
        __strong typeof(self)strongSelf = weakSelf;
        
//        NSData *imageData = UIImageJPEGRepresentation(clippedImage, PHOTO_COMPRESS);
        NSData *imageData = [NSObject imageData:clippedImage];
        
        if ([imageData length] >0) {
            imageData = [GTMBase64 encodeData:imageData];
        }
        NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
        
        [strongSelf uploadImageWithBase64Str:imageStr];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [picker pushViewController:clipperVC animated:YES];

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
            NSString *photoUrl = [dic objectForKey:@"imageUrl"];
            self.coverStr = photoUrl;
            self.placeHolderImgV.hidden = YES;
            [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil];
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
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

#pragma mark - setter

-(UIScrollView *)srcV{
    if (!_srcV) {
        _srcV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        //        _srcV.backgroundColor = Red_Color;
    }
    return _srcV;
}

-(UIImageView *)coverImgV{
    if (!_coverImgV) {
        _coverImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        //        _coverImgV.image = [UIImage imageNamed:@"upload_logo.png"];
        
        _coverImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto)];
        [_coverImgV addGestureRecognizer:ges];
        _coverImgV.layer.masksToBounds = YES;
        _coverImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImgV;
}

-(UIImageView *)placeHolderImgV{
    if (!_placeHolderImgV) {
        _placeHolderImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _placeHolderImgV.image = [UIImage imageNamed:@"upload_logo.png"];
        //        [_placeHolderImgV sizeToFit];
        _placeHolderImgV.left = self.coverImgV.width/2-_placeHolderImgV.width/2;
        _placeHolderImgV.top = self.coverImgV.height/2-_placeHolderImgV.height/2;
        _placeHolderImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setFirstPhoto)];
        [_placeHolderImgV addGestureRecognizer:ges];
    }
    return _placeHolderImgV;
}

-(RegionView *)regionView{
    if (!_regionView) {
        _regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
        _regionView.closeBtn.hidden = NO;
        _regionView.hidden = YES;
    }
    return _regionView;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

-(void)chooselabelbtnclick
{
    selectsitetagsVC *vc = [selectsitetagsVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick:(NSMutableArray *)array
{
    self.label = [array componentsJoinedByString:@","]?:@"";
    [self.labelBtn setTitle:self.label forState:normal];
}

-(void)chooseXiaoquClick
{
    localcommunityVC *vc = [localcommunityVC new];
    vc.isfromsite = YES;
    vc.returnValueBlock = ^(NSString *passedValue){
        
        self.socialName = passedValue;
        [self.xiaoquBtn setTitle:self.socialName?:@"" forState:normal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
