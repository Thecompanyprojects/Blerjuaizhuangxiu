//
//  ShopDetailViewController.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "shopDetailView.h"
#import "PanoramaViewController.h"
#import "BuildCaseViewController.h"
#import "CompanyIntroductController.h"
#import "goodsModel.h"
#import "ZCHGoodsDetailViewController.h"
#import "MaterialCalculatorController.h"
#import "OwnerEvaluateController.h"
#import "CompanyDetailViewController.h"
#import "ZCHCooerateCompanyController.h"
#import "ZCHCooperateController.h"
#import "SDCycleScrollView.h"
#import "MainMaterialDiaryController.h"
#import "PellTableViewSelect.h"
#import "LoginViewController.h"
#import "ComplainViewController.h"
#import "NSObject+CompressImage.h"
#import "ZCHCooperateListModel.h"
#import "DecorateNeedViewController.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "ZCHBudgetGuideConstructionCaseCell.h"
#import "YellowPageActivityCell.h"
#import "WQLPaoMaView.h"
#import "ActivityCustomDefine.h"
#import "HistoryActivityViewController.h"
#import "ActivityShowController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "AdvertisementWebViewController.h"
#import "ExcellentStaffViewController.h"
#import "ZCHNewsInforController.h"
#import "NewsActivityShowController.h"
#import "YellowGoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "ZCHPublicWebViewController.h"
#import "senceWebViewController.h"
#import "senceModel.h"
#import "SubsidiaryModel.h"
#import "YellowActicleView.h"
#import "ZCHCalculatorItemsModel.h"
#import "BLEJBudgetGuideController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "homenewsVC.h"
#import "JinQiViewController.h"
#import "SendFlowersViewController.h"
#import "XianHuaJinQiGuanzhuCell.h"
@interface ShopDetailViewController ()

@property(nonatomic,strong)UITableView *table;

@property (copy, nonatomic) NSString *lastCellHeight;
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic)UILabel *jinQiL;
@property (strong, nonatomic)UILabel *xianHuaL;



// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 置顶的公司列表
@property (strong, nonatomic) NSMutableArray *topConstructionList;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
@property(strong,nonatomic)BLRJCalculatortempletModelAllCalculatorcompanyData *allCalculatorCompanyData;
// 预算报价的顶部图片
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
// 预算报价的底部图片
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;


@property(nonatomic,strong)NSMutableArray *companyItemArray;
//顶部底部图片数组
@property(nonatomic,strong)NSMutableArray *topImageArr;
@property(nonatomic,strong)NSMutableArray *bottomImageArr;
//广告图信息字典数组
@property (nonatomic, strong) NSMutableArray *adListDictArray;
// 推荐工地数组
@property (nonatomic, strong) NSMutableArray *reommendConArray;
// 全景数组
@property (strong, nonatomic) NSMutableArray *viewList;

// 材料计算器的图片地址数组
@property (nonatomic, strong) NSMutableArray *calImageArray;

// 店铺的基本信息
@property (strong, nonatomic) NSMutableDictionary *companyDic;

// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 分享的遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 是否是内网状态
@property (nonatomic, assign) BOOL isInnerNetState;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
// 是否收藏了的标识
@property (nonatomic, strong) NSString *collectFlag;
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *adScrollView;

// 合作企业
@property (strong, nonatomic) NSMutableArray *cooperateArr;

// 合作企业cell
@property (strong, nonatomic) UITableViewCell *cooperateCell;
@property (strong, nonatomic) UILabel *goodCountLabel;

// 是否是经理
@property (assign, nonatomic) BOOL isManager;

// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;

// 底部收藏按钮
@property (strong, nonatomic) UIButton *collectionBtn;

@property (nonatomic, assign) BOOL hasSupport; // 是否点赞
@property (nonatomic, strong) UIButton *supportButton;

@property (nonatomic, assign) BOOL hasActivity; // 是否有活动
// 当前活动
@property (nonatomic, strong) NSMutableDictionary *activityDict;
// 以往活动列表
@property (nonatomic, strong) NSMutableArray *acticityArray;
// 用户自定义字段数组
@property (nonatomic, strong) NSMutableArray *customDefineArray;
// 已报名用户手机号数组
@property (nonatomic, strong) NSMutableArray *userPhoneArray;
@property (nonatomic, strong) UIButton *checkCodeBtn;
@property (nonatomic, assign) CGFloat activityImageHeight;

@property (nonatomic, strong) NSMutableAttributedString *paoMaoAttribureStr;
@property (strong, nonatomic) NSMutableArray *phoneArr;

@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@property (strong, nonatomic) SDCycleScrollView *allView;
@property (copy, nonatomic) NSString *imageVerificationCode;

@property (strong, nonatomic)UIImageView *jinQi;
@property (strong, nonatomic)UIImageView *xianHua;

@property (strong, nonatomic)UIView *FlipView;
@property (strong, nonatomic)UIView *baseView;
@end

@interface ShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,shopDetailViewDelagate, SDCycleScrollViewDelegate,UIActionSheetDelegate> {
    // 验证码倒计时时间
    dispatch_source_t _vertifytime;
    CGFloat dynamicHeight;
    CGFloat paoMaHeight;
    CGFloat signUpHeight;
   
}
//存放商品数据的数组
@property(nonatomic,strong)NSMutableArray *goodListArray;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //存放商品
    self.goodListArray = [NSMutableArray array];
    //广告list
    self.topImageArr = [NSMutableArray array];
    self.bottomImageArr=[NSMutableArray array];
    self.adListDictArray = [NSMutableArray array];
    // 工地推荐
    self.reommendConArray = [NSMutableArray array];
    // 材料计算器图片数组
    self.calImageArray = [NSMutableArray array];
    // 合作企业
    self.cooperateArr = [NSMutableArray array];
    
    self.bottomCalculatorImageArr=[NSMutableArray array];
    self.topCalculatorImageArr=[NSMutableArray array];
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = self.shopName;
    self.isManager = NO;
    self.isInnerNetState = NO;
    //广告轮播图
    self.adScrollView= [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6) delegate:nil placeholderImage:nil];
    self.adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    self.adScrollView.backgroundColor = [UIColor blackColor];
    self.adScrollView.tag = 1000011;
    self.adScrollView.autoScrollTimeInterval = BANNERTIME;
    
    _hasActivity = NO;
    self.acticityArray = [NSMutableArray array];
    self.customDefineArray = [NSMutableArray array];
    self.activityDict = [NSMutableDictionary dictionary];
    self.userPhoneArray = [NSMutableArray array];
    self.phoneArr = [NSMutableArray array];
    self.viewList = [NSMutableArray array];
    self.activityImageHeight = 0;
    _constructionCase=[NSMutableArray array];
    _companyItemArray=[NSMutableArray array];
    self.code =-1;
    //数据获取
     [self requestData];
    [self getData];
    
    [self addBottomView];
    if (_notVipButHaveArticle) {
        [self buildNotVipButHaveActicleView];
    } else {
        [self creatTableView];
        [self creatHeaderView];
    }
    
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
   
    // 分享视图
    [self addBottomShareView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self addSuspendedButton];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"ShopDetail"];
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"kPaoMaContinueAnimation" object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];

}

-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = INSTRCTIONHTML;
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 三点按钮
- (void)moreBtnClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
    
    // 弹出的自定义视图
    NSArray *array;
    if (!self.isManager) {
        if (self.collectFlag.integerValue > 0) { // 已添加到收藏
            array = @[@"取消收藏", @"投诉", @"分享"];
        } else {
            array = @[@"收藏",@"投诉", @"分享"];
        }
    } else {
        
        if (self.collectFlag.integerValue > 0) { // 已添加到收藏
            array = @[@"取消收藏", @"投诉", @"分享",@"合作企业"];
        } else {
            array = @[@"收藏",@"投诉", @"分享",@"合作企业"];
        }


    }
    
    if (_notVipButHaveArticle) {
        if (self.collectFlag.integerValue > 0) { // 已添加到收藏
            array = @[@"取消收藏", @"投诉", @"分享"];
        } else {
            array = @[@"收藏",@"投诉", @"分享"];
        }
    }
    
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        
        
        if (index == 0) { // 收藏  需要登录 ，其他不需要
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录

                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
            }else{
                if (self.collectFlag.integerValue >0) {
                    [self unCollectionShopOrCompany];
                } else {
                    [self saveShopOrCompany];
                }
                
            }
        }else if (index == 1){ // 投诉
            ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
            ComplainVC.companyID = self.shopID.integerValue;
            [self.navigationController pushViewController:ComplainVC animated:YES];
        }else if (index == 2){//分享
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight - kSCREEN_WIDTH/2.0 - 70;
                self.shadowView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
        } else if (index == 3) {
            // 是否是内网状态
            if (_isInnerNetState) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"定制环境，不能查看"];
                return;
            }
            ZCHCooerateCompanyController *cooperateVC = [[ZCHCooerateCompanyController alloc] init];
            cooperateVC.companyId = self.shopID;
            cooperateVC.isShop = YES;
            cooperateVC.companyModel = [SubsidiaryModel new];
            cooperateVC.companyModel.companyProvince = self.companyDic[@"companyProvince"];
            cooperateVC.companyModel.companyCity = self.companyDic[@"companyCity"];
            cooperateVC.companyModel.companyCounty = self.companyDic[@"companyCounty"];
            
            [self.navigationController pushViewController:cooperateVC animated:YES];
        }
        
    } animated:YES];
    
}



- (void)unCollectionShopOrCompany {
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    NSDictionary *paramDic = @{
                               @"collectionId":@(self.collectFlag.integerValue),
                               };
    YSNLog(@"------%@", paramDic);
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                self.collectFlag = @"0";
                [[PublicTool defaultTool] publicToolsHUDStr:@"已从收藏列表中移除" controller:self sleep:1.0];
                self.collectionBtn.selected = NO;
            }
                break;
                
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"操作失败" controller:self sleep:1.0];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)saveShopOrCompany  {
    
    NSString *url = @"collection/add.do";
    NSString *requestString = [BASEURL stringByAppendingString:url];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.shopID.integerValue) forKey:@"relId"]; // 店铺或公司ID
    [params setObject:@(user.agencyId) forKey:@"agencysId"]; // 用户ID
    YSNLog(@"%@", params);
    [NetManager afGetRequest:requestString parms:params finished:^(id responseObj) {
        YSNLog(@"%@",responseObj);
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            self.collectFlag = [NSString stringWithFormat:@"%ld", [responseObj[@"collectionId"] integerValue]];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏成功"];
            self.collectionBtn.selected = YES;
            
        } else if([responseObj[@"code"] isEqualToString:@"1002"]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经收藏过了"];
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

#pragma  mark - 分享 ↓
- (void)addBottomShareView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomShareView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/2.0 + 70)];
    self.bottomShareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.shadowView addSubview:self.bottomShareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"分享给好友";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomShareView addSubview:titleLabel];
    
    NSArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0"];
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"我的二维码"];
    for (int i = 0; i < 5; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%4 * BLEJWidth * 0.25, titleLabel.bottom + 20 + (i/4 * BLEJWidth * 0.25), BLEJWidth * 0.25, BLEJWidth * 0.25)];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickShareContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        [self.bottomShareView addSubview:btn];
    }
    
    
}
- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
}

- (void)didClickShareContentBtn:(UIButton *)btn {

    NSString *shareTitle = self.companyDic[@"companyName"];
    NSString *shareDescription = self.companyDic[@"companyIntroduction"];
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    NSURL *shareImageUrl = [NSURL URLWithString:self.companyDic[@"companyLogo"]];
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.shopLogo == nil) {
        [[UIApplication sharedApplication].keyWindow hudShow];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (image) {
            shareImage = image;
            
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
            
        } else {
            shareImage = [UIImage imageNamed:@"shareDefaultIcon"];
            shareData = UIImagePNGRepresentation(shareImage);
            
        }
    } else {
        shareImage = self.shopLogo;
        
        NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
        if (data.length > 32) {
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
            
        }
    }
    
    
    [self addTwoDimensionCodeView];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%@.htm?origin=%@", self.shopID,self.origin]];
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];

            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopYellowPageShare"];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];

            WXWebpageObject *webPageObject = [WXWebpageObject object];

            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopYellowPageShare"];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 2:
        {// QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];

                NSURL *url = [NSURL URLWithString:shareURL];

                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopYellowPageShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            
            break;
        case 3:
        {// QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                

                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopYellowPageShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            break;
        case 4:
        {// 二维码
            [MobClick event:@"ShopYellowPageShare"];
            self.TwoDimensionCodeView.hidden = NO;
            self.shadowView.hidden = YES;
            self.bottomShareView.blej_y = BLEJHeight;
            [UIView animateWithDuration:0.25 animations:^{
                
                self.TwoDimensionCodeView.alpha = 1.0;
                self.navigationController.navigationBar.alpha = 0;
            }];
        }
            break;
        default:
            break;
    }
    
    // 统计公司分享数量
    [NSObject companyShareStatisticsWithConpanyId:self.shopID];
    
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {
    
    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    //    [self.view sendSubviewToBack:self.tableView];
    self.TwoDimensionCodeView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.TwoDimensionCodeView.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [self.TwoDimensionCodeView addSubview:codeView];
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%@.htm", self.shopID]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hudShow];
        });
        
        UIImage *shareImage;
        if (self.shopLogo == nil) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]]]];
            if (image) {
                shareImage = image;
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            } else {
                shareImage = [UIImage imageNamed:@"shareDefaultIcon"];
                
            }
        } else {
            shareImage = self.shopLogo;
            NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
            if (data.length > 32) {
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hiddleHud];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];
            
        });
    });
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    label.text = @"截屏保存到相册:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    [self.TwoDimensionCodeView addSubview:label];
    
    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10, BLEJWidth, 30)];
    labelBottom.text = @"在微信环境下按住图片识别二维码打开";
    labelBottom.textColor = [UIColor darkGrayColor];
    labelBottom.textAlignment = NSTextAlignmentCenter;
    labelBottom.font = [UIFont systemFontOfSize:16];
    [self.TwoDimensionCodeView addSubview:labelBottom];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.TwoDimensionCodeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeView.mas_top).equalTo(-20);
        make.left.right.equalTo(0);
    }];
    titleLabel.text = @"企业";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    
    UILabel *companyNameLabel = [[UILabel alloc] init];
    [self.TwoDimensionCodeView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top).equalTo(-10);
        make.left.equalTo(codeView).equalTo(6);
        make.right.equalTo(codeView).equalTo(-6);
    }];
    companyNameLabel.text = self.shopName;
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.font = [UIFont systemFontOfSize:20];
    companyNameLabel.textColor = [UIColor blackColor];
    
    self.TwoDimensionCodeView.hidden = YES;
}

- (void)didClickTwoDimensionCodeView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}

#pragma mark  分享 ↑

#pragma mark   界面数据的获取
- (void)requestData {
    
    NSString *url = [NSString stringWithFormat:@"company/yellowInit/%@.do",@(self.shopID.integerValue)];
    NSString *requestString = [BASEURL stringByAppendingString:url];
  
    
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyId = [NSString stringWithFormat:@"%ld", model.agencyId];
    NSDictionary *param = @{@"agencyId": agencyId};
    
    __weak typeof(self) weakSelf = self;
    [NetManager afPostRequest:requestString parms:param finished:^(id responseObj) {
        
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
        
            // 店铺基本信息
            self.companyDic = [NSMutableDictionary dictionaryWithDictionary:[responseObj[@"data"] objectForKey:@"company"]];
    
            self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
            self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
            
            if (self.navigationItem.title.length == 0) {
                self.navigationItem.title = self.companyDic[@"companyName"];
            }
            
            self.isInnerNetState = [responseObj[@"data"][@"inOrOutStatus"] integerValue];
            
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];

            
            UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 0, 50)];
            [footView addSubview:scanLabel];
            scanLabel.font = [UIFont systemFontOfSize:16];
            scanLabel.textColor = [UIColor darkGrayColor];
            scanLabel.text = @"浏览量";
            [scanLabel sizeToFit];
            
            CGSize sizeCount = [self.companyDic[@"displayNumbers"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:16]];
            UILabel *displayCount = [[UILabel alloc] initWithFrame:CGRectMake(scanLabel.right + 10, 0, sizeCount.width, 50)];
            [footView addSubview:displayCount];
            displayCount.textAlignment = NSTextAlignmentLeft;
            displayCount.font = [UIFont systemFontOfSize:16];
            displayCount.textColor = [UIColor darkGrayColor];
            displayCount.text = self.companyDic[@"browse"];
            
            scanLabel.centerY = displayCount.centerY;
            
            UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(displayCount.right, 0, 50, 44)];
            self.supportButton = goodBtn;
            goodBtn.centerY = displayCount.centerY;
            [goodBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
            [goodBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateHighlighted];
            [goodBtn addTarget:self action:@selector(didClickGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:goodBtn];
            
            CGSize goodSizeCount = [self.companyDic[@"likeNumbers"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:16]];
            UILabel *goodCount = [[UILabel alloc] initWithFrame:CGRectMake(goodBtn.right, 0, goodSizeCount.width, 50)];
            self.goodCountLabel = goodCount;
            [footView addSubview:goodCount];
            goodCount.textAlignment = NSTextAlignmentRight;
            goodCount.font = [UIFont systemFontOfSize:16];
            goodCount.textColor = [UIColor darkGrayColor];
            goodCount.text = self.companyDic[@"likeNumbers"];
            
            UIButton *complainBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 50, 0, 50, 50)];
            [complainBtn setTitle:@"投诉" forState:UIControlStateNormal];
            [complainBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            complainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [complainBtn addTarget:self action:@selector(didClickComplainBtn:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:complainBtn];
            
            self.table.tableFooterView = footView;
            
            //商品
            [weakSelf.goodListArray addObjectsFromArray:[NSMutableArray yy_modelArrayWithClass:[goodsModel class] json:responseObj[@"data"][@"merchandies"]]];
            // 全景视图
            [self.viewList removeAllObjects];
            self.viewList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[senceModel class] json:[responseObj[@"data"] objectForKey:@"viewList"]]];
            
           //广告轮播图
            [weakSelf.adListDictArray removeAllObjects];
            [weakSelf.adListDictArray addObjectsFromArray:responseObj[@"data"][@"headImages"]];
            for (NSDictionary *dic in responseObj[@"data"][@"headImages"]) {
                [weakSelf.topImageArr addObject:dic[@"picUrl"]];
            }
            
            [weakSelf.bottomImageArr removeAllObjects];
            for (NSDictionary *dic in responseObj[@"data"][@"footImages"]) {
                [weakSelf.bottomImageArr addObject:dic[@"picUrl"]];
            }
            
            [weakSelf.reommendConArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZCHBudgetGuideConstructionCaseModel class] json:responseObj[@"data"][@"conList"]]];
            
            // 合作企业
            NSArray *cooperateArr = [responseObj[@"data"] objectForKey:@"enterPriseList"];
            [weakSelf.cooperateArr removeAllObjects];
            weakSelf.cooperateCell = nil;
            for (NSDictionary *dict in cooperateArr) {
                
                ZCHCooperateListModel *cooperateModel = [ZCHCooperateListModel yy_modelWithJSON:dict];
                
                if (![weakSelf.cooperateArr containsObject:cooperateModel]) {
                    [weakSelf.cooperateArr addObject:cooperateModel];
                }
            }
            // 是否是经理(可以添加合作企业)
            weakSelf.isManager = [[responseObj[@"data"] objectForKey:@"isManager"] boolValue];
            
            // 计算器顶部视图
            
            
            NSArray *ArrCalculator = [responseObj[@"data"] objectForKey:@"calHeadImages"];
            [self.topCalculatorImageArr removeAllObjects];
            
            
            for (NSDictionary *dict in ArrCalculator) {
                
               
                    [self.topCalculatorImageArr addObject:dict[@"picUrl"]];
                
            }
            
            [self.bottomCalculatorImageArr removeAllObjects];
            NSArray *bottomImageCal = [responseObj[@"data"] objectForKey:@"calFootImages"];
            [self.bottomCalculatorImageArr removeAllObjects];
            
            for (NSDictionary *dict in bottomImageCal) {
                
               
                    [self.bottomCalculatorImageArr addObject:dict[@"picUrl"]];
                
            }
            
          
            weakSelf.collectFlag = responseObj[@"data"][@"inCollection"];
            weakSelf.collectionBtn.selected = [self.collectFlag boolValue];
            
            // 活动列表
            NSArray *array = [responseObj[@"data"] objectForKey:@"activityList"];
            _hasActivity = array.count>0;
            
            if (_hasActivity) {
                if ([NSStringFromClass([array class]) isEqualToString:@"__NSDictionaryI"]) {
                    self.activityDict = [responseObj[@"data"] objectForKey:@"activityList"];
                }else
                    self.activityDict = [array[0] mutableCopy];
                
                self.acticityArray = [array mutableCopy];
                self.customDefineArray =  [[NSArray yy_modelArrayWithClass:[ActivityCustomDefine class] json:self.activityDict[@"custom"]] mutableCopy];
                self.userPhoneArray = [[responseObj[@"data"] objectForKey:@"signUpList"] mutableCopy];
            }
        }
        
        if (weakSelf.topImageArr.count == 0) {
            weakSelf.adScrollView.localizationImageNamesGroup = @[[UIImage imageNamed:@"topbanner_default"]];
        } else {
            weakSelf.adScrollView.imageURLStringsGroup = weakSelf.topImageArr;
        }
        [weakSelf.table reloadData];
    
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
        
    }];
    
}

#pragma mark - 获取计算器模板相关的内容
- (void)getData {
    
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
            
            self.companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:dictData[@"list"]]];
            for (BLRJCalculatortempletModelAllCalculatorTypes *dict in  self.companyItemArray) {
                
                if ( dict.templeteTypeNo  > 2000 &&dict.templeteTypeNo <3000) {
                    [self.baseItemsArr addObject:dict];
                }
                if (dict.templeteTypeNo  ==0) {
                    [self.suppleListArr addObject:dict];
                }
            }
            BLRJCalculatortempletModelAllCalculatorcompanyData* companyData=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:dictData[@"company"]];
            
            self.allCalculatorCompanyData=companyData;
            
            
            
            if (self.baseItemsArr.count==0) {
                
                //如果baseitems数据为空，去本地取出数据
                NSString *strPath = [[NSBundle mainBundle] pathForResource:@"DefaultBaseItem" ofType:@"geojson"];
                NSData *JSONData = [NSData dataWithContentsOfFile:strPath];
                
                id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
                
                
                
                
                self.companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:jsonObject[@"data"][@"list"]]];
                for (BLRJCalculatortempletModelAllCalculatorTypes *dict in  self.companyItemArray) {
                    
                    if ( dict.templeteTypeNo  > 2000 &&dict.templeteTypeNo <3000) {
                        [self.baseItemsArr addObject:dict];
                    }
                    if (dict.templeteTypeNo  ==0) {
                        [self.suppleListArr addObject:dict];
                    }
                }
                BLRJCalculatortempletModelAllCalculatorcompanyData* companyDatas=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:jsonObject[@"data"][@"company"]];
                
                self.allCalculatorCompanyData=companyDatas;
                
            }
            
            
            
            
            
            
            //                if (self.allCalculatorCompanyData.calVip == nil || [self.allCalculatorCompanyData.calVip isEqualToString:@""]) {// 0表示不是会员  还没有开通200
            //
            //                }
            //                self.isOpenVip = [self.allCalculatorCompanyData.calVip integerValue];
            //
            //                if (self.allCalculatorCompanyData.calVipEndTime == nil || [self.allCalculatorCompanyData.calVipEndTime isEqualToString:@""]) {// 0表示不是会员  还没有开通200
            //
            //                }
            
        }else{
            [[PublicTool defaultTool] publicToolsHUDStr:responseObj[@"msg"] controller:self sleep:1.5];
        }
        
        [self.table reloadData];

        
     
        
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:errorMsg controller:self sleep:1.5];
    }];
}
- (void)creatTableView {

    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, kSCREEN_WIDTH, kSCREEN_HEIGHT - 69 - 50) style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    
    self.table.delegate = self;

    self.table.dataSource = self;
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table registerNib:[UINib nibWithNibName:@"ZCHBudgetGuideConstructionCaseCell" bundle:nil] forCellReuseIdentifier:@"ZCHBudgetGuideConstructionCaseCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
    self.table.tableFooterView = footerView;
}

#pragma mark - 添加底部视图
- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth/4, bottomView.height)];
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
    UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.width + 1, 0, BLEJWidth/4-1, bottomView.height)];
    [collectionBtn setImage:[UIImage imageNamed:@"noSelectCollection"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"selectCollection"] forState:UIControlStateSelected];
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [collectionBtn setTitle:@"赠送礼物" forState:UIControlStateNormal];
     [collectionBtn setImage: [UIImage imageNamed:@"icon_liwu"] forState:normal];
  //  [collectionBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn = collectionBtn;
    [bottomView addSubview:collectionBtn];
    
    UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.right, 0, BLEJWidth/4, bottomView.height)];
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

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    [self.phoneArr removeAllObjects];
    
    if (!(!self.companyDic || self.companyDic[@"companyLandline"] == nil || [self.companyDic[@"companyLandline"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyLandline"]];
    }
    
    if (!(!self.companyDic || self.companyDic[@"companyPhone"] == nil || [self.companyDic[@"companyPhone"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyPhone"]];
    }
    if (self.phoneArr.count == 0) {
        return;
    }
    
    UIActionSheet *actionSheet;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    }
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.phoneArr.count == 1) {
        if (buttonIndex == 0) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else {
            
        }
    } else {
        
        if (buttonIndex == 0) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else if (buttonIndex == 1) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[1]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else {
            
        }
    }
}


- (void)didClickCollectionBtn:(UIButton *)btn {// 收藏(取消)
    
    //    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    //    if (!isLogin) { // 未登录
    //
    //        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
    //
    //    } else {
    //        if (self.collectFlag.integerValue > 0) {
    //
    //            [self unCollectionShopOrCompany];
    //        } else {
    //
    //            [self saveShopOrCompany];
    //        }
    //
    //    }
    
    self.FlipView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight+ 180)];
    [self.view addSubview:self.FlipView];
    
    self.baseView =[[UIView alloc]initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth,  180)];
    self.baseView.backgroundColor =[UIColor whiteColor];
    [self.FlipView addSubview:self.baseView];
    
    UIButton *BtnGift = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, BLEJWidth/6, 30)];
    
    BtnGift.titleLabel.adjustsFontSizeToFitWidth=YES;
    [BtnGift setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [BtnGift setTitle:@"礼物" forState:UIControlStateNormal];
    
    [self.baseView addSubview:BtnGift];
    UIButton *btnLine=[[UIButton alloc]initWithFrame:CGRectMake(20,BtnGift.bottom+3 , BLEJWidth/6-10, 1)];
    btnLine.backgroundColor=[UIColor redColor];
    [self.baseView addSubview:btnLine];
    
    _xianHua=[[UIImageView alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    _xianHuaL=[[UILabel alloc]initWithFrame:CGRectMake(20+_xianHua.right+5, 80+10, 40, 20)];
    _jinQi=[[UIImageView alloc]initWithFrame:CGRectMake(_xianHuaL.right+5,80 , 40, 40)];
    _jinQiL=[[UILabel alloc]initWithFrame:CGRectMake(_jinQi.right+5, 80+10, 40, 20)];
    [_jinQi setContentMode:UIViewContentModeScaleAspectFill];
    [_xianHua setContentMode:UIViewContentModeScaleAspectFill];
    _jinQi.image=[UIImage imageNamed:@"Personcard_Flag"];
    _xianHua.image= [UIImage imageNamed:@"Personcard_Flower"] ;
   
    self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
    self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
    
    _jinQi.userInteractionEnabled=YES;
    _xianHua.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToJinQiPurchase)];
    
    UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToXianHuaPurchase)];
    [_jinQi addGestureRecognizer:Tap1];
    [_xianHua addGestureRecognizer:Tap2];
    //     [jinQi addTarget:self action:@selector(ToJinQiPurchase) forControlEvents:UIControlEventTouchUpInside];
    //     [xianHua addTarget:self action:@selector(ToXianHuaPurchase) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:_jinQi];
    [self.baseView addSubview:_xianHua];
    
    [self.baseView addSubview:_jinQiL];
    [self.baseView addSubview:_xianHuaL];
    
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(hiddenView:)];
    
    [self.FlipView addGestureRecognizer:Tap];
    
    
    
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.FlipView.mj_y = -180;
        self.FlipView.backgroundColor=    [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
    }];
}



- (void)hiddenView:(UITapGestureRecognizer*)tapGesture{
    
    CGPoint selectPoint = [tapGesture locationInView:self.FlipView];
    
    NSLog(@"%@",[NSValue valueWithCGPoint:selectPoint]);
    
    //CGRectContainsPoint(CGRect rect, <#CGPoint point#>)判断某个点是否包含在某个CGRect区域内
    
    if(!CGRectContainsPoint(self.baseView.frame, selectPoint)){
        
        [UIView animateWithDuration:0.3f animations:^{
            
            // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
            self.FlipView.mj_y += 180 ;
        } completion:^(BOOL finished) {
            [self.FlipView removeFromSuperview];
        }];
        
    }
    
    
    
}
#pragma mark 锦旗的购买事件
-(void)ToJinQiPurchase{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    
    JinQiViewController *view =[[JinQiViewController alloc]init];
     view.isSendFromCompany =YES;
    view.companyId = self.shopID;
    WeakSelf(self)
    view.completionBlock = ^(NSString *count) {
        StrongSelf(weakself)
        if (count) {
            [strongself requestData];
            [strongself.table reloadData];
            
            self.xianHuaL.text =[NSString stringWithFormat:@"%@%@",@"鲜花:",self.companyDic[@"flowerNumber"]];
            self.jinQiL.text =[NSString stringWithFormat:@"%@%@",@"锦旗:",self.companyDic[@"pennantNumber"]];
        }
    };
    [self.navigationController pushViewController:view animated:YES];
    
}
#pragma mark 鲜花的购买事件

-(void)ToXianHuaPurchase{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    NSLog(@"++++++++++++++++++");
    SendFlowersViewController *Flowerview =[[SendFlowersViewController alloc]init];
    Flowerview.compamyIDD =self.shopID;
    Flowerview.isCompamyID =YES;
    WeakSelf(self)
    Flowerview.blockIsPay = ^(BOOL isPay) {
        StrongSelf(weakself)
        if (isPay ==YES) {
            //鲜花的数量加一
           
            [strongself requestData];
            [strongself.table reloadData];
            self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
            self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];

        }
        
    };
    [self.navigationController pushViewController:Flowerview animated:YES];
}


#pragma mark - 预约
- (void)didClickAppointmentBtn:(UIButton *)btn {// 预约
    
    
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
    
    // 在线预约浏览量
    [NSObject needDecorationStatisticsWithConpanyId:self.shopID];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 3 || section == 4) {
        
        if (self.goodListArray.count == 0) {
            return 0.001;
        } else {
            return 5;
        }
    }
    if (section == 1 || section == 2) {
//        return  _hasActivity ? 5 : 0.000001;
        // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
        NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
        if (activStateInteger==3) {
            return 0;
        }
        else
        {
            return 5;
        }
    }
    
    if (section == 5 || section == 6) {
        if (self.reommendConArray.count == 0) {
            return 0.001;
        } else {
            return 5;
        }
    }
    if (section == 7 || section == 8) {
        if (self.cooperateArr.count == 0) {
            return 0.001;
        } else {
            return 5;
        }
    }
    return 5;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0 || section == 1 || section == 2 || section == 5 || section == 7 || section == 3 || section == 4 || section == 9) {
        return 1;
    }
    if (section == 6) {
        //施工案例的cell的数目
        return 1;
//        return self.reommendConArray.count;
    }
    if (section == 8) {
        if (self.viewList.count > 0) {
            return 1;
        } else {
            return 0;
        }
    }
    if (section == 10) {
        //施工案例的cell的数目
        return self.cooperateArr.count > 0 ? 1 : 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return kSCREEN_WIDTH * 0.6;
    }
    
    
    if (indexPath.section == 3 ) {
        if (self.goodListArray.count == 0) {
            return 0;
        }
        return 44;
    }
    //商品cell的高度
    if (indexPath.section == 4) {
        
        if (self.goodListArray.count >3) {
            return 300 * hightScale;
        }else if (self.goodListArray.count <= 3 && self.goodListArray.count != 0){
            
            return 150 * hightScale;
            
        }else{
            
            return 0;
            
        }
        
    }
    if (indexPath.section == 1) {
       // return _hasActivity? 44 : 0;
        
        // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
        NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
        if (activStateInteger==3) {
            return 0.01f;
        }
        else
        {
            return 44;
        }
        
    }
    
    if (indexPath.section == 2) {
        // 有活动
        if (_hasActivity) {
            // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
            NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
             YellowPageActivityCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YellowPageActivityCell" owner:nil options:nil].lastObject;
            if (activStateInteger == 0) {
              
                return (cell.cellHeightExceptImageHeightAndNotNecessaryTFFrame + self.activityImageHeight + dynamicHeight+paoMaHeight+signUpHeight);
                
            }
            else if (activStateInteger==3)
            {
                return 0.01f;
            }
            else {
                return cell.cellHeightExceptImageHeightAndNotNecessaryTFFrame + self.activityImageHeight+dynamicHeight+paoMaHeight+signUpHeight;
            }
        } else {
            // 没有活动
            return 0;
        }
        
    }
    if (indexPath.section == 5) {
        if (self.reommendConArray.count == 0) {
            return 0;
        } else {
            return 44;
        }
        
    }
    
    if (indexPath.section == 6) {
        // 经典案例
        NSInteger count = 0;
        if (self.reommendConArray.count % 2 == 0) {
            
            count = self.reommendConArray.count / 2;
        } else {
            
            count = self.reommendConArray.count / 2 + 1;
        }
        return count * ((kSCREEN_WIDTH - 32) * 0.3 + 36);
    }
    if (indexPath.section == 7) {
        if (self.viewList.count == 0) {
            return 0;
        } else {
            return 44;
        }
    }
    if (indexPath.section == 8) {
        
        return self.viewList.count > 0 ? BLEJWidth * 0.6 : 0;
    }
    if (indexPath.section == 9) {
        if (self.cooperateArr.count == 0) {
            return 0;
        } else {
            return 44;
        }
    }
    
    if (indexPath.section == 10) {
        
        return ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1));
    }
    
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

//    return 9;
    return 11;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==0) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"XianHuaJinQiGuanzhuCell" owner:nil options:nil];
        XianHuaJinQiGuanzhuCell *CEll = [nibArray lastObject];
        [CEll setData:self.companyDic];
        return CEll;
    }
    
    return [UIView new];
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return 80;
    }
    return 0.001;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (cycleScrollView.tag == 888888) {
        
        NSString *webUrl = self.adListDictArray[index][@"picHref"];
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
}


- (void)buildNotVipButHaveActicleView {
    YellowActicleView *v = [[YellowActicleView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50)];
    v.designsId = self.designsId.integerValue;
    [self.view addSubview:v];
}

#pragma mark 顶部九宫格视图
- (void)creatHeaderView {

    NSArray *imageArr = @[@"brief",@"constructionCase",@"quote",@"news",@"yuangong",@"productshow",@"quanjing",@"case"];
    NSArray *titleArr = @[@"店铺简介",@"案例展示",@"装修报价",@"新闻资讯",@"优秀员工",@"商品展示",@"全景展示",@"合作企业"];

    //背景图
    UIView  *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kSCREEN_WIDTH, kSCREEN_HEIGHT/3.3)];
    
    [self.view addSubview:bgView];
    
    self.table.tableHeaderView = bgView;
    
    CGFloat kWidth = kSCREEN_WIDTH/4 ;
    CGFloat kHeight = bgView.height/2;
    
    for (int i = 0; i < titleArr.count; i ++) {
    
        CGFloat X = (i < titleArr.count/2 ? i * kWidth : (i - titleArr.count/2)*kWidth);
        CGFloat Y = (i < titleArr.count/2 ? 0 : kHeight);

        shopDetailView *detailView = [[shopDetailView alloc]initWithFrame:CGRectMake(X, Y, kWidth, kHeight)];
        
        [bgView addSubview:detailView];
        detailView.delegate = self;
        detailView.titleLabel.text = titleArr[i];
        
        detailView.titleLabel.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0];
        
        detailView.bgImage.image = [UIImage imageNamed:imageArr[i]];
    
        detailView.shopTag = i + 100;
        detailView.delegate = self;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 1 || indexPath.section == 5 || indexPath.section == 7 || indexPath.section == 9) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            
            //广告轮播图
            
            SDCycleScrollView *adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6) delegate:self placeholderImage:[UIImage imageNamed:@"topbanner_default"]];
            adView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
            adView.backgroundColor = [UIColor blackColor];
            adView.autoScrollTimeInterval = BANNERTIME;
            adView.imageURLStringsGroup = self.topImageArr;
            adView.tag = 888888;
            [cell.contentView addSubview:adView];
            
        }
        
        //商品展示
        if (indexPath.section == 3) {
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
            bottomView.backgroundColor = White_Color;
            
            UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 44)];
            caseLabel.textAlignment = NSTextAlignmentCenter;
            caseLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:caseLabel];
            NSString *contentStr = @"—— 商品展示 ——";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
            
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
            caseLabel.attributedText = str;
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 44)];
            [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
            [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
            [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
            moreBtn.userInteractionEnabled = NO;
            [bottomView addSubview:moreBtn];
            
            [cell.contentView addSubview:bottomView];
            if (self.goodListArray.count == 0) {
                cell.hidden = YES;
            }
        }
        
        //商品
        if (indexPath.section == 4) {
            
            [self goodsShowWithArray:self.goodListArray bgView:cell];
            if (self.goodListArray.count == 0) {
                
                cell.hidden = YES;
            }
        }
        
        if (indexPath.section == 1) {
            
            
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
            bottomView.backgroundColor = White_Color;
            
            UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 44)];
            caseLabel.textAlignment = NSTextAlignmentCenter;
            caseLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:caseLabel];
            NSString *contentStr = @"—— 最新活动 ——";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
            
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
            caseLabel.attributedText = str;
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 44)];
            [moreBtn setTitle:@"以往活动" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
            [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
            [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
            moreBtn.userInteractionEnabled = NO;
            [bottomView addSubview:moreBtn];
            moreBtn.hidden = !(self.acticityArray.count >1);
            
            [cell.contentView addSubview:bottomView];
            
            if (!_hasActivity) {
                cell.hidden = YES;
            }
            // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
            NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
            if (activStateInteger==3) {
                cell.hidden = YES;
            }
           
            
            
            
           
        }
        if (indexPath.section == 5) {
            
      
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
            bottomView.backgroundColor = White_Color;
            
            UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 44)];
            caseLabel.textAlignment = NSTextAlignmentCenter;
            caseLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:caseLabel];
            NSString *contentStr = @"—— 经典案例 ——";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
            
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
            caseLabel.attributedText = str;
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 44)];
            [moreBtn setTitle:@"全部案例" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
            [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
            [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
            moreBtn.userInteractionEnabled = NO;
            [bottomView addSubview:moreBtn];
            
            [cell.contentView addSubview:bottomView];
            
            if (self.reommendConArray.count == 0) {
                cell.hidden = YES;
            }
        }
        
        if (indexPath.section == 7) {
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
            bottomView.backgroundColor = White_Color;
            
            UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 44)];
            caseLabel.textAlignment = NSTextAlignmentCenter;
            caseLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:caseLabel];
            NSString *contentStr = @"—— 全景图 ——";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
            
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 5)];
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(7, 2)];
            caseLabel.attributedText = str;
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 44)];
            [moreBtn setTitle:@"全部图纸" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
            [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
            [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
            moreBtn.userInteractionEnabled = NO;
            [bottomView addSubview:moreBtn];
            
            [cell.contentView addSubview:bottomView];
            
            if (self.viewList.count == 0) {
                cell.hidden = YES;
            }
        }
        if (indexPath.section == 9) {
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
            bottomView.backgroundColor = White_Color;
            
            UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 44)];
            caseLabel.textAlignment = NSTextAlignmentCenter;
            caseLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:caseLabel];
            NSString *contentStr = @"—— 合作企业 ——";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
            
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
            caseLabel.attributedText = str;
            
            [cell.contentView addSubview:bottomView];
            
            if (self.cooperateArr.count == 0) {
                cell.hidden = YES;
            }
        }
        
        return cell;
        
    }
    if(indexPath.section == 2) {
        YellowPageActivityCell *cell = [[NSBundle mainBundle] loadNibNamed:@"YellowPageActivityCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.checkCodeBtn = cell.sendCodeButton;
        
        // 头部图片
        NSURL *url = [NSURL URLWithString:self.activityDict[@"coverMap"]];
        [cell.topImageView sd_setImageWithURL:url];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
        UIImage * image;
        if (existBool) {
            image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }else{
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
        }
        if (image.size.width) {
            // 活动图片高度固定
           
            self.activityImageHeight = BLEJWidth *2/3;;
         
        }
        

        
        
        // 跑马视图
        NSMutableAttributedString *mulattrStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < self.userPhoneArray.count; i ++) {
            if ([self.userPhoneArray[i][@"userPhone"] integerValue] == 0 || [self.userPhoneArray[i][@"userPhone"] isEqualToString:@""]) {
                continue ;
            }
            NSString *phoneStr = self.userPhoneArray[i][@"userPhone"];
            if (phoneStr.length > 6) {
                phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            NSString *str = [NSString stringWithFormat:@"手机号为%@的业主已经报名成功            ",phoneStr];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:225/255.0 green:56/255.0 blue:45/255.0 alpha:1.0] range:NSMakeRange(4, 11)];
            [mulattrStr appendAttributedString:attrStr];
        }
        
        self.paoMaoAttribureStr = mulattrStr;
        WQLPaoMaView *paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(32, 0, kSCREEN_WIDTH - 32, 20) withAttributeTitle:mulattrStr];
        [cell.paoMaView removeAllSubViews];
        [cell.paoMaView addSubview:paoma];
        cell.paomaViewConstant.constant =self.paoMaoAttribureStr !=nil &&self.paoMaoAttribureStr.length !=0
        ? 20:0;
        paoMaHeight =cell.paomaViewConstant.constant;
       
        UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
        imageBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        UIImageView *imagaV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 1, 20, 18)];
        imagaV.image = [UIImage imageNamed:@"yellowPage_singup_ad"];
        [imageBackView addSubview:imagaV];
        [cell.paoMaView addSubview:imageBackView];
        if ( self.paoMaoAttribureStr ==nil || self.paoMaoAttribureStr.length ==0) {
            imageBackView.hidden =YES;
        }else{
            imageBackView.hidden=NO;
        }
       
        // 报名人数
        if ([self.activityDict[@"personNum"] integerValue] !=0 ) {
            
      
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
        NSString *str0 = [NSString stringWithFormat:@"%ld位", [self.activityDict[@"personNum"] integerValue]];;
        NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont systemFontOfSize:22], NSForegroundColorAttributeName: [UIColor colorWithRed:225/255.0 green:56/255.0 blue:45/255.0 alpha:1.0]};
        NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
        NSDictionary *dictAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"已经有 " attributes:dictAttr];
        NSAttributedString *attr1;
        NSDictionary *dictAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        if (IPhone5 || IPhone4) {
            attr1= [[NSAttributedString alloc]initWithString:@" 业主成功报名" attributes:dictAttr1];
        } else {
            attr1= [[NSAttributedString alloc]initWithString:@" 业主成功报名(数据真实无虚假)" attributes:dictAttr1];
        }
        [attributedString appendAttributedString:attr];
        [attributedString appendAttributedString:attr0];
        [attributedString appendAttributedString:attr1];
        cell.signUpNumberLabel.attributedText = attributedString;
       
    }
        cell.AlreadysignupBtn.constant = cell.signUpNumberLabel.attributedText !=nil && cell.signUpNumberLabel.attributedText.length !=0 ? 30+16:0;
        signUpHeight =cell.AlreadysignupBtn.constant;
        // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
        NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
        
        if (activStateInteger == 0) {
            for (int i = 0; i < self.customDefineArray.count; i ++) {
                ActivityCustomDefine *customModel = self.customDefineArray[i];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + (i * 74), kSCREEN_WIDTH - 60, 20)];
               [cell.dynamicView addSubview:label];
                label.font = AdaptedFontSize(16);
                label.text = customModel.customName;
                UITextField *customTF = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 16, kSCREEN_WIDTH - 60, 30)];
                customTF.layer.borderColor=[UIColor grayColor].CGColor;
                
                customTF.layer.borderWidth=0.7;
               [cell.dynamicView addSubview:customTF];
                customTF.font = [UIFont systemFontOfSize:16];
                if ([customModel.isMust isEqualToString:@"1"]) {
                    customTF.placeholder = [NSString stringWithFormat:@"请输入%@（必填）", customModel.customName];
                } else {
                    customTF.placeholder = [NSString stringWithFormat:@"请输入%@", customModel.customName];
                }
               
                customTF.tag = 10000 + i;
                customTF.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                
                cell.dynamicHeightconstant.constant +=74;
                dynamicHeight=cell.dynamicHeightconstant.constant;
            }
        } else if (activStateInteger == 5 || activStateInteger == 4) {
            // 活动已停止报名
            [cell.signUpButton setTitle:@"已停止报名" forState:UIControlStateDisabled];
            [cell.signUpButton setBackgroundColor:[UIColor lightGrayColor]];
            cell.signUpButton.enabled = NO;
            [cell.sendCodeButton setBackgroundColor:[UIColor lightGrayColor]];
            cell.sendCodeButton.enabled = NO;
            cell.nameTF.userInteractionEnabled = NO;
            cell.phoneNumTF.userInteractionEnabled = NO;
            cell.vertifyCodeTF.userInteractionEnabled = NO;
        } else if(activStateInteger == 3) {
            // 活动结束
            [cell.signUpButton setTitle:@"活动已结束" forState:UIControlStateDisabled];
            [cell.signUpButton setBackgroundColor:[UIColor lightGrayColor]];
            cell.signUpButton.enabled = NO;
            [cell.sendCodeButton setBackgroundColor:[UIColor lightGrayColor]];
            cell.sendCodeButton.enabled = NO;
            cell.nameTF.userInteractionEnabled = NO;
            cell.phoneNumTF.userInteractionEnabled = NO;
            cell.vertifyCodeTF.userInteractionEnabled = NO;
        }
        cell.block = ^(NSString *string) {
            self.imageVerificationCode = string;
            NSLog(@"%@",self.imageVerificationCode);
        };
        MJWeakSelf;
        cell.getVeitifyCodeBlock = ^(YellowPageActivityCell *cell) {
            YSNLog(@"验证码");
            if (![cell.phoneNumTF.text ew_justCheckPhone]) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确手机号"];
                return ;
            }
            NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
            [codeDict setObject:cell.phoneNumTF.text forKey:@"phone"];
            [codeDict setObject:weakSelf.activityDict[@"designTitle"] forKey:@"activityName"];
            [codeDict setObject:weakSelf.activityDict[@"address"] forKey:@"address"];
            [codeDict setObject:weakSelf.activityDict[@"activityId"] forKey:@"activityId"];
            
            NSString *temCompanyId = self.shopID;
            if (!temCompanyId||[temCompanyId integerValue]==0) {
                temCompanyId = @"0";
            }
            [codeDict setObject:temCompanyId forKey:@"companyId"];
            [weakSelf getVertifyCodeWithDict:codeDict];
        };
        cell.signUpNowBlock = ^(YellowPageActivityCell *cell) {
            YSNLog(@"报名");
            if ([cell.nameTF.text isEqualToString:@""]) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入姓名"];
                return ;
            }
            if (![cell.phoneNumTF.text ew_justCheckPhone]) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确手机号"];
                return ;
            }
            
            if (![cell.vertifyCodeTF.text ew_checkDegitalCountIs:6]) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入6位数验证码"];
                return ;
            }
    
            NSMutableDictionary *mulDict = [NSMutableDictionary dictionary];
            [mulDict setObject:cell.nameTF.text forKey:@"userName"];
            [mulDict setObject:cell.phoneNumTF.text forKey:@"userPhone"];
            [mulDict setObject:@([weakSelf.activityDict[@"activityId"] integerValue]) forKey:@"activityId"];
            [mulDict setObject:cell.vertifyCodeTF.text forKey:@"code"];
            [mulDict setObject:weakSelf.shopID forKey:@"companyId"];
            
            NSMutableArray *customArray = [NSMutableArray array];
        
            
            [mulDict setObject:customArray forKey:@"customs"];
            NSString *singJsonStr = [NSString convertToJsonData:mulDict];

            //warning self.imageVerificationCode;
            NSDictionary *paramDic = @{@"signJson": singJsonStr};
            YSNLog(@"%@", paramDic);
            //            [weakSelf signUpWithDict:paramDic];
            [weakSelf signUpWithDict:paramDic completion:^(bool isSuccess) {
                YSNLog(@"%ld", (long)isSuccess);
                if (isSuccess) {
                    
                    // 报名人数
                    [self.activityDict setObject:@([self.activityDict[@"personNum"] integerValue] + 1) forKey:@"personNum"];
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
                    NSString *str0 = [NSString stringWithFormat:@"%ld位", [self.activityDict[@"personNum"] integerValue]];;
                    NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont systemFontOfSize:22], NSForegroundColorAttributeName: [UIColor colorWithRed:225/255.0 green:56/255.0 blue:45/255.0 alpha:1.0]};
                    NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
                    NSDictionary *dictAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
                    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"已经有 " attributes:dictAttr];
                    NSAttributedString *attr1;
                    NSDictionary *dictAttr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
                    if (IPhone5 || IPhone4) {
                        attr1= [[NSAttributedString alloc]initWithString:@" 业主成功报名" attributes:dictAttr1];
                    } else {
                        attr1= [[NSAttributedString alloc]initWithString:@" 业主成功报名(数据真实无虚假)" attributes:dictAttr1];
                    }
                    [attributedString appendAttributedString:attr];
                    [attributedString appendAttributedString:attr0];
                    [attributedString appendAttributedString:attr1];
                    cell.signUpNumberLabel.attributedText = attributedString;
                    
                    // 跑马视图
                    NSString *phoneStr = cell.phoneNumTF.text;
                    if (phoneStr.length > 0) {
                        phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    }
                    NSString *str = [NSString stringWithFormat:@"手机号为%@的业主已经报名成功            ",phoneStr];
                    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:225/255.0 green:56/255.0 blue:45/255.0 alpha:1.0] range:NSMakeRange(4, 11)];
                    
                    [self.paoMaoAttribureStr  appendAttributedString:attrStr];
                    WQLPaoMaView *paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(32, 0, kSCREEN_WIDTH - 32, 20) withAttributeTitle:self.paoMaoAttribureStr];
                    [cell.paoMaView removeAllSubViews];
                    [cell.paoMaView addSubview:paoma];
                    
                    UIView *imageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
                    imageBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                    UIImageView *imagaV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 1, 20, 18)];
                    imagaV.image = [UIImage imageNamed:@"yellowPage_singup_ad"];
                    [imageBackView addSubview:imagaV];
                    [cell.paoMaView addSubview:imageBackView];
                    
                    // 在下面可以清空cell数据
                    cell.nameTF.text = @"";
                    cell.phoneNumTF.text = @"";
                    cell.vertifyCodeTF.text = @"";
             
                    // 发送验证码倒计时结束
                    dispatch_source_cancel(_vertifytime);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.checkCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.checkCodeBtn.userInteractionEnabled = YES;
                        self.checkCodeBtn.backgroundColor = kMainThemeColor;
                    });
                }
            }];
        };
        cell.activityDetailBlock = ^(YellowPageActivityCell *cell) {
            YSNLog(@"活动详情");
            NSInteger activityType = [self.activityDict[@"type"] integerValue];
            if (activityType==1) {
                //联盟活动
                ActivityShowController *vc = [[ActivityShowController alloc] init];
                vc.designsId = [NSString stringWithFormat:@"%ld", [self.activityDict[@"designsId"] integerValue]];
                vc.activityId = [NSString stringWithFormat:@"%ld", [self.activityDict[@"activityId"] integerValue]];
                
                vc.calVipTag = [self.companyDic[@"calVip"] integerValue];
                
                vc.coverMap = self.activityDict[@"coverMap"];
                
                vc.companyName = self.shopName;
                vc.companyLogo = self.companyDic[@"companyLogo"];
                vc.companyId = self.shopID;
                vc.companyLandLine = self.companyDic[@"companyLandline"];
                vc.companyPhone = self.companyDic[@"companyPhone"];
                if ([self.activityDict[@"address"] isEqualToString:@"线下"]) {
                    vc.activityAddress = self.activityDict[@"activityAddress"];
                } else {
                    vc.activityAddress = @"线上活动";
                }
                vc.activityTime = self.activityDict[@"startTime"]; // 时间戳
                vc.designTitle = self.activityDict[@"designTitle"];
                vc.musicStyle = [self.activityDict[@"musicPlay"] integerValue];
                vc.designSubTitle = self.activityDict[@"designSubTitle"];
                
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }
            else{
                NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
                vc.designsId = [self.activityDict[@"designsId"] integerValue];

                vc.activityType = 3;
                
                vc.companyName = self.shopName;
                vc.companyLogo = self.companyDic[@"companyLogo"];
                vc.companyId = self.shopID;
                vc.companyLandLine = self.companyDic[@"companyLandline"];
                vc.companyPhone = self.companyDic[@"companyPhone"];
                vc.origin = self.origin;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        };
        
        if (!_hasActivity) {
            cell.hidden = YES;
        }
        // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
       
        if (activStateInteger==3) {
            cell.hidden = YES;
        }
        return cell;
    }
    if(indexPath.section == 6){

        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        // 图片 5：3  左右边距 8  图片底部文字高度20 上下边距8   (kSCREEN_WIDTH - 32)/2.0 * 3/5.0 + (20 + 16)
        NSInteger imageWith = (kSCREEN_WIDTH - 32)/2.0;
        NSInteger imageHeigt = imageWith * 3/5.0;
        NSInteger margin = 8;
        NSInteger textHeigt = 20;
        NSInteger viewHeight = imageHeigt + margin * 2 + textHeigt;
        NSInteger viewWidht = margin * 2 + imageWith;
        for (int i = 0; i < self.reommendConArray.count; i ++) {
            ZCHBudgetGuideConstructionCaseModel *model = self.reommendConArray[i];
            
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(viewWidht * (i%2), viewHeight*(i/2), viewWidht, viewHeight)];
            [cell.contentView addSubview:cellView];
            cellView.tag = i;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAnliDetail:)];
            cellView.userInteractionEnabled = YES;
            [cellView addGestureRecognizer:tapGR];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, imageWith, imageHeigt)];
            [cellView addSubview:imageV];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.layer.masksToBounds = YES;
            NSString *url = model.picUrl ? model.picUrl : model.coverMap;
            [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_icon"]];
            
            UILabel *textLabel = [[UILabel alloc] init];
            [cellView addSubview:textLabel];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-8);
                make.bottom.equalTo(-3);
                make.height.equalTo(20);
            }];
            textLabel.font = [UIFont systemFontOfSize:15];
            // 38 146 243
            textLabel.textColor = [UIColor colorWithRed:28/255.0 green:146/255.0 blue:243/255.0 alpha:1.0];
            textLabel.text = model.displayNumbers;
            
            UIImageView *scanIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
            [cellView addSubview:scanIV];
            [scanIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(textLabel);
                make.right.equalTo(textLabel.mas_left).equalTo(-10);
                make.size.equalTo(CGSizeMake(20, 10));
            }];
            
            NSInteger middleBgViewHeight = 20;
            UIView *middleBgView = [[UIView alloc] initWithFrame:CGRectMake(8, imageHeigt + 8 - middleBgViewHeight, imageWith, middleBgViewHeight)];
            [cellView addSubview:middleBgView];
            middleBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            

            
            UILabel *nounLabel = [UILabel new];
            nounLabel.font = [UIFont systemFontOfSize:12];
            nounLabel.textColor = [UIColor whiteColor];
            nounLabel.text = model.ccAreaName;
            nounLabel.textAlignment = NSTextAlignmentCenter;
            [middleBgView addSubview:nounLabel];
            [nounLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.right.equalTo(0);
                make.top.equalTo(0);
                make.height.equalTo(middleBgViewHeight);
            }];

        }
        
        return cell;
    }
    if (indexPath.section == 8) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJWidth * 0.6)];
        if (self.viewList.count > 0) {
            [cell.contentView addSubview:self.allView];
            NSMutableArray *picArr = [NSMutableArray array];
            for (int i = 0; i < self.viewList.count; i ++) {
                senceModel *model = self.viewList[i];
                [picArr addObject:model.picUrl];
            }
            NSMutableArray *titleArr = [NSMutableArray array];
            for (int i = 0; i < self.viewList.count; i ++) {
                senceModel *model = self.viewList[i];
                [titleArr addObject:model.picTitle];
            }
            self.allView.imageURLStringsGroup = picArr.copy;
            self.allView.titlesGroup = titleArr.copy;
            __weak typeof(self) weakSelf = self;
            self.allView.clickItemOperationBlock = ^(NSInteger currentIndex) {
                
                senceModel *model = weakSelf.viewList[currentIndex];
                NSString *webUrl = model.picHref;
                if (webUrl.length > 0) {
                    if (![webUrl ew_isUrlString]) {
                        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
                        return;
                    }
                    
                    //全景图
                    senceWebViewController *sence = [[senceWebViewController alloc]init];
                    sence.model = model;
                    sence.companyLogo = weakSelf.companyDic[@"companyLogo"];
                    sence.companyName = weakSelf.shopName;
                    [weakSelf.navigationController pushViewController:sence animated:YES];
                }
            };
        }
        return cell;
    }
    if (indexPath.section == 10) {
        
        if (self.cooperateCell == nil) {
            self.cooperateCell = [[UITableViewCell alloc] init];
            self.cooperateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.cooperateCell.layer.masksToBounds = YES;
            for (int i = 0; i < self.cooperateArr.count; i ++) {
                
                UIButton *btn = [self cooperateViewWithModel:self.cooperateArr[i]];
                btn.frame = CGRectMake((i % 3) * BLEJWidth * 1 / 3, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (i / 3), BLEJWidth * 1 / 3, (BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20);
                btn.tag = i;
                [self.cooperateCell addSubview:btn];
            }
            for (int i = 0; i < self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1); i ++) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (i + 1) - 1, BLEJWidth, 1)];
                line.backgroundColor = kBackgroundColor;
                [self.cooperateCell addSubview:line];
            }
            
            for (int i = 0; i < 2; i ++) {
                
                if (i == 0) {
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((BLEJWidth * 1 / 3) * (i + 1) - 1, 0, 1, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1)))];
                    line.backgroundColor = kBackgroundColor;
                    [self.cooperateCell addSubview:line];
                } else {
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((BLEJWidth * 1 / 3) * (i + 1) - 1, 0, 1, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 2 ? 1 : 0)))];
                    line.backgroundColor = kBackgroundColor;
                    [self.cooperateCell addSubview:line];
                }
            }
        }
        
        return self.cooperateCell;
    }
    
    return [UITableViewCell new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 6) {

    }
    
    if (indexPath.section == 3) {
        
        YellowGoodsListViewController *VC = [YellowGoodsListViewController new];
        VC.fromBack = NO;
        VC.shopId = self.shopID;
        VC.collectFlag = self.collectFlag;
        VC.shopid = self.shopID;
        VC.dataDic = self.companyDic;
        VC.companyName = self.shopName;
        VC.shareCompanyLogoURLStr = [self.companyDic objectForKey:@"companyLogo"];
        VC.shareDescription = [self.companyDic objectForKey:@"companyIntroduction"];
        VC.origin = self.origin;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    if (indexPath.section == 1) {
        // 跳转到以往活动
        if (self.acticityArray.count > 1) {
            HistoryActivityViewController *historyVC = [[HistoryActivityViewController alloc] init];
            historyVC.dataArray = self.acticityArray;
            historyVC.companyID = self.shopID;
            historyVC.companyName = self.companyDic[@"companyName"];
            historyVC.companyLogo = self.companyDic[@"companyLogo"];
            historyVC.companyPhone = self.companyDic[@"companyPhone"];
            historyVC.companyLandLine = self.companyDic[@"companyLandline"];
            historyVC.companyCalVip = [self.companyDic[@"calVip"] integerValue];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
    }
    // 全部案例
    if (indexPath.section == 5) {
        [self caseShow];
    }
    if (indexPath.section == 7) {
        
        PanoramaViewController *panorama = [[PanoramaViewController alloc]init];
        
        //页面跳转标记
        panorama.tag = 1000;
        panorama.origin = self.origin;
        panorama.shopID = self.shopID;
        panorama.companyType = self.companyDic[@"companyType"];
        panorama.dataDic = self.companyDic;
        [self.navigationController pushViewController:panorama animated:YES];
    }
}

#pragma mark cell中的label
- (UILabel *)titleLabel:(NSString *)title height:(CGFloat)height {

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,kSCREEN_WIDTH, height)];
    label.text = title;
    label.font = NB_FONTSEIZ_BIG;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    return label;
}


#pragma mark 商品展示
- (void)goodsShowWithArray:(NSMutableArray *)goodsArray bgView:(UIView *)bgView {

    CGFloat kWidth = kSCREEN_WIDTH/3 ;
    CGFloat kHeight;
    NSArray *arr = [NSArray array];
    if (goodsArray.count <= 6) {
        
        arr = goodsArray;
        kHeight = 150 * hightScale;
        
    }else{
    
        kHeight = 300 * hightScale/2;
        //截取商品的前6个展示在界面上
        NSRange range = NSMakeRange(0, 6);
        arr = [goodsArray subarrayWithRange:range];
        
    }
    
    
    for (int i = 0; i < arr.count; i ++) {
        
        goodsModel *model = arr[i];
        
        CGFloat X = 0;
        CGFloat Y = 0;
        
        if (i < 3) {
            X = i * kWidth;
            Y = 0;
            
        }else{
        
            X =  (i - 3)*kWidth;
            Y =  kHeight;
        
        }
        
        shopDetailView *detailView = [[shopDetailView alloc]initWithFrame:CGRectMake(X, Y, kWidth - 1, kHeight - 1)];
        
        detailView.bgImage.contentMode = UIViewContentModeScaleAspectFill;
        detailView.bgImage.clipsToBounds = YES;
        detailView.bgImage.frame = CGRectMake(5, 5, detailView.width - 10, detailView.width - 10);
        detailView.titleLabel.frame = CGRectMake(5, CGRectGetMaxY(detailView.bgImage.frame), detailView.bgImage.width, detailView.height - detailView.bgImage.height);
        [bgView addSubview:detailView];
        
        
//        detailView.titleLabel.text = [NSString stringWithFormat:@"￥%@ \n %@",model.price,model.name];
        NSString *str1 = [NSString stringWithFormat:@"￥%@ ",model.price];
        NSAttributedString *aS1 = [[NSAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:NB_FONTSEIZ_SMALL, NSForegroundColorAttributeName:[UIColor redColor]}];
        NSString *str2 = [NSString stringWithFormat:@"\n %@",model.name];
        NSAttributedString *aS2 = [[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:NB_FONTSEIZ_SMALL, NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSMutableAttributedString *mulAS = [NSMutableAttributedString new];
        [mulAS appendAttributedString:aS1];
        [mulAS appendAttributedString:aS2];
        detailView.titleLabel.attributedText = [mulAS copy];
        
        detailView.titleLabel.numberOfLines = 2;
        detailView.titleLabel.textAlignment = NSTextAlignmentLeft;
        [detailView.bgImage sd_setImageWithURL:[NSURL URLWithString:model.display] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        
        detailView.shopTag = 200 + i;
        detailView.delegate = self;
    }
}


#pragma mark shopDetailViewDelagate (上面那八个按钮的点击的代理方法)

-(void)shopDetailActions:(NSInteger)tag {

    switch (tag) {
        case 100:
            //店铺简介
            [self shopIntroduce];
            break;
        case 101:
            //案例展示
            [self caseShow];
            break;
        case 102:
            //计算器
            [self zhuangXiuBaoJia];
            break;
        case 103:
            //新闻资讯
            [self appraise];
            break;
        case 104:
            //优秀员工
            [self excellentEmployee];
            break;
        case 105:
            //施工团队(4.5.5之后是商品展示)
            [self workTeam];
            break;
        case 106:
            //店铺全景
            [self shopSence];
            break;
        case 107:
            //合作企业
            [self produceList];
            break;
        default:
            //商品展示 点击事件
            [self goodsAction:tag];
            break;
    }

}

-(void)zhuangXiuBaoJia{
    // 装修报价
        BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
        VC.calculatorModel = self.calculatorTempletModel;
        //底部底部视图
        VC.bottomCalculatorImageArr =self.bottomCalculatorImageArr;
        VC.topCalculatorImageArr=self.topCalculatorImageArr;
    
        VC.homeModel=self.homeModel;
        VC.cooperateArr =self.cooperateArr;
         VC.constructionCase = self.constructionCase;
        VC.baseItemsArr = self.baseItemsArr;
        VC.suppleListArr = self.suppleListArr;
        VC.companyDic =self.companyDic;
        VC.viewList =self.viewList;
        VC.userPhoneArray =self.userPhoneArray;
        VC.companyDic=self.companyDic;
        VC.origin =self.origin;
        VC.companyID = self.shopID;
        VC.code =self.code;
        VC.shareCompanyLogoURLStr =self.homeModel.typeLogo;;
        VC.shareDescription=self.homeModel.companyIntroduction;;
        VC.collectFlag =self.collectFlag;
        VC.isConVip = self.companyDic[@"conVip"];
        VC.dispalyNum =self.companyDic[@"displayNumbers"];
        [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark 店铺简介
- (void)shopIntroduce {

    CompanyIntroductController *intro = [[CompanyIntroductController alloc]init];
    intro.companyId = self.shopID;
    intro.iscompany = NO;
    intro.origin = self.origin;
    intro.companyType = self.companyDic[@"companyType"];
    intro.displayNum = self.companyDic[@"displayNumbers"];
    [self.navigationController pushViewController:intro animated:YES];
}

#pragma mark - 跳转到案例详情
- (void)gotoAnliDetail:(UITapGestureRecognizer *)tapGR {
    UIView *view = tapGR.view;
    NSInteger index = view.tag;
    if ([self.companyDic[@"conVip"] integerValue] == 0) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"主人暂未开通云管理会员"];
        return;
    }
    
    ZCHBudgetGuideConstructionCaseModel *model = self.reommendConArray[index];
    MainMaterialDiaryController *vc = [[MainMaterialDiaryController alloc] init];
    vc.pennantnumber =self.companyDic[@"pennantNumber"];
    vc.flowerNumber =self.companyDic[@"flowerNumber"];
    vc.consID = [model.constructionId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark  案例展示
- (void)caseShow {

    BuildCaseViewController *show = [[BuildCaseViewController alloc]init];
    show.companyId = self.shopID;
    show.isCompany = NO;
    show.isConVIP = [self.companyDic[@"conVip"] integerValue] == 0 ? NO : YES;
    [self.navigationController pushViewController:show animated:YES];
}

#pragma mark 计算器
- (void)calculator {

    MaterialCalculatorController *VC = [[MaterialCalculatorController alloc] init];
//    VC.imageArray = self.calImageArray;
    VC.shopID = self.shopID;
    VC.isConVip = self.companyDic[@"conVip"];
    VC.dispalyNum = self.companyDic[@"displayNumbers"];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 新闻资讯
- (void)appraise {
    
    homenewsVC *vc = [homenewsVC new];
    vc.companyId = self.companyDic[@"companyId"]?:@"";
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark 优秀员工
- (void)excellentEmployee {

    ExcellentStaffViewController *esVC = [[ExcellentStaffViewController alloc] init];
    esVC.companyId = self.companyDic[@"companyId"];
//    esVC.teamType = 1025;
    esVC.titleStr = @"施工团队";
    esVC.isShop = YES;
    esVC.origin = self.origin;
    esVC.companyType = self.companyDic[@"companyType"];
    esVC.companyDic = self.companyDic;
    esVC.dispalyNum = self.companyDic[@"displayNumbers"];
    [self.navigationController pushViewController:esVC animated:YES];
}


#pragma mark 施工团队(4.5.5之后变成了商品展示)
- (void)workTeam {
    YellowGoodsListViewController *VC = [YellowGoodsListViewController new];
    VC.fromBack = NO;
    VC.shopId = self.shopID;
    VC.shopid = self.shopID;
    VC.collectFlag = self.collectFlag;
    VC.dataDic = self.companyDic;
    VC.companyName = self.shopName;
    VC.shareCompanyLogoURLStr = [self.companyDic objectForKey:@"companyLogo"];
    VC.shareDescription = [self.companyDic objectForKey:@"companyIntroduction"];
    VC.origin = self.origin;
    [self.navigationController pushViewController:VC animated:YES];

}

#pragma mark 店铺全景
- (void)shopSence {

    PanoramaViewController *panorama = [[PanoramaViewController alloc]init];
    
    //页面跳转标记
    panorama.tag = 1000;
    panorama.origin = self.origin;
    panorama.shopID = self.shopID;
    panorama.companyType = self.companyDic[@"companyType"];
    panorama.dataDic = self.companyDic;
    [self.navigationController pushViewController:panorama animated:YES];
}

#pragma mark 合作企业
- (void)produceList {
    
    // 是否是内网状态
    if (_isInnerNetState) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"定制环境，不能查看"];
        return;
    }
    
    ZCHCooperateController *VC = [[ZCHCooperateController alloc] init];
    VC.companyId = self.shopID;
    VC.iscompany = NO;
    VC.companyDic = self.companyDic;
    VC.times = self.times;
    VC.origin = self.origin;
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark 商品展示
- (void)goodsAction:(NSInteger )tag {

//    ZCHGoodsDetailViewController *VC = [[ZCHGoodsDetailViewController alloc] init];
//    VC.goodModel = self.goodListArray[tag - 200];
//    [self.navigationController pushViewController:VC animated:YES];
    
    
    goodsModel *model = self.goodListArray[tag - 200];
    
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.flowerNumber =self.companyDic[@"flowerNumber"];
    vc.pennantnumber =self.companyDic[@"pennantNumber"];
    vc.goodsID = model.goodsId;
    vc.shopID = self.shopID;
    
    vc.fromBack = NO;
    vc.collectFlag = self.collectFlag;
    vc.shopid = self.shopID;
    vc.collectFlag = self.collectFlag;
    vc.shopid = self.shopID;
    vc.dataDic = self.companyDic;
    vc.companyType = @"";
    vc.origin = self.origin;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 获取验证码
- (void)getVertifyCodeWithDict:(NSDictionary *)dict{
    NSString *apiStr = [BASEURL stringByAppendingString:@"sms/getSignUpSms.do"];
    [NetManager afPostRequest:apiStr parms:dict finished:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1000) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
            __block int timeout = 120; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            _vertifytime = _timer;
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                
                if(timeout <= 0) { //倒计时结束，关闭
                    
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.checkCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.checkCodeBtn.userInteractionEnabled = YES;
                        self.checkCodeBtn.backgroundColor = kMainThemeColor;
                    });
                    
                } else {
                    
                    int seconds = timeout;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        //NSLog(@"____%@",strTime);
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [self.checkCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        self.checkCodeBtn.userInteractionEnabled = NO;
                        self.checkCodeBtn.backgroundColor = kDisabledColor;
                    });
                    timeout--;
                }
            });
            
            dispatch_resume(_timer);
            
            return ;
        } else if ([responseObj[@"code"] integerValue] == 1003) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已经报名过改活动"];
        }  else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送失败"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}
#pragma mark - 活动报名
- (void)signUpWithDict:(NSDictionary *)dict{
    [dict setValue:self.origin?:@"0" forKey:@"origin"];
    NSString *apiStr = [BASEURL stringByAppendingString:@"signUp/signUp.do"];
    [NetManager afPostRequest:apiStr parms:dict finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"报名成功"];
            }
                break;
            case 1003:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            case 1004:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码已过期，请重新获取"];
                break;
            case 1005:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已经报名过该活动"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"报名失败"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (void)signUpWithDict:(NSDictionary *)dict completion:(void(^)(bool))signUpComopletion {
    NSString *apiStr = [BASEURL stringByAppendingString:@"signUp/signUp.do"];
    [NetManager afPostRequest:apiStr parms:dict finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1000) {
            signUpComopletion(YES);
        } else {
            signUpComopletion(NO);
        }
        switch (code) {
            case 1000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"报名成功"];
            }
                break;
            case 1003:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            case 1004:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码已过期，请重新获取"];
                break;
            case 1005:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已经报名过该活动"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"报名失败"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 合作企业视图
- (UIButton *)cooperateViewWithModel:(ZCHCooperateListModel *)model {
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = White_Color;
    [btn addTarget:self action:@selector(didClickCooperate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, BLEJWidth * 1 / 3 - 20, (BLEJWidth * 1 / 3 - 20) * 3 / 8)];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.layer.masksToBounds = YES;
    [logoView sd_setImageWithURL:[NSURL URLWithString:model.sloganLogo] placeholderImage:nil];
    [btn addSubview:logoView];
    
    CGSize size = [model.companyName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:12]];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, logoView.bottom, size.width > BLEJWidth * 1 / 3 - 20 - 14 ? BLEJWidth * 1 / 3 - 20 - 14 : size.width, 20)];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.text = model.companyName;
    [btn addSubview:nameLabel];
    
    UIImageView *vipLogo = [[UIImageView alloc] initWithFrame:CGRectMake(nameLabel.right, logoView.bottom + 3, 14, 14)];
    vipLogo.image = [UIImage imageNamed:@"vip"];
    [btn addSubview:vipLogo];
    
    if ([model.appVip isEqualToString:@"1"]) {
        vipLogo.hidden = NO;
    } else {
        vipLogo.hidden = YES;
    }
    
    CGSize sizeCount = [model.displayNumbers boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:12]];
    UILabel *showCount = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 1 / 3 - 10 - sizeCount.width, nameLabel.bottom, sizeCount.width, 20)];
    [btn addSubview:showCount];
    showCount.textAlignment = NSTextAlignmentRight;
    showCount.font = [UIFont systemFontOfSize:12];
    showCount.textColor = kCustomColor(33, 151, 216);
    showCount.text = model.displayNumbers;
    
    UIImageView *scanIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
    [btn addSubview:scanIV];
    [scanIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(showCount);
        make.right.equalTo(showCount.mas_left).equalTo(-5);
        make.size.equalTo(CGSizeMake(20, 10));
    }];
    
    return btn;
}

#pragma mark - 合作企业点击视图
- (void)didClickCooperate:(UIButton *)btn {
    
    if (self.times && [self.times isEqualToString:@"2"]) {
        return;
    }
    
    ZCHCooperateListModel *model = [self.cooperateArr objectAtIndex:btn.tag];
    if ([model.appVip isEqualToString:@"1"]) {
        //公司的详情
        if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1064"] || [model.companyType isEqualToString:@"1065"]) {
            CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
            company.companyName = model.companyName;
            company.companyID = model.companyId;
            company.times = @"2";
            company.origin = self.origin;
            company.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:company animated:YES];
        } else {
            //店铺的详情;
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = model.companyName;
            shop.shopID = model.companyId;
            shop.times = @"2";
            shop.origin = self.origin;
            model.browse = [NSString stringWithFormat:@"%ld", model.browse.integerValue + 1];
            shop.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shop animated:YES];
        }
        
    }
}
#pragma mark 免费报价
- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
    VC.calculatorModel = self.calculatorTempletModel;
    VC.bottomCalculatorImageArr =self.bottomCalculatorImageArr;
    VC.topCalculatorImageArr=self.topCalculatorImageArr;
    VC.homeModel=self.homeModel;
    VC.cooperateArr =self.cooperateArr;
    VC.constructionCase = self.constructionCase;
    VC.baseItemsArr = self.baseItemsArr;
    VC.suppleListArr = self.suppleListArr;
    VC.companyDic =self.companyDic;
    VC.viewList =self.viewList;
    VC.userPhoneArray =self.userPhoneArray;
    VC.companyDic=self.companyDic;
    VC.origin =self.origin;
    VC.companyID = self.shopID;
    VC.code =self.code;
    VC.shareCompanyLogoURLStr =self.homeModel.typeLogo;;
    VC.shareDescription=self.homeModel.companyIntroduction;;
    VC.collectFlag =self.collectFlag;
    VC.isConVip = self.companyDic[@"conVip"];
    VC.dispalyNum =self.companyDic[@"displayNumbers"];
    [self.navigationController pushViewController:VC animated:YES];
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
    [NSObject needDecorationStatisticsWithConpanyId:self.shopID];
    
}

#pragma mark - 投诉按钮的点击事件
- (void)didClickComplainBtn:(UIButton *)btn {
    
    ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
    ComplainVC.companyID = self.shopID.integerValue;
    [self.navigationController pushViewController:ComplainVC animated:YES];
}

#pragma  mark - 发送验证码
- (void)sendvertifyAction {
    
    [self.infoView endEditing:YES];
    if (![self.infoView.phoneTF.text ew_justCheckPhone]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"callDecoration/sendPhoneCode.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [param setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [weakSelf timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已喊过装修"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败或操作过于频繁"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)timelessWithSecond:(NSInteger)s button:(UIButton *)btn {
    
    __block int timeout = (int)s; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = kMainThemeColor;
            });
        } else {
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
                btn.backgroundColor = kDisabledColor;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

#pragma mark - 完成
- (void)finishiAction {
    
    if ([self.infoView.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if (![self.infoView.phoneTF.text ew_checkPhoneNumber]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的联系方式"];
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.infoView.vertifyCodeTF.text forKey:@"phoneCode"];
    [dic setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text forKey:@"fullName"];
    [dic setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.companyDic[@"companyType"] forKey:@"companyType"];
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
                completionVC.companyType = weakSelf.companyDic[@"companyType"];
                NSString *constructionType = weakSelf.companyDic[@"constructionType"];
                completionVC.constructionType = constructionType;
                [self.navigationController pushViewController:completionVC animated:YES];
                break;
            }
            case 1001:
                break;
                //            本月已喊过装修
            case 1002:
                self.infoView.hidden = YES;
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


#pragma mark - 点赞按钮的点击事件
- (void)didClickGoodBtn:(UIButton *)btn {

    if (!_hasSupport) {
        _hasSupport = YES;
        [btn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        self.goodCountLabel.text = [NSString stringWithFormat:@"%ld", [self.goodCountLabel.text integerValue] + 1];
        CGSize goodSizeCount = [self.goodCountLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:16]];
        self.goodCountLabel.width = goodSizeCount.width;
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *apiStr = [BASEURL stringByAppendingString:@"company/like.do"];
        NSDictionary *param = @{
                                @"agencyId" : @(user.agencyId),
                                @"companyId" : self.shopID
                                };
        [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        } failed:^(NSString *errorMsg) {
        }];
    }
}

- (SDCycleScrollView *)allView {
    
    if (_allView == nil) {
        _allView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJWidth * 0.6) delegate:self placeholderImage:nil];
        _allView.autoScrollTimeInterval = BANNERTIME;
        _allView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _allView.backgroundColor = [UIColor blackColor];
        _allView.showPageControl = NO;
        _allView.ishaveMiddleImage = YES;
    }
    return _allView;
}

@end
