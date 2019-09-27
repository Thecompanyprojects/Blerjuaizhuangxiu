//
//  ZCHCaseAndBeautyController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCaseAndBeautyController.h"
#import "SiteTableViewCell.h"
#import "UnionActivityListCell.h"
#import "ConstructionDiaryTwoController.h"
#import "MainMaterialDiaryController.h"
#import "MyBeautifulArtShowController.h"
#import "NewsActivityShowController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateNeedViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "BLEJBudgetGuideController.h"
#import "DecorateCompletionViewController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"


static NSString *reuseCaseIdentifier = @"SiteTableViewCell";
//static NSString *reuseBeautyIdentifier = @"UnionActivityListCell";

@interface ZCHCaseAndBeautyController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) UIImageView *topImageView;

@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *bottomShareView;
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;
@property (strong, nonatomic) UIButton *collectionBtn;

// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
// 预算报价的顶部图片
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
// 预算报价的底部图片
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;
@property (assign, nonatomic) NSInteger code;

@end

@implementation ZCHCaseAndBeautyController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"名 片";
    self.view.backgroundColor = White_Color;
    self.phoneArr = [NSMutableArray array];
    
    self.suppleListArr = [NSMutableArray array];
    self.baseItemsArr = [NSMutableArray array];
    self.topCalculatorImageArr = [NSMutableArray array];
    self.bottomCalculatorImageArr = [NSMutableArray array];
    self.constructionCase = [NSMutableArray array];
    self.code = -1;
    
    [self setUpUI];
    [self addBottomView];
    [self addBottomShareView];
    [self getCalculatorData];
}

- (void)setUpUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom - 50) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SiteTableViewCell" bundle:nil] forCellReuseIdentifier:reuseCaseIdentifier];
//    [self.tableView registerNib:[UINib nibWithNibName:@"UnionActivityListCell" bundle:nil] forCellReuseIdentifier:reuseBeautyIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    [self.view addSubview:self.tableView];
    
    // 设置导航栏最右侧的按钮
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    shareBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [shareBtn addTarget:self action:@selector(didClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
}

#pragma mark - 分享按钮的点击事件
- (void)didClickShareBtn:(UIButton *)btn {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight - (BLEJWidth * 0.5 + 70);
        self.shadowView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isCase) {
        
        return self.caseArr.count + 1;
    } else {
        
        return self.beautyArr.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
        photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.cardDic[@"coverMap"]] placeholderImage:nil];
        self.topImageView = imageView;
        [photoCell.contentView addSubview:imageView];
        
        UIButton *caseBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 50, kSCREEN_WIDTH * 0.6 - 30 - 5, 50, 30)];
        caseBtn.layer.cornerRadius = 5;
        if (self.isCase) {
            [caseBtn setBackgroundColor:kMainThemeColor];
            self.btn = caseBtn;
        } else {
            [caseBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        [caseBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [caseBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [caseBtn setTitle:@"案例" forState:UIControlStateNormal];
        if (self.caseArr.count == 0) {
            caseBtn.hidden = YES;
        } else {
            caseBtn.hidden = NO;
        }
        caseBtn.tag = 100001;
        caseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [imageView addSubview:caseBtn];
        
        UIButton *beautyBtn = [[UIButton alloc] initWithFrame:CGRectMake(caseBtn.left, caseBtn.top - 33, caseBtn.width, caseBtn.height)];
        beautyBtn.layer.cornerRadius = 5;
        if (self.isCase) {
            [beautyBtn setBackgroundColor:[UIColor lightGrayColor]];
        } else {
            [beautyBtn setBackgroundColor:kMainThemeColor];
            self.btn = beautyBtn;
        }
        
        [beautyBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [beautyBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [beautyBtn setTitle:@"美文" forState:UIControlStateNormal];
        beautyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        beautyBtn.tag = 100002;
        if (self.beautyArr.count == 0) {
            beautyBtn.hidden = YES;
        } else {
            beautyBtn.hidden = NO;
        }
        [imageView addSubview:beautyBtn];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, beautyBtn.top, BLEJWidth - 100, 70)];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.textColor = [UIColor grayColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = self.cardDic[@"trueName"];
        [photoCell.contentView addSubview:nameLabel];
        
        return photoCell;
    } else {
        if (self.isCase) {
            
            SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCaseIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.houseHoldLabel.font = [UIFont systemFontOfSize:16];
            cell.stateBtn.hidden = YES;
            cell.locationLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8 - 4;
            cell.companyLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8;
            if (self.caseArr.count > 0) {
                cell.cardModel = self.caseArr[indexPath.row - 1];
            }
//            cell.delegate = self;
            cell.path = indexPath;
            return cell;
            
        } else {
            
            //美文
            UnionActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnionActivityListCellTwo"];
            if (!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"UnionActivityListCell" owner:self options:nil][1];
            }
            cell.beautyModel = self.beautyArr[indexPath.row - 1];
            return cell;
        }
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - 美文或者案例的点击事件
- (void)didClickBtn:(UIButton *)btn {
    
    if (btn.tag == self.btn.tag) {
        return;
    } else {
        
        [self.btn setBackgroundColor:[UIColor lightGrayColor]];
        [btn setBackgroundColor:kMainThemeColor];
        self.btn = btn;
        if (btn.tag == 100001) {

            self.isCase = YES;
//            self.title = @"案 例";
        } else {

            self.isCase = NO;
//            self.title = @"美 文";
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return;
    }
    
    if (self.isCase) {
        
        SiteModel *site = self.caseArr[indexPath.row - 1];
        NSInteger company = [site.companyType integerValue];
        
        if ([site.isConVip integerValue] == 0) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"主人暂未开通云管理会员"];
            return;
        }
        if (company == 1018 || company == 1064 || company == 1065) {
            
            ConstructionDiaryTwoController *diaryVC = [[ConstructionDiaryTwoController alloc] init];
            diaryVC.consID = [site.constructionId integerValue];
            [self.navigationController pushViewController:diaryVC animated:YES];
        } else {
            MainMaterialDiaryController *diaryVC = [[MainMaterialDiaryController alloc] init];
            diaryVC.consID = [site.constructionId integerValue];
            [self.navigationController pushViewController:diaryVC animated:YES];
        }
    } else {
        
        BeautifulArtListModel *model = self.beautyArr[indexPath.row - 1];
        if ([model.types isEqualToString:@"2"]) {
            //我的美文
            MyBeautifulArtShowController *vc = [[MyBeautifulArtShowController alloc] init];
            vc.designsId = [model.designId integerValue];
            vc.activityType = 2;
            vc.meCalVipTag = [self.cardDic[@"calVip"] integerValue];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //活动美文
            NewsActivityShowController *VC = [[NewsActivityShowController alloc] init];
            VC.activityType = 2;
            VC.designsId = [model.designId integerValue];
            VC.companyId = self.companyDic[@"companyId"];
            VC.companyName = self.companyDic[@"companyName"];
            VC.companyLogo = self.companyDic[@"companyLogo"];
            VC.origin = @"2";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return kSCREEN_WIDTH * 0.6;
    } else {
        if (self.isCase) {
            return 100;
        } else {
            return 50;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
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
    
    if (!self.cardDic || self.cardDic.allKeys.count == 0 ) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"图片还需完善"];
        return;
    }
    NSString *shareTitle = self.cardDic[@"trueName"];
    NSString *shareDescription = self.cardDic[@"indu"];
    if (shareTitle.length > 30) {
        shareTitle = [shareTitle substringToIndex:28];
    }
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.topImageView == nil || self.topImageView.image == nil) {
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
        shareImage = self.topImageView.image;
        
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
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];  // 返回YES 跳转成功
            if (isSend) {
                [MobClick event:@"CompanyYellowPageShare"];
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
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
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
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
                
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                if (code == 0) {
                    [MobClick event:@"CompanyYellowPageShare"];
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
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                if (code == 0) {
                    [MobClick event:@"CompanyYellowPageShare"];
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
            [MobClick event:@"CompanyYellowPageShare"];
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
    self.TwoDimensionCodeView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.TwoDimensionCodeView.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [self.TwoDimensionCodeView addSubview:codeView];
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hudShow];
        });
        
        UIImage *shareImage;
        if (self.topImageView == nil || self.topImageView.image == nil) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.cardDic[@"coverMap"]]]];
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
            shareImage = self.topImageView.image;
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
    companyNameLabel.text = self.cardDic[@"trueName"];
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

#pragma mark - 添加底部视图
- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
    if ([self.companyDic[@"companyType"] integerValue] == 1018 || [self.companyDic[@"companyType"] integerValue] == 1064 || [self.companyDic[@"companyType"] integerValue] == 1064) {
        
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
        self.collectionBtn.selected = ([self.cardDic[@"collectionId"] integerValue] == 0 ? NO : YES);
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
//        [houseBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [houseBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:houseBtn];
        
    } else {
        
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
        self.collectionBtn.selected = ([self.cardDic[@"collectionId"] integerValue] == 0 ? NO : YES);
        [bottomView addSubview:collectionBtn];
        
        UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.right, 0, BLEJWidth - collectionBtn.right, bottomView.height)];
        appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        appointmentBtn.backgroundColor = kMainThemeColor;
        [appointmentBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [appointmentBtn setTitle:@"在线预约" forState:UIControlStateNormal];
        [appointmentBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:appointmentBtn];
    }
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
    if (!(!self.cardDic || self.cardDic[@"phone"] == nil || [self.cardDic[@"phone"] isEqualToString:@""])) {
        
        [self.phoneArr addObject:self.cardDic[@"phone"]];
    }
    if (self.phoneArr.count == 0) {
        return;
    }
    
    if (self.phoneArr.count == 2) {
        if ([self.phoneArr[0] isEqualToString:self.phoneArr[1]]) {
            [self.phoneArr removeLastObject];
        }
    }
    if (self.phoneArr.count == 3) {
        if ([self.phoneArr[1] isEqualToString:self.phoneArr[2]]) {
            [self.phoneArr removeLastObject];
        }
    }
    
    UIActionSheet *actionSheet;
    actionSheet.tag = 10002;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else if (self.phoneArr.count == 2) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    } else if (self.phoneArr.count == 3) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], self.phoneArr[2], nil];
    }
    
    [actionSheet showInView:self.view];
}

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
    [NSObject needDecorationStatisticsWithConpanyId:self.companyDic[@"companyId"]];
    
}

- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    
    // 装修报价
    if (self.code == 1000) {
        
       
            
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.origin = self.origin;
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
            VC.calculatorModel = self.calculatorTempletModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.companyDic[@"companyId"];
        
            VC.isConVip = self.companyDic[@"conVip"];
            [self.navigationController pushViewController:VC animated:YES];
//         if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置简装/精装报价"];
//        }
    } else if (self.code == -1) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络不畅，请稍后重试"];
    } else {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置模板"];
    }
}

- (void)didClickHouseBtn:(UIButton *)btn {// 量房
    
    DecorateNeedViewController *decoration = [[DecorateNeedViewController alloc]init];
    decoration.companyID = self.companyDic[@"companyId"];
    decoration.areaList = self.areaArr;
    decoration.companyType = @"1018";
    [self.navigationController pushViewController:decoration animated:YES];
}

#pragma mark - 收藏按钮的点击事件
- (void)didClickCollectionBtn:(UIButton *)btn {// 收藏(取消)
    
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (!isLogin) { // 未登录
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
        
    } else {
        if (btn.selected) {
            
            [self unCollectionShopOrCompany];
        } else {
            
            [self saveShopOrCompany];
        }
        
    }
}

#pragma mark 在线咨询
- (void)callOthers {
    
    [self.phoneArr removeAllObjects];
    
    if (!(!self.companyDic || self.companyDic[@"companyLandline"] == nil || [self.companyDic[@"companyLandline"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyLandline"]];
    }
    
    if (!(!self.companyDic || self.companyDic[@"companyPhone"] == nil || [self.companyDic[@"companyPhone"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyPhone"]];
    }
    if (!(!self.cardDic || self.cardDic[@"phone"] == nil || [self.cardDic[@"phone"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.cardDic[@"phone"]];
    }
    if (self.phoneArr.count == 0) {
        return;
    }
    UIActionSheet *actionSheet;
    actionSheet.tag = 10002;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else if (self.phoneArr.count == 2) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    } else if (self.phoneArr.count == 3) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], self.phoneArr[2], nil];
    }
    
    [actionSheet showInView:self.view];
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
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约修失败，稍后重试"];
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

#pragma mark - 获取计算器模板相关的内容
- (void)getCalculatorData {
    
    BLEJCalculatorGetTempletByCompanyId *calculatorGetTempletByCompanyId = [[BLEJCalculatorGetTempletByCompanyId alloc] initWithCompanyId:self.companyDic[@"companyId"]];
    [calculatorGetTempletByCompanyId startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        self.code = code;
        if (code == 1000) {
            
       ///     self.calculatorTempletModel = [BLEJCalculatorTempletModel yy_modelWithDictionary:[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"templet"]];
            self.topCalculatorImageArr = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"headImages"];
            self.bottomCalculatorImageArr = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"footImages"];
            NSArray *baseArr = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"baseItems"];
            for (NSDictionary *dict in baseArr) {
                
                BLEJCalculatorBaseAndSuppleListModel *calculatorBaseAndSuppleListModel = [BLEJCalculatorBaseAndSuppleListModel yy_modelWithJSON:dict];
                
                if (![self.baseItemsArr containsObject:calculatorBaseAndSuppleListModel]) {
                    [self.baseItemsArr addObject:calculatorBaseAndSuppleListModel];
                }
            }
            
            NSArray *suppleArr = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"suppleList"];
            for (NSDictionary *dict in suppleArr) {
                
                BLEJCalculatorBaseAndSuppleListModel *calculatorBaseAndSuppleListModel = [BLEJCalculatorBaseAndSuppleListModel yy_modelWithJSON:dict];
                
                if (![self.suppleListArr containsObject:calculatorBaseAndSuppleListModel]) {
                    [self.suppleListArr addObject:calculatorBaseAndSuppleListModel];
                }
            }
            
            NSArray *caseArr = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"conList"];
            for (NSDictionary *dict in caseArr) {
                
                ZCHBudgetGuideConstructionCaseModel *caseListModel = [ZCHBudgetGuideConstructionCaseModel yy_modelWithJSON:dict];
                
                if (![self.constructionCase containsObject:caseListModel]) {
                    [self.constructionCase addObject:caseListModel];
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
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
    } else if (self.phoneArr.count == 2) {
        
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
    } else if (self.phoneArr.count == 3) {
        
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
        } else if (buttonIndex == 2) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[2]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else {
            
        }
    }
}

#pragma mark - 取消收藏
- (void)unCollectionShopOrCompany {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    NSDictionary *paramDic = @{
                               @"collectionId" : self.cardDic[@"collectionId"]
                               };
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [self.cardDic setObject:@(0) forKey:@"collectionId"];
                [[PublicTool defaultTool] publicToolsHUDStr:@"已取消收藏" controller:self sleep:1.0];
                self.collectionBtn.selected = NO;
                if (self.block) {
                    self.block();
                }
            }
                break;
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"操作失败" controller:self sleep:1.0];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 收藏
- (void)saveShopOrCompany  {
    
    NSString *requestString = [BASEURL stringByAppendingString:@"collection/add.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.cardDic[@"cardId"] forKey:@"relId"]; // 名片id
    [params setObject:@(user.agencyId) forKey:@"agencysId"]; // 用户ID
    [params setObject:@"2" forKey:@"type"];
    [NetManager afGetRequest:requestString parms:params finished:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1000) {
            
            [self.cardDic setObject:@([responseObj[@"collectionId"] integerValue]) forKey:@"collectionId"];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏成功"];
            self.collectionBtn.selected = YES;
            
            if (self.block) {
                self.block();
            }
        } else if ([responseObj[@"code"] integerValue] == 1002) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经收藏过了"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏失败"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
