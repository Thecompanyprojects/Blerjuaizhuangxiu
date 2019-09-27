//
//  DecorateCompletionViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateCompletionViewController.h"
#import "DecorateCompletionHeaderView.h"
//#import "DecorateAnliView.h"
#import "ZCHBudgetGuideConstructionCaseCell.h"

#import "YellowPageCompanyTableViewCell.h"
#import "ConstructionDiaryTwoController.h"
#import "CompanyDetailViewController.h"
#import "NSObject+CompressImage.h"


@interface DecorateCompletionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headeerView;

// 施工案例数据数组
@property (nonatomic, strong) NSArray *anliArray;
// 公司数据
@property (nonatomic, strong) NSDictionary *meDict;


// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 分享的遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;

@property (nonatomic, strong) UIImage *shareImage;

@end

@implementation DecorateCompletionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
   //self.title = [self.companyType isEqualToString:@"1018"] ? @"在线预约" : @"在线预约";
    self.title = [self.constructionType isEqualToString:@"0"] ? @"在线预约":@"在线预约";
    self.anliArray = self.dataDic[@"company"][@"constructionList"];
    self.meDict = self.dataDic[@"company"];
    
    [self tableView];
    
    // 分享视图
    [self addBottomShareView];
}


#pragma  mark - UITableViewDelegate/Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.anliArray.count;
    } else if(section == 1) {
        
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ZCHBudgetGuideConstructionCaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ZCHBudgetGuideConstructionCaseCell" forIndexPath:indexPath];
        NSDictionary *dic = self.anliArray[indexPath.row];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"coverMap"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        cell.contentLabel.text = dic[@"ccShareTitle"];
        cell.areaNameLabel.text = dic[@"ccAreaName"];
        cell.displayCountLabel.text = [NSString stringWithFormat:@"%ld",  [dic[@"displayNumbers"] integerValue]];
        return cell;
    }
    if(indexPath.section == 1) {
        YellowPageCompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageCompanyTableViewCell class]) owner:self options:nil] lastObject];
            cell.phoneTitleLabel.text = @"电话：";
        }

        [cell.companyLogo sd_setImageWithURL:[NSURL URLWithString:self.meDict[@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        
        self.shareImage = cell.companyLogo.image;
        cell.companyNameLabel.text = self.meDict[@"companyName"];

        
        [cell.phoneNumBtn setTitle:self.meDict[@"companyLandline"] forState:UIControlStateNormal];
        [cell.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        // 案例
        cell.caseNmuberLabel.text = [NSString stringWithFormat:@"%@", self.meDict[@"caseTotal"]];
        // 施工中
        cell.designerNumberLabel.text = [NSString stringWithFormat:@"%@", self.meDict[@"constructionNum"]];
        // 商品
        cell.gongzhangNumberLabel.text = [NSString stringWithFormat:@"%@", self.meDict[@"mers"]];
        // 展现量
        cell.supervisorNumberLabel.text = [NSString stringWithFormat:@"%@", self.meDict[@"displayNumbers"]];
        
        
        
        cell.locationLabel.text = [NSString stringWithFormat:@"[%@]", self.meDict[@"cityName"]];

        if ([self.meDict[@"appVip"] integerValue] == 1) { // VIP
            cell.vipImage.hidden = NO;
            //cell.detailButton.hidden = NO;
            cell.moreBtn.hidden = YES;
            cell.moreImage.hidden = YES;
        }else{
            cell.vipImage.hidden = YES;
            //cell.detailButton.hidden = YES;
            cell.moreBtn.hidden = NO;
            cell.moreImage.hidden = NO;
        }
        cell.detailButton.hidden = true;
        cell.detailButton.layer.borderColor = [[UIColor redColor] CGColor];

        return cell;
    }
    return [UITableViewCell new];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 施工案例
        NSDictionary *dic = self.anliArray[indexPath.row];
        NSInteger constructionId = [dic[@"constructionId"] integerValue];
        ConstructionDiaryTwoController *diaryVC = [[ConstructionDiaryTwoController alloc]init];
        diaryVC.consID = constructionId;
        [self.navigationController pushViewController:diaryVC animated:YES];
    }
    if (indexPath.section == 1) {
        // 点击了进入公司企业
        CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
        company.companyName = self.meDict[@"companyName"];
        company.companyID = self.meDict[@"companyId"];
        company.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:company animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 80;
    }
    if (indexPath.section == 1) {
        return 86;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 && self.anliArray.count > 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
        caseLabel.backgroundColor = White_Color;
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        caseLabel.text = @"————— 经典案例 —————";
        caseLabel.textColor = [UIColor darkGrayColor];
        [bgView addSubview:caseLabel];
        return bgView;
    }
    if (section == 1) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
        caseLabel.backgroundColor = White_Color;
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        caseLabel.textColor = [UIColor darkGrayColor];
        caseLabel.text = @"————— 了解我们 —————";
        [bgView addSubview:caseLabel];
        return bgView;
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.anliArray.count > 0) {
            return 60;
        } else {
            return 0.001;
        }
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return  10;
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
    
    NSString *shareTitle = self.meDict[@"companyName"];
    NSString *shareDescription = self.meDict[@"companyIntroduction"];
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    
    UIImage *shareImage;
    NSData *shareData;
    
    
//    YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    shareImage = cell.companyLogo.image;
    shareImage = self.shareImage;
    
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
    //（0：公司 施工，1：店铺 主材） constructionType
    if ([self.constructionType isEqualToString:@"0"]) {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", [self.meDict[@"companyId"] integerValue]]];
    } else {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%ld.htm", [self.meDict[@"companyId"] integerValue]]];
    }
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
                [MobClick event:@"HanZhuangXiuCompletion"];
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

            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"HanZhuangXiuCompletion"];
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
                    [MobClick event:@"HanZhuangXiuCompletion"];
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
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"HanZhuangXiuCompletion"];
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
            [MobClick event:@"HanZhuangXiuCompletion"];
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
    
    NSString *shareURL;
    if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1065"] || [self.companyType isEqualToString:@"1064"]) {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%ld.htm", [self.meDict[@"companyId"] integerValue]]];
    } else {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%ld.htm", [self.meDict[@"companyId"] integerValue]]];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *shareImage;
//        YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//        shareImage = cell.companyLogo.image;
        shareImage = self.shareImage;
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
    YellowPageCompanyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
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
#pragma mark - LazyMethod
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(0);
//            make.left.right.bottom.equalTo(0);
//        }];
//        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headeerView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZCHBudgetGuideConstructionCaseCell" bundle:nil] forCellReuseIdentifier:@"ZCHBudgetGuideConstructionCaseCell"];
    }
    return _tableView;
}


- (UIView *)headeerView {
    if (_headeerView == nil) {
        _headeerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0)];
        
        
        DecorateCompletionHeaderView *hView = [[NSBundle mainBundle] loadNibNamed:@"DecorateCompletionHeaderView" owner:nil options:nil].firstObject;
        
        hView.infoLabel.text = [NSString stringWithFormat:@"你已成功预约了%@的装修需求，稍后会有相关人员与您沟通详细的设计事宜，如有打扰，敬请原谅！", self.meDict[@"companyName"]] ;
        CGFloat labelHeight = [hView.infoLabel sizeThatFits:CGSizeMake(CGRectGetWidth(hView.infoLabel.frame), MAXFLOAT)].height + 10;
        [hView.infoLabel sizeToFit];
        
        hView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, labelHeight + 150);
        hView.shareBlock = ^{
            YSNLog(@"分享-------------");
            [UIView animateWithDuration:0.2 animations:^{
                self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                self.shadowView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
        };
        
        _headeerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, labelHeight + 150);
        [_headeerView addSubview:hView];
    }
    return _headeerView;
}
@end

























