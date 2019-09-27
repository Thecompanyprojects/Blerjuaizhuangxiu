//
//  ZCHSearchViewController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSearchViewController.h"
#import "HomeDefaultModel.h"
#import "YellowPageCompanyTableViewCell.h"
#import "YellowPageShopTableViewCell.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "ComplainViewController.h"
#import "NSObject+CompressImage.h"
#import "ZCHCityModel.h"
#import "WMSearchBar.h"
#import "LoginViewController.h"
#import "CompanyDetailNotVipController.h"
#import "VIPExperienceShowViewController.h"
extern ZCHCityModel *cityModel;
extern ZCHCityModel *countyModel;
@interface ZCHSearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, YellowPageShopTableViewCellDelegate, YellowPageCompanyTableViewCellDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UITableView *tableView;


// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 分享的遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 被分享的那个model
@property (nonatomic, strong) HomeDefaultModel *shareCollectionModel;
// 分享的公司ID
@property (nonatomic, assign) NSInteger shareCompanyID;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;

@property (nonatomic, strong) NSIndexPath *shareIndexPath;

@property (nonatomic, assign) BOOL isShopShare;  // 是店铺分享
@property (assign, nonatomic) NSInteger pageNum;

@end

@implementation ZCHSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.pageNum = 1;
    [self setUI];
    
    // 分享视图
    [self addBottomShareView];
    
    [self.searchBar becomeFirstResponder];
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
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 11.0) {

        self.definesPresentationContext = YES;

        WMSearchBar *searchBar = [[WMSearchBar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 2 * 44 - 2 * 15, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索商家品类或店铺名";
        searchBar.backgroundImage = [UIImage new];
        searchBar.backgroundColor = [UIColor clearColor];
        searchBar.userInteractionEnabled = YES;
        searchBar.tintColor = kDisabledColor;

        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 30.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);

        UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
        [wrapView addSubview:searchBar];
        self.navigationItem.titleView = wrapView;
        self.searchBar = searchBar;
    } else {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 0, 50, 44)];
        self.searchBar.placeholder = @"搜索商家品类或店铺名";
        self.searchBar.delegate = self;
        self.searchBar.userInteractionEnabled = YES;
        self.searchBar.backgroundImage = [UIImage new];
        self.searchBar.backgroundColor = [UIColor clearColor];
        self.searchBar.tintColor = kDisabledColor;
        self.navigationItem.titleView = self.searchBar;
    }
    

    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum++;
        [self getData];
    }];
}

#pragma mark - YellowPageShopTableViewCellDelegate
- (void)YellowPageShopTableViewCell:(YellowPageShopTableViewCell *)cell moreBtnClicked:(UIButton *)btn {
    self.shareCompanyID = btn.tag;
    self.isShopShare = YES;
    NSIndexPath *shareIndexP = [self.tableView indexPathForCell:cell];
    self.shareIndexPath = shareIndexP;
    self.shareCollectionModel = self.dataArr[shareIndexP.row];
    NSArray *titleArray;
    if (self.shareCollectionModel.collectionId > 0) {
        titleArray = [NSArray arrayWithObjects:@"取消收藏", @"投诉", @"分享", @"取消", nil];
    } else {
        titleArray = [NSArray arrayWithObjects:@"收藏", @"投诉", @"分享", @"取消", nil];
    }

    NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
    HomeDefaultModel *model = self.dataArr[indexP.row];

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.shareCollectionModel.collectionId > 0) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.tag = 300;
                [self.navigationController pushViewController:loginVC animated:YES];
            }else{
                [self unCollectionShopOrCompany];
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
                [self saveShopOrCompany];
            }
        }];
        [alertC addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
        ComplainVC.companyID = model.shopID.integerValue;
        [self.navigationController pushViewController:ComplainVC animated:YES];
        [self.navigationController pushViewController:ComplainVC animated:YES];
    }];
    [alertC addAction:action];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = NO;
        }];
    }];
    [alertC addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action3];
    
    [self.navigationController presentViewController:alertC animated:YES completion:nil];
    
}

#pragma mark - YellowPageCompanyTableViewCellDelegate
- (void)YellowPageCompanyTableViewCell:(YellowPageCompanyTableViewCell *)cell moreBtnClicked:(UIButton *)btn {
    self.isShopShare = NO;
    self.shareCompanyID = btn.tag;
    NSIndexPath *shareIndexP = [self.tableView indexPathForCell:cell];
    self.shareIndexPath = shareIndexP;
    self.shareCollectionModel = self.dataArr[shareIndexP.row];
    NSArray *titleArray;
    if (self.shareCollectionModel.collectionId > 0) {
        titleArray = [NSArray arrayWithObjects:@"取消收藏", @"投诉", @"分享", @"取消", nil];
    } else {
        titleArray = [NSArray arrayWithObjects:@"收藏", @"投诉", @"分享", @"取消", nil];
    }
    
    
    NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
    HomeDefaultModel *model = self.dataArr[indexP.row];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.shareCollectionModel.collectionId > 0) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.tag = 300;
                [self.navigationController pushViewController:loginVC animated:YES];
            }else{
               [self unCollectionShopOrCompany];
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
                [self saveShopOrCompany];
            }
        }];
        [alertC addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
        ComplainVC.companyID = model.shopID.integerValue;
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

#pragma mark - 收藏
- (void)saveShopOrCompany  {
    
    NSString *url = @"collection/add.do";
    NSString *requestString = [BASEURL stringByAppendingString:url];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.shareCompanyID) forKey:@"relId"]; // 店铺或公司ID
    [params setObject:@(user.agencyId) forKey:@"agencysId"]; // 用户ID
    [NetManager afGetRequest:requestString parms:params finished:^(id responseObj) {
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            self.shareCollectionModel.collectionId = [responseObj[@"collectionId"] integerValue];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏成功"];
            
        } else if([responseObj[@"code"] isEqualToString:@"1002"]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经收藏过了"];
        }else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}


- (void)unCollectionShopOrCompany {
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    NSDictionary *paramDic = @{
                               @"collectionId":@(self.shareCollectionModel.collectionId),
                               };
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                self.shareCollectionModel.collectionId = 0;
                [[PublicTool defaultTool] publicToolsHUDStr:@"已从收藏列表中移除" controller:self sleep:1.0];
            }
                break;
                
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"操作失败" controller:self sleep:1.0];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
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
    NSString *shareTitle = self.shareCollectionModel.typeName;
//    NSString *descriptionStr = [NSString stringWithFormat:@"%@\n案例%ld 设计师%ld 工长%ld 监理%ld",self.shareCollectionModel.companyLandLine, (long)self.shareCollectionModel.constructionNum, (long)self.shareCollectionModel.sjsNum, (long)self.shareCollectionModel.gzNum, (long)self.shareCollectionModel.jlNum];
    
    
    NSString *shareDescription = self.shareCollectionModel.companyIntroduction;
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
//    NSURL *shareImageUrl = [NSURL URLWithString:self.shareCollectionModel.typeLogo];
    UIImage *shareImage;
    NSData *shareData;
    
    YellowPageShopTableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
    shareImage = cell.companyLogo.image;
    
    if (shareImage == nil) {
        YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
        shareImage = cell.companyLogo.image;
    }
    
    NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
    if (data.length > 32) {
        UIGraphicsBeginImageContext(CGSizeMake(300, 300));
        [shareImage drawInRect:CGRectMake(0,0,300,300)];
        shareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat scale = 32.0 / data.length;
        shareData  = UIImageJPEGRepresentation(shareImage, scale);
        
    }
    
    NSString *shareURL;
    if (self.isShopShare) {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%ld.htm", self.shareCompanyID]];
    } else {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", self.shareCompanyID]];
    }
    
    [self addTwoDimensionCodeView];
    
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
//            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", self.shareCompanyID]];
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                if (self.isShopShare) {
                    [MobClick event:@"ShopListShare"];
                } else {
                    [MobClick event:@"CompanyListShare"];
                }
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
            //            NSString *shareURL = WebPageUrl;
//            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", self.shareCompanyID]];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                if (self.isShopShare) {
                    [MobClick event:@"ShopListShare"];
                } else {
                    [MobClick event:@"CompanyListShare"];
                }
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
                
//                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", self.shareCompanyID]];
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    if (self.isShopShare) {
                        [MobClick event:@"ShopListShare"];
                    } else {
                        [MobClick event:@"CompanyListShare"];
                    }
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
                
//                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", self.shareCompanyID]];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    if (self.isShopShare) {
                        [MobClick event:@"ShopListShare"];
                    } else {
                        [MobClick event:@"CompanyListShare"];
                    }
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
            if (self.isShopShare) {
                [MobClick event:@"ShopListShare"];
            } else {
                [MobClick event:@"CompanyListShare"];
            }
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
    
    [NSObject companyShareStatisticsWithConpanyId:[NSString stringWithFormat:@"%ld", self.shareCompanyID]];
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {
    
    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    [self.view sendSubviewToBack:self.tableView];
    self.TwoDimensionCodeView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.TwoDimensionCodeView.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [self.TwoDimensionCodeView addSubview:codeView];
    
    NSString *shareURL;
    if (self.isShopShare) {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%ld.htm", (long)self.shareCompanyID]];
    } else {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", (long)self.shareCompanyID]];
    }

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *shareImage;
        YellowPageShopTableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
        shareImage = cell.companyLogo.image;
        shareImage = [UIImage imageWithData:[NSObject imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
        if (shareImage == nil) {
            YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
            shareImage = cell.companyLogo.image;
            shareImage = [UIImage imageWithData:[NSObject imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
        }

        codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hiddleHud];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];
            //[SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.3];
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
    NSString *companyName;
    YellowPageShopTableViewCell * shopCell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
    companyName = shopCell.companyNameLabel.text;
    if (companyName == nil) {
        YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
        companyName = cell.companyNameLabel.text;
    }
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




#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    HomeDefaultModel *model = self.dataArr[indexPath.row];
    model.address = model.locationStr;
//    model.address = globalCityName;
//    if ([model.commodityType isEqualToString:@"1"]) {

        cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageCompanyTableViewCell class]) owner:self options:nil] lastObject];
        }
        ((YellowPageCompanyTableViewCell*)cell).cellType = YellowPageCompanyTableViewCellTypeDefault;
        ((YellowPageCompanyTableViewCell*)cell).model = model;
        ((YellowPageCompanyTableViewCell*)cell).delegate = self;
        return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeDefaultModel *model = [self.dataArr objectAtIndex:indexPath.row];
    if ([model.vipState isEqualToString:@"1"]) {
        
        if ([model.companyType isEqualToString:@"1018"]||[model.companyType isEqualToString:@"1064"]||[model.companyType isEqualToString:@"1065"]) {
            CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
            company.companyName = model.typeName;
            company.companyID = model.shopID;
            company.origin = self.origin;
            company.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:company animated:YES];
        } else {
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = model.typeName;
            shop.shopID = model.shopID;
            shop.origin = self.origin;
            shop.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shop animated:YES];
        }
    } else {
        VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
        controller.isEdit = false;
        controller.companyId = model.shopID?:model.id;
        controller.origin = self.origin;
        [self.navigationController pushViewController:controller animated:true];
    }
}

- (void)getData {
    
    NSString *agencyId;
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        
        agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    } else {
        
        agencyId = @"0";
    }
    
    NSString *api = [BASEURLWX stringByAppendingString:@"company/getCompanyByMap.do"];

    self.parameters[@"type"] = @(0);
    self.parameters[@"pageSize"] = @(50);
    self.parameters[@"page"] = @(self.pageNum);
    self.parameters[@"serchContent"] = self.searchBar.text;
     CLLocationDegrees tempLongitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLongitude"] doubleValue];
    CLLocationDegrees tempLatitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLatitude"] doubleValue];
    self.parameters[@"longitude"] = @(tempLongitude);
    self.parameters[@"latitude"] = @(tempLatitude);
    [NetManager afPostRequest:api parms:self.parameters finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            if (self.pageNum == 1) {
                [self.tableView.mj_header endRefreshing];
                [self.dataArr removeAllObjects];
                self.dataArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[HomeDefaultModel class] json:responseObj[@"data"][@"commodityList"]]];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HomeDefaultModel class] json:responseObj[@"data"][@"commodityList"]]];
            }
            
            if (self.dataArr.count == 0 && self.searchBar.text && ![self.searchBar.text isEqualToString:@""]) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"未搜到相关信息"];
            }
        }
        if (responseObj && [responseObj[@"code"] integerValue] == 1001 && self.searchBar.text && ![self.searchBar.text isEqualToString:@""]) {
            
            [self.dataArr removeAllObjects];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"未搜到相关信息"];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    self.pageNum = 1;
    [self getData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
