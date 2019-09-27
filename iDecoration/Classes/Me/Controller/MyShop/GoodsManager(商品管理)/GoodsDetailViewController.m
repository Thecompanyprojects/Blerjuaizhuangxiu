//
//  GoodsDetailViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "SDCycleScrollView.h"
#import "GoodsDetailNameCell.h"
#import "GoodsDetailEnterShopCell.h"
#import "GoodsDetailContentCell.h"
#import "GoodsDetailModel.h"
#import "MainMaterialDiaryController.h"
#import "CLPlayerView.h"
#import "GoodsDetailCommentCell.h"
#import "GoodsDetailRecommendGoodCell.h"
#import "ComplainViewController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "GoodsListModel.h"
#import "senceWebViewController.h"
#import "YellowGoodsListViewController.h"
#import "BLEJBudgetGuideController.h"
#import "DecorateNeedViewController.h"
#import "PellTableViewSelect.h"
#import "GoodsEditViewController.h"
#import "GoodsEditModel.h"
#import "GoodsShareQRCodeView.h"
#import "GoodsParameterView.h"
#import "GoodsParamterModel.h"
#import "AllCommmentViewController.h"
#import "ClassifyModel.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "PromptModel.h"
#import "LoginViewController.h"
#import "SelectGoodsPromptView.h"
#import "YPImagePreviewController.h"
#import "PhoneAndIdentifyCodeView.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "ZYCShareView.h"
#import "JinQiViewController.h"
#import "localbannerView.h"
#import "SendFlowersViewController.h"

@interface GoodsDetailViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, CLPlayerViewDelegate, GoodsParameterViewDelegate, SelectGoodsPromptViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *adScrollView; // 轮播图
@property (nonatomic, strong) UILabel *adFlagLabel;
@property (nonatomic, strong) UIView *musicView; // 歌曲视图

@property (nonatomic, strong) GoodsDetailModel *detailModel; // 商品数据
@property (nonatomic, strong) NSMutableArray *goodsDetailArray; // 商品详情描述数据
@property (nonatomic, strong) NSMutableArray *commentArray; // 评论数据
@property (nonatomic, strong) NSMutableArray *recommendGoodsArray; // 推荐商品数据
@property (nonatomic, strong) NSMutableArray *goodsDetailImageArray; // 商品详情图片数组
@property (strong, nonatomic) ZYCShareView *shareView;

@property (nonatomic, assign) BOOL isHaveMusic; // 是否有背景音乐
@property (nonatomic, assign) BOOL isPlayingMusic;

@property (nonatomic, weak) CLPlayerView *videoPlayerView; // 视频播放器
@property (nonatomic, strong) UIButton *palyVideoBtn;

@property (nonatomic, weak) CLPlayerView *detailVideoPlayerView; // 详情视频播放器
@property (nonatomic, strong) UIImageView *vrPlayIV; // 详情视频播放标识

@property (nonatomic, weak) CLPlayerView *musicPlayerView; // 音乐播放
@property (nonatomic, strong) UIButton *playMusicBtn;
@property (nonatomic, strong) UILabel *musicNameLabel;
@property (nonatomic, strong) UILabel *musicTimeLabel;

@property (nonatomic, assign) BOOL hasSupport; // 是否点赞
@property (nonatomic, strong) UIButton *supportButton;
@property (strong, nonatomic) UILabel *goodCountLabel; // 底部点赞数量
@property (nonatomic, strong) UILabel *scanCountLabel; // 浏览量
@property (nonatomic, strong) UILabel *collectionNumLabel; // 收藏量

// 底部收藏按钮
@property (strong, nonatomic) UIButton *collectionBtn;
@property (nonatomic, strong) NSMutableArray *phoneArray; // 电话数组 电话咨询
@property (nonatomic, strong) DecorateInfoNeedView *infoView; // 店铺的在线预约
@property(nonatomic,strong)localbannerView *bannerView;
// 分享ocal
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) GoodsShareQRCodeView *TwoDimensionCodeView;


// 商品参数
@property (nonatomic, strong) GoodsParameterView *paramererView;
// 商品参数数组
@property (nonatomic, strong) NSMutableArray *parameterArray;
// 服务承若数组
@property (nonatomic, strong) NSMutableArray *serviceArray;
// 优惠券数组
@property (nonatomic, strong) NSMutableArray *discountArray;
// 价格数组
@property (nonatomic, strong) NSMutableArray *priceArray;
// 选择商品
@property (nonatomic, strong) SelectGoodsPromptView *selectView;

@property (nonatomic, strong) NSString *isConVip;

@property (nonatomic, assign) BOOL isshoucang;
@property (nonatomic, copy) NSString *collectionId;

@property (nonatomic, assign) BOOL isshowBottom;



@property(nonatomic,strong)UIView *FlipView;
@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)UIImageView *xianHua;
@property(nonatomic,strong)UIImageView *jinQi;
@property(nonatomic,strong)UILabel *xianHuaL;
@property(nonatomic,strong)UILabel *jinQiL;

@end



// 音乐播放计时器
static NSString *CLPlayer_musicTimer = @"CLPlayer_musicTimer";

@implementation GoodsDetailViewController

#pragma mark - LifeMethod


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_videoPlayerView destroyPlayer];
    [_musicPlayerView destroyPlayer];
    [_detailVideoPlayerView destroyPlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = kBackgroundColor;
    self.isshowBottom = YES;
    self.shareView = [ZYCShareView sharedInstance];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self setScanFooterView];
    
    if (self.shopid.integerValue > 0) {
        self.shopID = self.shopid;
    } else {
        self.shopid = self.shopID;
    }
    // 设置导航栏最右侧的按钮
    
    UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    UIImageView *imageView = [UIImageView new];
    if (self.fromBack) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"threemorewithe"]];
        [moreBtn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(25, 25));
        }];
        [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
        [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [moreBtn setTitle:@"分享" forState:normal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    _isPlayingMusic = NO;
   
    self.phoneArray = [NSMutableArray array];
    
    
    
    _bannerView = [[localbannerView alloc] init];
    _bannerView.frame = CGRectMake(0, kSCREEN_HEIGHT-49, kSCREEN_WIDTH, 49);
    [_bannerView.btn0 addTarget:self action:@selector(headbtn0click) forControlEvents:UIControlEventTouchUpInside];
    [_bannerView.btn1 addTarget:self action:@selector(headbtn1click) forControlEvents:UIControlEventTouchUpInside];
    [_bannerView.btn2 addTarget:self action:@selector(headbtn2click) forControlEvents:UIControlEventTouchUpInside];
    [_bannerView.btn3 addTarget:self action:@selector(headbtn3click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bannerView];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NormalMethod

- (void)getData {

    //[[UIApplication sharedApplication].keyWindow hudShow];
    
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getById.do"];
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{
                               @"id": @(self.goodsID),
                               @"agencysId":@(model.agencyId)
                               
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        //[[UIApplication sharedApplication].keyWindow hiddleHud];
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            if (self.detailModel) {
                self.detailModel = nil;
            }
            self.detailModel = [GoodsDetailModel new];
            [self.detailModel yy_modelSetWithJSON:[responseObj objectForKey:@"model"]];
            

            NSDictionary *newdic = [responseObj objectForKey:@"model"];
            self.companyType = [NSString stringWithFormat:@"%@",[newdic objectForKey:@"companyType"]];
            
            if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1064"] || [self.companyType isEqualToString:@"1065"]) {
                // 公司的
                
            } else{
                // 店铺的
            
            }
            
            // 分享
            
            [self addTwoDimensionCodeView];
            
            NSDictionary *dict = [responseObj objectForKey:@"displayList"];
            NSMutableArray *mulArray = [NSMutableArray array];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString * obj, BOOL * _Nonnull stop) {
                [mulArray addObject:obj];
            }];
            if (self.detailModel.videoImg.length > 0) {
                [mulArray insertObject:self.detailModel.videoImg atIndex:0];
            }
            NSArray *displayArray = [mulArray copy];
            self.detailModel.displayList = displayArray;
            self.adScrollView.imageURLStringsGroup = displayArray;
            self.adFlagLabel.text = [NSString stringWithFormat:@"1/%ld", self.detailModel.displayList.count];
            self.detailModel.displayList = displayArray;
            
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.goodsDetailArray removeAllObjects];
            [weakSelf.goodsDetailArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[List class] json:array]];
            [weakSelf.goodsDetailImageArray removeAllObjects];
            [weakSelf.goodsDetailArray enumerateObjectsUsingBlock:^(List *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.imgUrl.length > 0) {
                    [weakSelf.goodsDetailImageArray addObject:obj.imgUrl];
                }
            }];
            
            //商品参数
            [self.parameterArray removeAllObjects];
            self.parameterArray = [self.detailModel.standardList mutableCopy];

            // 服务 数组里也是用参数的Model 即 GoodsParamterModel
            [self.serviceArray removeAllObjects];
            self.serviceArray = [self.detailModel.serviceList mutableCopy];
            
            // 价格
            [self.priceArray removeAllObjects];
            self.priceArray = [self.detailModel.priceTypeList mutableCopy];
            
            //优惠券 PromptModel 数组
            [self.discountArray removeAllObjects];
            self.discountArray = [self.detailModel.activityList mutableCopy];

            // 全景
            if (self.detailModel.viewName.length > 0) {
                List *vrModel = [List new];
                vrModel.content = self.detailModel.viewName;
                vrModel.imgUrl = self.detailModel.viewImg;
                [weakSelf.goodsDetailArray insertObject:vrModel atIndex:0];
                [weakSelf.goodsDetailImageArray insertObject:vrModel.imgUrl atIndex:0];
            }
            
            // 评论
            NSArray *commentArr = [responseObj objectForKey:@"commentList"];
            [weakSelf.commentArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CommmentModel class] json:commentArr]];
            // 推荐商品
            NSArray *recommedArr = [responseObj objectForKey:@"sendMerchandiesList"];
            [weakSelf.recommendGoodsArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:recommedArr]];
            
            _videoPlayerView.url = [NSURL URLWithString:self.detailModel.videoUrl];
            _musicPlayerView.url = [NSURL URLWithString:self.detailModel.musicUrl];
            if (!(self.detailModel.musicUrl.length > 0)) {
                self.musicView.hidden = YES;
                self.headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH + 5);
            } else {
                self.musicView.hidden = NO;
                _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH + 65);
            }
            if (!(self.detailModel.videoUrl.length > 0)) {
                self.palyVideoBtn.hidden = YES;
            } else {
                self.palyVideoBtn.hidden = NO;
            }
            
            self.goodCountLabel.text = [NSString stringWithFormat:@"%ld",self.detailModel.likeNumber];
            [self.goodCountLabel sizeToFit];
            self.scanCountLabel.text = [NSString stringWithFormat:@"%ld",self.detailModel.scanCount];
            [self.scanCountLabel sizeToFit];
            self.collectionNumLabel.text = self.detailModel.collectionNum;
            [self.collectionNumLabel sizeToFit];
            
            self.musicNameLabel.text = self.detailModel.musicName;
            
            [self setQRCodeShare];
            
            if (self.detailModel.isCheap) {
                [self playMusic:self.playMusicBtn];
            }
            [weakSelf.tableView reloadData];
        } else {
            
        }
        
        
    } failed:^(NSString *errorMsg) {
      
    }];
}


#pragma mark - 三点按钮

- (void)moreBtnClicked:(UIButton *)sender {
    if (self.fromBack) {
        // 弹出的自定义视图
        
        NSArray *array;
        if ([self.detailModel.isYellow isEqualToString:@"1"]) {
            if ([self.detailModel.recommend isEqualToString:@"0"]) {
             
                array = @[@"分享", @"编辑", @"取消置顶"];
                
            }
            else
            {
                array = @[@"分享", @"编辑", @"取消置顶"];
                
            }
            
        } else {
            if ([self.detailModel.recommend isEqualToString:@"0"]) {
              
                array = @[@"分享", @"编辑", @"置顶"];
                
            }
            else
            {
            
                array = @[@"分享", @"编辑", @"置顶"];
            }
            
        }
        
        [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 120, 0) selectData:array images:nil action:^(NSInteger index) {
            
            if (index == 0) {
                [self shareAction];
            }
            if (index == 1) {
                [self editAction];
            }
            if (index == 2) {
                [self setTopAction];
            }
            
        } animated:YES];
    }
}


- (void)setTopAction {
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/changeIsYellowStatus.do"];
   
    NSDictionary *paramDic = @{
                               @"merchantId": @(self.shopID.integerValue),
                               @"id":@(self.goodsID),
                               @"isYellow": @([self.detailModel.isYellow isEqualToString:@"1"]?0: 1)
                               };

    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        // 1000:置顶成功，1001.失败，1002.该店铺置顶商品超过6个
        switch (code) {
            case 1000:
            {
                NSString *str = [self.detailModel.isYellow isEqualToString:@"1"] ? @"取消置顶成功" : @"置顶成功";
                [[UIApplication sharedApplication].keyWindow hudShowWithText:str];
                self.detailModel.isYellow = [self.detailModel.isYellow isEqualToString:@"1"] ? @"0" : @"1";
            }
                break;
            case 1001:
            {
                NSString *str = [self.detailModel.isYellow isEqualToString:@"0"] ? @"取消置顶失败，稍后再试" : @"置顶失败，稍后再试";
                [[UIApplication sharedApplication].keyWindow hudShowWithText:str];
            }
                break;
            case 1002:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该店铺置顶商品达到6个，不能置顶"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"操作失败，稍后再试"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 编辑
- (void)editAction {
    GoodsEditViewController *editVC = [GoodsEditViewController new];
    editVC.agencJob = self.agencJob.integerValue;
    editVC.implement =  self.implement;
    editVC.isFromDetail = YES;
    editVC.shopId = self.shopID;
    NSMutableArray *mulArray = [NSMutableArray array];
    
    
    NSInteger num = self.goodsDetailArray.count;
    // 是否有全景  有全景， 详情信息从第二个开始
//    int i = (self.detailModel.viewName.length > 0) ? 1 : 0;
    for (int i = (self.detailModel.viewName.length > 0) ? 1 : 0 ; i < num; i ++) {
        List *model = self.goodsDetailArray[i];
        GoodsEditModel *eModel = [GoodsEditModel new];
        eModel.contentText = model.content;
        eModel.imgUrl = model.imgUrl;
        eModel.videoUrl = model.mvUrl;
        [mulArray addObject:eModel];
    }
    editVC.dataArray = [mulArray mutableCopy];
    if (self.detailModel.musicUrl.length > 0) {
        editVC.musicUrl = self.detailModel.musicUrl;
        editVC.musicName = self.detailModel.musicName;
    } else {
        editVC.musicUrl = @"";
        editVC.musicName = @"";
    }
    

    NSMutableArray *adImageURLMulArr = [NSMutableArray arrayWithArray:self.detailModel.displayList];
    if ([adImageURLMulArr.firstObject isEqualToString:self.detailModel.videoImg]) {
        [adImageURLMulArr removeObjectAtIndex:0];
    }
    
    editVC.adImgURLArray = adImageURLMulArr;
    
    
    editVC.videoUrl = self.detailModel.videoUrl;
    editVC.videoImageUrl = self.detailModel.videoImg;
    
    editVC.coverImgStr = self.detailModel.viewImg;
    editVC.nameStr = self.detailModel.viewName;
    editVC.linkUrl = self.detailModel.viewUrl;
    
    editVC.goodsName = self.detailModel.name;
    editVC.price = [NSString stringWithFormat:@"%@",self.detailModel.price];
    editVC.standard = self.detailModel.standard;
    
    editVC.goodsID = self.detailModel.goodsID;
    editVC.classifyModel = [ClassifyModel newModelWithID:self.detailModel.categoryId andCategoryName:self.detailModel.categoryName];
    
    editVC.listArray = self.parameterArray;
    editVC.serviceArray = self.serviceArray;
    editVC.priceArray = self.priceArray;
    editVC.moreExplain = self.detailModel.cutLine;
    editVC.musicStyle = self.detailModel.isCheap;
    MJWeakSelf;
    editVC.EditingCompletionBlock = ^{
        [weakSelf getData];
    };
    [self.navigationController pushViewController:editVC animated:YES];
    
}
#pragma mark - 分享
- (void)shareAction {
    [self makeShareView];
    [self.shareView share];
   
//    NSString *shopId = [NSString stringWithFormat:@"%ld", self.detailModel.goodsID]; // 商品ID
//    NSString *shareTitle = self.detailModel.name;
//    NSString *shareDescription = self.detailModel.companyName;
//
//    if (shareDescription.length > 30) {
//        shareDescription = [shareDescription substringToIndex:28];
//    }
//    NSString *imgURLString = self.detailModel.displayList[0];
//    UIImageView *imageView = self.adScrollView.subviews[0].subviews[0].subviews[0].subviews[0];
//    UIImage *iconImage = imageView.image;
//
//    self.shareView.URL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/showeGoodsInfo/%@.htm", shopId]];
//    self.shareView.imageURL = imgURLString;
//    self.shareView.companyName = shareTitle;
//

}



-(void)shareblick
{
 
//     __weak typeof (self) weakSelf = self;
//
//    self.shareView.blockWeChatFriend = ^{
//        WXMediaMessage *message = [WXMediaMessage message];
//        message.title = shareTitle;
//        message.description = shareDescription;
//        UIImage *img =  [UIImage imageWithData:[weakSelf imageWithImage:iconImage scaledToSize:CGSizeMake(300, 300)]];
//        [message setThumbImage:img];
//        WXWebpageObject *webPageObject = [WXWebpageObject object];
//        NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/showeGoodsInfo/%@.htm", shopId]];
//        webPageObject.webpageUrl = shareURL;
//        message.mediaObject = webPageObject;
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
//        req.bText = NO;
//        req.message = message;
//        req.scene = WXSceneSession;
//        BOOL isSend = [WXApi sendReq:req];
//        YSNLog(@"%d",isSend);
//
//    };
//    self.shareView.blockWeChatTimeline = ^{
//
//    };
//    self.shareView.blockQQZone = ^{
//
//    };
//    self.shareView.blockQQFriend = ^{
//
//    };
//
//    self.shareView.blockQRCode1st = ^{
//        //[self makeQRCodeWithType:1];
//    };
//    self.shareView.blockQRCode2nd = ^{
//        //[self makeQRCodeWithType:0];
//    };
}

// 播放 音乐
- (void)playMusic:(UIButton *)sender {
    if (_musicPlayerView == nil) {
        CLPlayerView *musicPlauerView = [[CLPlayerView alloc] initWithFrame:self.musicView.frame];
        _musicPlayerView = musicPlauerView;
        _musicPlayerView.videoFillMode = VideoFillModeResizeAspect;
        _musicPlayerView.repeatPlay = YES;
        [self.musicView addSubview:_musicPlayerView];
        _musicPlayerView.hidden = YES;
        _musicPlayerView.url = [NSURL URLWithString:self.detailModel.musicUrl];
    }
    
    _isPlayingMusic = !_isPlayingMusic;
    if (_isPlayingMusic) {

        [_videoPlayerView pausePlay];
        
        
         [sender setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
        [_musicPlayerView playVideo];
        
        //当前时长
        //计时器，循环执行 设置音乐播放时间
        [[CLGCDTimerManager sharedManager] scheduledDispatchTimerWithName:CLPlayer_musicTimer
                                                             timeInterval:1.0f
                                                                delaySecs:0
                                                                    queue:dispatch_get_main_queue()
                                                                  repeats:YES
                                                                   action:^{
                                                                       [self setMusicTime];
                                                                   }];
       [[CLGCDTimerManager sharedManager] startTimer:CLPlayer_musicTimer];
        
        
    } else {
        [sender setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        [_musicPlayerView pausePlay];
        [[CLGCDTimerManager sharedManager] suspendTimer:CLPlayer_musicTimer];
    }

    
}

// 设置音乐时间
- (void)setMusicTime {
    NSString *str = [self.musicPlayerView playerCurrentTime];
    if ([str isEqualToString:@"00:00"]) {
        self.musicTimeLabel.text = @"缓冲中。。。";
    } else {
        self.musicTimeLabel.text = [self.musicPlayerView playerCurrentTime];
    }
    
//    YSNLog(@"88888  %@", [self.musicPlayerView playerCurrentTime]);
}
// 播放头部视频
- (void)playVideoAction {
    if (self.videoPlayerView == nil) {
        [self setupPlayerView:self.adScrollView];
    }
    self.videoPlayerView.url = [NSURL URLWithString:self.detailModel.videoUrl];
    // 停止音乐播放
    [_musicPlayerView pausePlay];
    [self.playMusicBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
    _isPlayingMusic = NO;
    [[CLGCDTimerManager sharedManager] suspendTimer:CLPlayer_musicTimer];
    
    self.palyVideoBtn.hidden = YES;
    _videoPlayerView.hidden = NO;
   [_videoPlayerView playVideo];
}

#pragma mark - CLPlayerViewDelegate
// 视频播放暂停
- (void)playerViewPauseAction {
    
}
// 视频播放继续
- (void)playerViewPlayAction {
    [self.playMusicBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
    _isPlayingMusic = NO;
    [_musicPlayerView pausePlay];
    [[CLGCDTimerManager sharedManager] suspendTimer:CLPlayer_musicTimer];
    [_videoPlayerView playVideo];
}


// 进入店铺
- (void)enterShopAction {
    
    if ([self.companyType integerValue]==1018 || [self.companyType integerValue]==1064 || [self.companyType integerValue]==1065) {
        CompanyDetailViewController *VC = [[CompanyDetailViewController alloc] init];

        VC.companyID = [NSString stringWithFormat:@"%ld",self.detailModel.merchantId];
        VC.companyName = self.detailModel.companyName;
        VC.origin = self.origin;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else{
        ShopDetailViewController *VC = [[ShopDetailViewController alloc] init];
        VC.origin = self.origin;
        VC.shopID = [NSString stringWithFormat:@"%ld", self.detailModel.merchantId];
        VC.shopName = self.detailModel.companyName;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

// 全部评论
- (void)gotoAllComment {
    AllCommmentViewController *allCommment = [AllCommmentViewController new];
    allCommment.commentArray = self.commentArray;
    [self.navigationController pushViewController:allCommment animated:YES];
}
// 全部商品
- (void)gotoAllGoodsAction {
    YellowGoodsListViewController *vc = [YellowGoodsListViewController new];
    vc.shopId = [NSString stringWithFormat:@"%ld",self.detailModel.merchantId];
    
    vc.fromBack = self.fromBack;
    vc.origin = self.origin;
    
    vc.collectFlag = self.collectFlag;
    vc.shopid = self.shopid;
    vc.dataDic = self.dataDic;
    vc.companyType = self.companyType;
    vc.phone = self.phone;
    vc.telPhone = self.telPhone;
    vc.areaList = self.areaList;
    vc.baseItemsArr = self.baseItemsArr;
    vc.suppleListArr = self.suppleListArr;
    vc.constructionCase = self.constructionCase;
    vc.topCalculatorImageArr = self.topCalculatorImageArr;
    vc.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    vc.companyDic = self.companyDic;
    vc.calculatorModel = self.calculatorTempletModel;
    vc.code = self.code;
    vc.companyName =  [self.companyDic objectForKey:@"companyName"];
    vc.shareCompanyLogoURLStr = [self.companyDic objectForKey:@"companyLogo"];
    vc.shareDescription = [self.companyDic objectForKey:@"companyIntroduction"];;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)leftCellTapAction:(UITapGestureRecognizer *)tapGR {
    UIView *view = tapGR.view;
    GoodsListModel *model = self.recommendGoodsArray[view.tag];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    
    vc.fromBack = self.fromBack;
    vc.goodsID = model.goodsID;
    vc.shopID = self.shopID;
    vc.origin = self.origin;
    vc.collectFlag = self.collectFlag;
    vc.shopid = self.shopid;
    vc.dataDic = self.dataDic;
    vc.companyType = self.companyType;
    vc.phone = self.phone;
    vc.telPhone = self.telPhone;
    vc.areaList = self.areaList;
    vc.baseItemsArr = self.baseItemsArr;
    vc.suppleListArr = self.suppleListArr;
    vc.constructionCase = self.constructionCase;
    vc.topCalculatorImageArr = self.topCalculatorImageArr;
    vc.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    vc.companyDic = self.companyDic;
    vc.calculatorTempletModel = self.calculatorTempletModel;
    vc.code = self.code;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    self.adFlagLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, cycleScrollView.imageURLStringsGroup.count];
    
    if (!(self.detailModel.videoUrl.length > 0)) {
        self.palyVideoBtn.hidden = YES;
    } else {
        self.palyVideoBtn.hidden = index;
    }
}
#pragma mark - 图片浏览
-(void)lookPhoto:(NSInteger)index imgArray:(NSArray *)imgArray{
    __weak GoodsDetailViewController *weakSelf=self;
    YPImagePreviewController *yvc = [[YPImagePreviewController alloc]init];
    yvc.images = imgArray ;
    yvc.index = index ;
    UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
    [weakSelf presentViewController:uvc animated:YES completion:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 5; // 0 商品名称  1  进入店铺   2. 商品详情 3. 业主评价 4. 推荐商品
/*
 // 0 商品名称  1领取优惠券   2商品参数  3 服务承诺   4选择   5进入店铺   6. 商品详情 7. 业主评价 8. 推荐商品
 
 */
    return 9;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1 || section == 2 || section == 3 || section == 4) {
        return 1;
    }
    if (section == 5) {
        return 1;
    }
    if (section == 6) {
        return self.goodsDetailArray.count;
    }
    if (section == 7) {
        return self.commentArray.count >= 3 ? 3 : self.commentArray.count;
    }
    if (section == 8) {
        NSInteger count = self.recommendGoodsArray.count/2 + self.recommendGoodsArray.count%2;
        return count >= 3 ? 3 : count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GoodsDetailNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailNameCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailNameCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.detailModel;
        
        NSMutableArray *mulArr = [NSMutableArray array];
        NSInteger count = self.detailModel.activityList.count > 3 ? 3 : self.detailModel.activityList.count;
        for (int i = 0; i < count; i ++) {
            ActivityListModel *amodel = self.detailModel.activityList[i];
            [mulArr addObject:amodel.activityName];
        }
        cell.discountTitleArray = [mulArr copy];
        return cell;
    }
    if (indexPath.section == 1) {
       
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsParamerecellr"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"领取优惠券";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsParamerecellr"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"商品参数";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsParamerecellr"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"服务承诺";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goodsParamerecellr"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"选择";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    if (indexPath.section == 5) {
        GoodsDetailEnterShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailEnterShopCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailEnterShopCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.enterShopBtn addTarget:self action:@selector(enterShopAction) forControlEvents:UIControlEventTouchUpInside];
        cell.model = self.detailModel;
        
        return cell;
    }
    
    if (indexPath.section == 6) {
        // 商品详情  第一个为全景  视频在其中的顺序里面
        GoodsDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailContentCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailContentCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        List *model = self.goodsDetailArray[indexPath.row];
        cell.contentLabel.text = model.content;
        if (model.content.length == 0) {
            cell.imageTopToContetLabelBottomCon.constant = 0;
        }
        NSURL *url = [NSURL URLWithString:model.imgUrl];
        [cell.imageV sd_setImageWithURL:url];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
        UIImage * image;
        if (existBool) {
            image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }else{
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
        }
        if (model.mvUrl.length > 0) {
            // 视频限制视频高
            if (image.size.width) {
                cell.imageViewHeightCon.constant = kSCREEN_WIDTH;
            } else {
                cell.imageViewHeightCon.constant = 0;
                cell.imageTopToContetLabelBottomCon.constant = 0;
            }
        } else {
            
            if (image.size.width) {
                cell.imageViewHeightCon.constant = image.size.height/image.size.width * (kSCREEN_WIDTH - 16);
            } else {
                cell.imageViewHeightCon.constant = 0;
                cell.imageTopToContetLabelBottomCon.constant = 0;
            }
        }
        
        MJWeakSelf;
        
        if (model.mvUrl.length > 0) {
            // 有视频
            UIImageView *vrView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_play"]];
            self.vrPlayIV = vrView;
            [cell.contentView addSubview:vrView];
            [vrView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-20);
                make.bottom.equalTo(-20);
                make.size.equalTo(CGSizeMake(40, 40));
            }];
            
            cell.clickImageBlock = ^{
                [weakSelf playDetailViedoWithListModel:model];
            };
        } else {
            // 没有视频的
            if (indexPath.row == 0 && self.detailModel.viewName.length > 0) {
                // 有全景
                cell.clickImageBlock = ^{
                    senceWebViewController *senceVC = [senceWebViewController new];
                    senceVC.webUrl = self.detailModel.viewUrl;
                    senceVC.isFrom = YES;
                    senceVC.companyName = self.detailModel.companyName;
                    senceVC.companyLogo = self.detailModel.companyLogo;
                    [self.navigationController pushViewController:senceVC animated:YES];
                };
                
            } else {
                // 全景和视频不添加图片点击浏览事件
                cell.clickImageBlock = ^{
                    [weakSelf lookPhoto:indexPath.row imgArray:weakSelf.goodsDetailImageArray];
                };
            }
        }

        if (indexPath.row == 0 && self.detailModel.viewName.length > 0) {
            // 有全景
            UIImageView *vrView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VRButton"]];
            [cell.contentView addSubview:vrView];
            [vrView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-20);
                make.bottom.equalTo(-20);
                make.size.equalTo(CGSizeMake(40, 40));
            }];
        }
        
        return cell;
    }
    
    if (indexPath.section == 7) {
        GoodsDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCommentCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailCommentCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.commentLabel.numberOfLines = 3;
        cell.model = self.commentArray[indexPath.row];

        return cell;
    }
    if (indexPath.section == 8) {
        GoodsDetailRecommendGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailRecommendGoodCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailRecommendGoodCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        GoodsListModel *leftModel = self.recommendGoodsArray[indexPath.row * 2];
        cell.leftModel = leftModel;
        NSMutableArray *mulArr = [NSMutableArray array];
        NSInteger count = leftModel.activityList.count > 3 ? 3 : leftModel.activityList.count;
        for (int i = 0; i < count; i ++) {
            ActivityListModel *amodel = leftModel.activityList[i];
            [mulArr addObject:amodel.activityName];
        }
        cell.leftDiscountTitleArray = [mulArr copy];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftCellTapAction:)];
        cell.bgView.userInteractionEnabled = YES;
        cell.bgView.tag = indexPath.row * 2;
        [cell.bgView addGestureRecognizer:tapGR];
        
        if (indexPath.row * 2 + 1 <= self.recommendGoodsArray.count - 1) {
            GoodsListModel *rightModel = self.recommendGoodsArray[indexPath.row * 2 + 1];
            cell.rightModel = rightModel;
            NSMutableArray *mulArr = [NSMutableArray array];
            NSInteger count = rightModel.activityList.count > 3 ? 3 : rightModel.activityList.count;
            for (int i = 0; i < count; i ++) {
                ActivityListModel *amodel = rightModel.activityList[i];
                [mulArr addObject:amodel.activityName];
            }
            cell.rightDiscountTitleArray = [mulArr copy];
            
            UITapGestureRecognizer *rightTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftCellTapAction:)];
            cell.rightBgView.userInteractionEnabled = YES;
            cell.rightBgView.tag = indexPath.row * 2 + 1;
            [cell.rightBgView addGestureRecognizer:rightTapGR];
        }
        
        
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 6) {
        if (self.goodsDetailArray.count == 0) {
            return [UIView new];
        }
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [bgView addSubview:bottomView];
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:caseLabel];
        NSString *contentStr = @"商品详情";
        caseLabel.text = contentStr;
        
        return bgView;
    }
    
    if (section == 7) {
        if (self.commentArray.count == 0) {
            return [UIView new];
        }
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [bgView addSubview:bottomView];
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:caseLabel];
        NSString *contentStr = @"—— 业主评论 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];

        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
        caseLabel.attributedText = str;
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 50)];
        [nextBtn setTitle:@"全部评论" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [nextBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(gotoAllComment) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
        [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
        [bottomView addSubview:nextBtn];
        
        return bgView;
    }
    if (section == 8) {
        if (self.recommendGoodsArray.count == 0) {
            return [UIView new];
        }
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [bgView addSubview:bottomView];
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:caseLabel];
        NSString *contentStr = @"—— 推荐商品 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];

        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
        caseLabel.attributedText = str;
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 50)];
        [nextBtn setTitle:@"全部商品" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [nextBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(gotoAllGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
        [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
        [bottomView addSubview:nextBtn];
        //        nextBtn.hidden = !(self.acticityArray.count >1);
        
        
        return bgView;
    }
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 6) {
        return self.goodsDetailArray.count > 0? 60 : 0.01f;
    } else if (section == 7) {
        return self.commentArray.count > 0? 60 : 0.01f;
    } else if (section == 8) {
        return self.recommendGoodsArray.count > 0? 60 : 0.01f;
    } else {
        return 5;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) { // 领取优惠券
        if (self.discountArray.count!=0) {
            self.paramererView.topTitle = @"优惠券";
            [self.paramererView.listArray removeAllObjects];
            [self.paramererView.promptArray removeAllObjects];
            self.paramererView.promptArray = [self.discountArray mutableCopy];
            [UIView animateWithDuration:0.25 animations:^{
                self.paramererView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
            }];
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无优惠券" controller:self sleep:1.5];
        }
    }
    if (indexPath.section == 2) { // 商品参数
        self.paramererView.topTitle = @"商品参数";
        [self.paramererView.listArray removeAllObjects];
        [self.paramererView.promptArray removeAllObjects];
        self.paramererView.listArray = [self.parameterArray mutableCopy];
        [UIView animateWithDuration:0.25 animations:^{
            self.paramererView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        }];
    }
    if (indexPath.section == 3) { // 服务承诺
        self.paramererView.topTitle = @"服务承诺";
        [self.paramererView.listArray removeAllObjects];
        [self.paramererView.promptArray removeAllObjects];
        self.paramererView.listArray = [self.serviceArray mutableCopy];
        [UIView animateWithDuration:0.25 animations:^{
            self.paramererView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        }];
    }
    if (indexPath.section == 4) { // 选择
        if (self.priceArray.count == 0) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该商品未设置选项"];
            return;
        }
        [self didSelectedTitleAt:0];
        NSMutableArray *array = [NSMutableArray array];
        [self.priceArray enumerateObjectsUsingBlock:^(GoodsPriceModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj.name];
        }];
        self.selectView.buttonTitleArray = [array copy];
        [UIView animateWithDuration:0.25 animations:^{
            self.selectView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        }];
    }
    
    if (indexPath.section == 6 && indexPath.row == 0) {
        if (self.detailModel.viewName.length > 0) {
            
            // 有全景
            senceWebViewController *senceVC = [senceWebViewController new];
            senceVC.webUrl = self.detailModel.viewUrl;
            senceVC.isFrom = YES;
            senceVC.companyName = self.detailModel.companyName;
            senceVC.companyLogo = self.detailModel.companyLogo;
            [self.navigationController pushViewController:senceVC animated:YES];
        }
    }
    
    if (indexPath.section == 6) {
         List *model = self.goodsDetailArray[indexPath.row];
        if (model.mvUrl.length > 0) {
            // 详情中的视频播放
            [self playDetailViedoWithListModel:model];
            
        }
    }else if (indexPath.section == 7) {//业主评论
        CommmentModel *model = self.commentArray[indexPath.row];
        MainMaterialDiaryController *controller = [MainMaterialDiaryController new];
        controller.consID = model.constructionId;
        [self.navigationController pushViewController:controller animated:true];
    }
    
    
}

- (void)playDetailViedoWithListModel:(List *)model {
    if (![model.mvUrl ew_isUrlString]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"视频地址不正确， 不能播放"];
        return;
    }
    
    CLPlayerView *playerView = [[CLPlayerView alloc] init];
    self.detailVideoPlayerView = playerView;
    [self.view addSubview:self.detailVideoPlayerView];
    [self.detailVideoPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.bottom.equalTo(0);
    }];
    self.detailVideoPlayerView.url = [NSURL URLWithString:model.mvUrl];
    self.detailVideoPlayerView.hidden = NO;
    self.detailVideoPlayerView.repeatPlay = NO;
    self.detailVideoPlayerView.delegate = self;
    self.detailVideoPlayerView.isLandscape = NO;
    self.detailVideoPlayerView.videoFillMode = VideoFillModeResizeAspect;
    self.detailVideoPlayerView.strokeColor = [UIColor clearColor];
    self.detailVideoPlayerView.toolBarDisappearTime = 3;
    
    [self.detailVideoPlayerView backButton:^(UIButton *button) {
        
        [self.detailVideoPlayerView pausePlay];
        self.detailVideoPlayerView.hidden = YES;
        self.vrPlayIV.hidden = NO;
        [self.detailVideoPlayerView destroyPlayer];
        [self.detailVideoPlayerView removeFromSuperview];
    }];
    [self.detailVideoPlayerView endPlay:^{
        [self.detailVideoPlayerView pausePlay];
        self.detailVideoPlayerView.hidden = YES;
        self.vrPlayIV.hidden = NO;
        [self.detailVideoPlayerView destroyPlayer];
        [self.detailVideoPlayerView removeFromSuperview];
    }];
    [self.detailVideoPlayerView playVideo];
}

#pragma mark - GoodsParameterViewDelegate 领取优惠券
- (void)didSelectedPromotionAt:(NSInteger)index withPromptModel:(ActivityListModel *)promptModel goodsDiscountCell:(GoodsDiscountCell *)cell{
    
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (!isLogin) { // 未登录
        LoginViewController *vc = [LoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *apiStr = [BASEURL stringByAppendingString:@"merchandiesActivity/receiveTicket.do"];
        NSDictionary *paramDic =  paramDic = @{
                                               @"merchandiesId":@(self.detailModel.goodsID),
                                               @"agencyId":@(userModel.agencyId),
                                               @"activityId":@(promptModel.activityID)
                                               };
        [NetManager afGetRequest:apiStr parms:paramDic finished:^(id responseObj) {
            NSInteger code = [responseObj[@"code"] integerValue];
            switch (code) {
                case 1000:
                {
                    SHOWMESSAGE(@"领取成功");
                    cell.bgImageView.image = [UIImage imageNamed:@"bg_jihuo"];
                    [self getData];
                }
                    break;
                case 1001:
                    SHOWMESSAGE(@"领取失败， 稍后再试");
                    break;
                case 1002:
                    SHOWMESSAGE(@"您已经领取过该优惠券");
                    break;
                default:
                     SHOWMESSAGE(@"领取失败， 稍后再试");
                    break;
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

#pragma mark - SelectGoodsPromptViewDelegate
- (void)didSelectedTitleAt:(NSInteger)index {
    GoodsPriceModel *model = self.priceArray[index];
    __block NSString *imageURL = nil;
    [self.priceArray enumerateObjectsUsingBlock:^(GoodsPriceModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.imageURL.length > 0) {
            imageURL = obj.imageURL;
        }
    }];
    NSString *sureImageURL = model.imageURL.length > 0 ? model.imageURL : imageURL;
    
    [self.selectView.imageView sd_setImageWithURL:[NSURL URLWithString:sureImageURL]];
    self.selectView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.price.doubleValue];
    self.selectView.numLabel.text = [NSString stringWithFormat:@"库存%@%@", model.num, model.unit];
    YSNLog(@"点击了第 %ld 个标签", index);
}

- (void)selectGoodsPromptView:(SelectGoodsPromptView *)view subBtnActionAtIndex:(NSInteger)index {
    if (view.buyNumLabel.text.integerValue > 0) {
        view.buyNumLabel.text = [NSString stringWithFormat:@"%ld", view.buyNumLabel.text.integerValue - 1];
    }
}

- (void)selectGoodsPromptView:(SelectGoodsPromptView *)view addBtnActionAtIndex:(NSInteger)index {
    GoodsPriceModel *model = self.priceArray[index];
    if (view.buyNumLabel.text.integerValue < model.num.integerValue) {
        view.buyNumLabel.text = [NSString stringWithFormat:@"%ld", view.buyNumLabel.text.integerValue + 1];
    }
}

#pragma mark - 分享↓


- (void)makeShareView {
    WeakSelf(self);
    NSString *shopId = [NSString stringWithFormat:@"%ld", self.detailModel.goodsID]; // 商品ID
    NSString *shareTitle = self.detailModel.name;
    NSString *shareDescription = self.detailModel.companyName;
    NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/showeGoodsInfo/%@.htm", shopId]];

    self.shareView.URL = shareURL;
    self.shareView.shareTitle = shareTitle;
    self.shareView.shareCompanyIntroduction = shareDescription;
    self.shareView.shareViewType = ZYCShareViewTypeDefault;

    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    //NSString *imgURLString = self.detailModel.displayList[0];
    UIImageView *imageView = self.adScrollView.subviews[0].subviews[0].subviews[0].subviews[0];
    UIImage *iconImage = imageView.image;
    OSMessage *msg = [[OSMessage alloc] init];
    msg.title = shareTitle;
    msg.link = shareURL;
    msg.desc = shareDescription;
    NSData *imageData = UIImagePNGRepresentation(iconImage);
    msg.image = imageData;
    
    self.shareView.blockQRCode1st = ^{
        weakself.TwoDimensionCodeView.hidden = NO;
        weakself.shadowView.hidden = YES;
        weakself.bottomShareView.blej_y = BLEJHeight;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.TwoDimensionCodeView.alpha = 1.0;
            weakself.navigationController.navigationBar.alpha = 0;
        }];
    };
    self.shareView.blockQRCode2nd = ^{
        weakself.TwoDimensionCodeView.hidden = NO;
        weakself.shadowView.hidden = YES;
        weakself.bottomShareView.blej_y = BLEJHeight;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.TwoDimensionCodeView.alpha = 1.0;
            weakself.navigationController.navigationBar.alpha = 0;
        }];
    };
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        
        self.shadowView.hidden = YES;
    }];
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
    NSString *goodsName = self.detailModel.name;
    NSString *shareURL;
    shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"store/showeGoodsInfo/%ld.htm", self.detailModel.goodsID]];
    
    MJWeakSelf;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *companyLogoImage;
        UIImage *coverImage;
        NSString *coverImageURLString = @"";
        if (self.detailModel.videoImg.length > 0) {
            coverImageURLString = self.detailModel.displayList[0];
        } else {
            coverImageURLString = self.detailModel.displayList[0];
        }
        NSString *companyLogo = self.detailModel.companyLogo;
        if (coverImageURLString.length > 0) {
            coverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverImageURLString]]];
        }
        if (companyLogo.length > 0) {
            companyLogoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:companyLogo]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:companyLogoImage logoScaleToSuperView:0.25];
                weakSelf.TwoDimensionCodeView.coverImageView.image = coverImage;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
                weakSelf.TwoDimensionCodeView.coverImageView.image = coverImage;
            });
        }
  
    });
    
    NSString *companyName = self.detailModel.companyName;
    self.TwoDimensionCodeView.shopName = companyName.length > 0 ? companyName: @"未命名公司";
    self.TwoDimensionCodeView.goodsName = goodsName;
    self.TwoDimensionCodeView.price = [NSString stringWithFormat:@"￥%@元", self.detailModel.price];
    
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
#pragma mark - 分享↑

-(void)headbtn0click{
    [self.phoneArray removeAllObjects];
    
    NSString *landLine = [self.dataDic objectForKey:@"companyLandline"];
    NSString *managerLine = [self.dataDic objectForKey:@"companyPhone"];
    
    if (self.phoneArray.count > 0) {
        if (!(!landLine || [landLine isKindOfClass:[NSNull class]] || [landLine isEqualToString:@""])) {
            [self.phoneArray addObject:landLine];
        }
        if (!(!managerLine || [managerLine isKindOfClass:[NSNull class]] || [managerLine isEqualToString:@""])) {
            [self.phoneArray addObject:managerLine];
        }
    } else {
        if (!(!self.phone || [self.phone isKindOfClass:[NSNull class]] || [self.phone isEqualToString:@""])) {
            [self.phoneArray addObject:self.phone];
        }
        if (!(!self.telPhone || [self.telPhone isKindOfClass:[NSNull class]] || [self.telPhone isEqualToString:@""])) {
            [self.phoneArray addObject:self.telPhone];
        }
    }
    
    
    
    
    if (self.phoneArray.count <= 0) {
        return;
    }
    UIAlertController *alerC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (int i = 0; i < self.phoneArray.count; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:self.phoneArray[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArray[i]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }];
        [alerC addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alerC addAction:cancelAction];
    [self presentViewController:alerC animated:YES completion:nil];
}
-(void)headbtn1click{
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
   _xianHuaL=[[UILabel alloc]initWithFrame:CGRectMake(20+_xianHua.right+5, 80+10, 20, 20)];
    _jinQi=[[UIImageView alloc]initWithFrame:CGRectMake(20+60+40,80 , 40, 40)];
   _jinQiL=[[UILabel alloc]initWithFrame:CGRectMake(20+60+40+_xianHua.right+5, 80+10, 20, 20)];
    [_jinQi setContentMode:UIViewContentModeScaleAspectFill];
    [_xianHua setContentMode:UIViewContentModeScaleAspectFill];
    _jinQi.image=[UIImage imageNamed:@"Personcard_Flag"];
    _xianHua.image= [UIImage imageNamed:@"Personcard_Flower"] ;
  
    _jinQiL.text =self.pennantnumber;
    _xianHuaL.text =self.flowerNumber;
    
    
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

    if(!CGRectContainsPoint(self.baseView.frame, selectPoint)){
        
        [UIView animateWithDuration:0.3f animations:^{

            self.FlipView.mj_y += 180 ;
        } completion:^(BOOL finished) {
            [self.FlipView removeFromSuperview];
        }];
        
    }
    
    
    
}
#pragma mark 锦旗的购买事件
-(void)ToJinQiPurchase{
    
    [UIView animateWithDuration:0.3f animations:^{

        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    JinQiViewController *view =[[JinQiViewController alloc]init];
    view.isSendFromCompany =YES;
    view.companyId = @(self.detailModel.merchantId).stringValue;
    WeakSelf(self)
    view.completionBlock = ^(NSString *count) {
        StrongSelf(weakself)
        if (count) {
            strongself.jinQiL.text=[NSString stringWithFormat:@"%ld",(self.pennantnumber.integerValue +1)];
             
            
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
    Flowerview.compamyIDD =@(self.detailModel.merchantId).stringValue;
    Flowerview.isCompamyID =YES;
    WeakSelf(self)
    Flowerview.blockIsPay = ^(BOOL isPay) {
        StrongSelf(weakself)
        if (isPay ==YES) {
            //鲜花的数量加一
            strongself.xianHuaL.text =[NSString stringWithFormat:@"%ld",(self.flowerNumber.integerValue +1)];
  
            
        }
        
    };
    [self.navigationController pushViewController:Flowerview animated:YES];
}



#pragma mark - LazyMethod
- (NSMutableArray *)goodsDetailArray {
    if (_goodsDetailArray == nil) {
        _goodsDetailArray = [NSMutableArray array];
    }
    return _goodsDetailArray;
}

- (NSMutableArray *)goodsDetailImageArray {
    if (_goodsDetailImageArray == nil) {
        _goodsDetailImageArray = [NSMutableArray array];
    }
    return _goodsDetailImageArray;
}

- (NSMutableArray *)commentArray {
    if (_commentArray == nil) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSMutableArray *)recommendGoodsArray {
    if (_recommendGoodsArray == nil) {
        _recommendGoodsArray = [NSMutableArray array];
    }
    return _recommendGoodsArray;
}

- (NSMutableArray *)parameterArray {
    if (!_parameterArray) {
        _parameterArray = [NSMutableArray array];
    }
    return _parameterArray;
}

- (NSMutableArray *)serviceArray {
    if (_serviceArray == nil) {
        _serviceArray = [NSMutableArray array];
    }
    return _serviceArray;
}

- (NSMutableArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}

- (NSMutableArray *)discountArray {
    if (_discountArray == nil) {
        _discountArray = [NSMutableArray array];
    }
    return _discountArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH,kSCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
        if (self.fromBack) {
            _tableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [UIView new];
        _headerView.backgroundColor = kBackgroundColor;
        CGFloat headerViewHeight = 0.01f;
        self.adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH) delegate:self placeholderImage:nil];
        self.adScrollView.autoScroll = NO;
        self.adScrollView.showPageControl = NO;
        self.adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.adScrollView.backgroundColor = [UIColor blackColor];
        
        [_headerView addSubview:self.adScrollView];
        self.adFlagLabel = [UILabel new];
        [self.adScrollView addSubview:self.adFlagLabel];
        [self.adFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-16);
            make.left.equalTo(32);
            make.height.equalTo(24);
            make.width.equalTo(40);
        }];
        self.adFlagLabel.textColor = [UIColor whiteColor];
        self.adFlagLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.adFlagLabel.font = [UIFont systemFontOfSize:14];
        self.adFlagLabel.layer.cornerRadius = 12;
        self.adFlagLabel.layer.masksToBounds = YES;
        self.adFlagLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setupPlayerView:self.adScrollView];
        
        UIButton *playVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.palyVideoBtn = playVideoBtn;
        playVideoBtn.frame = CGRectMake(kSCREEN_WIDTH - 60, kSCREEN_WIDTH - 50, 40, 40);
        [self.adScrollView addSubview:playVideoBtn];
        [playVideoBtn setBackgroundImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        [playVideoBtn addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
        
        // 歌曲视图
        UIView *musicView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_WIDTH + 5, kSCREEN_WIDTH, 60)];
        self.musicView = musicView;
        [_headerView addSubview:musicView];
        musicView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 42, 42)];
        imageV.image = [UIImage imageNamed:@"CD"];
        [musicView addSubview:imageV];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        self.musicNameLabel = nameLabel;
        [musicView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV.mas_top).equalTo(5);
            make.left.equalTo(imageV.mas_right).equalTo(8);
            make.right.equalTo(-8);
        }];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = @"歌曲名字";
        UILabel *timeLabel = [UILabel new];
        self.musicTimeLabel = timeLabel;
        [musicView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).equalTo(0);
            make.left.equalTo(imageV.mas_right).equalTo(8);
        }];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.text = @"00:00";
        
         CLPlayerView *musicPlauerView = [[CLPlayerView alloc] initWithFrame:musicView.frame];
        _musicPlayerView = musicPlauerView;
        _musicPlayerView.videoFillMode = VideoFillModeResizeAspect;
        _musicPlayerView.repeatPlay = YES;
        [musicView addSubview:_musicPlayerView];
        _musicPlayerView.hidden = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playMusicBtn = btn;
        [musicView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        _isPlayingMusic = NO;
        [btn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        headerViewHeight =kSCREEN_WIDTH + 65;
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, headerViewHeight);
    }
    return _headerView;
}

// 头部视频播放
- (void)setupPlayerView:(UIView *)headerView {
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH)];
    
    _videoPlayerView = playerView;
    [headerView addSubview:_videoPlayerView];
    _videoPlayerView.hidden = YES;
    _videoPlayerView.delegate = self;
    
    //    //重复播放，默认不播放
    _videoPlayerView.repeatPlay = YES;
    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    _videoPlayerView.isLandscape = NO;
    //    //设置等比例全屏拉伸，多余部分会被剪切
    _videoPlayerView.videoFillMode =VideoFillModeResizeAspect;
        _videoPlayerView.strokeColor = kMainThemeColor;
    //    //工具条消失时间，默认10s
        _videoPlayerView.toolBarDisappearTime = 3;
    //顶部工具条隐藏样式，默认不隐藏
//    _playerView.topToolBarHiddenType = TopToolBarHiddenAll;
    //返回按钮点击事件回调,小屏状态才会调用，全屏默认变为小屏
    [_videoPlayerView backButton:^(UIButton *button) {
//        NSLog(@"返回按钮被点击");
        //[_videoPlayerView destroyPlayer];
        [_videoPlayerView pausePlay];
        _videoPlayerView.hidden = YES;
        self.palyVideoBtn.hidden = NO;
    }];
    //播放完成回调
    [_videoPlayerView endPlay:^{
        //销毁播放器
       // [_videoPlayerView destroyPlayer];
        [_videoPlayerView pausePlay];
        _videoPlayerView.hidden = YES;
        self.palyVideoBtn.hidden = NO;
        
    }];
}

// 设置浏览量视图
- (void)setScanFooterView {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];
    
    UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 0, 50)];
    [footView addSubview:scanLabel];
    scanLabel.font = [UIFont systemFontOfSize:16];
    scanLabel.textColor = [UIColor darkGrayColor];
    scanLabel.text = @"浏览量";
    [scanLabel sizeToFit];
    
    UILabel *displayCount = [[UILabel alloc] initWithFrame:CGRectMake(scanLabel.right + 10, 0, 0, 50)];
    self.scanCountLabel = displayCount;
    [footView addSubview:displayCount];
    displayCount.textAlignment = NSTextAlignmentRight;
    displayCount.font = [UIFont systemFontOfSize:16];
    displayCount.textColor = [UIColor darkGrayColor];
    displayCount.text = @"0";
    [displayCount sizeToFit];
    
    UILabel *collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(displayCount.right + 25, 0, 0, 50)];
    [footView addSubview:collectionLabel];
    collectionLabel.font = [UIFont systemFontOfSize:16];
    collectionLabel.textColor = [UIColor darkGrayColor];
    collectionLabel.text = @"收藏量";
    [collectionLabel sizeToFit];
    
    UILabel *collectionNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(collectionLabel.right + 10, 0, 0, 50)];
    self.collectionNumLabel = collectionNumLabel;
    [footView addSubview:collectionNumLabel];
    collectionNumLabel.textAlignment = NSTextAlignmentRight;
    collectionNumLabel.font = [UIFont systemFontOfSize:16];
    collectionNumLabel.textColor = [UIColor darkGrayColor];
    collectionNumLabel.text = @"0";
    [collectionNumLabel sizeToFit];
    
    UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionNumLabel.right + 10, 0, 44, 44)];
    self.supportButton = goodBtn;
    [goodBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    [goodBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateHighlighted];
    [goodBtn addTarget:self action:@selector(didClickGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:goodBtn];
    
    UILabel *goodCount = [[UILabel alloc] initWithFrame:CGRectMake(goodBtn.right, 0, 0, 50)];
    self.goodCountLabel = goodCount;
    [footView addSubview:goodCount];
    goodCount.textAlignment = NSTextAlignmentRight;
    goodCount.font = [UIFont systemFontOfSize:16];
    goodCount.textColor = [UIColor darkGrayColor];
    goodCount.text = @"0";
    [goodCount sizeToFit];
    
    
    UIButton *complainBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 50, 0, 50, 50)];
    [complainBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [complainBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    complainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [complainBtn addTarget:self action:@selector(didClickComplainBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:complainBtn];
    goodCount.centerY = complainBtn.centerY;
    goodBtn.centerY = goodCount.centerY;
    displayCount.centerY = goodBtn.centerY;
    scanLabel.centerY = displayCount.centerY;
    collectionLabel.centerY = goodBtn.centerY;
    collectionNumLabel.centerY = goodBtn.centerY;
    
    self.tableView.tableFooterView = footView;
}

- (GoodsParameterView *)paramererView {
    if (_paramererView == nil) {
        _paramererView = [[GoodsParameterView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        _paramererView.delegate = self;
        [self.view addSubview:_paramererView];
        [self.view sendSubviewToBack:self.tableView];
        
        _paramererView.finishBlock = ^(GoodsParameterView *paramView) {
            [UIView animateWithDuration:0.25 animations:^{
                paramView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
            }];
        };
    }
    return _paramererView;
}

- (SelectGoodsPromptView *)selectView {
    if (_selectView == nil) {
        _selectView = [[SelectGoodsPromptView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        _selectView.delegate = self;
        [self.view addSubview:_selectView];
        _selectView.finishBlock = ^(SelectGoodsPromptView *promptView) {
            [UIView animateWithDuration:0.25 animations:^{
                promptView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
            }];
        };
    }
    return _selectView;
}
#pragma mark - 点赞按钮的点击事件
- (void)didClickGoodBtn:(UIButton *)btn {
    
    if (!_hasSupport) {
        _hasSupport = YES;
        
        [btn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        self.goodCountLabel.text = [NSString stringWithFormat:@"%ld", [self.goodCountLabel.text integerValue] + 1];
        
        [self.goodCountLabel sizeToFit];
        
        NSString *goodsIDStr = [NSString stringWithFormat:@"%ld", self.goodsID];
        NSString *apiStr = [BASEURL stringByAppendingString:@"store/dz.do"];
        NSDictionary *paramDic =  paramDic = @{
                                               @"merchandId":goodsIDStr
                                               };
        [NetManager afGetRequest:apiStr parms:paramDic finished:^(id responseObj) {
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    
}

#pragma mark - 投诉按钮的点击事件
- (void)didClickComplainBtn:(UIButton *)btn {
    ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
    ComplainVC.companyID = self.shopID.integerValue;
    ComplainVC.complainFrom = 6;
    [self.navigationController pushViewController:ComplainVC animated:YES];
}

#pragma mark - 添加底部视图↓
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
    
    // 收藏
//    // 242 105 71
//    self.collectionBtn.frame = CGRectMake(phoneBtn.right+1, 0, BLEJWidth/4-1, bottomView.height);
//    [self.collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.collectionBtn setTitle:@"赠送礼物" forState:UIControlStateNormal];
//    [self.collectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.collectionBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
//    [bottomView addSubview:self.collectionBtn];
//
//
//    UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.collectionBtn.right, 0, BLEJWidth/4, bottomView.height)];
//    priceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    priceBtn.backgroundColor = kCustomColor(242, 105, 71);
//    [priceBtn setTitleColor:White_Color forState:UIControlStateNormal];
//    [priceBtn setTitle:@"免费报价" forState:UIControlStateNormal];
//    [priceBtn addTarget:self action:@selector(didClickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:priceBtn];
//
//
//    UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, priceBtn.width, bottomView.height)];
//    houseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    houseBtn.backgroundColor = kMainThemeColor;
//    [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
//    [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];
//    [houseBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:houseBtn];
}

#pragma mark - 底部视图的点击事件

- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
   
}


#pragma mark - 预约
- (void)headbtn3click{// 预约
    
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
    [param setObject:self.shopID forKey:@"companyId"];
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


#pragma mark - 预约完成
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
    [dic setObject:self.shopID forKey:@"companyId"];
    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"公司类型没有传"];
    [dic setObject:self.companyDic[@"companyType"] forKey:@"companyType"];
    [dic setObject:@(proType) forKey:@"proType"];
    [dic setObject:@"0" forKey:@"agencyId"];
    [dic setObject:@"3" forKey:@"callPage"];
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
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"公司类型没有传"];
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
    
    // 收藏
    // 242 105 71

    self.collectionBtn.frame = CGRectMake(phoneBtn.width+1, 0, 80, bottomView.height);
    [self.collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.collectionBtn];
    
    
    UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.collectionBtn.right, 0, (BLEJWidth - self.collectionBtn.width-phoneBtn.width) * 0.5, bottomView.height)];
    priceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    priceBtn.backgroundColor = kCustomColor(242, 105, 71);
    [priceBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [priceBtn setTitle:@"免费报价" forState:UIControlStateNormal];
    [priceBtn addTarget:self action:@selector(didClickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:priceBtn];
    

    UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, priceBtn.width, bottomView.height)];
    houseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    houseBtn.backgroundColor = kMainThemeColor;
    [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];
    [houseBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:houseBtn];
    
}

- (void)headbtn2click {// 装修
    
//    // 装修报价
//    if (self.code == 1000) {
//
//        if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
//
    BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
    VC.origin = self.origin;
    VC.baseItemsArr = self.baseItemsArr;
    VC.suppleListArr = self.suppleListArr;
    VC.calculatorModel = self.calculatorTempletModel;
    VC.constructionCase = self.constructionCase;
    VC.companyID = self.shopid;
    VC.topImageArr = self.topCalculatorImageArr;
    VC.bottomImageArr = self.bottomCalculatorImageArr;
    VC.isConVip = self.isConVip; //self.companyDic[@"conVip"];
  //  VC.dispalyNum = self.calculatorTempletModel.displayNumbers;
    [self.navigationController pushViewController:VC animated:YES];
    
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置简装/精装报价"];
//        }
//    } else if (self.code == -1) {
//
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络不畅，请稍后重试"];
//    } else {
//
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置模板"];
//    }
}

- (void)didClickHouseBtn:(UIButton *)btn {// 量房
    
    DecorateNeedViewController *decoration = [[DecorateNeedViewController alloc]init];
    decoration.companyID = self.shopid;
    decoration.areaList = self.areaList;
    decoration.companyType = @"1018";
    [self.navigationController pushViewController:decoration animated:YES];
}

-(UIButton *)collectionBtn
{
    if(!_collectionBtn)
    {
        _collectionBtn = [[UIButton alloc] init];
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    }
    return _collectionBtn;
}


#pragma mark - 添加底部视图↑


@end
