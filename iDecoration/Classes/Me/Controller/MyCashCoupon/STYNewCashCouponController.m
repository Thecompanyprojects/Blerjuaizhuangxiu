//
//  STYNewCashCouponController.m
//  iDecoration
//
//  Created by sty on 2018/2/5.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "STYNewCashCouponController.h"
#import "WWPickerView.h"
#import "WSDatePickerView.h"
#import "LocationViewController.h"

#import "PellTableViewSelect.h"
#import "ZCHAllGetRecordCouponController.h"
#import "ZCHPublicWebViewController.h"
#import "LYShareMenuView.h"

@interface STYNewCashCouponController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,LYShareMenuViewDelegate>{
    BOOL isSpecial;// no:普通代金券。yes：手气代金券
    
    BOOL _isCanEdit;//是否可以编辑
}

// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) UITextField *startTimeTextF;
@property (nonatomic, strong) UITextField *endTimeTextF;
@property (nonatomic, strong) UITextField *ScopeTextF;
@property (nonatomic, strong) UITextField *AddressTextF;
@property (nonatomic, strong) UITextView *remarkTextV;
@property (nonatomic, strong) UILabel *placeHolderL;
@property (nonatomic, strong) LYShareMenuView *shareMenuView;
@end

@implementation STYNewCashCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"促销代金券";
    if (!self.isEdit) {
        isSpecial = NO;
    }
    else{
        if (![self.CouponType integerValue]) {
            isSpecial = NO;
        }
        else{
            isSpecial = YES;
        }
        
        if (self.ischoose) {
            // 设置导航栏最右侧的按钮
            UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            moreBtn.frame = CGRectMake(0, 0, 44, 44);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"threemorewithe"]];
            [moreBtn addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(0);
                make.centerY.equalTo(0);
                make.size.equalTo(CGSizeMake(25, 25));
            }];
            [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
            
            [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
        }
        else
        {
            UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            shareBtn.frame = CGRectMake(0, 0, 44, 44);
            [shareBtn setTitle:@"分享" forState:normal];
            shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [shareBtn addTarget:self action:@selector(sharebtnclick) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        }
        
        
       
    }
    if (self.CouponScopeStr&&self.CouponScopeStr.length>0) {
        self.CouponScopeStr = [self.CouponScopeStr stringByAppendingString:@"公里"];
    }
    [self setUI];
    [self setupshare];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:self.remarkTextV];
}


-(void)setUI{
    
    BOOL isEnabled = NO;
    if (!self.isEdit) {
        isEnabled = YES;
    }
    else{
        isEnabled = _isCanEdit;
    }
    [self.view removeAllSubViews];
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom)];
    
    [self.view addSubview:scrollV];
    
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 130)];
    topV.backgroundColor = RGB(207, 185, 68);
    [scrollV addSubview:topV];
    
    UIImageView *redImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 110, 130)];
    redImgV.centerY = topV.centerY;
    redImgV.image = [UIImage imageNamed:@"red_packet"];
    [topV addSubview:redImgV];
    
    UILabel *specialL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-90-20, redImgV.top+10, 90, 20)];
    
    specialL.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCashType:)];
    [specialL addGestureRecognizer:ges];
    
    specialL.userInteractionEnabled = isEnabled;
    
//    specialL.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"改为" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName: White_Color} ];
    
    NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:@"手气代金券" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: Blue_Color} ];
    
    NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"普通代金券" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: Blue_Color} ];
    
    [tempAttrStringTwo addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 5)];
    [tempAttrStringThree addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 5)];
    
    if (!isSpecial) {
        //普通代金券
        [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
    }
    else{
        //手气代金券
        [tempAttrStringOne appendAttributedString:tempAttrStringThree];
    }
    
    
    
    
    specialL.attributedText = tempAttrStringOne;
    [topV addSubview:specialL];
    
    NSString *cashStr;
    
    if (!isSpecial) {
        //普通代金券
        cashStr = @"普通代金券";
    }
    else{
        //手气代金券
        cashStr = @"手气代金券";
    }
    UILabel *orinalL = [[UILabel alloc]initWithFrame:CGRectMake(specialL.left-123, redImgV.top, 123, 30)];
    orinalL.text = cashStr;
    orinalL.textColor = White_Color;
    orinalL.font = [UIFont systemFontOfSize:24];
    orinalL.textAlignment = NSTextAlignmentLeft;
    [topV addSubview:orinalL];
    
    UILabel *placeHoderL = [[UILabel alloc]initWithFrame:CGRectMake(orinalL.left+2, orinalL.bottom+20, topV.width-orinalL.left-2, 20)];
    placeHoderL.text = !isSpecial?@"普通代金券：每人领取固定金额的代金券":@"手气代金券：每人领取代金券的金额随机";
    placeHoderL.textColor = White_Color;
    placeHoderL.font = NB_FONTSEIZ_TINE;
    placeHoderL.textAlignment = NSTextAlignmentLeft;
    [topV addSubview:placeHoderL];
    
    UIImageView *ExplainImgV = [[UIImageView alloc]initWithFrame:CGRectMake(placeHoderL.left+3, redImgV.bottom-5-15, 15, 15)];
//    ExplainImgV.centerY = topV.centerY;
    ExplainImgV.image = [UIImage imageNamed:@"question"];
    [topV addSubview:ExplainImgV];
    
    //使用说明
    UILabel *ExplainL = [[UILabel alloc]initWithFrame:CGRectMake(ExplainImgV.right, ExplainImgV.top, 150, ExplainImgV.height)];
    NSString *temStr = !isSpecial?@"普通代金券使用攻略":@"手气代金券使用攻略";
    NSMutableAttributedString *ExplainAttrStringOne = [[NSMutableAttributedString alloc] initWithString:temStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
    [ExplainAttrStringOne addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, temStr.length)];
    ExplainL.attributedText = ExplainAttrStringOne;
    
    ExplainL.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goInstructionsVc)];
    [ExplainL addGestureRecognizer:gesTwo];
    
    [topV addSubview:ExplainL];
    
    
    
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, topV.bottom, kSCREEN_WIDTH, scrollV.height-topV.height)];
    bottomV.backgroundColor = RGB(242, 243, 248);
    [scrollV addSubview:bottomV];
    CGFloat topX = 0;
    NSString *temFaceStr;
    if (!isSpecial) {
        temFaceStr = @"单 个 面 值：";
    }
    else{
        temFaceStr = @"总   面   值：";
    }
    NSArray *leftArray = @[@"代金券名称：",@"发 行 数 量：",temFaceStr,@"生 效 时 间：",@"过 期 时 间：",@"领 取 范 围：",@"领 取 地 点："];
    NSArray *rightArray = @[@"不超过8个字",@"请输入发行数量：",@"请输入面值：",@"",@"",@"请选择领取范围",@""];
    for (int i = 0 ; i<leftArray.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, topX, kSCREEN_WIDTH, 45)];
//        view.backgroundColor = UIRandomColor;
        [bottomV addSubview:view];
        
        
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, view.height)];
        leftL.text = leftArray[i];
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = NB_FONTSEIZ_NOR;
        leftL.textAlignment = NSTextAlignmentCenter;
        [view addSubview:leftL];
        
        
        UITextField *rightTextF = [[UITextField alloc]initWithFrame:CGRectMake(leftL.right, 0, view.width-leftL.right, view.height)];
        rightTextF.textColor = COLOR_BLACK_CLASS_3;
        rightTextF.font = NB_FONTSEIZ_NOR;
        rightTextF.placeholder = rightArray[i];
        rightTextF.tag = i;
        rightTextF.delegate = self;
        [rightTextF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [view addSubview:rightTextF];
        
        if (i==0) {
            if (self.CouponNameStr) {
                rightTextF.text = self.CouponNameStr;
            }
        }
        
        //
//        NSString *str = leftArray[i];
        if (i==1) {
            rightTextF.frame = CGRectMake(leftL.right, 0, view.width-leftL.right-50, view.height);
            rightTextF.keyboardType = UIKeyboardTypeNumberPad;
            //个
            UILabel *geL = [[UILabel alloc]initWithFrame:CGRectMake(view.width-50, 0, 50, view.height)];
            geL.text = @"个";
            geL.textColor = COLOR_BLACK_CLASS_3;
            geL.font = NB_FONTSEIZ_NOR;
            geL.textAlignment = NSTextAlignmentLeft;
            [view addSubview:geL];
            
            if (self.CouponNumStr) {
                rightTextF.text = self.CouponNumStr;
            }
//            self.numTextF = rightTextF;
        }
        if (i==2) {
            rightTextF.frame = CGRectMake(leftL.right, 0, view.width-leftL.right-50, view.height);
            rightTextF.keyboardType = UIKeyboardTypeNumberPad;
            //个
            UILabel *geL = [[UILabel alloc]initWithFrame:CGRectMake(view.width-50, 0, 50, view.height)];
            geL.text = @"元";
            geL.textColor = COLOR_BLACK_CLASS_3;
            geL.font = NB_FONTSEIZ_NOR;
            geL.textAlignment = NSTextAlignmentLeft;
            [view addSubview:geL];
//            self.FaceValueTextF = rightTextF;
            if (self.CouponFaceValueStr) {
                rightTextF.text = self.CouponFaceValueStr;
            }
        }
        if (i==3||i==4) {
            rightTextF.userInteractionEnabled = NO;
            UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            timeBtn.frame = rightTextF.frame;
            timeBtn.backgroundColor = Clear_Color;
            timeBtn.tag = i;
            [timeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:timeBtn];
            
            timeBtn.userInteractionEnabled = isEnabled;
            
            if (i==3) {
                self.startTimeTextF = rightTextF;
                
                if (self.CouponStartTimeStr) {
                    rightTextF.text = self.CouponStartTimeStr;
                }
            }
            else{
                self.endTimeTextF = rightTextF;
                
                if (self.CouponEndTimeStr) {
                    rightTextF.text = self.CouponEndTimeStr;
                }
            }
        }
        if (i==5) {
            rightTextF.userInteractionEnabled = NO;
            UIButton *scropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            scropBtn.frame = rightTextF.frame;
            scropBtn.backgroundColor = Clear_Color;
            [scropBtn addTarget:self action:@selector(scropBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:scropBtn];
            scropBtn.userInteractionEnabled = isEnabled;
            if (self.CouponScopeStr&&self.CouponScopeStr.length>0) {
                rightTextF.text = self.CouponScopeStr;
            }
            
            self.ScopeTextF = rightTextF;
        }
        if (i==6) {
            rightTextF.frame = CGRectMake(leftL.right, 0, view.width-leftL.right-50, view.height);
            UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(view.width-50,(view.height-30)/2,30, 30)];
            locationButton.centerY = rightTextF.centerY;
            locationButton.contentMode = UIViewContentModeScaleAspectFit;
            [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
            [view addSubview:locationButton];
            locationButton.userInteractionEnabled = isEnabled;
            if (self.CouponAddressStr) {
                rightTextF.text = self.CouponAddressStr;
            }
            self.AddressTextF = rightTextF;
        }
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
        lineV.backgroundColor = kSepLineColor;
        [view addSubview:lineV];
        
        topX = topX+view.height;
        
        rightTextF.userInteractionEnabled = isEnabled;
    }
    UILabel *remarkL = [[UILabel alloc]initWithFrame:CGRectMake(15, topX, 60, 30)];
    remarkL.text = @"备  注：";
    remarkL.textColor = COLOR_BLACK_CLASS_3;
    remarkL.font = NB_FONTSEIZ_NOR;
    remarkL.textAlignment = NSTextAlignmentLeft;
    [bottomV addSubview:remarkL];
    
    UITextView *remarkTextV = [[UITextView alloc]initWithFrame:CGRectMake(15, remarkL.bottom, bottomV.width-15*2, 100)];
    remarkTextV.font = NB_FONTSEIZ_NOR;
    remarkTextV.textColor = COLOR_BLACK_CLASS_3;
    remarkTextV.delegate = self;
    [bottomV addSubview:remarkTextV];
    
    if (self.CouponRemarks) {
        remarkTextV.text = self.CouponRemarks;
    }
    
    self.remarkTextV = remarkTextV;
    
    self.remarkTextV.userInteractionEnabled = isEnabled;
    
    UILabel *placeHolderL = [[UILabel alloc]initWithFrame:CGRectMake(remarkTextV.left+5, remarkTextV.top+4, 200, 25)];
    placeHolderL.text = @"请输入内容(不超过100个字)";
    placeHolderL.textColor = COLOR_BLACK_CLASS_9;
    placeHolderL.font = NB_FONTSEIZ_NOR;
    placeHolderL.textAlignment = NSTextAlignmentLeft;
    [bottomV addSubview:placeHolderL];
    self.placeHolderL = placeHolderL;
    
    if (self.CouponRemarks&&self.CouponRemarks.length>0) {
        self.placeHolderL.hidden = YES;
    }
    
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(remarkTextV.left+5, remarkTextV.bottom, bottomV.width-remarkTextV.left-5-5, 30)];
    tipL.text = @"提示：本代金券只能在领取地点内领取";
    tipL.textColor = Red_Color;
    tipL.font = NB_FONTSEIZ_SMALL;
    tipL.textAlignment = NSTextAlignmentLeft;
    [bottomV addSubview:tipL];
    
    UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    successBtn.frame = CGRectMake(60,tipL.bottom+20,kSCREEN_WIDTH-60*2,40);
    successBtn.backgroundColor = Main_Color;
    [successBtn setTitle:@"完     成" forState:UIControlStateNormal];
    successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    successBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    successBtn.layer.masksToBounds = YES;
    successBtn.layer.cornerRadius = 5;
    [successBtn addTarget:self action:@selector(pushData:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:successBtn];
    
    
    if ((successBtn.bottom)>=bottomV.height) {
        bottomV.frame = CGRectMake(0, topV.bottom, kSCREEN_WIDTH, successBtn.bottom);
        scrollV.contentSize = CGSizeMake(kSCREEN_WIDTH, bottomV.height+topV.height+10);
    }
    successBtn.hidden = !isEnabled;
    scrollV.backgroundColor = RGB(242, 243, 248);
    
}

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}

#pragma mark - 三点按钮
- (void)moreBtnClicked:(UIButton *)sender {
    
    // 弹出的自定义视图
    NSArray *array = @[@"领取记录",@"编辑",@"分享"];
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        
        NSString *contStr = array[index];
        if ([contStr isEqualToString:@"领取记录"]) {
            ZCHAllGetRecordCouponController *vc = [[ZCHAllGetRecordCouponController alloc]init];
            vc.companyId = self.companyId;
            vc.couponId = self.CouponId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([contStr isEqualToString:@"编辑"]) {
            //已经领过
            if (self.isHaveRecive) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"该代金券已经领取过，不能编辑" controller:self sleep:1.5];
            }
            else{
                //改变状态
                _isCanEdit = YES;
                [self setUI];
            }
        }
        else  {
            //分享链接
            [self sharebtnclick];
            
        }
        
    } animated:YES];
    
}

#pragma mark - 使用攻略
-(void)goInstructionsVc{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/6971/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - action

-(void)pushData:(UIButton *)btn{
    [self.view endEditing:YES];
//    YSNLog(@"42");
    
    self.CouponNameStr = [self.CouponNameStr ew_removeSpaces];
    if (self.CouponNameStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"代金券名称必填" controller:self sleep:1.5];
        return;
    }
    
    if (self.CouponNameStr.length>8){
        [[PublicTool defaultTool] publicToolsHUDStr:@"代金券名称不能超过8个字" controller:self sleep:1.5];
        return;
    }
    
    self.CouponNumStr = [self.CouponNumStr ew_removeSpaces];
    if (self.CouponNumStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"发行数量必填" controller:self sleep:1.5];
        return;
    }
    
    self.CouponFaceValueStr = [self.CouponFaceValueStr ew_removeSpaces];
    if (self.CouponFaceValueStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"面值必填" controller:self sleep:1.5];
        return;
    }
    
    //普通代金券 -- 判断单个面值
    if (!isSpecial) {
        if([self.CouponFaceValueStr integerValue]<10){
            [[PublicTool defaultTool] publicToolsHUDStr:@"单个金额必须大于等于10元" controller:self sleep:1.5];
            return;
        }
    }
    //手气代金券 --判断10*个数 》总面值
    else{
        NSInteger zongPrice = 10*[self.CouponNumStr integerValue];
        
        if([self.CouponFaceValueStr integerValue]<zongPrice){
            [[PublicTool defaultTool] publicToolsHUDStr:@"单个金额必须大于等于10元" controller:self sleep:1.5];
            return;
        }
    }
    
    
    
    self.CouponStartTimeStr = [self.CouponStartTimeStr ew_removeSpaces];
    if (self.CouponStartTimeStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"生效时间必填" controller:self sleep:1.5];
        return;
    }
    
    self.CouponEndTimeStr = [self.CouponEndTimeStr ew_removeSpaces];
    if (self.CouponEndTimeStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"过期时间必填" controller:self sleep:1.5];
        return;
    }
    
    self.CouponScopeStr = [self.CouponScopeStr ew_removeSpaces];
    if (self.CouponScopeStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"领取范围必填" controller:self sleep:1.5];
        return;
    }
    
    self.CouponAddressStr = [self.CouponAddressStr ew_removeSpaces];
    if (self.CouponAddressStr.length<=0||self.longitude<=0||self.lantitude<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"地点必须定位" controller:self sleep:1.5];
        return;
    }
  
    //CouponRemarks
    
    self.CouponRemarks = [self.CouponRemarks ew_removeSpaces];
    if (self.CouponRemarks.length>100) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"备注内容不能大于100个字符" controller:self sleep:1.5];
        return;
    }
    
    if (!self.isEdit) {
        [self createCash];
    }
    else{
        [self editCash];
    }
    
}

#pragma mark - 创建代金券或礼品券

-(void)createCash{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcoupon/add.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    //领取范围
    NSArray *copeArray = [self.CouponScopeStr componentsSeparatedByString:@"公里"];
    NSString *copeStr = copeArray.firstObject;
    
    NSString *longitudeStr = [NSString stringWithFormat:@"%f",self.longitude];
    NSString *langitudeStr = [NSString stringWithFormat:@"%f",self.lantitude];
    NSDictionary *paramDic = @{@"startDate":self.CouponStartTimeStr,
                               @"endDate":self.CouponEndTimeStr,
                               @"couponName":self.CouponNameStr,
                               @"numbers":self.CouponNumStr,
                               @"price":self.CouponFaceValueStr,
                               @"companyId":self.companyId,
                               
                               @"agencyId":@(user.agencyId),
                               @"type":@(isSpecial?1:0),
                               @"exchangeScope":copeStr,
                               @"exchangeAddress":self.CouponAddressStr,
                               @"longitude":longitudeStr,
                               
                               @"latitude":langitudeStr,
                               @"remark":self.CouponRemarks.length>0?self.CouponRemarks:@"",
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:1.5];
                if (self.block) {
                    self.block();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 编辑代金券或礼品券

-(void)editCash{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcoupon/edit.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    //领取范围
    NSArray *copeArray = [self.CouponScopeStr componentsSeparatedByString:@"公里"];
    NSString *copeStr = copeArray.firstObject;
    
    NSString *longitudeStr = [NSString stringWithFormat:@"%f",self.longitude];
    NSString *langitudeStr = [NSString stringWithFormat:@"%f",self.lantitude];
    NSDictionary *paramDic = @{@"startDate":self.CouponStartTimeStr,
                               @"endDate":self.CouponEndTimeStr,
                               @"couponName":self.CouponNameStr,
                               @"numbers":self.CouponNumStr,
                               @"price":self.CouponFaceValueStr,
                               @"companyId":self.companyId,
                               @"couponId":self.CouponId,
                               @"agencyId":@(user.agencyId),
                               @"type":@(isSpecial?1:0),
                               @"exchangeScope":copeStr,
                               @"exchangeAddress":self.CouponAddressStr,
                               @"longitude":longitudeStr,
                               
                               @"latitude":langitudeStr,
                               @"remark":self.CouponRemarks.length>0?self.CouponRemarks:@"",
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
                if (self.block) {
                    self.block();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已有人领取过不能修改" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 定位获取地址

- (void)localionButtonAction {
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        NSString *addressStr = self.CouponAddressStr.length > 0 ? self.CouponAddressStr: @"";
        locationVC.address = addressStr;
        locationVC.longitude = self.longitude;
        locationVC.latitude  = self.lantitude;
        MJWeakSelf;
        locationVC.locationBlock = ^(NSString *addressName, double lantitude, double longitude){
            weakSelf.CouponAddressStr = addressName;
            weakSelf.longitude = longitude;
            weakSelf.lantitude = lantitude;
            weakSelf.AddressTextF.text = addressName;
        };
        [self.navigationController pushViewController:locationVC animated:YES];
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置不可用"
                                                        message:@"请到 手机设置->爱装修->位置 进行设置"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 999;
        [alert show];
        
    }
    
    
    
}

-(void)changeCashType:(UITapGestureRecognizer *)ges{
    isSpecial = !isSpecial;
    [self setUI];
}

-(void)timeBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    NSString *str;
    if (btn.tag == 3) {
        str = @"生效时间";
    }
    else{
        str = @"过期时间";
    }
    __weak typeof(self) weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:str CompleteBlock:^(NSDate *selectDate) {
        
        NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        //            NSLog(@"选择的日期：%@",date);
        
        if (btn.tag == 3) {
            weakSelf.CouponStartTimeStr = date;
            weakSelf.startTimeTextF.text = date;
        }
        else{
            weakSelf.CouponEndTimeStr = date;
            weakSelf.endTimeTextF.text = date;
        }
        
    }];
    datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
    [datepicker show];
}

-(void)scropBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    WWPickerView *pickerView = [[WWPickerView alloc] init];
    NSMutableArray *mutabArray = [NSMutableArray array];
    for (int i = 1; i<101; i++) {
        NSString *str = [NSString stringWithFormat:@"%d公里",i];
        [mutabArray addObject:str];
    }
    NSMutableArray *typeArray = [[NSMutableArray alloc]initWithArray:mutabArray];
    pickerView.isNeedRow = YES;
    [pickerView setDataViewWithItem:typeArray title:@"请选择领取范围"];

    [pickerView showPickView:self];

    //block回调
    __weak typeof (self) wself = self;
    pickerView.blockTwo = ^(NSString *selectedStr, NSInteger row) {
        wself.CouponScopeStr = selectedStr;
        wself.ScopeTextF.text = selectedStr;
    };
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    if (tag==0) {
        self.CouponNameStr = textField.text;
    }
    else if (tag==1) {
        self.CouponNumStr = textField.text;
    }
    else if (tag==2) {
        self.CouponFaceValueStr = textField.text;
    }
    else if (tag==3) {
        
    }
    else if (tag==4) {
        
    }
    else if (tag==5) {
        
    }
    else if (tag==6) {
        self.CouponAddressStr = textField.text;
    }
    else{
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    if (tag==0) {
        self.CouponNameStr = textField.text;
    }
    else if (tag==1) {
        self.CouponNumStr = textField.text;
    }
    else if (tag==2) {
        self.CouponFaceValueStr = textField.text;
    }
    else if (tag==3) {
        
    }
    else if (tag==4) {
        
    }
    else if (tag==5) {
        
    }
    else if (tag==6) {
        self.CouponAddressStr = textField.text;
    }
    else{
        
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length<=0) {
        self.placeHolderL.hidden = NO;
    }
    else{
        self.placeHolderL.hidden = YES;
    }
    self.CouponRemarks = textView.text;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<=0) {
        self.placeHolderL.hidden = NO;
    }
    else{
        self.placeHolderL.hidden = YES;
    }
    self.CouponRemarks = textView.text;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textViewDidChangeText:(NSNotification *)notification{
    static int kMaxLenth = 100;
    UITextView *textview = (UITextView *)notification.object;
    NSString *toBeString = textview.text;
    NSString *lang = [[[UIApplication sharedApplication] textInputMode] primaryLanguage];
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectRange = [textview markedTextRange];
        UITextPosition *position = [textview positionFromPosition:selectRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length>kMaxLenth) {
                
                // 截取子串
                textview.text = [toBeString substringToIndex:kMaxLenth];
                
                [self.view endEditing:YES];
                [[PublicTool defaultTool] publicToolsHUDStr:@"不超过100个字" controller:self sleep:1.5];
                
            }
        }
        else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            
            
        }
    }
    else
    {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLenth) {
            
            // 截取子串
            
            textview.text = [toBeString substringToIndex:kMaxLenth];
            
            [self.view endEditing:YES];
            [[PublicTool defaultTool] publicToolsHUDStr:@"不超过100个字" controller:self sleep:1.5];
        }
    }
    
}



#pragma mark - uialertviewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == 2000) {
//        if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 分享

-(void)sharebtnclick
{
    [self.shareMenuView show];
}


-(void)setupshare
{
    //[self.view addSubview:self.shareMenuView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.shareMenuView];
    //配置item
    NSMutableArray *array = NSMutableArray.new;
    LYShareMenuItem *item0 = nil;
    item0 = [LYShareMenuItem shareMenuItemWithImageName:@"qq" itemTitle:@"QQ"];
    [array addObject:item0];
    
    LYShareMenuItem *item1 = nil;
    item1 = [LYShareMenuItem shareMenuItemWithImageName:@"qqkongjian" itemTitle:@"QQ空间"];
    [array addObject:item1];
    
    LYShareMenuItem *item2 = nil;
    item2 = [LYShareMenuItem shareMenuItemWithImageName:@"weixin-share" itemTitle:@"微信好友"];
    [array addObject:item2];
    
    LYShareMenuItem *item3 = nil;
    item3 = [LYShareMenuItem shareMenuItemWithImageName:@"pengyouquan" itemTitle:@"朋友圈"];
    [array addObject:item3];

    self.shareMenuView.shareMenuItems = [array copy];
}

- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{

    switch (index) {
        case 0:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.CouponId]];
                NSURL *url = [NSURL URLWithString:shareURL];
                NSData *imagedata = UIImagePNGRepresentation([UIImage imageNamed:@"red_packet"]);
                NSString *shareDescription = self.companyName;
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:self.CouponNameStr description:shareDescription previewImageData:imagedata];
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                }
                
            }
        }
            break;
        case 1:
        {
            // QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
      
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.CouponId]];
                NSURL *url = [NSURL URLWithString:shareURL];
                NSData *imagedata = UIImagePNGRepresentation([UIImage imageNamed:@"red_packet"]);
                NSString *shareDescription = self.companyName;
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:self.CouponNameStr description:shareDescription previewImageData:imagedata];
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                }
            }
        }
            break;
        case 2:
        {
            //微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = self.CouponNameStr;
            message.description = self.companyName;
            [message setThumbImage:[UIImage imageNamed:@"red_packet"]];
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.CouponId]];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];
            }
        }
            break;
        case 3:
        {
            // 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.CouponId]];
            message.title = self.CouponNameStr;
            message.description = self.companyName;
            [message setThumbImage:[UIImage imageNamed:@"red_packet"]];
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];
            }
        }
            break;
        default:
            break;
    }
}

@end
