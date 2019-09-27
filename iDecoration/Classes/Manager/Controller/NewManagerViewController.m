
//
//  NewManagerViewController.m
//  iDecoration
//
//  Created by 丁 on 2018/3/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewManagerViewController.h"
#import "DistributionViewController.h"
#import "DistributionControlVC.h"
#import "MyCompanyViewController.h"
#import "LoginViewController.h"
#import "CreatShopUnionController.h"
#import "MyConstructionSiteViewController.h"
#import "MyBeautifulArtController.h"
#import "NewMyPersonCardController.h"
#import "CustomerViewController.h"
#import "CreateCompanyViewController.h"
#import "UnionCompanyModel.h"
#import "SSPopup.h"
#import "ShopUnionListModel.h"
#import "ShopUnionListController.h"
#import "LoginViewController.h"
#import <JPUSHService.h>
#import "CalculateViewController.h"
#import "NeedDecorationViewController.h"
#import "ActivityMessageViewController.h"
#import "CompanyApplyViewController.h"
#import "UnionInviteMessageController.h"
#import "ZCHUnionApplyMsgController.h"
#import "ZCHCooperateMesController.h"
#import "STYMyCashCouponController.h"
#import "DayStatisticsViewController.h"
#import "AdvertisementWebViewController.h"
#import "SearchUnionController.h"
#import "JoinCompanyController.h"
#import "YGLCurrentPersonCompanyModel.h"
#import "ZCHCalculatorPayController.h"
#import "STYMyCashCouponController.h"
#import "CertificationModel.h"
#import "CompanyCertificationController.h"
#import "CertificateStatusController.h"
#import "CompanyMarginController.h"
#import "CompanyIncomeController.h"
#import "ZCHPublicWebViewController.h"
#import "ZCHShopperManageViewController.h"
#import "BLEJBudgetTemplateController.h"
#import "SubsidiaryModel.h"
#import "BackGoodsListViewController.h"
#import "VipGroupViewController.h"
#import "PanoramaViewController.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "ZCHNewsActivityController.h"
#import "ZCHCashCouponController.h"
#import "ZCHCooerateCompanyController.h"
#import "UploadAdvertisementController.h"
#import "ScancodeController.h"
#import "citywideMessageVC.h"
#import "MyOrderViewController.h"
#import "mywalletVC.h"
#import "CollectionViewController.h"
#import "CertificateSuccessNewController.h"
#import "myattentionVC.h"
#import "CalculatorSetViewController.h"
#import "draftboxVC.h"
#import "RedEnvelopeManagementViewController.h"
#import "companyprogramVC.h"
#import "PCManagementViewController.h"
#import "NetworkManagementViewController.h"

// scrollView中除去广告图和它上下的间隙 剩余视图的高度 // 就是所有小图标的大View视图高度
#define managerViewHeight (960+90+230 - 90)
#define managerViewHiddenHeight (690 + 90 + 230)  // 折叠时的高度

@interface NewManagerViewController ()<UIScrollViewDelegate,SSPopupDelegate, UIAlertViewDelegate>
{
    BOOL ischoose;//分销是否通过审核
    BOOL _isLogined;
    BOOL _isZongjingli;//是否是总经理
    BOOL implement;//是否是执行经理（0：不是，1：是)
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) NSString *adImageHref;
@property (nonatomic, strong) UIView *managementView;
@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UserInfoModel *userModel;

@property (nonatomic, strong) NSMutableArray *companyArray; // 查看联盟相关的公司数组
@property (nonatomic, strong) NSMutableArray *currentPersonCompanyArray; // 当前人员具有的公司数组
@property (nonatomic, strong) YGLCurrentPersonCompanyModel *currentCompanyModel; // 当前选择的公司
@property (nonatomic, strong) NSMutableArray *unionArray;

@property (nonatomic, strong) UILabel *messageFlagLabel;
@property(nonatomic,  strong) UIButton *ManageBtn;


@property (nonatomic, strong) UIView *enterpriseManagerView;
@property (nonatomic, strong) UIView *enterinfoManagerView;
@property (nonatomic, strong) NSMutableArray *enterpriseManagerBtnArray;
@property (nonatomic, strong) NSMutableArray *enterinfoMangerBtnArray;
@property (nonatomic, assign) BOOL isShowAll; // 是否显示的是全部按钮
@property (nonatomic, assign) BOOL isShowinfoAll;//是否显示个人管理全部按钮
@property (nonatomic, strong) UIButton *foldBtn; // 收起按钮
@property (nonatomic, strong) UIButton *foleBtn2;// 个人部分收起按钮
@property (strong, nonatomic) TTAlertView *alertView; // 定制会员弹框
@property (nonatomic,strong) NSMutableArray *curremtModelArray;
@property (nonatomic, strong) SubsidiaryModel *currentModel; // 当前公司的model2

@property (nonatomic, strong) NSMutableArray *messageCenterLabelArray; // 消息中心 消息数量提示 label 数组

@end

@implementation NewManagerViewController



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (_isLogined == YES) {
        //        获取用户模型
        self.userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    }
    [self getMessageNumDataWithNetWork];
    [self getAdImgAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPersonCompanyArray = [NSMutableArray array];
    ischoose = NO;
    _isShowAll = NO;
    _isShowinfoAll = NO; 
    

    [self scrollView];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"切换公司" target:self action:@selector(showCurrentPersonCompanyList)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentPersonCompanyList) name:kDidLoginSuccess object:nil];

    UIImage *imageQRCode = [UIImage imageNamed:@"red_Qr"];
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithimage:imageQRCode selImage:imageQRCode target:self action:@selector(qrBtnClick:)];
    [leftItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self getCurrentPersonCompanyList];
}

// 获取当前用户公司列表
- (void)getCurrentPersonCompanyList {
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        return;
    }
    ShowMB
    NSString *apiStr = [BASEURL stringByAppendingString:@"statistic/getCompanys.do"];
    UserInfoModel *userInfo = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    NSDictionary *param = @{
                            @"agencyId": @(userInfo.agencyId)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        HiddenMB
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            NSArray *companys = responseObj[@"data"][@"companys"];
            self.currentPersonCompanyArray = [[NSArray yy_modelArrayWithClass:[YGLCurrentPersonCompanyModel class] json:companys] mutableCopy];
            [self getCurrentModel];
        }
    } failed:^(NSString *errorMsg) {
        HiddenMB
    }];
}

- (void)getCurrentModel {
    ShowMB
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *requestString = [BASEURL stringByAppendingString:@"company/findCompanyList.do"];
    NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                          };
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
        HiddenMB
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            NSDictionary *dict = responseObj[@"data"];
            NSArray *arr = [dict objectForKey:@"companyList"];
            
            self.curremtModelArray = [[NSArray yy_modelArrayWithClass:[SubsidiaryModel class] json:arr] mutableCopy];
            
            // 如果是一个公司就直接跳转不弹框选择公司了
            if (self.currentPersonCompanyArray.count == 1) {
                self.currentCompanyModel = self.currentPersonCompanyArray.firstObject;
                self.currentModel = self.curremtModelArray.firstObject;
                self.navigationItem.title = self.currentModel.companyName;
            }

            if (self.currentPersonCompanyArray.count > 0) {
                self.currentCompanyModel = self.currentPersonCompanyArray.firstObject;
                self.currentModel = self.curremtModelArray.firstObject;
            }
            
            // 设置标题
            [self.curremtModelArray enumerateObjectsUsingBlock:^(SubsidiaryModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.headQuarters.integerValue == 1) {
                    self.navigationItem.title = obj.companyName;
                    *stop = YES;
                }
            }];
            
        }
    } failed:^(NSString *errorMsg) {
        HiddenMB
    }];
}

#pragma mark - 显示公司列表
- (void)showCurrentPersonCompanyList {
    if (self.currentPersonCompanyArray.count == 0) {
        [self showAlertViewWithNoCompany];
        return;
    }
    SSPopup* selection=[[SSPopup alloc]init];
    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
    selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
    [self.view addSubview:selection];
    NSMutableArray *temArray = [NSMutableArray array];
    for (YGLCurrentPersonCompanyModel *model in self.currentPersonCompanyArray) {
        [temArray addObject:model.companyName];
    }
    NSArray *QArray = [temArray copy];
    [selection CreateTableview:QArray withTitle:@"请选择公司" setCompletionBlock:^(int tag) {
        self.currentCompanyModel = self.currentPersonCompanyArray[tag];
        self.navigationItem.title = self.currentCompanyModel.companyName;
        SubsidiaryModel *model = self.curremtModelArray[tag];
        self.currentModel = model;
    }];
}
#pragma mark - 显示公司列表选择公司后直接跳转
- (void)showCurrentPersonCompanyListMethodTwo:(UIButton *)sender {
//    if (self.currentPersonCompanyArray.count == 0) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"您没有公司!" controller:self sleep:2.0];
////        [self showAlertViewWithNoCompany];
//        return;
//    }
    SSPopup* selection=[[SSPopup alloc]init];
    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
    selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
    [self.view addSubview:selection];
    NSMutableArray *temArray = [NSMutableArray array];
    for (YGLCurrentPersonCompanyModel *model in self.currentPersonCompanyArray) {
        [temArray addObject:model.companyName];
    }
    NSArray *QArray = [temArray copy];
    MJWeakSelf;
    [selection CreateTableview:QArray withTitle:@"请选择公司" setCompletionBlock:^(int tag) {
        weakSelf.currentCompanyModel = weakSelf.currentPersonCompanyArray[tag];
        weakSelf.navigationItem.title = weakSelf.currentCompanyModel.companyName;
        
        SubsidiaryModel *model = self.curremtModelArray[tag];
        self.currentModel = model;
        [weakSelf orangeManageBtnClick:sender];
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor whiteColor];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(self.navigationController.navigationBar.bottom);
        }];
        [self adImageView];
        [self managementView];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIImageView *)adImageView {
    if (_adImageView == nil) {
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, kSCREEN_WIDTH - 10, (kSCREEN_WIDTH - 10) * 276/684.0)];
        _adImageView.image = [UIImage imageNamed:@"cloud_banner"];
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.layer.cornerRadius = 10;
        _adImageView.layer.masksToBounds = YES;
        [self.scrollView addSubview:_adImageView];
    }
    return _adImageView;
}

- (UIView *)managementView{
    if (!_managementView) {
        _managementView = [[UIView alloc]init];
        [self.scrollView addSubview:_managementView];
        [_managementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.adImageView.mas_bottom).equalTo(5);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, managerViewHeight));
        }];
        CGFloat scHeight = self.adImageView.height + self.managementView.height + 10;
        self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, scHeight);
        
        _managementView.backgroundColor = [UIColor whiteColor];
        
        
        CGFloat leftMargin = 26.0;
        CGFloat leftMarginOfThree = 40.0;
        CGFloat btnWith = 65.0;
        CGFloat btnHeight = 70;
        CGFloat marginWithFour = (kSCREEN_WIDTH - 52 - 4 * btnWith) / 3.0; // 一行四个按钮的间距
        CGFloat margiWithThree = (kSCREEN_WIDTH - 80 - 3 * btnWith) / 2.0; // 一行四个按钮的间距
        CGFloat vMargin = 20.0; // 按钮垂直间距20
        
        // --------------------- 公司管理--------------------
        UIView *mView = [[UIView alloc] init];
        self.enterpriseManagerView = mView;
        [_managementView addSubview:mView];
        CGFloat height = _isShowAll? 400: 230;
        [mView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(height);
        }];
        CGFloat mHeight = _isShowAll ? managerViewHeight : managerViewHiddenHeight;
        [_managementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.adImageView.mas_bottom).equalTo(5);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, mHeight));
        }];
        CGFloat sHeight = self.adImageView.height + mHeight + 10;
        self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, sHeight);

        UIImageView *orangeImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 16, 4, 14)];
        orangeImg.image = [UIImage imageNamed:@"icon_one"];
        [mView addSubview:orangeImg];
        UILabel *orangeLab = [[UILabel alloc]initWithFrame:CGRectMake(4 + 4 + 8, 16, 68, 14)];
        orangeLab.text = @"企业管理";
        orangeLab.font = [UIFont systemFontOfSize:16];
        [mView addSubview:orangeLab];
        
        UIButton *flodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.foldBtn = flodBtn;
        [flodBtn setTitle:@"收起" forState:UIControlStateNormal];
        flodBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [flodBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mView addSubview:flodBtn];
        flodBtn.hidden = !_isShowAll;
        [flodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(orangeLab);
            make.right.equalTo(-16);
            make.size.equalTo(CGSizeMake(40, 40));
        }];
        [flodBtn addTarget:self action:@selector(flodAction) forControlEvents:UIControlEventTouchUpInside];
        NSArray *names;
        NSArray *imageNames;
        if (isCustomMadeHidden) {
            names = @[@"我的公司", @"工地管理",@"企业网站", @"商品展示", @"计算器模板",@"新闻活动", @"商户联盟",@"公司认证", @"公司收入",@"合作企业", @"广告图管理", @"红包管理", @"五网合一"];
            imageNames = @[@"icon_wodegongsi", @"icon_wodegongdi", @"btn_huangye", @"btn_shangpinzhanshi", @"btn_jisuanqi", @"btn_news", @"icon_shanghulianmeng", @"btn_gongsirenzheng", @"btn_gongsishouru", @"icon_hezuoqiye", @"btn_ad", @"icon_hongbao", @"icon_heyi_hi"];
        }else{
            imageNames = @[@"icon_wodegongsi", @"icon_wodegongdi", @"btn_huangye", @"btn_shangpinzhanshi", @"btn_jisuanqi", @"btn_news", @"icon_shanghulianmeng", @"btn_gongsirenzheng", @"btn_gongsishouru", @"icon_hezuoqiye", @"btn_shangjiaguanli", @"btn_ad", @"icon_hongbao",  @"icon_heyi_hi"];
            names = @[@"我的公司", @"工地管理",@"企业网站", @"商品展示", @"计算器模板",@"新闻活动", @"商户联盟",@"公司认证", @"公司收入",@"合作企业", @"商家管理", @"广告图管理", @"红包管理", @"五网合一"];
        }
        self.enterpriseManagerBtnArray = [NSMutableArray array];
        for (int i = 0; i < names.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + i%4 * (btnWith + marginWithFour), orangeLab.bottom + 20 + (i/4 * (btnHeight + vMargin)), btnWith, btnHeight)];
            btn.tag = i;
            [self.enterpriseManagerBtnArray addObject:btn];
            [btn addTarget:self action:@selector(orangeManageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
            [btn setTitle:names[i] forState:UIControlStateNormal];
            if (i == 7) {
                if (_isShowAll) {
                   
                } else {
                    [btn setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
                    [btn setTitle:@"更多" forState:UIControlStateNormal];
                }
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setButtonImageTopAngTitleBottom:btn];
            [mView addSubview:btn];
            if (i >= 8) {
                btn.hidden = !_isShowAll;
            }
        }

        UIView *mLineView = [[UIView alloc] init];
        [mView addSubview:mLineView];
        [mLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(1);
            make.bottom.equalTo(0);
        }];
        mLineView.backgroundColor =  [UIColor colorWithRed:232./255. green:232./255. blue:232./255. alpha:1];
        
        // --------------------- 个人管理 -------------------
        UIView *personalMView = [[UIView alloc] init];
        self.enterinfoManagerView = personalMView;
        [_managementView addSubview:personalMView];
        
        CGFloat height2 = _isShowinfoAll? 310: 230;
        [personalMView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(mView.mas_bottom).equalTo(0);
            make.height.equalTo(height2);
        }];
        
        UIImageView *pmImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 16, 4, 14)];
        pmImg.image = [UIImage imageNamed:@"icon_gerenguanli"];
        [personalMView addSubview:pmImg];
        UILabel *pmLab = [[UILabel alloc]initWithFrame:CGRectMake(4 + 4 + 8, 16, 68, 14)];
        pmLab.text = @"个人管理";
        pmLab.font = [UIFont systemFontOfSize:16];
        [personalMView addSubview:pmLab];
        
        
        UIButton *flodBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.foleBtn2 = flodBtn2;
        [flodBtn2 setTitle:@"收起" forState:UIControlStateNormal];
        flodBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
        [flodBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [personalMView addSubview:flodBtn2];
        flodBtn.hidden = !_isShowinfoAll;
        [flodBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(pmLab);
            make.right.equalTo(-16);
            make.size.equalTo(CGSizeMake(40, 40));
        }];
        [flodBtn2 addTarget:self action:@selector(flodAction2) forControlEvents:UIControlEventTouchUpInside];
        [self.foleBtn2 setHidden:YES];
        
        NSArray *personalImageNames = @[@"icon_wodemeiwen", @"icon_wodemingpian", @"icon_daijinquan", @"btn_wodedingdan", @"btn_money", @"btn_wodefenxiao", @"btn_shoucang",@"btn_guanzhu",@"btn_caogao"];
        NSArray *personalNames = @[@"我的美文", @"我的名片", @"我的代金券", @"我的订单", @"我的钱包", @"我的分销", @"我的收藏",@"关注",@"我的草稿箱"];
        self.enterinfoMangerBtnArray = [NSMutableArray array];
        
        for (int i = 0; i < personalNames.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + i%4 * (btnWith + marginWithFour), pmLab.bottom + 20 + (i/4 * (btnHeight + vMargin)), btnWith, btnHeight)];
            btn.tag = i;
            [self.enterinfoMangerBtnArray addObject:btn];
            
            [btn setImage:[UIImage imageNamed:personalImageNames[i]] forState:UIControlStateNormal];
            [btn setTitle:personalNames[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            if (i == 7) {
                if (_isShowinfoAll) {
                } else {
                    [btn setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
                    [btn setTitle:@"更多" forState:UIControlStateNormal];
                }
            }
            
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setButtonImageTopAngTitleBottom:btn];
            [btn addTarget:self action:@selector(personalManagerAction:) forControlEvents:UIControlEventTouchUpInside];
            [personalMView addSubview:btn];
            
            if (i >= 8) {
                btn.hidden = !_isShowinfoAll;
            }
            if (i==8) {
                
                UILabel *label = [UILabel new];
                [btn addSubview:label];
                label.tag = 1000;
                label.hidden = YES;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(btn.imageView.mas_top);
                    make.centerX.equalTo(btn.imageView.mas_right);
                    make.size.equalTo(CGSizeMake(20, 20));
                }];
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor redColor];
                label.layer.cornerRadius = 10;
                label.layer.masksToBounds = YES;
                
                
            }
         
            
        }
        
        UIView *pmLineView = [[UIView alloc] init];
        [personalMView addSubview:pmLineView];
        [pmLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(1);
            make.bottom.equalTo(0);
        }];
        pmLineView.backgroundColor =  [UIColor colorWithRed:232./255. green:232./255. blue:232./255. alpha:1];
        
        // --------------------- 消息中心 -------------------
        UIView *mssageView = [[UIView alloc] init];
        [_managementView addSubview:mssageView];
        [mssageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(personalMView.mas_bottom).equalTo(0);
            make.height.equalTo(230);
        }];

        UIImageView *redImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 16, 4, 14)];
        redImg.image = [UIImage imageNamed:@"icon_two"];
        [mssageView addSubview:redImg];
        UILabel *redLab = [[UILabel alloc]initWithFrame:CGRectMake(4 + 4 + 8, 16, 68, 14)];
        redLab.text = @"消息中心";
        redLab.font = [UIFont systemFontOfSize:16];
        [mssageView addSubview:redLab];

        
        NSArray *messageImageNames = @[@"icon_jisuanbaojia", @"icon_kehuyuyue", @"icon_baominghuodong", @"icon_gongsishenqing", @"icon_lianmengyaoqing", @"icon_lianmengshenqing", @"icon_hezuoqiye" ];
        NSArray *messageNames = @[@"计算报价", @"客户预约", @"活动报名", @"公司申请", @"联盟邀请", @"联盟申请", @"合作企业"];

        self.messageCenterLabelArray = [NSMutableArray array];
        for (int i = 0; i < messageNames.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + i%4 * (btnWith + marginWithFour), redLab.bottom + 20 + (i/4 * (btnHeight + vMargin)), btnWith, btnHeight)];
            btn.tag = i;
            [btn addTarget:self action:@selector(redManageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:messageImageNames[i]] forState:UIControlStateNormal];
            [btn setTitle:messageNames[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setButtonImageTopAngTitleBottom:btn];
            [mssageView addSubview:btn];
            
            UILabel *label = [UILabel new];
            [btn addSubview:label];
            label.tag = 800 + i;
            label.hidden = YES;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(btn.imageView.mas_top);
                make.centerX.equalTo(btn.imageView.mas_right);
                make.size.equalTo(CGSizeMake(20, 20));
            }];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            [self.messageCenterLabelArray addObject:label];
            label.backgroundColor = [UIColor redColor];
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            
        }

        UIView *messageLineView = [[UIView alloc] init];
        [mssageView addSubview:messageLineView];
        [messageLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(1);
            make.bottom.equalTo(0);
        }];
        messageLineView.backgroundColor =  [UIColor colorWithRed:232./255. green:232./255. blue:232./255. alpha:1];
        
    // --------------------- 数据统计 -------------------
        UIView *statisticsView = [[UIView alloc] init];
//        屏蔽掉数据统计
        [_managementView addSubview:statisticsView];
        [statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(mssageView.mas_bottom).equalTo(0);
            make.height.equalTo(230);
        }];

        UIImageView *greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(4, 16, 4, 14)];
        greenImg.image = [UIImage imageNamed:@"icon_three"];
        [statisticsView addSubview:greenImg];
        UILabel *greenLab = [[UILabel alloc]initWithFrame:CGRectMake(4 + 4 + 8, 16, 68, 14)];
        greenLab.text = @"数据统计";
        greenLab.font = [UIFont systemFontOfSize:16];
        [statisticsView addSubview:greenLab];
        
        
        NSArray *statisticsImageNames = @[@"icon_yue", @"icon_nian", @"btn_more"];
        NSArray *statisticsNames = @[@"月统计", @"年统计", @"更多统计"];
        for (int i = 0; i < statisticsImageNames.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(leftMarginOfThree + i%3 * (btnWith + margiWithThree), redLab.bottom + 20 + (i/3 * (btnHeight + vMargin)), btnWith, btnHeight)];
            btn.tag = i + 1;
            [btn addTarget:self action:@selector(greenManageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:statisticsImageNames[i]] forState:UIControlStateNormal];
            [btn setTitle:statisticsNames[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setButtonImageTopAngTitleBottom:btn];
            [statisticsView addSubview:btn];
        }
        
    }
    return _managementView;
}

// 收起
- (void)flodAction {
    self.foldBtn.hidden = YES;
    if (!_isShowAll) {
        return;
    }
    _isShowAll = !_isShowAll;
    [self.enterpriseManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(230);
    }];
    for (int i = 8; i < self.enterpriseManagerBtnArray.count; i ++) {
        ((UIButton*) self.enterpriseManagerBtnArray[i]).hidden = YES;
    }
    UIButton *btn = self.enterpriseManagerBtnArray[7];
    [btn setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [self setButtonImageTopAngTitleBottom:btn];
    
    [self.managementView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(self.adImageView.mas_bottom).equalTo(5);
        make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, managerViewHiddenHeight));
    }];
    CGFloat height = self.adImageView.height + managerViewHiddenHeight + 10;
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, height);
}

-(void)flodAction2
{
    self.foleBtn2.hidden = YES;
    if (!_isShowinfoAll) {
        return;
    }
    _isShowinfoAll = !_isShowinfoAll;
    [self.enterinfoManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.enterpriseManagerView.mas_bottom).equalTo(0);
        make.height.equalTo(230);
    }];
    for (int i = 8; i < self.enterinfoMangerBtnArray.count; i ++) {
        ((UIButton*) self.enterinfoMangerBtnArray[i]).hidden = YES;
    }
    UIButton *btn = self.enterinfoMangerBtnArray[7];
    [btn setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    [self setButtonImageTopAngTitleBottom:btn];
    
}

// 设置按钮 图上字下
- (void)setButtonImageTopAngTitleBottom:(UIButton *)btn {
    CGFloat imageWith = btn.imageView.frame.size.width;
    CGFloat imageHeight = btn.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    labelWidth = btn.titleLabel.intrinsicContentSize.width;
    labelHeight = btn.titleLabel.intrinsicContentSize.height;
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-10/2.0, 0, 0, -labelWidth);
    labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-10/2.0, 0);
    btn.titleEdgeInsets = labelEdgeInsets;
    btn.imageEdgeInsets = imageEdgeInsets;
}
#pragma mark --  企业管理 事件
- (void)orangeManageBtnClick:(UIButton *)sender{
    ischoose = YES;
    if (!_isLogined) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    if (self.currentPersonCompanyArray.count == 0) {
        if (sender.tag == 7) {
            if (_isShowAll) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您没有公司!" controller:self sleep:2.0];
                return;
            }
        }else if (sender.tag != 0 && sender.tag != 1) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"您没有公司!" controller:self sleep:2.0];
            return;
        }
    }else{
        // 没选择公司的选择公司
        if (self.currentCompanyModel == nil ) {
            //        [self showCurrentPersonCompanyList];
            [self showCurrentPersonCompanyListMethodTwo:sender];
        }
    }
    
    
    if (sender.tag == 0) {
        // 我的公司
        [self getCompanyList];
        return;
    }
    
    if (sender.tag == 1) {
        // 我的工地
        MyConstructionSiteViewController *vc = [[MyConstructionSiteViewController alloc]init];
        vc.agencysJob = self.currentModel.agencysJob;
        vc.implement = self.currentModel.implement;
        vc.cityId = self.currentModel.companyCity?:@"0";
        vc.countyId = self.currentModel.companyCounty?:@"0";
        NSInteger company = [self.currentModel.companyType integerValue];
        NSString *companyFlag = @"";
        if (company==1018||company==1064||company==1065) {
            companyFlag = @"1";
        }
        else
        {
            companyFlag = @"2";
        }
        vc.companyFlag = companyFlag;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 2) {
        // 公司企业
        int a = [self.currentModel.appVip intValue];
        
        if (a == 1) {
            //未过期
            if ([self.currentModel.companyType integerValue]==1018 || [self.currentModel.companyType integerValue]==1065 ||
                [self.currentModel.companyType integerValue]==1064) {
                CompanyDetailViewController *VC = [[CompanyDetailViewController alloc] init];
                VC.companyID = self.currentModel.companyId;
                VC.companyName = self.currentModel.companyName;
                VC.origin = @"2";
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{
                ShopDetailViewController *VC = [[ShopDetailViewController alloc] init];
                VC.origin = @"2";
                VC.shopID = self.currentModel.companyId;
                VC.shopName = self.currentModel.companyName;
                [self.navigationController pushViewController:VC animated:YES];
            }
        } else {
            // 过期
            [self showViewWithoutOpenVIP];
        }
    }
    if (sender.tag == 3) {
        // 商品展示
        // 设计师 商品展示
        int a = [self.currentModel.appVip intValue];
        if (a == 1) {
            BackGoodsListViewController *vc = [[BackGoodsListViewController alloc] init];
            vc.shopId = self.currentModel.companyId;
            vc.agencJob = self.currentModel.agencysJob.integerValue;
            vc.companyType = self.currentModel.companyType;
            vc.implement = self.currentCompanyModel.implement;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // 过期
            [self showViewWithoutOpenVIP];
        }
    }
    if (sender.tag == 4) {
//        // 店铺的现在灭有计算器模板
//        if (self.currentModel.companyType.integerValue != 1018 &&
//            self.currentModel.companyType.integerValue != 1064 &&
//            self.currentModel.companyType.integerValue != 1065) {
//
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请切换到公司查看"];
//            return;
//        }
        // 计算器模板
        // 只有总经理 经理 设计师  可以编辑基础模板
        if (self.currentModel != nil) {
            BLEJBudgetTemplateController *VC = [[BLEJBudgetTemplateController alloc] init];
            VC.companyID = [NSString stringWithFormat:@"%ld", (long)self.currentCompanyModel.companyId];
            VC.companyLogo = self.currentCompanyModel.companyLogo;
            VC.model = self.currentModel;
            NSInteger agencyJob = self.currentCompanyModel.agencyJob;
            if (agencyJob == 1010||agencyJob == 1002||agencyJob ==1003||self.currentCompanyModel.implement) {  // 设计师可以编辑 其他人不可以编辑
                VC.isCanEdit = YES;
            } else {
                VC.isCanEdit = NO;
            }
            [self.navigationController pushViewController:VC animated:YES];
//            BLEJTemplatePackageViewController *vc =[BLEJTemplatePackageViewController new];
//            vc.companyID = [NSString stringWithFormat:@"%ld", (long)self.currentCompanyModel.companyId];
//            vc.textString =self.currentModel.companyIntroduction;
//            vc.model =self.currentModel;
//            NSInteger agencyJob = self.currentCompanyModel.agencyJob;
//            if (agencyJob == 1010||agencyJob == 1002||agencyJob ==1003||self.currentCompanyModel.implement) {  // 设计师可以编辑 其他人不可以编辑
//                vc.editStatus =YES;
//            } else {
//                vc.editStatus=NO;
//            }
//
//            [self.navigationController pushViewController:vc animated:YES];
//
        }
    }
    if (sender.tag == 5) {
        // 新闻活动
        ZCHNewsActivityController *newsVC = [[ZCHNewsActivityController alloc] init];
        newsVC.model = self.currentModel;
        newsVC.implement = self.currentCompanyModel.implement;
        __weak typeof(self) weakSelf = self;
        newsVC.ZCHNewsActivityVipBlock = ^{
            weakSelf.currentModel.calVip = @"1";
        };
        [self.navigationController pushViewController:newsVC animated:YES];
    }
    if (sender.tag == 6) {
        // 联盟活动 商户联盟
        [self requestUninPower];
    }
    if (sender.tag == 7) {
        if (_isShowAll) {
            // 点击事件
            if (self.currentCompanyModel == nil) {
                
                [self showCurrentPersonCompanyListMethodTwo:sender];
                return;
            }
            // 公司认证
            // 获取公司认证状态
            MJWeakSelf;
            NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAuthentication/getCompanyAuthencation.do"];
            NSDictionary *paramDic = @{@"companyId":@(self.currentCompanyModel.companyId)
                                       };
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                switch ([responseObj[@"code"] integerValue]) {
                    case 1002: // 未认证
                    {
                        CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
                        VC.companyId = [NSString stringWithFormat:@"%ld", (long)self.currentCompanyModel.companyId];
                        VC.CertificatSuccessBlock = ^{
                        };
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                    }
                        break;
                    case 1000:
                    {
                        CertificationModel *cModel = [CertificationModel yy_modelWithJSON:responseObj[@"data"][@"data"]];
                        
                        CertificateSuccessNewController *vc = [[CertificateSuccessNewController alloc] initWithNibName:@"CertificateSuccessNewController" bundle:nil];
                        vc.model = cModel;
                        vc.companyId = [NSString stringWithFormat:@"%ld", (long)weakSelf.currentCompanyModel.companyId];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        
                    }
                        break;
                    default:
                        break;
                }
            } failed:^(NSString *errorMsg) {
                
            }];
            
        } else {
            // 展开动作
            _isShowAll = !_isShowAll;
            self.foldBtn.hidden = NO;
            [self.enterpriseManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(0);
                make.top.equalTo(0);
                make.height.equalTo(400);
            }];
            for (int i = 8; i < self.enterpriseManagerBtnArray.count; i ++) {
                ((UIButton*) self.enterpriseManagerBtnArray[i]).hidden = NO;
            }
            [self.managementView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.top.equalTo(self.adImageView.mas_bottom).equalTo(5);
                make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, managerViewHeight));
            }];
            CGFloat height = self.adImageView.height + managerViewHeight + 10;
            self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, height);
            
            [sender setImage:[UIImage imageNamed:@"btn_gongsirenzheng"] forState:UIControlStateNormal];
            [sender setTitle:@"公司认证" forState:UIControlStateNormal];
            [self setButtonImageTopAngTitleBottom:sender];
        }
        return;
    }

    if (sender.tag == 8) {
        // 定金收入
        CompanyIncomeController *vc = [[CompanyIncomeController alloc ] initWithNibName:@"CompanyIncomeController" bundle:nil];
        vc.companyId = [NSString stringWithFormat:@"%ld", self.currentCompanyModel.companyId];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    if (sender.tag == 9) {
        // 合作企业
        ZCHCooerateCompanyController *cooperateVC = [[ZCHCooerateCompanyController alloc] init];
        cooperateVC.companyId = self.currentModel.companyId;
        BOOL isShop = NO;
        if ([self.currentModel.companyType integerValue]==1018 || [self.currentModel.companyType integerValue]==1064 || [self.currentModel.companyType integerValue]==1065) {
            isShop = NO;
        }
        else{
            isShop = YES;
        }
        cooperateVC.isShop = isShop;
        cooperateVC.companyModel = self.currentModel;
        [self.navigationController pushViewController:cooperateVC animated:YES];
        
    }

    
    if (sender.tag == 10) {
        // 广告管理
        UploadAdvertisementController *VC = [[UploadAdvertisementController alloc] init];
        VC.companyID = self.currentModel.companyId;
       // BOOL isShop = NO;
//        if ([self.currentModel.companyType integerValue]==1018 || [self.currentModel.companyType integerValue]==1064 || [self.currentModel.companyType integerValue]==1065) {
//            isShop = NO;
//        }
//        else{
//            isShop = YES;
//        }
       // VC.isShop = isShop;
        VC.adBlock = ^(NSInteger hasImage) {
        };
        [self.navigationController pushViewController:VC animated:YES];
    }

    if (sender.tag == 11) {//红包管理

        RedEnvelopeManagementViewController *controller = [RedEnvelopeManagementViewController new];
        controller.currentModel = self.currentModel;
        controller.curremtModelArray = self.curremtModelArray;
        controller.currentPersonCompanyArray = self.currentPersonCompanyArray;
        controller.currentCompanyModel = self.currentCompanyModel;
        [self.navigationController pushViewController:controller animated:true];

    }

    if (sender.tag == 12) {//五网合一
        NetworkManagementViewController *controller = [NetworkManagementViewController new];
        controller.currentModel = self.currentModel;
        controller.curremtModelArray = self.curremtModelArray;
        controller.currentPersonCompanyArray = self.currentPersonCompanyArray;
        controller.currentCompanyModel = self.currentCompanyModel;
        [self.navigationController pushViewController:controller animated:true];
    }
}
//  未开通会员 商品展示 ----提示开通企业网会员
- (void)showViewWithoutOpenVIP {
    
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您未开通企业网会员，开通后可查看，立即开通？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            // 跳转开通会员
            VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
            VC.companyId = self.currentModel.companyId;
            __weak typeof(self) weakSelf = self;
            VC.successBlock = ^() {
                [weakSelf getCurrentCompanyModel];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"开通", nil];
    [alertView show];
}
#pragma mark - 点击屏幕使alertView消失
- (void)tap:(UITapGestureRecognizer *)tap {
    
    if (tap.state == UIGestureRecognizerStateEnded){
        CGPoint location = [tap locationInView:nil];
        if (![self.alertView pointInside:[self.alertView convertPoint:location fromView:self.alertView.window] withEvent:nil]){
            [self.alertView.window removeGestureRecognizer:tap];
            [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}


#pragma mark -- 个人管理 事件
- (void)personalManagerAction:(UIButton *)sender {
    // @"我的美文", @"我的名片", @"我的代金券", @"打赏收入", @"我的号码通"
    if (!_isLogined) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    switch (sender.tag) {
        case 0:
        {
            // 我的美文
            MyBeautifulArtController *vc = [[MyBeautifulArtController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            // 我的名片
            NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
            NSInteger agencyid = self.userModel.agencyId;
            if (!agencyid||agencyid == 0) {
                agencyid = 0;
            }
            vc.agencyId = [NSString stringWithFormat:@"%ld", agencyid];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            // 我的代金券
            STYMyCashCouponController *myCashVC = [STYMyCashCouponController new];
            [self.navigationController pushViewController:myCashVC animated:YES];
        }
            break;
//        case 3:
//        {
//            // 我的号码通
//            ZCHCalculatorPayController *VC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
//            __block NSString *companyId = @"0";
//            if (self.currentCompanyModel!= nil &&  self.currentCompanyModel.companyId > 0) {
//            companyId = [NSString stringWithFormat:@"%ld", self.currentCompanyModel.companyId];
//            }
//            VC.isNotCompany = YES;
//            VC.companyId = companyId;
//            VC.type = @"1";
//            MJWeakSelf;
//            VC.refreshBlock = ^() {
//            };
//            [weakSelf.navigationController pushViewController:VC animated:YES];
//        }
//            break;
            // @"我的订单", @"我的钱包", @"我的分销", @"我的收藏
        case 3:
        {
            MyOrderViewController *orderVC = [MyOrderViewController new];
            orderVC.agencyId = self.userModel.agencyId;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case 4:
        {
        //我的钱包
        mywalletVC *vc = [mywalletVC new];
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
        // @"我的分销"
        DistributionControlVC *vc = [DistributionControlVC new];
        [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            CollectionViewController *vC = [[CollectionViewController alloc]init];
            [self.navigationController pushViewController:vC animated:YES];
        }
             break;
        case 7:
        {
            if (_isShowinfoAll) {
                //我的收藏
                myattentionVC *vc = [myattentionVC new];
                vc.companyId = [NSString stringWithFormat:@"%ld", self.currentCompanyModel.companyId];
                [self.navigationController pushViewController:vc animated:YES];
            }else{

                _isShowinfoAll = !_isShowinfoAll;
                [self.foleBtn2 setHidden:NO];
                [self.enterinfoManagerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(0);
                    make.top.equalTo(self.enterpriseManagerView.mas_bottom).equalTo(0);
                    make.height.equalTo(310);
                }];
                for (int i = 8; i < self.enterinfoMangerBtnArray.count; i ++) {
                    ((UIButton*) self.enterinfoMangerBtnArray[i]).hidden = NO;
                }
                [sender setImage:[UIImage imageNamed:@"btn_guanzhu"] forState:UIControlStateNormal];
                [sender setTitle:@"关注" forState:UIControlStateNormal];
                [self setButtonImageTopAngTitleBottom:sender];

            }
        }
            break;
        case 8:
        {
            //草稿箱
            draftboxVC *vc = [draftboxVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark ---消息中心的Button点击事件

- (void)redManageBtnClick:(UIButton *)sender{
    if (!_isLogined) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    switch (sender.tag) {
        case 0:
        {
            CalculateViewController *vc = [[CalculateViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            NeedDecorationViewController *vc = [[NeedDecorationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ActivityMessageViewController *vc = [[ActivityMessageViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            CompanyApplyViewController *vc = [[CompanyApplyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            UnionInviteMessageController *vc = [[UnionInviteMessageController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            ZCHUnionApplyMsgController *vc = [[ZCHUnionApplyMsgController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            // 合作企业
            ZCHCooperateMesController *cooperateMesVC = [[ZCHCooperateMesController alloc] init];
            [self.navigationController pushViewController:cooperateMesVC animated:YES];
        }
            break;
//        case 7:
//        {
//            citywideMessageVC *vc = [citywideMessageVC new];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        default:
            break;
    }
}

#pragma mark - 数据统计Button的点击事件

- (void)greenManageBtnClick:(UIButton *)sender{
    if (!_isLogined) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    DayStatisticsViewController *vc = [[DayStatisticsViewController alloc]init];
    if (self.currentCompanyModel.companyId == 0) {//self.currentPersonCompanyArray
        if (self.currentPersonCompanyArray.count > 0) {
            YGLCurrentPersonCompanyModel *model = self.currentPersonCompanyArray[0];
            vc.companyId = [NSString stringWithFormat:@"%ld", model.companyId];
        }else{
            SHOWMESSAGE(@"您还没有公司")
            return;
        }
    }else
        vc.companyId = [NSString stringWithFormat:@"%ld", self.currentCompanyModel.companyId];
    vc.currentPerson = @(self.userModel.agencyId).stringValue;
    switch (sender.tag) {
        case 0:
        {
            vc.DayStatisticsViewControllerType = DayStatisticsViewControllerTypeDay;
            vc.title = [NSString stringWithFormat:@"%@ - 周统计", self.currentCompanyModel.companyName];
            vc.type = 2;
        }
            break;
        case 1:
        {
            vc.DayStatisticsViewControllerType = DayStatisticsViewControllerTypeWeek;
            vc.title = [NSString stringWithFormat:@"%@ - 月统计", self.currentCompanyModel.companyName];
            vc.type = 1;
        }
            break;
        case 2:
        {
            vc.DayStatisticsViewControllerType = DayStatisticsViewControllerTypeMonth;
            vc.title = [NSString stringWithFormat:@"%@ - 年统计", self.currentCompanyModel.companyName];
            vc.type = 0;
        }
            break;
        case 3:
            SHOWMESSAGE(@"敬请期待")
            return;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 获取广告图
- (void)getAdImgAction{
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"carouselImg/v2/getCityImgList.do"];
    UserInfoModel *userInfo = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    NSDictionary *param = @{
                            @"currentPerson": @(userInfo.agencyId)
                            };
    
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            NSArray *bannerList = responseObj[@"data"][@"bannerList"];
            if (bannerList.count > 0) {
                NSDictionary *imageInfoDic = bannerList[0];
                NSString *imageUrlStr = imageInfoDic[@"picUrl"];
                NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
                [self.adImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"cloud_banner"]];
                self.adImageView.userInteractionEnabled = YES;
                self.adImageHref = imageInfoDic[@"picHref"];
                UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImageTapAction)];
                [self.adImageView addGestureRecognizer:tapGR];
            }
            
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

- (void)adImageTapAction {
    NSString *webUrl = self.adImageHref;
    if (webUrl.length > 0) {
        if (![webUrl ew_isUrlString]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
            return;
        }
        AdvertisementWebViewController *adWebViewVC = [[AdvertisementWebViewController alloc] init];
        adWebViewVC.webUrl = webUrl;
        [self.navigationController pushViewController:adWebViewVC animated:YES];
    }
}

#pragma mark - 获取当前公司model2
- (void)getCurrentCompanyModel {
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *requestString = [BASEURL stringByAppendingString:@"company/findCompanyList.do"];
    NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                          };
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            NSDictionary *dict = responseObj[@"data"];
            NSArray *arr = [dict objectForKey:@"companyList"];
            for (NSDictionary *dic in arr) {
                if ([dic[@"companyId"] integerValue] == self.currentCompanyModel.companyId) {
                    self.currentModel = [SubsidiaryModel yy_modelWithDictionary:dic];
                }
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 我的公司判断权限
- (void)getCompanyList {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *requestString = [BASEURL stringByAppendingString:@"company/findCompanyList.do"];
    NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                          };
    [self.view hudShow];
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
        [self.view hiddleHud];
        if ([responseObj[@"code"] isEqualToString:@"1001"]) {
            //该用户还未加入公司
            CreateCompanyViewController *vc = [[CreateCompanyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            MyCompanyViewController *companyVC = [[MyCompanyViewController alloc]init];
            [self.navigationController pushViewController:companyVC animated:YES];
        }
        if ([responseObj[@"code"] isEqualToString:@"1002"]) {
            [self showAlertViewWithNoCompany];
        }
        if ([responseObj[@"code"] isEqualToString:@"2000"]){
            [[PublicTool defaultTool] publicToolsHUDStr:@"查询出现错误" controller:self sleep:2.0];
        }
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:2.0];
    }];
}

// 没有公司去创建或加入公司
- (void)showAlertViewWithNoCompany {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还没有公司，如果您是总经理请创建公司，其他职位请申请加入公司。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"创建公司" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CreateCompanyViewController *companyVC = [[CreateCompanyViewController alloc]init];
        [self.navigationController pushViewController:companyVC animated:YES];
    }];
    UIAlertAction *joinAction = [UIAlertAction actionWithTitle:@"加入公司" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JoinCompanyController *vc = [[JoinCompanyController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:createAction];
    [alert addAction:joinAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 300) {
        if (buttonIndex == 1) {
            //创建联盟
            SSPopup* selection=[[SSPopup alloc]init];
            selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
            
            selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
            selection.SSPopupDelegate=self;
            [self.view addSubview:selection];
            NSMutableArray *temArray = [NSMutableArray array];
            for (UnionCompanyModel *model in self.companyArray) {
                [temArray addObject:model.companyName];
            }
            
            NSArray *QArray = [temArray copy];
            
            [selection CreateTableview:QArray withTitle:@"请选择联盟所属公司" setCompletionBlock:^(int tag) {
                YSNLog(@"%d",tag);
                CreatShopUnionController *vc =[[CreatShopUnionController alloc]init];
                //        vc.areaListArray = self.areaListArray;
                UnionCompanyModel *model = self.companyArray[tag];
                vc.companyId = model.companyId;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
             ];
        }
        if (buttonIndex == 2) {
            // 申请加入联盟
            SSPopup* selection=[[SSPopup alloc]init];
            selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
            
            selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
            selection.SSPopupDelegate=self;
            [self.view addSubview:selection];
            NSMutableArray *temArray = [NSMutableArray array];
            for (UnionCompanyModel *model in self.companyArray) {
                [temArray addObject:model.companyName];
            }
            NSArray *QArray = [temArray copy];
            [selection CreateTableview:QArray withTitle:@"请选择联盟所属公司" setCompletionBlock:^(int tag) {
                YSNLog(@"%d",tag);
                SearchUnionController *vc =[[SearchUnionController alloc]init];
                //                //        vc.areaListArray = self.areaListArray;
                UnionCompanyModel *model = self.companyArray[tag];
                vc.companyId = model.companyId;
                vc.companyName = model.companyName;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
             ];
            
        }
        
        if (buttonIndex==3) {
            //查看联盟
            if (self.unionArray&&self.unionArray.count>0) {
                NSMutableArray *temArray = [NSMutableArray array];
                for (NSDictionary *dict in self.unionArray) {
                    NSString  *unionName = [dict objectForKey:@"unionName"];
                    [temArray addObject:unionName];
                }
                
                SSPopup* selection=[[SSPopup alloc]init];
                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                
                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                selection.SSPopupDelegate=self;
                [self.view addSubview:selection];
                
                
                NSArray *QArray = [temArray copy];
                
                [selection CreateTableview:QArray withTitle:@"请选择查看联盟" setCompletionBlock:^(int tag) {
                    YSNLog(@"%d",tag);
                    
                    NSDictionary *dict = self.unionArray[tag];
                    NSInteger unionId = [[dict objectForKey:@"unionId"] integerValue];
                    [self requestUnionDetailInfoWith:unionId];
                }
                 ];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无联盟，请选择加入或创建联盟" controller:self sleep:2.0];
            }
        }
    }
}
#pragma mark - 查询联盟相关权限
-(void)requestUninPower{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"union/getJurisdiction.do"];
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            _isZongjingli = [responseObj[@"isZongjingli"] boolValue];
            implement = [responseObj[@"implement"] boolValue];;
           // _isJingLi = [responseObj[@"isJingLi"] boolValue];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            if (statusCode==1000) {
                //进入联盟
                NSArray *array = responseObj[@"union"];
                [self.unionArray removeAllObjects];
                [self.unionArray addObjectsFromArray:array];
                NSArray *companyArray = responseObj[@"companyList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[UnionCompanyModel class] json:companyArray];
                self.companyArray = [NSMutableArray array];
                [self.companyArray addObjectsFromArray:arr];
                if (_isZongjingli||implement) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请选择创建或申请加入联盟或查看联盟"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"创建联盟", @"加入联盟",@"查看联盟",nil];
                    alert.tag = 300;
                    [alert show];
                }
                else{
                    
                    //是否有联盟列表
                    if (self.unionArray&&self.unionArray.count>0){

                        NSMutableArray *temArray = [NSMutableArray array];
                        for (NSDictionary *dict in self.unionArray) {
                            NSString  *unionName = [dict objectForKey:@"unionName"];
                            [temArray addObject:unionName];
                        }
                        
                        SSPopup* selection=[[SSPopup alloc]init];
                        selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                        
                        selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                        selection.SSPopupDelegate=self;
                        [self.view addSubview:selection];
                        NSArray *QArray = [temArray copy];
                        [selection CreateTableview:QArray withTitle:@"请选择查看联盟" setCompletionBlock:^(int tag) {
                            YSNLog(@"%d",tag);
                            
                            NSDictionary *dict = self.unionArray[tag];
                            NSInteger unionId = [[dict objectForKey:@"unionId"] integerValue];
                            [self requestUnionDetailInfoWith:unionId];
                        }
                         ];
                    }
                    else{
                        [[PublicTool defaultTool] publicToolsHUDStr:@"该公司还未加入联盟" controller:self sleep:1.5];
                    }
                    
                }
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您还未加入公司" controller:self sleep:2.0];
            }
            
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"该公司还未加入联盟" controller:self sleep:2.0];
            }
            else if (statusCode==1005) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您没有分公司" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
        }
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
    }];
}

#pragma mark - 查询联盟详情
-(void)requestUnionDetailInfoWith:(NSInteger)unionId{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"union/getListByCreatePerson.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"unionId":@(unionId),
                               @"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *array = responseObj[@"data"];
                NSDictionary *temDict = array.firstObject;
                NSArray *tempArray = [temDict objectForKey:@"companyList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[ShopUnionListModel class] json:tempArray];
                NSMutableArray *dataArray = [NSMutableArray array];
                [dataArray addObjectsFromArray:arr];
                
                NSString *unionLogo = temDict[@"unionLogo"];
                NSString *unionNumber = temDict[@"unionNumber"];
                NSString *unionName = temDict[@"unionName"];
                NSString *unionId = temDict[@"unionId"];
                NSString *unionPwd = temDict[@"unionPwd"];
                if (!unionPwd) {
                    unionPwd = @"111111";
                }
                BOOL isLeader = [temDict[@"isLeader"] boolValue];
                BOOL isZManage = [temDict[@"zjl"] boolValue];
                BOOL isFManage = [temDict[@"jl"] boolValue];
                
                ShopUnionListController *vc = [[ShopUnionListController alloc]init];
                vc.dataArray = dataArray;
                vc.unionLogo = unionLogo;
                vc.unionNumber = unionNumber;
                vc.unionName = unionName;
                vc.unionPwd = unionPwd;
                vc.unionId = [unionId integerValue];
                vc.isLeader = isLeader;
                vc.isZManage = isZManage;
                vc.isFManage = isFManage;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}


- (void)getMessageNumDataWithNetWork {
    
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        
        //__block NSInteger totalUnreadCount = 0;

        NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
        if (!agencyid||agencyid == 0) {
            agencyid = 0;
        }
        UserInfoModel *userInfo = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"message/getMessageNum.do"];
        NSDictionary *paramDic = @{
                                   @"agencyId":@(agencyid),
                                   @"phone": @(userInfo.phone.integerValue)
                                   };
        
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(NSDictionary *responseObj) {
            // 加载成功
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (code == 1000) {
                    NSDictionary *numDic = [responseObj objectForKey:@"data"];
                    NSMutableArray *numArray = [NSMutableArray array];
                    // 计算器报价消息数量
                    NSInteger calCount = [numDic[@"calCount"] integerValue];
                    [numArray addObject:@(calCount)];
                    //客户预约
                    NSInteger callDeco = [numDic[@"callDeco"] integerValue];
                    [numArray addObject:@(callDeco)];
                    
                    //活动报名
                    NSInteger signupMessageNum = [numDic[@"signupMessageNum"] integerValue];
                    [numArray addObject:@(signupMessageNum)];
                    //公司申请
                    NSInteger companyApply = [numDic[@"companyApply"] integerValue];
                    [numArray addObject:@(companyApply)];
                    //联盟邀请
                    NSInteger invatationSum = [numDic[@"invatationSum"] integerValue];
                    [numArray addObject:@(invatationSum)];
                    //联盟申请
                    NSInteger unionApplyNum = [numDic[@"unionApplyNum"] integerValue];
                    [numArray addObject:@(unionApplyNum)];
                    // 合作企业
                    NSInteger enterPriseCount = [numDic[@"enterPriseCount"] integerValue];
                    [numArray addObject:@(enterPriseCount)];
//                    //同城发布
//                    NSInteger citywideMessage = [numDic[@"citywideMessage"] integerValue];
//                    [numArray addObject:@(citywideMessage)];
                    
                    //关注消息数量
                    NSInteger attentionMessageSum = [numDic[@"attentionMessageSum"]integerValue];
                    [numArray addObject:@(attentionMessageSum)];

                    
                    UILabel *newnewlab = [self.managementView viewWithTag:1000];
                    if (attentionMessageSum==0) {
                        [newnewlab setHidden:YES];
                    }
                    else
                    {
                         [newnewlab setHidden:NO];
                         newnewlab.text = [NSString stringWithFormat:@"%ld",attentionMessageSum];
                    }
                    
                    NSInteger totalNum = 0;
                    for (int i = 0; i < self.messageCenterLabelArray.count; i ++) {
                        UILabel *label = self.messageCenterLabelArray[i];
                        label.text = [NSString stringWithFormat:@"%ld", (long)[numArray[i] integerValue]];
                        label.hidden = [label.text isEqualToString:@"0"];
                        
                    }
                    
                    for (int i = 0; i<numArray.count; i++) {
                        totalNum += [numArray[i] integerValue];
                    }
                    if (totalNum > 0) {
                        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld", (long)totalNum]];
                    } else {
                        [self.tabBarItem setBadgeValue:nil];
                    }
                }
            });
        } failed:^(NSString *errorMsg) {
             [self.tabBarItem setBadgeValue:nil];
        }];
    }else {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)qrBtnClick:(UIButton *)btn{
    ScancodeController *vc = [[ScancodeController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)unionArray {
    if (_unionArray == nil) {
        _unionArray = [NSMutableArray array];
    }
    return _unionArray;
}

@end
