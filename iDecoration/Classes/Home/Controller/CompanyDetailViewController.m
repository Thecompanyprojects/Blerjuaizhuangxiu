//
//  CompanyDetailViewController.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "VIPExperienceShowViewController.h"
#import "CompanyDetailTableViewCell.h"
#import "CompanyIntroductController.h"
#import "BuildCaseViewController.h"
#import "OwnerEvaluateController.h"
#import "BLEJBudgetGuideController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "ZYCShareView.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "HKImageClipperViewController.h"
#include <CoreGraphics/CoreGraphics.h>
#include <ImageIO/ImageIOBase.h>
#import <ImageIO/ImageIO.h>
#import <sys/utsname.h>
#import "NSObject+CompressImage.h"
#import "ZCHBudgetGuideConstructionCaseCell.h"
#import "SDCycleScrollView.h"
#import "ConstructionDiaryTwoController.h"
#import "ShopDetailViewController.h"
#import "ZCHCooerateCompanyController.h"
#import "DecorateNeedViewController.h"
#import "ZCHCooperateController.h"
#import "PellTableViewSelect.h"
#import "LoginViewController.h"
#import "ComplainViewController.h"
#import "ZCHCooperateListModel.h"
#import "YellowPageActivityCell.h"
#import "WQLPaoMaView.h"
#import "ActivityCustomDefine.h"
#import "HistoryActivityViewController.h"
#import "ActivityShowController.h"
#import "AdvertisementWebViewController.h"
#import "ZCHNewsInforController.h"
#import "NewsActivityShowController.h"
#import "ExcellentStaffViewController.h"
#import "PanoramaViewController.h"
#import "YellowGoodsListViewController.h"
#import "shopDetailView.h"
#import "goodsModel.h"
#import "GoodsDetailViewController.h"
#import "ZCHPublicWebViewController.h"
#import "senceWebViewController.h"
#import "senceModel.h"
#import "SubsidiaryModel.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "YellowActicleView.h"
#import "BLEJBudgetPriceController.h"
#import "ZCHCalculatorSelectRoomNumView.h"
#import "ZCHCalculatorSimpleOfferModel.h"

#import "CoatingCalculaterController.h"
#import "FloorBoardCalculaterController.h"
#import "WallTitleCalculaterController.h"
#import "CurtainCalculateController.h"
#import "FloorTitleCalculaterController.h"
#import "WallPaperCalculatorController.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "homenewsVC.h"

#import "JinQiViewController.h"
#import "SendFlowersViewController.h"
#import "localcommunityVC.h"
#import "XianHuaJinQiGuanzhuCell.h"
#import "pushImageViewController.h"
#import "LYShareMenuView.h"

static NSString *kCellIdentify  =@"YellowPageActivityCell";
static NSString *reuseIdentifier = @"ZCHBudgetGuideConstructionCaseCell";
@interface CompanyDetailViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, SDCycleScrollViewDelegate, shopDetailViewDelagate,ZCHCalculatorSelectRoomNumViewDelegate,LYShareMenuViewDelegate>{
    UILabel *displayCount;
    UILabel *goodCount;
    NSString*displayCountnumber;
     NSString*goodCountnumber;
    UIView *footView;
    dispatch_source_t _timer;
}
@property (strong, nonatomic) ZYCShareView *shareView;
@property (assign, nonatomic) NSInteger testCodeType;
@property (assign, nonatomic) BOOL isSendCode;
@property (strong, nonatomic) UIImageView *imageViewGoodComment;
@property (strong, nonatomic) CompanyDetailTableViewCell *middleCell;

//购买锦旗鲜花的View
@property (strong, nonatomic)UIView *FlipView;
//购买锦旗鲜花的View
@property (strong, nonatomic)UIView *baseView;
// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 置顶的公司列表
@property (strong, nonatomic) NSMutableArray *topConstructionList;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes* calculatorModel;
//公司的信息数组
@property (nonatomic, strong) NSMutableArray *companyItemArray;
//工资的字典集合
@property (nonatomic, strong) BLRJCalculatortempletModelAllCalculatorcompanyData*  allCalculatorCompanyData;

// 记录是否可以点击跳转计算器界面(是否设置过基础模板)
@property (assign, nonatomic) NSInteger code;
// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;
// 商品
@property (strong, nonatomic) NSMutableArray *goodListArray;
// 标记是点的那个图片(8: 上  9: 下)
@property (assign, nonatomic) NSInteger beClickedPicNum;
// 顶部图片Id
@property (strong, nonatomic) NSMutableString *topPicId;
// 底部图片Id
@property (strong, nonatomic) NSMutableString *bottomPicId;
// 头部视图
@property (strong, nonatomic) UIImageView *topImageView;
// 计算器视图
@property (strong, nonatomic) UIView* btnCollectionView;
// 头部视图
@property (strong, nonatomic) SDCycleScrollView *topCycleScrollView;
// 底部视图的size
@property (assign, nonatomic) CGSize bottomSize;

@property(strong,nonatomic)LYShareMenuView *shareMenuView;
// 顶部图片url数组
@property (strong, nonatomic) NSMutableArray *topImageArr;
// 底部图片url数组
@property (strong, nonatomic) NSMutableArray *bottomImageArr;
// 顶部图片信息字典数组
@property (nonatomic, strong) NSMutableArray *topImageDicArray;
// 底部图片信息字典数组
@property (nonatomic, strong) NSMutableArray *bottomImageDicArray;

// 公司的装修区域
@property (strong, nonatomic) NSMutableArray *areaArr;
// 全景数组
@property (strong, nonatomic) NSMutableArray *viewList;
// 公司的基本信息
@property (strong, nonatomic) NSMutableDictionary *companyDic;
// 合作企业
@property (strong, nonatomic) NSMutableArray *cooperateArr;

// 合作企业cell
@property (strong, nonatomic) UITableViewCell *cooperateCell;
// 底部点赞数量
@property (strong, nonatomic) UILabel *goodCountLabel;


// 选择照片自定义剪切框
@property (nonatomic, assign) ClipperType clipperType;
@property (strong, nonatomic) UIImageView *clippedImageView; //显示结果图片
@property (nonatomic, assign) BOOL systemEditing;
@property (nonatomic, assign) BOOL isSystemType;

// 选择完照片之后的bgView
@property (strong, nonatomic) UIView *imageBgView;
@property (strong, nonatomic) UIImage *image;



// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 是否是定制会员
@property (nonatomic, assign) BOOL isVIP;
// 是否是内网状态
@property (nonatomic, assign) BOOL isInnerNetState;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
// 是否收藏标识   收藏了为收藏的id   collectFlag > 0 为收藏了   等于0为取消收藏
@property (nonatomic, strong) NSString *collectFlag;
// 是否是经理
@property (assign, nonatomic) BOOL isManager;
// 收藏按钮(底部)
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

@property (strong, nonatomic) SDCycleScrollView *allView;

@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@property (strong, nonatomic) ZCHCalculatorSelectRoomNumView *bottomView;


@property (strong, nonatomic)UIImageView *jinQi;
@property (strong, nonatomic)UIImageView *xianHua;
@property (strong, nonatomic)UILabel *jinQiL;
@property (strong, nonatomic)UILabel *xianHuaL;
@end

@interface CompanyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DidSelectDetailDelegate> {
    
    UITableView *_mainTableView;
    NSString *_topImageURL;
    NSString *_bottomImageURL;
    // 验证码倒计时时间
    dispatch_source_t _vertifytime;
    CGFloat dynamicHeight;
        CGFloat paoMaHeight;
        CGFloat signUpHeight;
 
}

@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initArrayAndProperty];

    self.testCodeType=1;
    self.isSendCode = NO;
    
    self.code = -1;
    self.isManager = NO;
    self.beClickedPicNum = 0;
    _hasActivity = NO;
    self.activityImageHeight = 0;
    self.isInnerNetState = NO;
    self.isVIP = NO;
    [self isCustomMadeVIP];
    
    if (_notVipButHaveArticle) {
        [self buildNotVipButHaveActicleView];
        [self addBottomView];
    } else {
        [self configureTableView];
        [self addBottomView];
    }

   
    
    self.automaticallyAdjustsScrollViewInsets=NO;
     self.navigationItem.title = self.companyName;
     self.view.backgroundColor = kBackgroundColor;
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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    

   
    [self addBottomShareView];
    [self addSuspendedButton];
    [self requestData];
    CLLocation *from;
    CLLocation *to;
    CLLocation *fromLocation    = [[CLLocation alloc] initWithLatitude:from.coordinate.latitude longitude:from.coordinate.longitude];
    CLLocation *toLocation      = [[CLLocation alloc] initWithLatitude:to.coordinate.latitude longitude:to.coordinate.longitude];
  
    CLLocationDistance distance = [fromLocation distanceFromLocation:toLocation ];
}

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}
- (void)makeShareView {
    WeakSelf(self);
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm?origin=%@", self.companyID,self.origin]];
    NSString *shareTitle = self.companyDic[@"companyName"];
    NSString *shareDescription = self.companyDic[@"companyIntroduction"];

    self.shareView.URL = shareURL;
    self.shareView.shareTitle = shareTitle;
    self.shareView.shareCompanyIntroduction = shareDescription;
    self.shareView.shareCompanyLogoImage = self.companyLogo;
    self.shareView.companyName = self.companyName;

    self.shareView.blockQRCode1st = ^{
        [MobClick event:@"CompanyYellowPageShare"];
        weakself.TwoDimensionCodeView.hidden = NO;
    
        [UIView animateWithDuration:0.25 animations:^{
            weakself.TwoDimensionCodeView.alpha = 1.0;
            weakself.navigationController.navigationBar.alpha = 0;
        }];
    };
    self.shareView.blockQRCode2nd = ^{
        [MobClick event:@"CompanyYellowPageShare"];
        weakself.TwoDimensionCodeView.hidden = NO;
      
        [UIView animateWithDuration:0.25 animations:^{
            weakself.TwoDimensionCodeView.alpha = 1.0;
            weakself.navigationController.navigationBar.alpha = 0;
        }];
    };
}
#pragma mark - shareview  分享

-(void)addsaveclick
{
    [self.shareMenuView show];
}

-(void)setupshare
{
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
    
    
    
    LYShareMenuItem *item4 = nil;
    item4 = [LYShareMenuItem shareMenuItemWithImageName:@"erweima-0" itemTitle:@"公司二维码"];
    [array addObject:item4];
    
    LYShareMenuItem *item5 = nil;
    item5 = [LYShareMenuItem shareMenuItemWithImageName:@"erweima-0" itemTitle:@"员工二维码"];
    [array addObject:item5];
    self.shareMenuView.shareMenuItems = [array copy];
}

- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm?origin=%@", self.companyID,self.origin]];
    NSString *sharetitle = self.companyDic[@"companyName"];
    NSString *sharedescription = self.companyDic[@"companyIntroduction"];
//    NSString *str1 = [BASEURL stringByAppendingString:@"citywiderecomend"];
//    NSString *shareURL = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,@"?type=3",@"&cityId=",self.cityId,@"&countyId",self.countyId];
//
//    NSString *sharetitle = @"上爱装修挑万家优品";
//    NSString *sharedescription = @"大牌来袭，等你抢购，特卖产品，等你来拿~";
    
    switch (index) {
        case 0:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:sharedescription previewImageData:nil];
                
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
                
                NSURL *url = [NSURL URLWithString:shareURL];
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:sharedescription previewImageData:nil];
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
            message.title = sharetitle;
            message.description = sharedescription;
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
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
            message.title = sharetitle;
            message.description = sharedescription;
            
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
            
        case 4:
            [self addTwoDimensionCodeView];
            self.TwoDimensionCodeView.hidden =NO;
            self.navigationController.navigationBar.alpha = 0;
//            [UIView animateWithDuration:0.25 animations:^{
//
//                self.TwoDimensionCodeView.alpha = 0;
//                self.navigationController.navigationBar.alpha = 1;
//            }completion:^(BOOL finished) {
//
//                self.TwoDimensionCodeView.hidden = YES;
//            }];
            break;
        case 5:
             [self addTwoDimensionCodeView];
            self.TwoDimensionCodeView.hidden =NO;
            self.navigationController.navigationBar.alpha = 0;
            break;
        default:
            break;
    }
}
-(void)initArrayAndProperty{
    
    self.baseItemsArr = [NSMutableArray array];
    self.suppleListArr = [NSMutableArray array];
   
    self.topConstructionList = [NSMutableArray array];
    self.constructionCase = [NSMutableArray array];
    self.goodListArray = [NSMutableArray array];
    self.viewList = [NSMutableArray array];
   
    self.topImageArr = [NSMutableArray array];
    self.bottomImageArr = [NSMutableArray array];
    self.topImageDicArray = [NSMutableArray array];
    self.bottomImageDicArray = [NSMutableArray array];
    self.areaArr = [NSMutableArray array];
    self.cooperateArr = [NSMutableArray array];
    self.phoneArr = [NSMutableArray array];
    self.companyDic = [NSMutableDictionary dictionary];
    self.acticityArray = [NSMutableArray array];
    self.customDefineArray = [NSMutableArray array];
    self.activityDict = [NSMutableDictionary dictionary];
    self.userPhoneArray = [NSMutableArray array];
    self.companyItemArray=[NSMutableArray array];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"装修公司"];
    [MobClick event:@"CompanyDetail"];
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPaoMaContinueAnimation" object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"装修公司"];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}


#pragma mark WFSuspendButtonDelegate
-(void)isButtonTouched{
    pushImageViewController *VC = [[pushImageViewController alloc] init];
    
    VC.title =self.companyName;
//    VC.titleStr = @"说明书";
//     NSString *shareURL = [BASEHTML stringByAppendingString:PaiMingGongLue];
//    VC.webUrl = shareURL;//INSTRCTIONHTML;
//    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
  
}

#pragma mark 导航栏按钮点击事件
-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航栏右边按钮
- (void)moreBtnClicked:(UIButton *)sender {
    
   
    // 弹出的自定义视图
    NSArray *array;
    //@"轻铺计算器",@"套餐计算器",@"瓷砖计算器",@"地板计算器",@"集成吊顶计算器",@"壁纸/壁铺计算器",@"地暖计算器",@"成品计算器",
    if (!self.isManager) {
        if (self.collectFlag.integerValue > 0) { // 已添加到收藏
            array = @[@"取消收藏", @"投诉", @"分享"];
        } else {
            array = @[@"收藏",@"投诉", @"分享"];
        }
    } else {
        
        if (self.collectFlag.integerValue > 0) { // 已添加到收藏
            array = @[@"取消收藏", @"投诉", @"分享"];
        } else {
            array = @[@"收藏",@"投诉", @"分享"];
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
                
                if (self.collectFlag.integerValue > 0) {
                    [self unCollectionShopOrCompany];
                } else {
                    [self saveShopOrCompany];
                }
            }
        }else if (index == 1){ // 投诉
            ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
            ComplainVC.companyID = self.companyID.integerValue;
            [self.navigationController pushViewController:ComplainVC animated:YES];
        }else if (index == 2){//分享


            [self.shareMenuView show];
            [self   setupshare];
          
        }
    } animated:YES];
    
}
#pragma mark 收藏按钮的点击和取消
- (void)unCollectionShopOrCompany {
    
    //NSString *defaultApi = [BASEURL stringByAppendingString:@"collection/delete.do"];
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    NSDictionary *paramDic = @{
                               @"collectionId":@(self.collectFlag.integerValue)
                               };
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        YSNLog(@"responseObj: %@", responseObj);
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
    

    NSString *url = POST_ADDSHOUCANG;
    NSString *requestString = [BASEURL stringByAppendingString:url];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.companyID.integerValue) forKey:@"relId"]; // 店铺或公司ID
    [params setObject:@(user.agencyId) forKey:@"agencysId"]; // 用户ID

    [NetManager afPostRequest:requestString parms:params finished:^(id responseObj) {
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            self.collectFlag = [NSString stringWithFormat:@"%ld", [responseObj[@"collectionId"] integerValue]];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏成功"];
            self.collectionBtn.selected = YES;
        } else if([responseObj[@"code"] isEqualToString:@"1002"]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经收藏过了"];
        }else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏失败"];
        }
        

    } failed:^(NSString *errorMsg) {
        
    }];
}
#pragma mark SetUI
- (void)buildNotVipButHaveActicleView {
    YellowActicleView *v = [[YellowActicleView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50)];
    v.designsId = self.designsId.integerValue;
    [self.view addSubview:v];
}

- (void)configureTableView {
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"ZCHBudgetGuideConstructionCaseCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
     [_mainTableView registerNib:[UINib nibWithNibName:@"YellowPageActivityCell" bundle:nil] forCellReuseIdentifier:kCellIdentify];
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6)];
    self.topCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6) delegate:self placeholderImage:nil];
    self.topCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.topCycleScrollView.backgroundColor = [UIColor blackColor];
    self.topCycleScrollView.autoScrollTimeInterval = BANNERTIME;
    self.topCycleScrollView.tag = 10000111;
    
    
    [self.view addSubview:_mainTableView];
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
//    [collectionBtn setImage:[UIImage imageNamed:@"noSelectCollection"] forState:UIControlStateNormal];
//    [collectionBtn setImage:[UIImage imageNamed:@"selectCollection"] forState:UIControlStateSelected];
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [collectionBtn setTitle:@"赠送礼物" forState:UIControlStateNormal];
    [collectionBtn setImage: [UIImage imageNamed:@"icon_liwu"] forState:normal];
    [collectionBtn setTitle:@"赠送礼物" forState:UIControlStateSelected];
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
    
    UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, BLEJWidth/4, bottomView.height)];
    houseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    houseBtn.backgroundColor = kMainThemeColor;
    [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];
    [houseBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:houseBtn];
}

// 判断是否为定制版会员
- (void)isCustomMadeVIP {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
    NSInteger roletypeid= [[dict objectForKey:@"roleTypeId"] integerValue];
    if (!roletypeid||roletypeid == 0) {
        roletypeid = 0;
    }
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/signInPersonJudge.do"];
    NSDictionary *paramDic = @{
                               @"currentPersionId":@(agencyid),
                               @"currentPersonJob":@(roletypeid)
                               };
    MJWeakSelf;
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                    
                    if (responseObj[@"innerOrOuterFlag"]) {
                        id a = responseObj[@"innerOrOuterFlag"];
                        NSString *tempstr;
                        if ([a isKindOfClass:[NSString class]]) {
                            tempstr = a;
                            if ([tempstr isEqualToString:@"innerIntent"]){
                                //内网 定制会员
                                weakSelf.isVIP = YES;
                            } else {
                                
                            }
                        }
                    }
                    break;
                case 10001:
                    
                    break;
            }
        }

    } failed:^(NSString *errorMsg) {
        
    }];
}
#pragma  mark - 分享 ↓
- (void)addBottomShareView {
    
   
    
}
#pragma mark shadowView点击事件
- (void)didClickShadowView:(UITapGestureRecognizer *)tap {

}

- (void)didClickShareContentBtn:(UIButton *)btn {

    
    NSString *shareTitle = self.companyDic[@"companyName"];
    NSString *shareDescription = self.companyDic[@"companyIntroduction"];
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.companyLogo == nil) {
        [[UIApplication sharedApplication].keyWindow hudShow];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]]]];
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
        shareImage = self.companyLogo;
        
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
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm?origin=%@", self.companyID,self.origin]];
    
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
            
            BOOL isSend = [WXApi sendReq:req];  // 返回YES 跳转成功
            
            YSNLog(@"issend: %d", isSend);
            if (isSend) {
                [MobClick event:@"CompanyYellowPageShare"];
            }
            
           
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            //            [message setThumbImage:[UIImage imageNamed:@"top_default"]];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CompanyYellowPageShare"];
            }

        }
            break;
        case 2:
        {// QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                if (code == 0) {
                    [MobClick event:@"CompanyYellowPageShare"];
                }
                
             
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
                if (code == 0) {
                    [MobClick event:@"CompanyYellowPageShare"];
                }
                

            }
        }
            break;
        case 4:
        {// 二维码
            [MobClick event:@"CompanyYellowPageShare"];
            self.TwoDimensionCodeView.hidden = NO;
          
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
    [NSObject companyShareStatisticsWithConpanyId:self.companyID];
    
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {
    
    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.TwoDimensionCodeView.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [self.TwoDimensionCodeView addSubview:codeView];

    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.companyID]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hudShow];
        });
        
        UIImage *shareImage;
        if (self.companyLogo == nil) {
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
            shareImage = self.companyLogo;
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
    companyNameLabel.text = self.companyName;
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


#pragma mark               获取公司的每个section的数据
- (void)requestData {
    
    NSString *requestString = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"company/yellowInit/%@.do", self.companyID]];
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyId = [NSString stringWithFormat:@"%ld", (long)model.agencyId];
    NSDictionary *param = @{@"agencyId": agencyId};
    [[UIApplication sharedApplication].keyWindow hudShow];

    [NetManager afPostRequest:requestString parms:param finished:^(id responseObj) {
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.companyDic removeAllObjects];
            // 公司信息
            self.companyDic = [NSMutableDictionary dictionaryWithDictionary:[responseObj[@"data"] objectForKey:@"company"]];
            
            self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
            self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
            if (self.navigationItem.title.length == 0) {
                self.navigationItem.title = self.companyDic[@"companyName"];
            }
            goodCountnumber = self.companyDic[@"likeNumbers"];
            displayCountnumber = self.companyDic[@"browse"];
            self.isInnerNetState = [responseObj[@"data"][@"inOrOutStatus"] integerValue];
            
           
            
            // 施工案例(推荐到企业的)
            NSArray *caseArr = [responseObj[@"data"] objectForKey:@"conList"];
            [self.constructionCase removeAllObjects];
            for (NSDictionary *dict in caseArr) {
                
                ZCHBudgetGuideConstructionCaseModel *caseListModel = [ZCHBudgetGuideConstructionCaseModel yy_modelWithJSON:dict];
                
                if (![self.constructionCase containsObject:caseListModel]) {
                    [self.constructionCase addObject:caseListModel];
                }
            }
            // 全景视图
            [self.viewList removeAllObjects];
            self.viewList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[senceModel class] json:[responseObj[@"data"] objectForKey:@"viewList"]]];
            
            // 商品
            [self.goodListArray removeAllObjects];
            [self.goodListArray addObjectsFromArray:[NSMutableArray yy_modelArrayWithClass:[goodsModel class] json:responseObj[@"data"][@"merchandies"]]];
            
            // 合作企业
            NSArray *cooperateArr = [responseObj[@"data"] objectForKey:@"enterPriseList"];
            [self.cooperateArr removeAllObjects];
            self.cooperateCell = nil;
            for (NSDictionary *dict in cooperateArr) {
                
                ZCHCooperateListModel *cooperateModel = [ZCHCooperateListModel yy_modelWithJSON:dict];
                
                if (![self.cooperateArr containsObject:cooperateModel]) {
                    [self.cooperateArr addObject:cooperateModel];
                }
            }
            
            // 装修区域
            NSArray *areaArr = [responseObj[@"data"] objectForKey:@"areaList"];
            [self.areaArr removeAllObjects];
            for (NSDictionary *dict in areaArr) {
                
                if (![self.areaArr containsObject:dict]) {
                    [self.areaArr addObject:dict];
                }
            }
            
            // 计算器顶部视图
            
            
            NSArray *ArrCalculator = [responseObj[@"data"] objectForKey:@"calHeadImages"];
            [self.topImageDicArray removeAllObjects];
            
            
            for (NSDictionary *dict in ArrCalculator) {
                
                if (![self.topImageDicArray containsObject:dict]) {
                    [self.topImageDicArray addObject:dict[@"picUrl"]];
                }
            }
            
              [self.bottomImageDicArray removeAllObjects];
            NSArray *bottomImageCal = [responseObj[@"data"] objectForKey:@"calFootImages"];
            [self.bottomImageDicArray removeAllObjects];
            
            for (NSDictionary *dict in bottomImageCal) {
                
                if (![self.bottomImageDicArray containsObject:dict]) {
                    [self.bottomImageDicArray addObject:dict[@"picUrl"]];
                }
            }
            
          
            // 底部视图
            NSArray *ImageArr = [responseObj[@"data"] objectForKey:@"headImages"];
            [self.topImageArr  removeAllObjects];
            
            for (NSDictionary *dict in ImageArr) {
                
                if (![self.topImageArr containsObject:dict]) {
                    [self.topImageArr addObject:dict[@"picUrl"]];
                }
            }
            // 顶部视图
           
            
            if (self.topImageArr.count > 0) {
                
                _mainTableView.tableHeaderView = self.topCycleScrollView;
                self.topCycleScrollView.imageURLStringsGroup = self.topImageArr;
            } else {
                
                self.topImageView.image = [UIImage imageNamed:@"topbanner_default"];
                _mainTableView.tableHeaderView = self.topImageView;
            }
            
            // 底部视图
            NSArray *CalImageArr = [responseObj[@"data"] objectForKey:@"footImages"];
            [self.bottomImageArr removeAllObjects];
          
            for (NSDictionary *dict in CalImageArr) {
                
                if (![self.bottomImageArr containsObject:dict]) {
                    [self.bottomImageArr addObject:dict[@"picUrl"]];
                }
            }
            // 是否是经理(可以添加合作企业)
            self.isManager = [[responseObj[@"data"] objectForKey:@"isManager"] boolValue];
            
            // 收藏的id
            self.collectFlag = responseObj[@"data"][@"inCollection"];
            self.collectionBtn.selected = [self.collectFlag boolValue];
            
            if (self.bottomImageArr.count >0) {
                
                _bottomImageURL = self.bottomImageArr[0];
                __weak typeof(self) weakSelf = self;
                //同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
                dispatch_queue_t queue = dispatch_queue_create("CompanyDetailViewController", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(queue, ^{
                    
                    if ([((NSString *)self.bottomImageArr[0]) containsString:@".webp"]) {
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.bottomSize = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:self.bottomImageArr[0]] andType:1];
                            [_mainTableView reloadData];
                        });
                    }
                    
                });
            }
            
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
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [_mainTableView reloadData];

    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
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
- (void)didClickCollectionBtn:(UIButton *)btn {// 收藏(取消)
    

    
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
    view.companyId = self.companyID;
    WeakSelf(self)
    view.completionBlock = ^(NSString *count) {
        StrongSelf(weakself)
        if (count) {
        
            [strongself requestData];
            [_mainTableView reloadData];
           
            self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
            self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
     
        }
    };
    [self.navigationController pushViewController:view animated:YES];
  
}
#pragma mark 鲜花的购买事件

-(void)ToXianHuaPurchase{
    NSLog(@"++++++++++++++++++");
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    
    SendFlowersViewController *Flowerview =[[SendFlowersViewController alloc]init];
    Flowerview.compamyIDD =self.companyID;
    Flowerview.isCompamyID =YES;
    WeakSelf(self)
    Flowerview.blockIsPay = ^(BOOL isPay) {
         StrongSelf(weakself)
        if (isPay ==YES) {
            //鲜花的数量加一
            [strongself requestData];
            [_mainTableView reloadData];
            self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
            self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
   //         XianHuaJinQiGuanzhuCell *CEll =(XianHuaJinQiGuanzhuCell *) [_mainTableView footerViewForSection:0];
//            CEll.foucsNumber.text = [NSString stringWithFormat:@"%@%@",@"关注:",self.companyDic[@"likeNumbers"]];;
   //         CEll.flowerNumber.text =[NSString stringWithFormat:@"%@%@",@"鲜花:",self.companyDic[@"flowerNumber"] ];
           
            
        }
        
    };
    [self.navigationController pushViewController:Flowerview animated:YES];
}





- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
    VC.homeModel=self.HomeModel;
    VC.cooperateArr =self.cooperateArr;
    VC.topImageArr = self.topImageDicArray;
    VC.bottomImageArr =self.bottomImageDicArray;
    VC.calculatorModel = self.calculatorModel;
    VC.baseItemsArr = self.baseItemsArr;
    VC.suppleListArr = self.suppleListArr;
    VC.companyDic =self.companyDic;
    VC.userPhoneArray =self.userPhoneArray;
    VC.constructionCase = self.constructionCase;
    VC.companyID = self.companyID;
    VC.viewList =self.viewList;
    VC.code =self.code;
    VC.display =displayCountnumber;
    VC.goodcount=goodCountnumber;
    VC.activityDict= self.activityDict;
    VC.shareCompanyLogoURLStr =self.shareCompanyLogoURLStr;
    VC.shareDescription=self.shareDescription;
    VC.collectFlag =self.collectFlag;
    VC.isConVip = self.companyDic[@"conVip"];
    VC.dispalyNum = self.companyDic[@"displayNumbers"];
    VC.origin = self.origin;
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
//    if (!self.infoView.textFieldImageVerificationCode.text.length) {
//        SHOWMESSAGE(@"请输入图形验证码")
//        return;
//    }
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
#warning 图形验证码 后台拖后腿 后续版本增加该功能 暂时注释
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



#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (cycleScrollView.tag == 10000111) {
        
        NSString *webUrl = self.topImageArr[index];
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

#pragma mark - tableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    if (section == 1) {
        
        return self.goodListArray.count == 0 ? 0 : 1;
    } else if (section == 2) {
        
        // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
        NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
        if (activStateInteger == 0) {

            return 1;
        }else if (activStateInteger==3)
        {
            return 0;
        }
        
        //return _hasActivity ? 1 : 0;
    } else if (section == 3) {
        
        return 1;
    } else if (section == 4) {
        
        return self.viewList.count > 0 ? 1 : 0;
    } else if (section == 5) {
        
        return self.cooperateArr.count > 0 ? 1 : 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CompanyDetailTableViewCell *cell = [[CompanyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"style"];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self goodsShowWithArray:self.goodListArray bgView:cell];

        return cell;
    } else if(indexPath.section == 2) {
    
        YellowPageActivityCell *cell =[[NSBundle mainBundle]loadNibNamed:@"YellowPageActivityCell" owner:self options:nil].lastObject;
        if (cell == nil) {
            cell = (YellowPageActivityCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YellowPageActivityCell"] ;
        }

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
            self.activityImageHeight =  BLEJWidth*2/3 ;
        }
       
        
        // 跑马视图
        NSMutableAttributedString *mulattrStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < self.userPhoneArray.count; i ++) {
            if ([self.userPhoneArray[i][@"userPhone"] integerValue] == 0 || [self.userPhoneArray[i][@"userPhone"] isEqualToString:@""]) {
                continue ;
            }
            NSString *phoneStr =[NSString stringWithFormat:@"%@", self.userPhoneArray[i][@"userPhone"]];
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
        if (  self.paoMaoAttribureStr ==nil || self.paoMaoAttribureStr.length ==0) {
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
        
                UITextField *customTF = [[UITextField alloc] initWithFrame:CGRectMake(0, label.bottom + 16, kSCREEN_WIDTH - 60, 30)];
                
                  [cell.dynamicView addSubview:customTF];
                customTF.font = [UIFont systemFontOfSize:16];
                if ([customModel.isMust isEqualToString:@"1"]) {
                    customTF.placeholder = [NSString stringWithFormat:@"请输入%@（必填）", customModel.customName];
                } else {
                    customTF.placeholder = [NSString stringWithFormat:@"请输入%@", customModel.customName];
                }
                customTF.tag = 10000 + i;
                customTF.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
                customTF.layer.borderColor=[UIColor grayColor].CGColor;
                
                customTF.layer.borderWidth=0.7;
             
                cell.dynamicHeightconstant.constant+= 74;
                dynamicHeight= cell.dynamicHeightconstant.constant;
             //   [[NSNotificationCenter defaultCenter ] postNotificationName:@"KCellHeightChange" object:@{@"height":cell.dynamicView}];
              
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
            NSString *temCompanyId = self.companyID;
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
            
            for (int i = 0 ; i < self.customDefineArray.count; i ++) {
                ActivityCustomDefine *customModel = self.customDefineArray[i];
                UITextField *tf = [cell.dynamicView viewWithTag:(10000 + i)];
                if ([tf.text isEqualToString:@""] && [customModel.isMust isEqualToString:@"1"]) {
                    NSString *name = [NSString stringWithFormat:@"请输入%@", customModel.customName];
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:name];
                    return;
                }
            }
            
            NSMutableDictionary *mulDict = [NSMutableDictionary dictionary];
            [mulDict setObject:cell.nameTF.text forKey:@"userName"];
            [mulDict setObject:cell.phoneNumTF.text forKey:@"userPhone"];
            [mulDict setObject:@([weakSelf.activityDict[@"activityId"] integerValue]) forKey:@"activityId"];
            [mulDict setObject:cell.vertifyCodeTF.text forKey:@"code"];
            [mulDict setObject:weakSelf.companyID forKey:@"companyId"];
            
            NSMutableArray *customArray = [NSMutableArray array];
            for (int i = 0; i < self.customDefineArray.count; i ++) {
                ActivityCustomDefine *customModel = self.customDefineArray[i];
                NSMutableDictionary *customDict = [NSMutableDictionary dictionary];
                NSString *name = customModel.customName;
                UITextField *textField = (UITextField *)[cell.dynamicView viewWithTag:(10000+i)];
                [customDict setObject:name forKey:@"customName"];
                [customDict setObject:textField.text forKey:@"customValue"];

                [customArray addObject:customDict];
            }
            [mulDict setObject:customArray forKey:@"customs"];
            NSString *singJsonStr = [NSString convertToJsonData:mulDict];
            
            NSDictionary *paramDic = @{@"signJson": singJsonStr};
            YSNLog(@"%@", paramDic);

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
                    if (phoneStr.length > 6) {
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
                    for (int i = 0; i < self.customDefineArray.count; i ++) {
                        UITextField *textField = (UITextField *)[cell.dynamicView viewWithTag:(10000+i)];
                        textField.text = @"";
                    }
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
                vc.companyId = [NSString stringWithFormat:@"%ld", [self.companyDic[@"companyId"] integerValue]];
                vc.companyLandLine = self.companyDic[@"companyLandline"];
                vc.companyPhone = self.companyDic[@"companyPhone"];
                vc.companyName = self.companyName;
                vc.companyLogo = self.companyDic[@"companyLogo"];
                vc.calVipTag = [self.companyDic[@"calVip"] integerValue];
                
                vc.coverMap = self.activityDict[@"coverMap"];
                
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
            } else {
                
                //新闻活动
                NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
                vc.designsId = [self.activityDict[@"designsId"] integerValue];
                vc.activityType = 3;
                // 手机号  座机号
                vc.companyId = [NSString stringWithFormat:@"%ld", [self.companyDic[@"companyId"] integerValue]];
                vc.companyLandLine = self.companyDic[@"companyLandline"];
                vc.companyPhone = self.companyDic[@"companyPhone"];
                vc.companyName = self.companyName;
                vc.companyLogo = self.companyDic[@"companyLogo"];
                vc.origin = self.origin;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        };
        
        if (!_hasActivity) {
            cell.hidden = YES;
        }
        return cell;
        
        
    /****以上是 活动详情 的所有代码，太tm长了*//*以上是 活动详情 的所有代码，太tm长*****/
/****以上是 活动详情 的所有代码，太tm长了*///*以上是 活动详情 的所有代码，太tm长了*****/
    } else if (indexPath.section == 3) {//经典案例

        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        // 图片 5：3  左右边距 8  图片底部文字高度20 上下边距8   (kSCREEN_WIDTH - 32)/2.0 * 3/5.0 + (20 + 16)
        NSInteger imageWith = (kSCREEN_WIDTH - 32)/2.0;
        NSInteger imageHeigt = imageWith * 3/5.0;
        NSInteger margin = 8;
        NSInteger textHeigt = 20;
        NSInteger viewHeight = imageHeigt + margin * 2 + textHeigt;
        NSInteger viewWidht = margin * 2 + imageWith;
        for (int i = 0; i < self.constructionCase.count; i ++) {
            ZCHBudgetGuideConstructionCaseModel *model = self.constructionCase[i];
            
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
            
            UILabel *areaLabel = [UILabel new];
            areaLabel.font = [UIFont systemFontOfSize:12];
            areaLabel.textColor = [UIColor whiteColor];
            areaLabel.textAlignment = NSTextAlignmentCenter;
            areaLabel.text = [NSString stringWithFormat:@"%@ m²", model.ccAcreage];
            [areaLabel sizeToFit];
            CGSize titleSize = [areaLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, middleBgViewHeight) withFont:(UIFont *)textLabel.font];
            [middleBgView addSubview:areaLabel];
            [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.centerX.equalTo(0);
                make.height.equalTo(middleBgViewHeight);
                make.width.equalTo(titleSize.width);
            }];
            
            UILabel *nounLabel = [UILabel new];
            nounLabel.font = [UIFont systemFontOfSize:12];
            nounLabel.textColor = [UIColor whiteColor];
            nounLabel.text = model.ccAreaName;
            nounLabel.textAlignment = NSTextAlignmentLeft;
            [middleBgView addSubview:nounLabel];
            [nounLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(2);
                make.right.equalTo(areaLabel.mas_left).equalTo(4);
                make.top.equalTo(0);
                make.height.equalTo(middleBgViewHeight);
            }];
            
            UILabel *styleLabel = [UILabel new];
            styleLabel.font = [UIFont systemFontOfSize:12];
            styleLabel.textColor = [UIColor whiteColor];
            styleLabel.text = model.style;
            styleLabel.textAlignment = NSTextAlignmentRight;
            [middleBgView addSubview:styleLabel];
            [styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-2);
                make.left.equalTo(areaLabel.mas_right).equalTo(4);
                make.top.equalTo(0);
                make.height.equalTo(middleBgViewHeight);
            }];
        }
        
        return cell;
        
    } else if (indexPath.section == 4) {//全景视图
        
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
                    sence.companyName = weakSelf.companyName;
                    [weakSelf.navigationController pushViewController:sence animated:YES];
                }
            };
        }
        return cell;
    } else if (indexPath.section == 5) {//合作企业
        
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
    }else if (indexPath.section ==6){//算量器
       
        return [UITableViewCell new];
       
    }else if (indexPath.section ==7){//底部视图
  
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image"];
        UIImageView *imageView = [[UIImageView alloc] init];
        [cell.contentView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        if (_bottomImageURL && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_bottomImageURL]] && ![_bottomImageURL isEqualToString:@""] && self.bottomSize.height > 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_bottomImageURL] placeholderImage:nil];
        } else {
            
        }
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        return cell;
    }
    
   
    return nil;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        
    }
    if (indexPath.section == 3) {
        
        YellowGoodsListViewController *VC = [YellowGoodsListViewController new];
        VC.fromBack = NO;
        VC.shopId = self.companyID;
        VC.collectFlag = self.collectFlag;
        VC.shopid = self.companyID;
        VC.dataDic = self.companyDic;
        VC.companyName = self.companyName;
        VC.shareCompanyLogoURLStr = [self.companyDic objectForKey:@"companyLogo"];
        VC.shareDescription = [self.companyDic objectForKey:@"companyIntroduction"];
        VC.origin = self.origin;
        [self.navigationController pushViewController:VC animated:YES];
        
    }

    if (indexPath.section == 6) {
        NSString *webUrl = self.bottomImageArr[0][@"picHref"];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        return ((kSCREEN_WIDTH - 3*1) / 4) * 2 + 1;

    } else if (indexPath.section == 1) {
        //商品cell的高度
        if (self.goodListArray.count > 3) {
            
            return 300 * hightScale;
        } else if (self.goodListArray.count <= 3 && self.goodListArray.count != 0){
            
            return 150 * hightScale;
        } else {
            
            return 0;
        }
    } else if (indexPath.section == 2) {

        // 有活动
        if (_hasActivity) {
            // 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
            NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
            YellowPageActivityCell *yellowpageCell=[[NSBundle mainBundle]loadNibNamed:@"YellowPageActivityCell" owner:self options:nil].firstObject;


            if (activStateInteger == 0) {
                return(yellowpageCell.cellHeightExceptImageHeightAndNotNecessaryTFFrame +self.activityImageHeight + dynamicHeight +paoMaHeight +signUpHeight);

               
            }else if (activStateInteger==3){
                return 0.01;
            }else{
                return( yellowpageCell.cellHeightExceptImageHeightAndNotNecessaryTFFrame + self.activityImageHeight+dynamicHeight+paoMaHeight+signUpHeight);
            }
        } else {
            // 没有活动
            return 0;
        }
    } else if (indexPath.section == 3) {
        // 经典案例
        NSInteger count = 0;
        if (self.constructionCase.count % 2 == 0) {
            
            count = self.constructionCase.count / 2;
        } else {
            
            count = self.constructionCase.count / 2 + 1;
        }
        // 图片 5：3  左右边距 8  图片底部文字高度20 上下边距8   (kSCREEN_WIDTH - 32)/2.0 * 3/5.0 + (20 + 16)
        return count * ((kSCREEN_WIDTH - 32) * 0.3 + 36);
    } else if (indexPath.section == 4) {//全景视图
        
        if (self.viewList.count > 0) {
            return BLEJWidth * 0.6;
        } else {
            return 0.001;
        }
    }  else if (indexPath.section == 5) {//合作企业

        return ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1));
    } else if(indexPath.section == 6) {//底部图片
           return   0.001;
        
    }else if(indexPath.section == 7){//算量器
  
        if (_bottomImageURL && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_bottomImageURL]] && ![_bottomImageURL isEqualToString:@""] && self.bottomSize.height > 0)  {
            return self.bottomSize.height;
        } else {
            return 0;
        }
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {

        return 5;
    }
    if (section == 1 && self.goodListArray.count > 0) {
        return 60;
    }
    if (section == 2 && _hasActivity) {// 当前活动可以报名显示其他报名选项 活动状态 （0：报名中，5:结束报名，4活动中，3：结束活动）
        NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
        if (activStateInteger==3) {
            return 0.01f;
        }else{
            return 60;
        }
    }else if (section == 3 && self.constructionCase.count > 0) {
        return 60;
    }else if (section == 4 && self.viewList.count > 0) {
        return 60;
    }else if (section == 5 && self.cooperateArr.count > 0) {
        return 60;
    }else if (section == 6) {
        return 0.001;
    }else if(section ==7){
        return 10;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section ==0) {
        return 80;
    }
    if ( section ==7) {
        return 100;
    }
   
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1 && self.goodListArray.count > 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [bgView addSubview:bottomView];
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:caseLabel];
        NSString *contentStr = @"—— 商品展示 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
     
        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 6)];
        caseLabel.attributedText = str;
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 50)];
        [nextBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [nextBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(didClickMoreProduct:) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
        [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
        [bottomView addSubview:nextBtn];
        
        return bgView;
    }
    
    if (section == 2 && _hasActivity) {
        
        NSInteger activStateInteger = [self.activityDict[@"activityStatus"] integerValue];
        if (activStateInteger==3) {
            return [UIView new];
        }
        else
        {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
            bgView.backgroundColor = kBackgroundColor;
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
            bottomView.backgroundColor = White_Color;
            [bgView addSubview:bottomView];
            
            UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
            caseLabel.textAlignment = NSTextAlignmentCenter;
            caseLabel.font = [UIFont systemFontOfSize:16];
            [bottomView addSubview:caseLabel];
            NSString *contentStr = @"—— 最新活动 ——";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
          [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 6)];
            caseLabel.attributedText=str;
          
        
          
         
        
            
            UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 50)];
            [nextBtn setTitle:@"以往活动" forState:UIControlStateNormal];
            [nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [nextBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
            [nextBtn addTarget:self action:@selector(gotoActivityList) forControlEvents:UIControlEventTouchUpInside];
            [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
            [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
            [bottomView addSubview:nextBtn];
            nextBtn.hidden = !(self.acticityArray.count >1);
            
            return bgView;
        }
        return [UIView new];
      
    }
    
    if (section == 3 && self.constructionCase.count > 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [bgView addSubview:bottomView];
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:caseLabel];
        
        
        NSString *contentStr = @"—— 经典案例 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 6)];
        caseLabel.attributedText=str;
    
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 50)];
        [nextBtn setTitle:@"全部案例" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [nextBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(didClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
        [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
        [bottomView addSubview:nextBtn];
        
        return bgView;
    }
    
    if (section == 4 && self.viewList.count > 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [bgView addSubview:bottomView];
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:caseLabel];
        
        NSString *contentStr = @"—— 全景图 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 5)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(7, 2)];
        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 5)];
        caseLabel.attributedText=str;
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 50)];
        [nextBtn setTitle:@"全部图纸" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [nextBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(didClickAllView:) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
        [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
        [bottomView addSubview:nextBtn];
        
        return bgView;
    }
    
    if (section == 5 && self.cooperateArr.count > 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        caseLabel.backgroundColor = White_Color;
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:caseLabel];
        
        NSString *contentStr = @"—— 合作企业 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 6)];
        caseLabel.attributedText=str;
        
        return bgView;
    }

    if (section ==6) {

//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
//            bgView.backgroundColor = kBackgroundColor;
//
//            UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
//            Label.backgroundColor = White_Color;
//            Label.textAlignment = NSTextAlignmentCenter;
//            Label.font = [UIFont systemFontOfSize:16];
//            [bgView addSubview:Label];
//
//
//        NSString *contentStr = @"———— 算量器 ————";
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
//        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 5）];
//        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(7, 2)];
//        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(2, 5)];
//            Label.attributedText = str;
        return [[UIView alloc] init];
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section ==0) {
      //  XianHuaJinQiGuanzhuCell *CEll =[UINib nibWithNibName:@"XianHuaJinQiGuanzhuCell" bundle:nil];
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"XianHuaJinQiGuanzhuCell" owner:nil options:nil];
       XianHuaJinQiGuanzhuCell *CEll = [nibArray lastObject];
        [CEll setData:self.companyDic];


        
        return CEll;
        
    }
    if (section ==7) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];
        
        UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 0, 50)];
        [footView addSubview:scanLabel];
        scanLabel.font = [UIFont systemFontOfSize:16];
        scanLabel.textColor = [UIColor darkGrayColor];
        scanLabel.text = @"浏览量";
        [scanLabel sizeToFit];
        
        CGSize sizeCount = [displayCountnumber boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:16]];
        displayCount = [[UILabel alloc] initWithFrame:CGRectMake(scanLabel.right + 10, 0, sizeCount.width, 50)];
        [footView addSubview:displayCount];
        displayCount.textAlignment = NSTextAlignmentRight;
        displayCount.font = [UIFont systemFontOfSize:16];
        displayCount.textColor = [UIColor darkGrayColor];
        displayCount.text =displayCountnumber;
        
        scanLabel.centerY = displayCount.centerY;
        
        UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(displayCount.right, 0, 44, 44)];
        goodBtn.centerY = displayCount.centerY;
        self.supportButton = goodBtn;
        [goodBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        [goodBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateHighlighted];
        [goodBtn addTarget:self action:@selector(didClickGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:goodBtn];
        
        CGSize goodSizeCount = [goodCountnumber  boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:16]];
        goodCount = [[UILabel alloc] initWithFrame:CGRectMake(goodBtn.right, 0, goodSizeCount.width, 50)];
        self.goodCountLabel = goodCount;
        [footView addSubview:goodCount];
        goodCount.textAlignment = NSTextAlignmentRight;
        goodCount.font = [UIFont systemFontOfSize:16];
        goodCount.textColor = [UIColor darkGrayColor];
        goodCount.text = goodCountnumber;
        
        UIButton *complainBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 50, 0, 50, 50)];
        [complainBtn setTitle:@"投诉" forState:UIControlStateNormal];
        [complainBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        complainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [complainBtn addTarget:self action:@selector(didClickComplainBtn:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:complainBtn];
        return footView;
//        _mainTableView.soterView = footView;
    }
   
    return [[UIView alloc] init];
}

#pragma mark 商品展示
- (void)goodsShowWithArray:(NSMutableArray *)goodsArray bgView:(UIView *)bgView {
    
    CGFloat kWidth = kSCREEN_WIDTH/3;
    CGFloat kHeight;
    NSArray *arr = [NSArray array];
    if (goodsArray.count <= 6) {
        
        arr = goodsArray;
        kHeight = 150 * hightScale;
    } else {
        
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
        } else {
            
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


#pragma mark -  最上面的那八个按钮的跳转
- (void)didSelectDetailActionWithTag:(NSInteger)tag {
    
    switch (tag) {
        case 0:
        {
            //公司简介
            CompanyIntroductController *VC = [[CompanyIntroductController alloc]init];
            VC.companyId = self.companyID;
            VC.origin = self.origin;
            VC.companyType = self.companyDic[@"companyType"];
            VC.iscompany = YES;
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
            
            VC.calculatorModel = self.calculatorModel;
            VC.constructionCase = self.constructionCase;
            VC.companyId = self.companyID;
            VC.topCalculatorImageArr = self.topImageArr;
            VC.bottomCalculatorImageArr = self.bottomImageArr;
            VC.companyDic = self.companyDic;
            VC.code = self.code;
            VC.displayNum = self.companyDic[@"displayNumbers"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1:
        {
            //施工案例
            BuildCaseViewController *vc = [[BuildCaseViewController alloc]init];
            vc.companyId = self.companyID;
            
            vc.isCompany = YES;
            vc.isConVIP = [self.companyDic[@"conVip"] integerValue] == 0 ? NO : YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            
            localcommunityVC *vc = [localcommunityVC new];
//            vc.cityId = cityModel.cityId;
//            vc.countyId = countyModel ? countyModel.cityId : @"0";
            vc.cityId = self.cityId;
            vc.countyId = self.countyId;
           
            [self.navigationController pushViewController:vc animated:YES];
            

        }
            break;
        case 3:
        {
            
            homenewsVC *vc = [homenewsVC new];
            vc.companyId = self.companyID?:@"";
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 4:
        {
            
            // 优秀员工
            ExcellentStaffViewController *esVC = [[ExcellentStaffViewController alloc] init];
            esVC.companyId = self.companyDic[@"companyId"];
//            esVC.teamType = 1025;
            esVC.origin = self.origin;
            esVC.titleStr = @"施工团队";
            esVC.index = 7;
            esVC.isShop = NO;
            esVC.companyType = self.companyDic[@"companyType"];
            esVC.areaList = self.areaArr;
            esVC.phone = self.companyDic[@"companyLandline"];
            esVC.telPhone = self.companyDic[@"companyPhone"];
            esVC.baseItemsArr = self.baseItemsArr;
            esVC.suppleListArr = self.suppleListArr;
            esVC.areaList = self.areaArr;
            esVC.calculatorTempletModel = self.calculatorModel;;
            esVC.constructionCase = self.constructionCase;
            esVC.companyId = self.companyID;
            esVC.topCalculatorImageArr = self.topImageArr;
            esVC.bottomCalculatorImageArr = self.bottomImageArr;
            esVC.companyDic = self.companyDic;
            esVC.code = self.code;
            esVC.dispalyNum = self.companyDic[@"displayNumbers"];
            [self.navigationController pushViewController:esVC animated:YES];
        }
            break;
        case 5:
        {
            YellowGoodsListViewController *VC = [YellowGoodsListViewController new];
            VC.fromBack = NO;
            VC.shopId = self.companyID;
            VC.shopid = self.companyID;
            VC.collectFlag = self.collectFlag;
            VC.companyType = self.companyDic[@"companyType"];
            VC.areaList = self.areaArr;
            VC.phone = self.companyDic[@"companyLandline"];
            VC.telPhone = self.companyDic[@"companyPhone"];
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
            VC.topCalculatorImageArr = self.topImageArr;
            VC.bottomCalculatorImageArr = self.bottomImageArr;
            VC.companyDic = self.companyDic;
            VC.calculatorModel = self.calculatorModel;
            VC.code = self.code;
            VC.constructionCase = self.constructionCase;
            VC.companyName = self.companyName;
            VC.shareCompanyLogoURLStr = self.shareCompanyLogoURLStr;
            VC.shareDescription = self.shareDescription;
            VC.origin = self.origin;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 6:
        {
            // 全景展示
            PanoramaViewController *panorama = [[PanoramaViewController alloc]init];
            //页面跳转标记
            panorama.tag = 1000;
            panorama.shopID = self.companyID;
            panorama.companyType = self.companyDic[@"companyType"];
            panorama.dataDic = self.companyDic;
            panorama.areaList = self.areaArr;
            panorama.phone = self.companyDic[@"companyLandline"];
            panorama.telPhone = self.companyDic[@"companyPhone"];
            panorama.baseItemsArr = self.baseItemsArr;
            panorama.suppleListArr = self.suppleListArr;
            panorama.calculatorModel = self.calculatorModel;
            panorama.constructionCase = self.constructionCase;
            panorama.topCalculatorImageArr = self.topImageArr;
            panorama.bottomCalculatorImageArr = self.bottomImageArr;
            panorama.companyDic = self.companyDic;
            panorama.code = self.code;
            panorama.origin = self.origin;
            [self.navigationController pushViewController:panorama animated:YES];
        }
            break;
        case 7:
        {
            // 是否是内网状态
            if (_isInnerNetState) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"定制环境，不能查看"];
                return;
            }
            // 合作企业
            ZCHCooperateController *VC = [[ZCHCooperateController alloc] init];
            VC.companyId = self.companyID;
            VC.iscompany = YES;
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
            VC.calculatorModel = self.calculatorModel;;
            VC.constructionCase = self.constructionCase;
            VC.companyId = self.companyID;
            VC.topCalculatorImageArr = self.topImageArr;
            VC.bottomCalculatorImageArr = self.bottomImageArr;
            VC.companyDic = self.companyDic;
            VC.code = self.code;
            VC.times = self.times;
            VC.origin = self.origin;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - 计算图片按照比例显示
- (CGSize)calculateImageSizeWithSize:(CGSize)size andType:(NSInteger)type {
    
    CGSize finalSize;
    
    if (type == 1) {
        
        finalSize.width = BLEJWidth;
        finalSize.height = size.height * BLEJWidth / size.width;
    } else {
        
        if (size.width / BLEJWidth > size.height / BLEJHeight) {
            
            finalSize.width = size.width * BLEJWidth / size.width;
            finalSize.height = size.height * BLEJWidth / size.width;
        } else {
            
            finalSize.width = size.width * BLEJHeight / size.height;
            finalSize.height = size.height * BLEJHeight / size.height;
        }
    }
    return finalSize;
}


- (CGSize)getImageSizeWithURL:(id)URL {
    
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    
    if (url == nil) {
        return CGSizeMake(BLEJWidth, 0.001);
    }
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        
        return CGSizeMake(BLEJWidth, 0.001);
    }
    if (!URL) {
        return CGSizeMake(BLEJWidth, 0.001);
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    NSString *phoneModel = [self iphoneType];
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                if ([phoneModel isEqualToString:@"iPhone 5"] || [phoneModel isEqualToString:@"iPhone 4S"] || [phoneModel isEqualToString:@"iPhone 4"] || [phoneModel isEqualToString:@"iPhone 5c"]) {
                    
                    CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
                } else {
                    
                    CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
                }
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                if ([phoneModel isEqualToString:@"iPhone 5"] || [phoneModel isEqualToString:@"iPhone 4S"] || [phoneModel isEqualToString:@"iPhone 4"] || [phoneModel isEqualToString:@"iPhone 5c"]) {
                    
                    CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
                } else {
                    
                    CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
                }
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, logoView.bottom, size.width > BLEJWidth * 1 / 3 - 20 - 17 ? BLEJWidth * 1 / 3 - 20 - 17 : size.width, 20)];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.text = model.companyName;
    [btn addSubview:nameLabel];
    
    UIImageView *vipLogo = [[UIImageView alloc] initWithFrame:CGRectMake(nameLabel.right + 3, logoView.bottom + 3, 14, 14)];
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
            company.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:company animated:YES];
        } else {
            //店铺的详情;
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = model.companyName;
            shop.shopID = model.companyId;
            shop.times = @"2";
            model.browse = [NSString stringWithFormat:@"%ld", model.browse.integerValue + 1];
            shop.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shop animated:YES];
        }

    } else {
        VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
        controller.isEdit = false;
        controller.companyId = model.companyId;
        controller.origin = self.origin;
        [self.navigationController pushViewController:controller animated:true];

    }
}

#pragma mark - 跳转到详情
- (void)gotoAnliDetail:(UITapGestureRecognizer *)tapGR {
    UIView *view = tapGR.view;
    NSInteger index = view.tag;
    if ([self.companyDic[@"conVip"] integerValue] == 0) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"主人暂未开通云管理会员"];
        return;
    }
    
    ZCHBudgetGuideConstructionCaseModel *model = self.constructionCase[index];
    if (model.constructionId && ![model.constructionId isEqualToString:@""] && ![model.constructionId isEqualToString:@"0"]) {
        
        ConstructionDiaryTwoController *constructionDiaryVC = [[ConstructionDiaryTwoController alloc] init];
        constructionDiaryVC.consID = [model.constructionId integerValue];
        [self.navigationController pushViewController:constructionDiaryVC animated:YES];
    } else {
        
        [self.view showHudFailed:@"该工地已不存在..."];
    }
}

#pragma mark - 跳转经典案例页面
- (void)didClickNextBtn:(UIButton *)btn {
    
    //施工案例
    BuildCaseViewController *vc = [[BuildCaseViewController alloc]init];
    vc.companyId = self.companyID;
    vc.isCompany = YES;
    vc.isConVIP = [self.companyDic[@"conVip"] integerValue] == 0 ? NO : YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转全景展示页面
- (void)didClickAllView:(UIButton *)btn {
    
    // 全景展示
    PanoramaViewController *panorama = [[PanoramaViewController alloc]init];
    //页面跳转标记
    panorama.tag = 1000;
    panorama.shopID = self.companyID;
    panorama.companyType = self.companyDic[@"companyType"];
    panorama.dataDic = self.companyDic;
    
    panorama.areaList = self.areaArr;
    panorama.phone = self.companyDic[@"companyLandline"];
    panorama.telPhone = self.companyDic[@"companyPhone"];
    panorama.baseItemsArr = self.baseItemsArr;
    panorama.suppleListArr = self.suppleListArr;
    panorama.calculatorModel = self.calculatorModel;
    panorama.constructionCase = self.constructionCase;
    panorama.topCalculatorImageArr = self.topImageArr;
    panorama.bottomCalculatorImageArr = self.bottomImageArr;;
    panorama.companyDic = self.companyDic;
    panorama.code = self.code;
    panorama.origin = self.origin;
    [self.navigationController pushViewController:panorama animated:YES];
}

#pragma mark - 跳转商品详情页面
#pragma mark shopDetailViewDelagate
- (void)shopDetailAction:(NSInteger)tag {
    
    goodsModel *model = self.goodListArray[tag - 200];
    
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.goodsID = model.goodsId;
    vc.shopID = self.companyID;
    vc.fromBack = 0;
    vc.collectFlag = self.collectFlag;
    vc.shopid = self.companyID;
    vc.dataDic = self.companyDic;
    vc.companyType = @"1018";
    vc.origin = self.origin;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转商品列表
- (void)didClickMoreProduct:(UIButton *)btn {
    
    YellowGoodsListViewController *VC = [YellowGoodsListViewController new];
    VC.fromBack = NO;
    VC.shopId = self.companyID;
    VC.shopid = self.companyID;
    VC.collectFlag = self.collectFlag;
    VC.companyType = self.companyDic[@"companyType"];
    VC.areaList = self.areaArr;
    VC.phone = self.companyDic[@"companyLandline"];
    VC.telPhone = self.companyDic[@"companyPhone"];
    VC.baseItemsArr = self.baseItemsArr;
    VC.suppleListArr = self.suppleListArr;
    VC.topCalculatorImageArr = self.topImageArr;
    VC.bottomCalculatorImageArr = self.bottomImageArr;
    VC.companyDic = self.companyDic;
    VC.calculatorModel = self.calculatorModel;
    VC.code = self.code;
    VC.constructionCase = self.constructionCase;
    VC.companyName = self.companyName;
    VC.shareCompanyLogoURLStr = self.shareCompanyLogoURLStr;
    VC.shareDescription = self.shareDescription;
    VC.origin = self.origin;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma  mark - 以往活动列表
- (void)gotoActivityList {
    
    HistoryActivityViewController *historyVC = [[HistoryActivityViewController alloc] init];
    historyVC.dataArray = self.acticityArray;
    historyVC.companyID = self.companyID;
    historyVC.companyName = self.companyDic[@"companyName"];
    historyVC.companyLogo = self.companyDic[@"companyLogo"];
    historyVC.companyPhone = self.companyDic[@"companyPhone"];
    historyVC.companyLandLine = self.companyDic[@"companyLandline"];
    historyVC.companyCalVip = [self.companyDic[@"calVip"] integerValue];
    
    [self.navigationController pushViewController:historyVC animated:YES];
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
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已经报名过该活动"];
        } else {
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

- (void)signUpWithDict:(NSMutableDictionary *)dict completion:(void(^)(bool))signUpComopletion {
    dict = dict.mutableCopy;
//    [dict setValue:self.origin?:@"0" forKey:@"origin"];
    dict[@"origin"] = self.origin?:@"0";
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
#pragma mark 各种计算器的点击事件
-(void)shopDetailActions:(NSInteger)tag{
    switch (tag) {
        case 100:
            //涂料计算器
        {
            CoatingCalculaterController *coatingVC = [UIStoryboard storyboardWithName:@"CoatingCalculaterController" bundle:nil].instantiateInitialViewController;
      //      coatingVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:coatingVC animated:YES];
        }
            break;
        case 101:
            //地板
        {
            FloorBoardCalculaterController *floorBoardVC = [UIStoryboard storyboardWithName:@"FloorBoardCalculaterController" bundle:nil].instantiateInitialViewController;
         //   floorBoardVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:floorBoardVC animated:YES];
        }
            break;
        case 102:
            //壁纸
        {
            WallPaperCalculatorController *wallVC = [UIStoryboard storyboardWithName:@"WallPaperCalculatorController" bundle:nil].instantiateInitialViewController;
        //    wallVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:wallVC animated:YES];
        }
            break;
        case 103:
            //墙砖
        {
            WallTitleCalculaterController *wallTitleVC = [UIStoryboard storyboardWithName:@"WallTitleCalculaterController" bundle:nil].instantiateInitialViewController;
          //  wallTitleVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:wallTitleVC animated:YES];
        }
            break;
        case 104:
            //窗帘 CurtainCalculateController
        {
            CurtainCalculateController *VC = [UIStoryboard storyboardWithName:@"CurtainCalculateController" bundle:nil].instantiateInitialViewController;
         //   VC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:VC animated:YES];
        }
            
            break;
        case 105:
            //地砖计算
        {
            FloorTitleCalculaterController *VC = [UIStoryboard storyboardWithName:@"FloorTitleCalculaterController" bundle:nil].instantiateInitialViewController;
          //  VC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
    }
    
}
#pragma mark - 投诉按钮的点击事件
- (void)didClickComplainBtn:(UIButton *)btn {
    
    ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
    ComplainVC.companyID = self.companyID.integerValue;
    [self.navigationController pushViewController:ComplainVC animated:YES];
}

#pragma mark - 点赞按钮的点击事件
- (void)didClickGoodBtn:(UIButton *)btn {
    
    if (!_hasSupport) {
        _hasSupport = YES;
        
        [btn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        self.goodCountLabel.text = [NSString stringWithFormat:@"%d", [self.goodCountLabel.text intValue] + 1];
        CGSize goodSizeCount = [self.goodCountLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:16]];
        self.goodCountLabel.width = goodSizeCount.width;
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *apiStr = [BASEURL stringByAppendingString:@"company/like.do"];
        NSDictionary *param = @{
                                @"agencyId" : @(user.agencyId),
                                @"companyId" : self.companyID
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
        _allView.showPageControl = NO;
        _allView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _allView.backgroundColor = [UIColor blackColor];
        _allView.ishaveMiddleImage = YES;
        
    }
    return _allView;
}

#pragma mark - 获取手机类型
- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}




-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
}




@end
