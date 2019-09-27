//
//  CollectionViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/8/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//  companyType  1018公司  非1018  店铺

#import "CollectionViewController.h"
#import "YellowPageShopTableViewCell.h"
#import "YellowPageCompanyTableViewCell.h"
#import "ShopDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "ComplainViewController.h"
#import "NSObject+CompressImage.h"

#import "companycollectionVC.h"
#import "shopcollectionVC.h"
#import "goodscollectionVC.h"
#import "sitecollectionVC.h"
#import "notescollectionVC.h"
#import "cardcollectionVC.h"
#import <ICPagingManager/ICPagingManager.h>

@interface CollectionViewController ()<UITableViewDelegate, UITableViewDataSource, YellowPageShopTableViewCellDelegate, YellowPageCompanyTableViewCellDelegate,ICPagingManagerProtocol>

@property (nonatomic, strong) UITableView *tableView;
// 列表数组
@property (nonatomic, strong) NSMutableArray *listArray;


// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 分享的遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 被分享的那个model
@property (nonatomic, strong) CollectionModel *shareCollectionModel;
// 分享的公司ID
@property (nonatomic, assign) NSInteger shareCompanyID;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;

// 被分享的IndexPath
@property (nonatomic, strong) NSIndexPath *shareIndexPath;

@property (nonatomic, assign) BOOL isShopShare; // 是否是店铺分享

@property (nonatomic,strong) ICPagingManager *manager;
@end

@implementation CollectionViewController
#pragma LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self createUI];
//    [self tableView];
//    [self getData];
//
//    // 分享视图
//    [self addBottomShareView];
    self.title = @"我的收藏";
    
    self.manager = [ICPagingManager manager];
    self.manager.delegate = self;
    [self.manager loadPagingWithConfig:^(ICSegmentBarConfig *config)
     {
         config.nor_color([UIColor darkGrayColor]);
         config.sel_color([UIColor blackColor]);
         config.line_color(Main_Color);
         config.backgroundColor = [UIColor clearColor];
     }];
}


- (ICPagingComponentBarStyle)style
{
    return ICPagingComponentStyleNormal;
}

/**
 
 控制器集合
 @return 控制器集合
 */
- (NSArray<UIViewController *> *)pagingControllerComponentChildViewControllers
{
    NSArray *array = [NSArray new];

    array = @[[companycollectionVC new],
              [shopcollectionVC new],
              [goodscollectionVC new],
              [sitecollectionVC new],
              [notescollectionVC new],
              [cardcollectionVC new]
                  ];

    
    return array;
}

/**
 选项卡标题
 
 @return @[]
 */
- (NSArray<NSString *> *)pagingControllerComponentSegmentTitles
{
    
        return @[@"公司",
                 @"店铺",
                 @"商品",
                 @"工地",
                 @"美文",
                 @"名片"];

}

/**
 选项卡位置 适配iPhone X 则减去88
 
 @return rect
 */
- (CGRect)pagingControllerComponentSegmentFrame
{
    return CGRectMake(0, kNaviBottom, self.view.bounds.size.width, 44);
}

/**
 选项卡位置 中间控制器view 高度
 
 @return CGFloat
 */
- (CGFloat)pagingControllerComponentContainerViewHeight
{
    return self.view.bounds.size.height - kNaviBottom;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NormalMethod

-(void)createUI{
    
    self.title = @"我的收藏";
}

// 获取数据列表
- (void)getData {
    self.listArray = [NSMutableArray array];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"collection/getList.do"];
    
    NSDictionary *paramDic = @{
                               @"agencysId":@(agencyid),
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(NSDictionary *responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSDictionary *dataDict = [responseObj objectForKey:@"data"];
            NSArray *listArray = [dataDict objectForKey:@"list"];
            [self.listArray removeAllObjects];
            [self.listArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CollectionModel class] json:listArray]];
            
            [self.tableView reloadData];
        } else if(code == 1002) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您还没有收藏"];
        } else if(code == 1001) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"用户Id出错"];
        } else {
            
        }
        
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        
        //加载失败
    }];
}

- (void)deleteCalculateByModel:(CollectionModel *)model indexPath:(NSIndexPath *)indexPath {
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    NSDictionary *paramDic = @{
                               @"collectionId":@(model.collectionId),
                               };
    YSNLog(@"------%@", paramDic);
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已从收藏列表中删除" controller:self sleep:1.0];
                [self.listArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
                break;
                
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.0];
                [self.tableView setEditing:NO animated:YES];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - YellowPageShopTableViewCellDelegate
- (void)YellowPageShopTableViewCell:(YellowPageShopTableViewCell *)cell moreBtnClicked:(UIButton *)btn {
    self.isShopShare = YES;
    self.shareCompanyID = btn.tag;
    NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
    self.shareIndexPath = indexP;
    CollectionModel *model = self.listArray[indexP.row];
    
    
    MJWeakSelf;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YSNLog(@"取消收藏");
        [weakSelf deleteCalculateByModel:model indexPath:indexP];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YSNLog(@"投诉");
        ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
        ComplainVC.companyID = model.companyId;
        [weakSelf.navigationController pushViewController:ComplainVC animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *shareIndexP = [weakSelf.tableView indexPathForCell:cell];
        
        weakSelf.shareCollectionModel = weakSelf.listArray[shareIndexP.row];
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
            weakSelf.shadowView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [alertC addAction:action4];
    [self presentViewController:alertC animated:YES completion:nil];

}

#pragma mark - YellowPageCompanyTableViewCellDelegate
- (void)YellowPageCompanyTableViewCell:(YellowPageCompanyTableViewCell *)cell moreBtnClicked:(UIButton *)btn {
    self.isShopShare = NO;
    self.shareCompanyID = btn.tag;
    NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
    self.shareIndexPath = indexP;
    CollectionModel *model = self.listArray[indexP.row];
    
    
    MJWeakSelf;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YSNLog(@"取消收藏");
        [weakSelf deleteCalculateByModel:model indexPath:indexP];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YSNLog(@"投诉");
        ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
        ComplainVC.companyID = model.companyId;
        [weakSelf.navigationController pushViewController:ComplainVC animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *shareIndexP = [weakSelf.tableView indexPathForCell:cell];
        weakSelf.shareCollectionModel = weakSelf.listArray[shareIndexP.row];
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
            weakSelf.shadowView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
        
        

    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [alertC addAction:action4];
    [self presentViewController:alertC animated:YES completion:nil];
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
    NSString *shareTitle = self.shareCollectionModel.companyName;
//    NSString *descriptionStr = [NSString stringWithFormat:@"%@\n案例%ld 设计师%ld 工长%ld 监理%ld",self.shareCollectionModel.companyLandLine, (long)self.shareCollectionModel.constructionNum, (long)self.shareCollectionModel.sjsNum, (long)self.shareCollectionModel.gzNum, (long)self.shareCollectionModel.jlNum];
    
    NSString *descriptionStr = self.shareCollectionModel.companyIntroduction;
    NSString *shareDescription = descriptionStr;
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
//    NSURL *shareImageUrl = [NSURL URLWithString:self.shareCollectionModel.companyLogo];
    
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
    

    [self addTwoDimensionCodeView];
    
    
    NSString *shareURL;
    if (self.isShopShare) {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%ld.htm", (long)self.shareCompanyID]];
    } else {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", (long)self.shareCompanyID]];
    }
    
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
//            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", (long)self.shareCompanyID]];
            
            
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
//            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", (long)self.shareCompanyID]];
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

                
//                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", (long)self.shareCompanyID]];
                
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
//                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", (long)self.shareCompanyID]];
                YSNLog(@"%@", shareURL);
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
    [[UIApplication sharedApplication].keyWindow hiddleHud];
    [NSObject contructionShareStatisticsWithConstructionId:[NSString stringWithFormat:@"%ld", self.shareCompanyID]];
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

    YSNLog(@"%@", shareURL);
 
    UIImage *shareImage; // 分享二维码中间的图片
    NSString *companyName; // 公司名称
    YellowPageShopTableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
    shareImage = cell.companyLogo.image;
    shareImage = [UIImage imageWithData:[NSObject imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
    companyName = cell.companyNameLabel.text;
    
    if (shareImage == nil) {
        YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
        shareImage = cell.companyLogo.image;
        shareImage = [UIImage imageWithData:[NSObject imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
    }
    if (companyName == nil) {
        YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.shareIndexPath];
        companyName = cell.companyNameLabel.text;
    }
    
    codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];
    
    
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


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CollectionModel *model = self.listArray[indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
    
    if (model.companyType == 1018 || model.companyType == 1064 ||model.companyType == 1065) { // 公司
        YellowPageCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YellowPageCompanyTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageCompanyTableViewCell class]) owner:self options:nil] lastObject];
        }
        ((YellowPageCompanyTableViewCell *)cell).collecitonModel = model;
        ((YellowPageCompanyTableViewCell *)cell).delegate = self;
        return cell;
    } else { // 店铺
        YellowPageShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YellowPageShopTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageShopTableViewCell class]) owner:self options:nil] lastObject];
        }
        ((YellowPageShopTableViewCell*)cell).collectionModel = model;
        ((YellowPageShopTableViewCell*)cell).delegate = self;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollectionModel *model = self.listArray[indexPath.row];
    if (model.companyType == 1018 || model.companyType == 1064 ||model.companyType == 1065) { // 跳转到公司
        YellowPageCompanyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailButton.hidden) {
            return;
        }
        CompanyDetailViewController *vc = [[CompanyDetailViewController alloc] init];
        vc.companyID = [NSString stringWithFormat:@"%ld", (long)model.companyId];
        vc.companyName = model.companyName;
        vc.companyLogo = cell.companyLogo.image;

        [self.navigationController pushViewController:vc animated:YES];
        
    } else { // 跳转到店铺
        YellowPageShopTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailButton.hidden) {
            return;
        }
        ShopDetailViewController *vc = [[ShopDetailViewController alloc] init];
        vc.shopID = [NSString stringWithFormat:@"%ld", (long)model.companyId];
        vc.shopName = model.companyName;
        vc.shopLogo = cell.companyLogo.image;
        vc.origin = @"0";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//是否允许编辑，默认值是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消收藏
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        CollectionModel *model = self.listArray[indexPath.row];

        [self deleteCalculateByModel:model indexPath:indexPath];
        
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}



#pragma LazyMethod
-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        _tableView.tableFooterView = [UIView new];

    }
    return _tableView;
}
@end
