
//
//  ZCHGoodsDetailViewController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHGoodsDetailViewController.h"
#import "ZCHGoodsHeaderView.h"
#import "ZCHGoodsDetailModel.h"
#import "ZCHGoodsDetailCell.h"
#include <CoreGraphics/CoreGraphics.h>
#include <ImageIO/ImageIOBase.h>
#import <ImageIO/ImageIO.h>
#import <sys/utsname.h>
#import "EditShopDetailVC.h"
#import "GoodsShareQRCodeView.h"

static NSString *reuseIdentifier = @"ZCHGoodsDetailCell";
@interface ZCHGoodsDetailViewController ()<UITableViewDelegate, UITableViewDataSource, ZCHGoodsDetailCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
// 展示图片文案的数组
@property (strong, nonatomic) NSMutableArray *dataArr;
// 保存cell行高的数组
@property (strong, nonatomic) NSMutableArray *cellHeight;
// 保存cell行高的数组
@property (strong, nonatomic) NSMutableArray *imageHeight;

@property (strong, nonatomic) NSMutableDictionary *topDic;

@property (strong, nonatomic) ZCHGoodsHeaderView *headerView;

@property (strong, nonatomic) NSMutableArray *imageHeightOne;
@property (strong, nonatomic) NSMutableArray *imageHeightTwo;
@property (strong, nonatomic) NSMutableArray *imageHeightThree;
@property (strong, nonatomic) NSMutableArray *imageHeightFour;
@property (strong, nonatomic) NSMutableArray *imageHeightFive;

@property (strong, nonatomic) NSMutableArray *dataDicArr;

// 分享
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) GoodsShareQRCodeView *TwoDimensionCodeView;

//店铺名称
@property (nonatomic, copy) NSString *shopName;
// 店铺logo
@property (nonatomic, copy) NSString *shopLogoUrl;


@property (nonatomic, copy) NSString *dispalyNum;
@property (nonatomic, copy) NSString *likeNum;

@property (nonatomic, assign) BOOL hasSupport; // 是否点赞
@property (nonatomic, strong) UIButton *supportButton;
@property (strong, nonatomic) UILabel *goodCountLabel; // 底部点赞数量
@property (nonatomic, strong) UILabel *scanCountLabel; // 浏览量

@end

@implementation ZCHGoodsDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"商品详情";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStyleGrouped];
    self.dataArr = [NSMutableArray array];
    self.cellHeight = [NSMutableArray array];
    self.imageHeight = [NSMutableArray array];
    self.imageHeightOne = [NSMutableArray array];
    self.imageHeightTwo = [NSMutableArray array];
    self.imageHeightThree = [NSMutableArray array];
    self.imageHeightFour = [NSMutableArray array];
    self.imageHeightFive = [NSMutableArray array];
    self.topDic = [NSMutableDictionary dictionary];
    self.dataDicArr = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHGoodsDetailCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    ZCHGoodsHeaderView *headerView = [ZCHGoodsHeaderView blej_viewFromXib];
    if (self.goodModel) {
        headerView.model = self.goodModel;
    } else if (self.dataDic) {
    
        headerView.dataDic = self.dataDic;
    }
    self.headerView = headerView;
    
    headerView.frame = CGRectMake(0, 0, BLEJWidth, BLEJWidth * 1/3 + 20);
    headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIView *topView = [[UIView alloc] initWithFrame:headerView.frame];
    [topView addSubview:headerView];
    self.tableView.tableHeaderView = topView;
    
    [self getData];
    [self setScanFooterView];
    
    if (self.productId) {
        [self addRightBtn];
    } else {
        [self addShareBtn];
        [self addBottomShareView];
        [self addTwoDimensionCodeView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
    
}
#pragma mark - 浏览量视图
- (void)setScanFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    footerView.backgroundColor = kBackgroundColor;
    self.tableView.tableFooterView = footerView;

    UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 0, 50)];
    [footerView addSubview:scanLabel];
    scanLabel.font = [UIFont systemFontOfSize:16];
    scanLabel.textColor = [UIColor darkGrayColor];
    scanLabel.text = @"浏览量";
    [scanLabel sizeToFit];

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    [footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(scanLabel);
        make.left.equalTo(scanLabel.mas_right).equalTo(5);
    }];
    label.text = self.dispalyNum;
    
    UILabel *goodCount = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH, 0, 0, 50)];
    self.goodCountLabel = goodCount;
    [footerView addSubview:goodCount];
    goodCount.textAlignment = NSTextAlignmentRight;
    goodCount.font = [UIFont systemFontOfSize:16];
    goodCount.textColor = [UIColor darkGrayColor];
    goodCount.text = self.likeNum;
    [goodCount sizeToFit];
    goodCount.centerY = scanLabel.centerY;
    goodCount.right = kSCREEN_WIDTH - 14;
    
    UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(goodCount.left - 44, 0, 44, 44)];
    self.supportButton = goodBtn;
    goodBtn.centerY = goodCount.centerY;
    [goodBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    [goodBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateHighlighted];
    [goodBtn addTarget:self action:@selector(didClickGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:goodBtn];
}

#pragma mark - 点赞按钮的点击事件
- (void)didClickGoodBtn:(UIButton *)btn {
    
    if (!_hasSupport) {
        _hasSupport = YES;
        
        [btn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        self.goodCountLabel.text = [NSString stringWithFormat:@"%ld", [self.goodCountLabel.text integerValue] + 1];
        self.goodCountLabel.right = kSCREEN_WIDTH - 14;
        [self.goodCountLabel sizeToFit];
        
        NSString *apiStr = [BASEURL stringByAppendingString:@"store/dz.do"];
        NSDictionary *paramDic = nil;
        
        if (self.productId) {
            
            paramDic = @{
                         @"merchandId":self.productId
                         };
        } else {
            
            if (self.goodModel) {
                if (self.goodModel.merchandiesId) {
                    paramDic = @{
                                 @"merchandId":self.goodModel.merchandiesId
                                 };
                }
                
                if (self.goodModel.merchandId) {
                    paramDic = @{
                                 @"merchandId":self.goodModel.merchandId
                                 };
                }
            }else{
                
                paramDic = @{
                             @"merchandId":self.dataDic[@"merchandiesId"]
                             };
            }
        }
        [NetManager afGetRequest:apiStr parms:paramDic finished:^(id responseObj) {
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    
}


#pragma mark - 编辑按钮
- (void)addRightBtn {
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(didClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

- (void)addShareBtn {
    
    // 设置导航栏最右侧的按钮
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    shareBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [shareBtn addTarget:self action:@selector(didClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
}

#pragma mark - 添加底部分享视图
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

#pragma mark - 点击分享类别的图标
- (void)didClickShareContentBtn:(UIButton *)btn {
    
    
    [self didClickShadowView:nil];
    
    NSString *shopId;
    NSString *shareTitle;
    NSString *shareDescription = self.topDic[@"companyName"];
    if (self.goodModel) {
        if (self.goodModel.merchandiesId) {
            
            shopId = self.goodModel.merchandiesId;
            shareTitle = self.goodModel.name;
        }
        
        if (self.goodModel.merchandId) {
            
            shopId = self.goodModel.merchandId;
            shareTitle = self.goodModel.name;
        }
    } else {
        
        shopId = self.dataDic[@"merchandiesId"];
        shareTitle = self.dataDic[@"name"];
    }
    
    if (shareDescription.length > 30) {
        
        shareDescription = [shareDescription substringToIndex:28];
    }
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];

            message.title = shareTitle;
            message.description = shareDescription;;
            UIImage *img = [UIImage imageWithData:[self imageWithImage:self.headerView.iconView.image scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];
            
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", shopId]];
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            YSNLog(@"%d",isSend);
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];

            message.title = shareTitle;
            message.description = shareDescription;;
            UIImage *img = [UIImage imageWithData:[self imageWithImage:self.headerView.iconView.image scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", shopId]];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            YSNLog(@"%d",isSend);
        }
            break;
        case 2:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", shopId]];
                NSURL *url = [NSURL URLWithString:shareURL];
                
                NSData *data = [self imageWithImage:self.headerView.iconView.image scaledToSize:CGSizeMake(300, 300)];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
            }
        }
            
            break;
        case 3:
        {// QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                NSURL *url = [NSURL URLWithString:[BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", shopId]]];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:[self imageWithImage:self.headerView.iconView.image scaledToSize:CGSizeMake(300, 300)]];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
            }
        }
            break;
        case 4:
        {// 二维码
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
    
    [NSObject goodsShareStatisticsWithMerchandiesId:shopId];
    
    
    
    
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {

    self.TwoDimensionCodeView = [[GoodsShareQRCodeView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    [self.view addSubview:self.TwoDimensionCodeView];
    self.TwoDimensionCodeView.backgroundColor = kBackgroundColor;
    self.TwoDimensionCodeView.alpha = 0;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    self.TwoDimensionCodeView.hidden = YES;
}

- (void)setQRCodeShare {
    NSString *goodsName;
    NSString *shareURL;
    if (self.goodModel) {
        goodsName = self.goodModel.name;
    }
    
    if (self.productId) {
        shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", self.productId]];
        
    } else {
        
        if (self.goodModel) {
            if (self.goodModel.merchandiesId) {
                shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", self.goodModel.merchandiesId]];
            }
            
            if (self.goodModel.merchandId) {
                shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", self.goodModel.merchandId]];
            }
        }else{
            shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/merchantDetail/%@.htm", self.dataDic[@"merchandiesId"]]];
        }
    }

    MJWeakSelf;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *companyLogoImage;
        NSString *companyLogo = self.topDic[@"companyLogo"];
        if (companyLogo.length > 0) {
            companyLogoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:companyLogo]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:companyLogoImage logoScaleToSuperView:0.25];
            });
        } else {

            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            });
        }
        
        
        
    });
    
    self.TwoDimensionCodeView.coverImageView.image = self.headerView.iconView.image;
    NSString *companyName = self.topDic[@"companyName"];
    self.TwoDimensionCodeView.shopName = companyName.length > 0 ? companyName: @"未命名公司";
    self.TwoDimensionCodeView.goodsName = goodsName;

//    self.TwoDimensionCodeView.shopName = @"店铺名称很长店铺名称很长店铺名称很长店铺名称很长店铺名称很长店铺名称很长店铺名称很长店铺名称很长";
//    self.TwoDimensionCodeView.goodsName = @"商品名称很超长商品名称很超长商品名称很超长商品名称很超长商品名称很超长商品名称很超长商品名称很超长";
    self.TwoDimensionCodeView.price = [NSString stringWithFormat:@"￥%@元", self.goodModel.price];
    
}

- (void)didClickTwoDimensionCodeView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}



- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

#pragma mark - 数据请求
- (void)getData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandies/getById.do"];
    
    NSDictionary *paramDic = @{@"id": @"0"};
    
    if (self.productId) {
        
        paramDic = @{
                     @"id":self.productId
                     };
    } else {
        
        if (self.goodModel) {
            if (self.goodModel.merchandiesId) {
                paramDic = @{
                             @"id":self.goodModel.merchandiesId
                             };
            }
            
            if (self.goodModel.merchandId) {
                paramDic = @{
                             @"id":self.goodModel.merchandId
                             };
            }
        }else{
            if (self.dataDic[@"merchandiesId"] == nil) {
                paramDic = @{@"id": @"0"};
            } else {
                paramDic = @{
                             @"id":self.dataDic[@"merchandiesId"]
                             };
            }
            
        }
    }
    
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArr removeAllObjects];
            [self.cellHeight removeAllObjects];
            [self.imageHeightFive removeAllObjects];
            [self.imageHeightFour removeAllObjects];
            [self.imageHeightThree removeAllObjects];
            [self.imageHeightTwo removeAllObjects];
            [self.imageHeightOne removeAllObjects];
            [self.imageHeight removeAllObjects];
            
            self.topDic = [NSMutableDictionary dictionaryWithDictionary:responseObj[@"model"]];
            self.headerView.dataDic = self.topDic;
            
            self.dispalyNum = [NSString stringWithFormat:@"%ld", [self.topDic[@"browse"] integerValue]];
            NSInteger likeNum = [self.topDic[@"likeNumber"] integerValue];
            self.likeNum = [NSString stringWithFormat:@"%ld", likeNum>0 ? likeNum : 0];
            [self setScanFooterView];
            if (responseObj[@"list"]) {
                
                self.dataDicArr = [NSMutableArray arrayWithArray:responseObj[@"list"]];
            }
            
            for (NSDictionary *dic in responseObj[@"list"]) {
                ZCHGoodsDetailModel *model = [ZCHGoodsDetailModel yy_modelWithDictionary:dic];
                [self.dataArr addObject:model];
                [self.cellHeight addObject:@"0"];
            }
            
            __weak typeof(self) weakSelf = self;
            //同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
            dispatch_queue_t queue = dispatch_queue_create("ZCHGoodsDetailViewController", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^{
                
                for (int i = 0; i < weakSelf.dataArr.count; i = i + 6) {
                    
                    ZCHGoodsDetailModel *model = weakSelf.dataArr[i];
                    if ([((NSString *)model.imgUrl) containsString:@".webp"]) {
                        
                    } else {
                        
                        CGSize sizeImage = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:model.imgUrl]];
                        [weakSelf.imageHeight addObject:[NSString stringWithFormat:@"%f", sizeImage.height]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        [weakSelf.tableView reloadTableViewWithRow:i andSection:0];
                            [weakSelf.tableView reloadData];
                        });
                    }
                }
            });
            
            dispatch_async(queue, ^{
                
                for (int i = 1; i < weakSelf.dataArr.count; i = i + 6) {
                    
                    ZCHGoodsDetailModel *model = weakSelf.dataArr[i];
                    if ([((NSString *)model.imgUrl) containsString:@".webp"]) {
                        
                    } else {
                        
                        CGSize sizeImage = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:model.imgUrl]];
                        [weakSelf.imageHeightOne addObject:[NSString stringWithFormat:@"%f", sizeImage.height]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        [weakSelf.tableView reloadTableViewWithRow:i andSection:0];
                            [weakSelf.tableView reloadData];
                        });
                    }
                }
            });
            
            dispatch_async(queue, ^{
                
                for (int i = 2; i < weakSelf.dataArr.count; i = i + 6) {
                    
                    ZCHGoodsDetailModel *model = weakSelf.dataArr[i];
                    if ([((NSString *)model.imgUrl) containsString:@".webp"]) {
                        
                    } else {
                        
                        CGSize sizeImage = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:model.imgUrl]];
                        [weakSelf.imageHeightTwo addObject:[NSString stringWithFormat:@"%f", sizeImage.height]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        [weakSelf.tableView reloadTableViewWithRow:i andSection:0];
                            [weakSelf.tableView reloadData];
                        });
                    }
                }
            });
            
            dispatch_async(queue, ^{
                
                for (int i = 3; i < weakSelf.dataArr.count; i = i + 6) {
                    
                    ZCHGoodsDetailModel *model = weakSelf.dataArr[i];
                    if ([((NSString *)model.imgUrl) containsString:@".webp"]) {
                        
                    } else {
                        
                        CGSize sizeImage = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:model.imgUrl]];
                        [weakSelf.imageHeightThree addObject:[NSString stringWithFormat:@"%f", sizeImage.height]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        [weakSelf.tableView reloadTableViewWithRow:i andSection:0];
                            [weakSelf.tableView reloadData];
                        });
                    }
                }
            });
            
            dispatch_async(queue, ^{
                
                for (int i = 4; i < weakSelf.dataArr.count; i = i + 6) {
                    
                    ZCHGoodsDetailModel *model = weakSelf.dataArr[i];
                    if ([((NSString *)model.imgUrl) containsString:@".webp"]) {
                        
                    } else {
                        
                        CGSize sizeImage = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:model.imgUrl]];
                        [weakSelf.imageHeightFour addObject:[NSString stringWithFormat:@"%f", sizeImage.height]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        [weakSelf.tableView reloadTableViewWithRow:i andSection:0];
                            [weakSelf.tableView reloadData];
                        });
                    }
                }
            });
            
            dispatch_async(queue, ^{
                
                for (int i = 5; i < weakSelf.dataArr.count; i = i + 6) {
                    
                    ZCHGoodsDetailModel *model = weakSelf.dataArr[i];
                    if ([((NSString *)model.imgUrl) containsString:@".webp"]) {
                        
                    } else {
                        
                        CGSize sizeImage = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:model.imgUrl]];
                        [weakSelf.imageHeightFive addObject:[NSString stringWithFormat:@"%f", sizeImage.height]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                        [weakSelf.tableView reloadTableViewWithRow:i andSection:0];
                            [weakSelf.tableView reloadData];
                        });
                    }
                    
                }
            });
            
            dispatch_barrier_async(queue, ^{
                
                NSLog(@"----barrier-----%@", [NSThread currentThread]);
            });

            dispatch_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.tableView reloadData];
                });
            });
            

        }
        [self setQRCodeShare];
        [self.tableView reloadData];
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHGoodsDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexpath = indexPath;
    
    if (indexPath.row % 6 == 0 && self.imageHeight.count > indexPath.row / 6) {
        cell.isShowImage = YES;
    } else if (indexPath.row % 6 == 1 && self.imageHeightOne.count > indexPath.row / 6) {
        cell.isShowImage = YES;
    } else if (indexPath.row % 6 == 2 && self.imageHeightTwo.count > indexPath.row / 6) {
        cell.isShowImage = YES;
    } else if (indexPath.row % 6 == 3 && self.imageHeightThree.count > indexPath.row / 6) {
        cell.isShowImage = YES;
    } else if (indexPath.row % 6 == 4 && self.imageHeightFour.count > indexPath.row / 6) {
        cell.isShowImage = YES;
    } else if (indexPath.row % 6 == 5 && self.imageHeightFive.count > indexPath.row / 6) {
        cell.isShowImage = YES;
    } else {
        cell.isShowImage = NO;
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 40)];
    sectionLabel.text = @"商品详情";
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.backgroundColor = White_Color;
    
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.imageHeight.count + self.imageHeightOne.count + self.imageHeightTwo.count + self.imageHeightThree.count + self.imageHeightFour.count + self.imageHeightFive.count > indexPath.row) {
        
        if (indexPath.row % 6 == 0 && self.imageHeight.count > indexPath.row / 6) {
            return [self.cellHeight[indexPath.row] floatValue] + [self.imageHeight[indexPath.row / 6] floatValue];
        }
        if (indexPath.row % 6 == 1 && self.imageHeightOne.count > indexPath.row / 6) {
            return [self.cellHeight[indexPath.row] floatValue] + [self.imageHeightOne[indexPath.row / 6] floatValue];
        }
        if (indexPath.row % 6 == 2 && self.imageHeightTwo.count > indexPath.row / 6) {
            return [self.cellHeight[indexPath.row] floatValue] + [self.imageHeightTwo[indexPath.row / 6] floatValue];
        }
        if (indexPath.row % 6 == 3 && self.imageHeightThree.count > indexPath.row / 6) {
            return [self.cellHeight[indexPath.row] floatValue] + [self.imageHeightThree[indexPath.row / 6] floatValue];
        }
        if (indexPath.row % 6 == 4 && self.imageHeightFour.count > indexPath.row / 6) {
            return [self.cellHeight[indexPath.row] floatValue] + [self.imageHeightFour[indexPath.row / 6] floatValue];
        }
        if (indexPath.row % 6 == 5 && self.imageHeightFive.count > indexPath.row / 6) {
            return [self.cellHeight[indexPath.row] floatValue] + [self.imageHeightFive[indexPath.row / 6] floatValue];
        }
        return [self.cellHeight[indexPath.row] floatValue] + 300;
        
    } else {
        
        return [self.cellHeight[indexPath.row] floatValue] + 300;
    }
}

- (void)cellHeightWithIndexpath:(NSIndexPath *)indexpath andCellHeight:(CGFloat)cellHeight {
    
    [self.cellHeight replaceObjectAtIndex:indexpath.row withObject:[NSString stringWithFormat:@"%lf", cellHeight]];
}

#pragma mark - 编辑按钮的点击事件
- (void)didClickEditBtn:(UIButton *)btn {
    
    NSLog(@"didClickEditBtn");

    EditShopDetailVC *VC = [[EditShopDetailVC alloc] init];
    VC.merchantNo = self.productId;
    VC.topDic = self.topDic;
    VC.dataArr = self.dataDicArr.mutableCopy;
    VC.isEditVC = YES;
    __weak typeof(self) weakSelf = self;
    VC.finishBlock = ^() {
        
        [weakSelf getData];
        weakSelf.backBlock();
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 分享按钮的点击事件
- (void)didClickShareBtn:(UIButton *)btn {
    
    self.shadowView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomShareView.blej_y = BLEJHeight - (70 + BLEJWidth * 0.5);
    } completion:^(BOOL finished) {
        
        self.shadowView.hidden = NO;
    }];
}


#pragma mark - 计算图片按照比例显示
- (CGSize)calculateImageSizeWithSize:(CGSize)size {
    
    CGSize finalSize;
    finalSize.width = BLEJWidth;
    finalSize.height = size.height * BLEJWidth / size.width;

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
    if (!URL) {
        return CGSizeZero;
    }
    if (url == nil) {
        return CGSizeZero;
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
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
