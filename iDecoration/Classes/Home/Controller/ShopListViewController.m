//
//  ShopListViewController.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopListViewController.h"
#import "NetManager.h"
#import "ShopListModel.h"
#import "HomeDefaultModel.h"
#import "YellowPageShopTableViewCell.h"
#import "ShopListADCell.h"
#import "ShopDetailViewController.h"
#import "ComplainViewController.h"
#import "LoginViewController.h"
#import "NSObject+CompressImage.h"
#import "ZCHBottomLocationPickerView.h"
#import "ZCHCityModel.h"
#import "ZCHNewLocationController.h"
#import "ZCHRightImageBtn.h"
#import "AdvertisementWebViewController.h"
#import "CollectionCompanyTool.h"
#import "CompanyDetailViewController.h"
#import "CompanyDetailNotVipController.h"
#import "VIPExperienceShowViewController.h"

#import "YellowPageCompanyTableViewCell.h"
@interface ShopListViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, YellowPageShopTableViewCellDelegate,YellowPageCompanyTableViewCellDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource> {
    
    UITableView *_mainTableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_adArray;
}

@property (nonatomic, strong) UITextField *searchTF;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) ZCHBottomLocationPickerView *locationView;
@property (strong, nonatomic) NSDictionary *selectedDic;
@property (strong, nonatomic) ZCHRightImageBtn *locationBtn;
@property (nonatomic, assign) NSInteger shopIdOrCompanyId;

@property (nonatomic, strong) ShopListModel *shareModel;
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 分享的遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 是否是定制会员
@property (nonatomic, assign) BOOL isVIP;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
@property(assign,nonatomic) NSInteger pageNum;
@property (nonatomic, strong) NSIndexPath *shareIndexpath;

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = self.titleStr;
    self.view.backgroundColor = kBackgroundColor;
    _dataArray = [NSMutableArray array];
    _adArray = [NSMutableArray array];
    [self setUI];
   [self dataRequest];
//  _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.pageNum = 1;
//        [self getDefaultData];
//    }];
//  _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageNum += 1;
//        [self getDefaultData];
//    }];
//    [_mainTableView. mj_header beginRefreshing];
   //  分享视图
    [self addBottomShareView];
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

- (void)setUI {
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom + 11, kSCREEN_WIDTH-20, 36)];
    self.searchTF.delegate = self;
    self.searchTF.backgroundColor = White_Color;
    self.searchTF.layer.borderColor = Bottom_Color.CGColor;
    self.searchTF.layer.cornerRadius = 5;
    self.searchTF.layer.borderWidth = 1;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = @"请输入店铺名称";
    
    [self.view addSubview:self.searchTF];
    
    [[PublicTool defaultTool] publicToolsAddLeftViewWithTextField:self.searchTF];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.searchTF.mas_top).offset(5);
        make.left.equalTo(self.searchTF.mas_right).offset(-27);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchTF.bottom + 9, kSCREEN_WIDTH, kSCREEN_HEIGHT-(self.searchTF.bottom + 9)) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.emptyDataSetSource = self;
    _mainTableView.emptyDataSetDelegate = self;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    [self.view addSubview:_mainTableView];
    
    self.locationBtn = [[ZCHRightImageBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (IPhone4) {
        self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    } else if (IPhone5) {
        self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    [self.locationBtn setTitle:self.cityModel ?self.cityModel.name : @"北京" forState:UIControlStateNormal];
    [self.locationBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
    self.navigationItem.rightBarButtonItem = rightbarItem;
}

#pragma mark - 请求数据

- (void)getDefaultData{
    
    
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        
        agencyid = 0;
    }
    
    NSString *api = [BASEURLWX stringByAppendingString:@"company/getCompanyByMap.do"];
    
//  @"type"  0:距离,-1好评,-2信用,2浏览,1:案例,5:商品
    
    NSDictionary *paramDic = @{
                               @"longitude" : self.longititude?:@(116.32),
                               @"latitude" : self.latitude?:@(39.00),
                               @"serchContent" : self.searchTF.text,
                               
                               @"provinceId" : self.cityModel.pid?:@"",
                               @"cityId" : self.cityModel.cityId?:@"110000",
                               @"countyId" :  self.cityModel.countyId ?: @"0",
                               @"needLocation" : [NSNumber numberWithInt:1],
                               @"page": [NSNumber numberWithInteger:self.pageNum]?:[NSNumber numberWithInt:1],
                               @"merchantType" : @(self.type)?:@"",
                               @"pageSize" : [NSNumber numberWithInt:30],
                               @"type":[NSNumber numberWithInt:0]
                               };
    
    
    [NetManager afPostRequest:api parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            
            NSMutableArray *systemArray = [NSMutableArray new];
            systemArray = responseObj[@"data"][@"systemNews"];
            //  [self setsystemlabarr:systemArray];
            
            if (responseObj[@"data"][@"commodityList"]) {
                
                if (self.pageNum == 1) {
                    [_dataArray removeAllObjects];
                    
                    
                    self.cityModel = [ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"city"]];
                    
                    [self.locationBtn setTitle:self.cityModel.name forState:UIControlStateNormal];
                    _dataArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[HomeDefaultModel class] json:responseObj[@"data"][@"commodityList"]]];
                    _adArray = [NSMutableArray arrayWithArray:responseObj[@"data"][@"carouselImg"]];
                    
                }else {// pageNum !=1
                    [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HomeDefaultModel class] json:responseObj[@"data"][@"commodityList"]]];
                }
                
                if ([responseObj[@"data"][@"commodityList"] count] < 30) {
                    _mainTableView. mj_footer.state = MJRefreshStateNoMoreData;
                }
            }
            
            [ _mainTableView.mj_header endRefreshing];
            [ _mainTableView.mj_footer endRefreshing];
            [ _mainTableView reloadData];
            
        } else {//和[responseObj[@"code"]对应
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {//和请求数据NetManager afPostRequest:对应
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
        [[PublicTool defaultTool] publicToolsHUDStr:errorMsg controller:self sleep:1.5];;
    }];
}
- (void) dataRequest{
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *requestStr = [BASEURL stringByAppendingString:@"company/getCompanyByType.do"];
    NSDictionary *para = @{
                           @"longitude" : self.longititude,
                           @"latitude" : self.latitude,
                           @"merchantType" : @(self.type),
                           @"serachContent" : self.searchTF.text,
                           @"provinceId" : self.cityModel.pid?:@"",
                           @"cityId" : self.cityModel.cityId?:@"110000",
                           @"countyId" : self.countyModel ? self.countyModel.cityId : @"0"
                           //    @"needLocation" : @"0",
                            //   @"currentPerson" : @(agencyid),
                         
                           };
    
    [NetManager afPostRequest:requestStr parms:para finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [_dataArray removeAllObjects];
            [_adArray removeAllObjects];
            _dataArray  = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[HomeDefaultModel class] json:responseObj[@"data"][@"merchantList"]];
         //   _adArray = [NSMutableArray arrayWithArray:responseObj[@"data"][@"carouseImgSortList"]];
            if (_dataArray.count == 0 && _adArray.count == 0) {
//                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"暂时没有数据"];
            }
        }
   //  [self formatData];
         [_mainTableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 搜索按钮点击事件
- (void)searchClick:(UIButton *)sender{
    
    [self textFieldShouldReturn:self.searchTF];
}

#pragma mark - YellowPageShopTableViewCellDelegate
- (void)YellowPageShopTableViewCell:(YellowPageShopTableViewCell *)cell moreBtnClicked:(UIButton *)btn {
    
    NSIndexPath *shareIndexP = [_mainTableView indexPathForCell:cell];
    self.shareIndexpath = shareIndexP;
    self.shareModel = _dataArray[shareIndexP.row];
    NSArray *titleArray;
    if (self.shareModel.collectionId > 0) {
        titleArray = [NSArray arrayWithObjects:@"取消收藏", @"投诉", @"分享", @"取消", nil];
    } else {
        titleArray = [NSArray arrayWithObjects:@"收藏", @"投诉", @"分享", @"取消", nil];
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.shareModel.collectionId > 0) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.tag = 300;
                [self.navigationController pushViewController:loginVC animated:YES];
            }else{
                [CollectionCompanyTool unCollectionShopOrCompanyWithCollectionID:self.shareModel.collectionId completion:^(NSInteger collectionId, BOOL isSuccess) {
                    if (isSuccess) {
                        self.shareModel.collectionId = 0;
                    }
                }];
            }
        }];
        [alertC addAction:action];
    } else {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.tag = 300;
                [self.navigationController pushViewController:loginVC animated:YES];
            }else{
                [CollectionCompanyTool saveShopOrCompanyWithCompanyID:btn.tag completion:^(NSInteger collectionId, BOOL isSuccess) {
                    if (isSuccess) {
                        self.shareModel.collectionId = collectionId;
                    }
                }];
            }
        }];
        [alertC addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
        ComplainVC.companyID = btn.tag;
        [self.navigationController pushViewController:ComplainVC animated:YES];
    }];
    [alertC addAction:action];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
            self.shadowView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }];
    [alertC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertC addAction:action3];
    
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
    

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
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"二维码"];
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
    //    分享的描述之前是从上一页面传来的
    //    NSString *shareTitle = self.companyName;
    //    NSString *shareDescription = self.shareDescription;
    //    NSURL *shareImageUrl = [NSURL URLWithString:self.shareCompanyLogoURLStr];
    
    NSString *shareTitle = self.shareModel.merchantName;
    NSString *shareDescription = self.shareModel.companyIntroduction;
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    
    UIImage *shareImage;
    NSData *shareData;
    
    
    YellowPageShopTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:self.shareIndexpath];
    shareImage = cell.companyLogo.image;
    
    NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
    if (data.length > 32) {
        UIGraphicsBeginImageContext(CGSizeMake(300, 300));
        [shareImage drawInRect:CGRectMake(0,0,300,300)];
        shareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat scale = 32.0 / data.length;
        shareData  = UIImageJPEGRepresentation(shareImage, scale);
        
    }
    
    [self addTwoDimensionCodeView];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%@.htm", self.shareModel.merchantId]];
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
//            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%@.htm", self.shareModel.merchantId]];
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopListShare"];
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
            //            [message setThumbImage:[UIImage imageNamed:@"top_default"]];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
//            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.shareModel.merchantId]];
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopListShare"];
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
                //从contentObj中传入数据，生成一个QQReq
                //                NSString *shareURL = WebPageUrl;
                //                NSString *shareURL = @"https://www.baidu.com";
                
//                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.shareModel.merchantId]];
                NSURL *url = [NSURL URLWithString:shareURL];
                // title = 分享标题
                // description = 施工单位 小区名称
                
                
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopListShare"];
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
                
//                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.shareModel.merchantId]];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopListShare"];
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
            [MobClick event:@"ShopListShare"];
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
    [NSObject companyShareStatisticsWithConpanyId:self.shareModel.merchantId];
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
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%@.htm", self.shareModel.merchantId]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        UIImage *shareImage;
        YellowPageShopTableViewCell * cell = [_mainTableView cellForRowAtIndexPath:self.shareIndexpath];
        shareImage = cell.companyLogo.image;
        shareImage = [UIImage imageWithData:[NSObject imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
        
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
    titleLabel.text = @"名片";
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
    YellowPageShopTableViewCell * cell = [_mainTableView cellForRowAtIndexPath:self.shareIndexpath];
    NSString *companyName = cell.companyNameLabel.text;
    companyNameLabel.text = companyName;
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

#pragma mark - UITextFieldDelegate
// 输入搜索内容之后进行页面的刷新
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self getDefaultData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    if (self.locationView.hidden == NO) {
        
        self.locationView.hidden = YES;
    }
}




- (void)formatData {
    
    if (_dataArray.count <= 4) {
        
        [_dataArray addObjectsFromArray:_adArray];
    } else {
        
        NSInteger adCount = _dataArray.count / 4;
        
        if (_adArray.count <= adCount) {
            for (int i = 0; i < _adArray.count; i ++) {
                
                [_dataArray insertObject:_adArray[i] atIndex:4 * (i + 1) + i];
            }
        }
        
        if (_adArray.count > adCount) {
            for (int i = 0; i < adCount; i ++) {
                
                [_dataArray insertObject:_adArray[i] atIndex:4 * (i + 1) + i];
                if (i == adCount - 1) {
                    [_dataArray addObjectsFromArray:[_adArray subarrayWithRange:NSMakeRange(i + 1, _adArray.count - i - 1)]];
                }
            }
        }
    }
    
    [_mainTableView reloadData];
}

- (void)selectCity {
    
    [self.searchTF resignFirstResponder];
    ZCHNewLocationController *locationVC = [[ZCHNewLocationController alloc] init];
    __weak typeof(self) weakSelf = self;
    locationVC.refreshBlock = ^(NSDictionary *modelDic) {
        self.pageNum = 1;
        
        [weakSelf.locationBtn setTitle:[modelDic objectForKey:@"name"]?:@"" forState:UIControlStateNormal];
        [weakSelf getDefaultData];
    };
    
    [self.navigationController pushViewController:locationVC animated:YES];
}

#pragma  mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    id model = _dataArray[indexPath.row];
//    if ([model isKindOfClass:[ShopListModel class]]) {
//
//        YellowPageShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageShopTableViewCell class]) owner:self options:nil] lastObject];
//        }
//        ((YellowPageShopTableViewCell *)cell).shopListModel = model;
//        cell.delegate = self;
    
        
        id model = _dataArray[indexPath.row];
        if ([model isKindOfClass:[HomeDefaultModel class]]) {

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageCompanyTableViewCell class]) owner:self options:nil] lastObject];
            }
            ((YellowPageCompanyTableViewCell *)cell).cellType = YellowPageCompanyTableViewCellTypeDistance;
            ((YellowPageCompanyTableViewCell *)cell).model = model;
            ((YellowPageCompanyTableViewCell *)cell).delegate = self;
          return cell;
   
    } else {
        
        ShopListADCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ad"];
        if (!cell) {
            cell = [[ShopListADCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ad"];
        }
        NSMutableArray *imageArr = [NSMutableArray array];
        NSMutableArray *hrefArray = [NSMutableArray array];
        for (int i = 0; i < ((NSArray *)model).count; i ++) {
            
            [imageArr addObject:[model[i] objectForKey:@"picUrl"]];
            [hrefArray addObject:[model[i] objectForKey:@"picHref"]];
        }
        
        cell.adImage.imageURLStringsGroup = imageArr;
        cell.hrefArray = hrefArray;
        MJWeakSelf;
        cell.gotoAdWebBlock = ^(NSString *hrfString) {
            AdvertisementWebViewController *adWebViewVC = [[AdvertisementWebViewController alloc] init];
            adWebViewVC.webUrl = hrfString;
            [weakSelf.navigationController pushViewController:adWebViewVC animated:YES];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id model = _dataArray[indexPath.row];
    if ([model isKindOfClass:[HomeDefaultModel class]] && ![((HomeDefaultModel *)model).vipState isEqualToString:@"0"]) {
        
        if (self.locationView.hidden == NO) {
            
            self.locationView.hidden = YES;
        }
        [self.searchTF endEditing:YES];
        YellowPageCompanyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.type == 201 || self.type == 202) {
            // 公司类型的
//            CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
//            company.companyName = ((ShopListModel *)model).merchantName;
//            company.companyID = ((ShopListModel *)model).merchantId;
//            company.hidesBottomBarWhenPushed = YES;
//            company.origin = self.origin;
//            [self.navigationController pushViewController:company animated:YES];
        } else {
            // 店铺类型的
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = ((HomeDefaultModel *)model).merchantName;
            shop.shopID = ((HomeDefaultModel *)model).merchantId;
            shop.hidesBottomBarWhenPushed = YES;
            shop.shopLogo = cell.companyLogo.image;
            shop.origin = self.origin;
            [self.navigationController pushViewController:shop animated:YES];
        }
        
    }else{
        // 非会员企业
        HomeDefaultModel *kModel = [HomeDefaultModel new];
     //   kModel = ((ShopListModel *)model);
        if (kModel.noVipDesignId.integerValue > 0) {
            // 非会员有美文
            CompanyDetailNotVipController *notViewVC = [CompanyDetailNotVipController new];
            notViewVC.companyID = kModel.merchantId;
            notViewVC.companyName = kModel.typeName;
            notViewVC.designsId = kModel.noVipDesignId;
            notViewVC.isCompany = self.type == 201 || self.type == 202;
            [self.navigationController pushViewController:notViewVC animated:YES];
            //公司的详情
            if (self.type == 201 || self.type == 202) {
                CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
                company.companyName = kModel.typeName;
                company.companyID = kModel.merchantId;
                kModel.browse = [NSString stringWithFormat:@"%ld", kModel.browse.integerValue + 1];
                kModel.displayNumbers = [NSString stringWithFormat:@"%ld", kModel.displayNumbers.integerValue + 1];
                company.notVipButHaveArticle = YES;
                company.designsId = kModel.noVipDesignId;
                company.hidesBottomBarWhenPushed = YES;
                company.origin = self.origin;
                [self.navigationController pushViewController:company animated:YES];
            }else{
                //店铺的详情;
                ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
                shop.shopName = kModel.typeName;
                shop.shopID = kModel.merchantId;
                kModel.browse = [NSString stringWithFormat:@"%ld", kModel.browse.integerValue + 1];
                kModel.displayNumbers = [NSString stringWithFormat:@"%ld", kModel.displayNumbers.integerValue + 1];
                shop.notVipButHaveArticle = YES;
                shop.designsId = kModel.noVipDesignId;
                shop.hidesBottomBarWhenPushed = YES;
                shop.origin = self.origin;
                [self.navigationController pushViewController:shop animated:YES];
            }
        } else {
            VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
            controller.isEdit = false;
            controller.companyId = kModel.merchantId;
            controller.origin = self.origin;
            [self.navigationController pushViewController:controller animated:true];
            return;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id model = _dataArray[indexPath.row];
    if ([model isKindOfClass:[HomeDefaultModel class]]) {
        
        return 100;
    }else{
        
        return kSCREEN_WIDTH * 0.6;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.locationView.hidden == NO) {
        
        self.locationView.hidden = YES;
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"未找到相关信息";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];
}

@end
