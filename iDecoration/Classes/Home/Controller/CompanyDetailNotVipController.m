//
//  CompanyDetailNotVipController.m
//  iDecoration
//
//  Created by zuxi li on 2018/5/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CompanyDetailNotVipController.h"
#import "PellTableViewSelect.h"
#import "ComplainViewController.h"
#import "CollectionCompanyTool.h"
#import "ZYCShareView.h"
#import <OpenShare/OpenShareHeader.h>
#import "CompanyQRShareView.h"
#import "YellowActicleView.h"
#import "CompanyNotVipModel.h"
#import "DecorateInfoNeedView.h"
#import "BLEJBudgetGuideController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "DecorateCompletionViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "ZCHCalculatorItemsModel.h"
@interface CompanyDetailNotVipController ()<UIWebViewDelegate>

// 是否收藏标识   收藏了为收藏的id   collectFlag > 0 为收藏了   等于0为取消收藏
@property (nonatomic, strong) NSString *collectFlag;
// 收藏按钮(底部)
@property (strong, nonatomic) UIButton *collectionBtn;
@property (strong, nonatomic) ZYCShareView *shareView;

@property (nonatomic, strong) CompanyNotVipModel *companyNotVipModel;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;

// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 置顶的公司列表
@property (strong, nonatomic) NSMutableArray *topConstructionList;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorModel;
// 预算报价的顶部图片
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
// 预算报价的底部图片
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
// 记录是否可以点击跳转计算器界面(是否设置过基础模板)
@property (assign, nonatomic) NSInteger code;
// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;
// 商品
@property (strong, nonatomic) NSMutableArray *goodListArray;


@end

@implementation CompanyDetailNotVipController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.title = self.companyName;
    
    [self buildNotVipButHaveActicleView];
    if (self.isCompany) {
        [self addCompanyBottomView];
    } else {
        [self addShopBottomView];
    }
    self.shareView = [ZYCShareView sharedInstance];
    [self makeShareView];
    [self getData];
    [self getCalculateTemplateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    NSString *api = [BASEURL stringByAppendingString:@"company/companyBaseInfoAndCollection.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *param = @{
                            @"companyId" : @(self.companyID.integerValue),
                            @"agencyId" : @(userModel.agencyId),
                            };
    
    [NetManager afPostRequest:api parms:param finished:^(id responseObj) {
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            self.companyNotVipModel = [CompanyNotVipModel yy_modelWithJSON:responseObj[@"data"][@"companyBaseInfo"]];
            self.collectFlag = self.companyNotVipModel.collectionId;
            self.collectionBtn.selected = self.companyNotVipModel.collectionId.integerValue > 0;
        }
    } failed:^(NSString *errorMsg) {
    }];
}

#pragma mark - 三点按钮
- (void)moreBtnClicked:(UIButton *)sender {
    
    // 弹出的自定义视图
    NSArray *array;
    if (self.collectFlag.integerValue > 0) { // 已添加到收藏
        array = @[@"取消收藏", @"投诉", @"分享"];
    } else {
        array = @[@"收藏",@"投诉", @"分享"];
    }
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        
        if (index == 0) { // 收藏  需要登录 ，其他不需要
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
            }else{
                
                if (self.collectFlag.integerValue > 0) {
                    [CollectionCompanyTool unCollectionShopOrCompanyWithCollectionID:self.collectFlag.integerValue completion:^(NSInteger collectionId, BOOL isSuccess) {
                        if (isSuccess) {
                            self.collectFlag = @"0";
                            self.collectionBtn.selected = NO;
                        }
                    }];
                    
                } else {
                    [CollectionCompanyTool saveShopOrCompanyWithCompanyID:self.companyID.integerValue completion:^(NSInteger collectionId, BOOL isSuccess) {
                        if (isSuccess) {
                            self.collectFlag = [NSString stringWithFormat:@"%ld", collectionId];
                            self.collectionBtn.selected = YES;
                        }
                    }];
                }
            }
        }else if (index == 1){ // 投诉
            ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
            ComplainVC.companyID = self.companyID.integerValue;
            [self.navigationController pushViewController:ComplainVC animated:YES];
        }else if (index == 2){//分享
            [self.shareView share];
        }
    } animated:YES];
    
}



- (void)makeShareView {
    WeakSelf(self);
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.companyID]];
    self.shareView.URL = shareURL;
    self.shareView.shareTitle = self.companyNotVipModel.companyName;
    self.shareView.shareCompanyIntroduction = self.companyNotVipModel.companyIntroduction;
    self.shareView.shareCompanyLogo = self.companyNotVipModel.companyLogo;
    self.shareView.companyName = self.companyNotVipModel.companyName;
    self.shareView.shareViewType = ZYCShareViewTypeCompanyOnly;
    self.shareView.blockQRCode1st = ^{
        CompanyQRShareView *QRShareView = [[CompanyQRShareView alloc] initViewWithShareURLStr:@"" shareImage:nil shareImageURLStr:@"" companyName:@""];
        [weakself.view addSubview:QRShareView];
        [UIView animateWithDuration:0.25 animations:^{
            QRShareView.alpha = 1.0;
            weakself.navigationController.navigationBar.alpha = 0;
        }];
        QRShareView.hiddenBlock = ^(CompanyQRShareView *QRView) {
            [UIView animateWithDuration:0.25 animations:^{
                weakself.navigationController.navigationBar.alpha = 1;
            }completion:^(BOOL finished) {
                [QRView removeFromSuperview];
            }];
        };
    };
}

- (void)buildNotVipButHaveActicleView {
    YellowActicleView *v = [[YellowActicleView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50)];
    [v setDesignsId:self.designsId.integerValue andCompanyId:self.companyID.integerValue];
    v.webView.delegate = self;
    [self.view addSubview:v];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"tocomplain"]) {
        ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
        ComplainVC.companyID = self.companyID.integerValue;
        [self.navigationController pushViewController:ComplainVC animated:YES];
        
        return NO;
    }
    return YES;
}


#pragma mark - 添加公司底部视图
- (void)addCompanyBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, bottomView.height)];
    [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, 1, bottomView.height)];
    line.backgroundColor = kBackgroundColor;
    [bottomView addSubview:line];
    
    // 242 105 71
    UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.width + 1, 0, 80, bottomView.height)];
    [collectionBtn setImage:[UIImage imageNamed:@"noSelectCollection"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"selectCollection"] forState:UIControlStateSelected];
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectionBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn = collectionBtn;
    [bottomView addSubview:collectionBtn];
    
    UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.right, 0, (BLEJWidth - collectionBtn.right) * 0.5, bottomView.height)];
    priceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    priceBtn.backgroundColor = kCustomColor(242, 105, 71);
    [priceBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [priceBtn setTitle:@"免费报价" forState:UIControlStateNormal];
    [priceBtn addTarget:self action:@selector(didClickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:priceBtn];
    
    UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, priceBtn.width, bottomView.height)];
    houseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    houseBtn.backgroundColor = kMainThemeColor;
    [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];
    [houseBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:houseBtn];
}

#pragma mark - 添加店铺底部视图
- (void)addShopBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, bottomView.height)];
    [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, 1, bottomView.height)];
    line.backgroundColor = kBackgroundColor;
    [bottomView addSubview:line];
    
    UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.width + 1, 0, 100, bottomView.height)];
    [collectionBtn setImage:[UIImage imageNamed:@"noSelectCollection"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"selectCollection"] forState:UIControlStateSelected];
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectionBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn = collectionBtn;
    [bottomView addSubview:collectionBtn];
    
    UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.right, 0, BLEJWidth - collectionBtn.right, bottomView.height)];
    appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    appointmentBtn.backgroundColor = kMainThemeColor;
    [appointmentBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [appointmentBtn setTitle:@"在线预约" forState:UIControlStateNormal];
    [appointmentBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:appointmentBtn];
}

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    NSMutableArray *phoneArr = [NSMutableArray array];
    [phoneArr removeAllObjects];
    if (self.companyNotVipModel.companyLandline.length > 0) {
        [phoneArr addObject:self.companyNotVipModel.companyLandline];
    }
    if (self.companyNotVipModel.companyPhone.length > 0) {
        [phoneArr addObject:self.companyNotVipModel.companyPhone];
    }
    if (phoneArr.count == 0) {
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (int i = 0; i < phoneArr.count; i ++) {
        UIAlertAction *ac = [UIAlertAction actionWithTitle:phoneArr[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneArr[i]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }];
        [alertC addAction:ac];
    }
    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:ac];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)didClickCollectionBtn:(UIButton *)btn {// 收藏(取消)
    
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (!isLogin) { // 未登录
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
    } else {
        if (self.collectFlag.integerValue > 0) {
            [CollectionCompanyTool unCollectionShopOrCompanyWithCollectionID:self.collectFlag.integerValue completion:^(NSInteger collectionId, BOOL isSuccess) {
                if (isSuccess) {
                    self.collectFlag = @"0";
                    self.collectionBtn.selected = NO;
                }
            }];
        } else {
            [CollectionCompanyTool saveShopOrCompanyWithCompanyID:self.companyID.integerValue completion:^(NSInteger collectionId, BOOL isSuccess) {
                if (isSuccess) {
                    self.collectFlag = [NSString stringWithFormat:@"%ld", collectionId];
                    self.collectionBtn.selected = YES;
                }
            }];
        }
        
    }
}
- (void)getCalculateTemplateData {
    
    NSString *urlStr =[BASEURL stringByAppendingString:BLEJCalculatorGetTempletByCompanyIdUrl];
    NSString *agencyid=   [[NSUserDefaults standardUserDefaults ]objectForKey:@"alias"];
    
    //NSString *companyId = self.companyID;
    NSString *companyId = @"1398";
    NSDictionary *parameter = @{@"companyId":companyId};
    
    [NetManager afPostRequest:urlStr parms:parameter finished:^(id responseObj) {
        //        [self getDataWithType:@"1"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            
            
            [self.baseItemsArr removeAllObjects];
            [self.suppleListArr removeAllObjects];
            
            
            
            NSDictionary *dictData= [responseObj objectForKey:@"data"];
            NSMutableArray *companyItemArray =[NSMutableArray arrayWithCapacity:10];
            companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:dictData[@"list"]]];
            for (BLRJCalculatortempletModelAllCalculatorTypes *dict in  companyItemArray) {
                
                if ( dict.templeteTypeNo  > 2000 &&dict.templeteTypeNo <3000) {
                    [self.baseItemsArr addObject:dict];
                }
                if (dict.templeteTypeNo  ==0) {
                    [self.suppleListArr addObject:dict];
                }
            }
            BLRJCalculatortempletModelAllCalculatorcompanyData* companyData=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:dictData[@"company"]];
            
           // self.allCalculatorCompanyData=companyData;
            
            
            
            
            //如果baseitems数据为空，去本地取出数据
            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"DefaultBaseItem" ofType:@"geojson"];
            NSData *JSONData = [NSData dataWithContentsOfFile:strPath];
            
            id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *dicTemplet = [[jsonObject
                                                objectForKey:@"data"]objectForKey:@"templet"] ;
            if (self.suppleListArr.count ==0) {
                NSMutableArray *supplyArray = [NSMutableArray arrayWithArray:[[jsonObject
                                                                               objectForKey:@"data"] objectForKey:@"defaultSupplementItemsList"]];
                
                self.suppleListArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:supplyArray]];
            }
            if (self.baseItemsArr.count ==0){
                NSMutableArray *baseItemArray = [NSMutableArray arrayWithArray:[[jsonObject objectForKey:@"data"] objectForKey:@"defaultBaseItemsList"]];
                
                self.baseItemsArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:baseItemArray]];
                
            }
            

            
        }else{
            [[PublicTool defaultTool] publicToolsHUDStr:responseObj[@"msg"] controller:self sleep:1.5];
        }
        
       
        
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:errorMsg controller:self sleep:1.5];
    }];
}



- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    
    // 装修报价
    if (self.code == 1000) {
        
       
            
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.baseItemsArr = self.baseItemsArr;
            VC.origin = self.origin;
            VC.suppleListArr = self.suppleListArr;
             VC.calculatorModel = self.calculatorModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.companyID;
            VC.topImageArr = self.topCalculatorImageArr;
            VC.bottomImageArr = self.bottomCalculatorImageArr;
            VC.isConVip = self.companyNotVipModel.conVip;
          //  VC.dispalyNum = self.calculatorTempletModel.displayNumbers;
            [self.navigationController pushViewController:VC animated:YES];
    
    } else if (self.code == -1) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络不畅，请稍后重试"];
    } else {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置模板"];
    }
}

#pragma mark - 在线预约 ↓
- (void)didClickHouseBtn:(UIButton *)btn {// 量房
    
    self.infoView = [[NSBundle mainBundle] loadNibNamed:@"DecorateInfoNeedView" owner:nil options:nil].lastObject;
    self.infoView.frame = self.view.frame;
    [self.infoView.finishButton addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.infoView];
    // 店铺和公司的界面区别
    [self.infoView.areaTF removeFromSuperview];
    [self.infoView.timeTF removeFromSuperview];
    self.infoView.tipLabel.text = @"本公司业务人员会与您电话沟通，请确保电话畅通！     ";
    //    self.infoView.tipLabelHeight.constant = 30;
    self.infoView.protocolImageTopToPhoneTFCon.constant = 6;
    
    MJWeakSelf;
    self.infoView.sendVertifyCodeBlock = ^{
        [weakSelf sendvertifyAction];
    };
    self.infoView.hidden = NO;
    // 在线预约 后台数据统计
    [NSObject needDecorationStatisticsWithConpanyId:self.companyID];
    
}

#pragma  mark 发送验证码
- (void)sendvertifyAction {
    [self.infoView endEditing:YES];
    if (![self.infoView.phoneTF.text ew_justCheckPhone]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"callDecoration/sendPhoneCode.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [param setObject:self.companyID forKey:@"companyId"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [NSObject timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已经预约过该公司"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"操作失败或操作过于频繁"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark  完成
- (void)finishiAction {
    
    if ([self.infoView.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if (![self.infoView.phoneTF.text ew_checkPhoneNumber]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的联系方式"];
        return;
    }
    if (!self.infoView.textFieldImageVerificationCode.text.length) {
        SHOWMESSAGE(@"请输入图形验证码")
        return;
    }
    if (self.infoView.vertifyCodeTF.text.length != 6) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入6位数的验证码"];
        return;
    }
    NSInteger proType = -1;
    if ([self.infoView.itemTF.text isEqualToString:@"量房"]) {
        proType = 0;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"设计"]) {
        proType = 1;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"施工"]) {
        proType = 2;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"维修"]) {
        proType = 3;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"其他"]) {
        proType = 4;
    }
    self.infoView.hidden = YES;
#warning 图形验证码
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.infoView.vertifyCodeTF.text forKey:@"phoneCode"];
    [dic setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text forKey:@"fullName"];
    [dic setObject:self.companyNotVipModel.companyId forKey:@"companyId"];
    [dic setObject:self.companyNotVipModel.companyType forKey:@"companyType"];
    [dic setObject:@(proType) forKey:@"proType"];
    [dic setObject:@"0" forKey:@"agencyId"];
    [dic setObject:@"0" forKey:@"callPage"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
     [dic setObject:self.origin?:@"0" forKey:@"origin"];
    NSString *url = [BASEURL stringByAppendingString:@"callDecoration/v2/save.do"];
    [NetManager  afGetRequest:url parms:dic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        switch ([responseObj[@"code"] integerValue]) {
                //喊装修成功
            case 1000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已提交成功请等待回复"];
                
                // 睡一秒
                [NSThread sleepForTimeInterval:1];
                
                DecorateCompletionViewController *completionVC = [[DecorateCompletionViewController alloc] init];
                completionVC.dataDic = responseObj[@"data"];
                completionVC.companyType = weakSelf.companyNotVipModel.companyType;
                NSString *constructionType = @"0";
                NSInteger companyT = weakSelf.companyNotVipModel.companyType.integerValue;
                if (companyT == 1018 || companyT == 1064 || companyT == 1065) {
                    constructionType = @"0";
                } else {
                    constructionType = @"1";
                }
                completionVC.constructionType = constructionType;
                [self.navigationController pushViewController:completionVC animated:YES];
                break;
            }
            case 1001:
                break;
                //            本月已喊过装修
            case 1002:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您本月已经预约过了"];
                break;
                //            不在装修区域
            case 1003:
                self.infoView.hidden = YES;
                [self replySubmit:dic];
                break;
                //             该区域暂无接单公司
            case 1004:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该区域暂无接单公司"];
                break;
            case 2000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败，稍后重试"];
                break;
            }
            case 2001:
            {
                self.infoView.hidden = NO;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            }
            default:
                break;
        }
        
    } failed:^(NSString *errorMsg) {
        
        [weakSelf.view hiddleHud];
        self.infoView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark   不在装修区域  是否继续提交
- (void)replySubmit:(NSMutableDictionary *)dic {
    
    //该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    __weak typeof(self)  weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [dic setObject:@(1) forKey:@"type"];
        
        [weakSelf upDataRequest:dic];
    }];
    
    
    [aler addAction:action];
    [aler addAction:action1];
    [self presentViewController:aler animated:YES completion:nil];
}

#pragma mark - 在线预约 ↑

@end
