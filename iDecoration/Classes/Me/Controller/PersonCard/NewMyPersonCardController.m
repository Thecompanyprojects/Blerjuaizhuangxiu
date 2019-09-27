//
//  NewMyPersonCardController.m
//  iDecoration
//
//  Created by sty on 2018/1/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMyPersonCardController.h"
#import "NewMyPersonCardTwoCell.h"
#import "NewMyPersonCardThreeCell.h"
#import "NewMyPersonCardFourCell.h"
#import "NewMyPersonCardFiveCell.h"
#import "NewMyPersonCardSixCell.h"
#import "FlowersListViewController.h"
#import "PellTableViewSelect.h"
#import "CLPlayerView.h"
#import "SDCycleScrollView.h"
#import "PersonCardModel.h"
#import "BeautifulArtCardModel.h"
#import "PersonConListModel.h"
#import "PersonGoodListModel.h"
#import "AllPersonBeautilArtController.h"
#import "EliteDetailViewController.h"
#import "MeViewController.h"
#import "PersonalInfoViewController.h"

#import "AllPersonCaseController.h"
#import "AllPersonGoodsController.h"

#import "GoodsDetailViewController.h"
#import "ConstructionDiaryTwoController.h"
#import "MainMaterialDiaryController.h"

#import "MyBeautifulArtShowController.h"
#import "NewsActivityShowController.h"
#import "EditInfoViewController.h"
#import "PersonCoverController.h"
#import "YellowGoodsListViewController.h"

#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "ZCHPublicWebViewController.h"
#import "MapViewController.h"

#import "SGQRCode.h"

#import "AppleIAPManager.h"
#import "LoginViewController.h"
#import "JinQiViewController.h"
#import "BannerListViewController.h"

#import "PushToLocalViewController.h"//点击精英推荐若自己没有推荐则跳转到 推送同城
#import "SendFlowersViewController.h"//鲜花
#import "SiteGroupChatViewController.h"
// 音乐播放计时器 
static NSString *CLPlayer_musicTimer = @"CLPlayer_musicTimer";

@interface NewMyPersonCardController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,SDCycleScrollViewDelegate, CLPlayerViewDelegate,NewMyPersonCardFourCellDelegate,NewMyPersonCardSixCellDelegat,NewMyPersonCardTwoCellDelegate>{
    CGFloat _cellFourH;
    CGFloat _cellSixH;
    CGFloat _cellThreeh;
    
    BOOL isHaveZan;//是否点过赞。 当前页面进来的时候未点赞，只能点赞一次
    BOOL isHavePower;
    BOOL isHaveGuanzhu; // 是否关注过
}



@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *adScrollView; // 轮播图
@property (nonatomic, strong) UILabel *adFlagLabel;
@property (nonatomic, strong) UIView *musicView; // 歌曲视图
@property (nonatomic, weak) CLPlayerView *videoPlayerView; // 视频播放器
@property (nonatomic, strong) UIImageView *palyVideoBtn;

@property (nonatomic, weak) CLPlayerView *musicPlayerView; // 音乐播放
@property (nonatomic, strong) UIButton *playMusicBtn;
@property (nonatomic, strong) UILabel *musicNameLabel;
@property (nonatomic, strong) UILabel *musicTimeLabel;

@property (nonatomic, assign) BOOL isHaveMusic; // 是否有北京音乐
@property (nonatomic, assign) BOOL isPlayingMusic;

@property (nonatomic, strong) NSMutableDictionary *companyDict;//公司字典
@property (nonatomic, strong) PersonCardModel *cardModel;

@property (nonatomic, strong) BeautifulArtCardModel *artModel;

//二维码
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *bottomShareView;
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) NSMutableArray *conListArray;
@property (nonatomic, strong) NSMutableArray *artListArray;
@property (nonatomic, strong) NSMutableArray *goodListArray;

@property (strong, nonatomic) UIButton *editBtn;
@end

@implementation NewMyPersonCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"名  片";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}];
    isHaveZan = NO;
    isHaveGuanzhu = NO;

    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if ([self.agencyId integerValue]==user.agencyId) {
        isHavePower = YES;
    }
    else{
        isHavePower = NO;
    }
    
    
    self.conListArray = [NSMutableArray array];
    self.artListArray = [NSMutableArray array];
    self.goodListArray = [NSMutableArray array];
    
    [self setUpUI];
    [self requestInfo];
    [self addBottomShareView];
    
    //修改封面的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:@"personCoverEditSucess" object:nil];
    
    //修改个人资料的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:@"personInfoEditSucess" object:nil];
    
   //添加美文的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:@"PersonAddBeautifulArtSucess" object:nil];
    
    //添加案例的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:@"PersonAddCaseSucess" object:nil];
    
    //
    
    //添加案例的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:@"PersonAddGoodsSucess" object:nil];
    //refreshData
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"kRealeaseToRefreshNewPerson" object:nil];
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
    [self addSuspendedButton];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.musicPlayerView destroyPlayer];
}

- (void)setUpUI{
 
    CGFloat naviBottom = kSCREEN_HEIGHT - self.navigationController.navigationBar.bottom;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = White_Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewMyPersonCardTwoCell" bundle:nil] forCellReuseIdentifier:@"NewMyPersonCardTwoCell"];
    [self.view addSubview:self.tableView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==3) {
        return self.artListArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 450;
    }
    else if (indexPath.section==1) {
        return _cellThreeh;
    }
    else if (indexPath.section==2) {
        return _cellFourH;
    }
    else if (indexPath.section==3) {
        return 80;
    }
    else if (indexPath.section==4) {
        return _cellSixH;
    }
    else{
       return 320;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        if (!isHavePower&&self.cardModel.coverMap.length<=0) {
            return 0;
        }
        return 330;
    }
    if (section==3) {
        return 52;
    }
    if (section==4) {
        return 52;
    }
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section==4) {
        return 50;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section==0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        [view addSubview:self.headerView];
        
        
        
        NSMutableArray *bannerArray = [NSMutableArray array];
        
        if (self.cardModel.videoImg&&self.cardModel.videoImg.length>0) {
            [bannerArray addObject:self.cardModel.videoImg];
        }
        if (self.cardModel.coverMap.length>0) {
            NSArray *array = [self.cardModel.coverMap componentsSeparatedByString:@","];
            [bannerArray addObjectsFromArray:array];
        }

        self.adScrollView.imageURLStringsGroup = bannerArray;
        
        //音乐
        if (!self.cardModel.music||self.cardModel.music.length<=0) {
            //没有音乐
            self.musicNameLabel.text = @"暂无音乐";
            self.playMusicBtn.userInteractionEnabled = NO;
        }
        else{
            self.musicNameLabel.text = self.cardModel.musicName;
            self.playMusicBtn.userInteractionEnabled = YES;
        }
        
        //视频
        if (!self.cardModel.video||self.cardModel.video.length<=0) {
            self.palyVideoBtn.hidden = YES;
        }
        else{
            self.palyVideoBtn.hidden = NO;
        }
        self.adFlagLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)bannerArray.count];
        
        
        
        return view;
    }
    
    if (section==3) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 52)];
        view.backgroundColor = kSepLineColor;
        
        UIView *firstV = [[UIView alloc]initWithFrame:CGRectMake(0, 6, kSCREEN_WIDTH, 40)];
        firstV.backgroundColor = White_Color;
        
        
        
        [view addSubview:firstV];
        
        UILabel *caseL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-(70/2), 0, 70, firstV.height)];
        caseL.text = @"我的美文";
        caseL.textColor = COLOR_BLACK_CLASS_3;
        caseL.font = NB_FONTSEIZ_NOR;
        caseL.textAlignment = NSTextAlignmentCenter;
        
        UIView *SegmentLeftV = [[UIView alloc]initWithFrame:CGRectMake(caseL.left-caseL.width/2, firstV.height/2-0.5, caseL.width/2, 1)];
        SegmentLeftV.backgroundColor = kSepLineColor;
        
        UIView *SegmentRightV = [[UIView alloc]initWithFrame:CGRectMake(caseL.right, firstV.height/2-0.5, caseL.width/2, 1)];
        SegmentRightV.backgroundColor = kSepLineColor;
        
        [firstV addSubview:caseL];
        [firstV addSubview:SegmentLeftV];
        [firstV addSubview:SegmentRightV];
        
        UIButton *allArticBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allArticBtn.frame = CGRectMake(firstV.width-80,0,80,firstV.height);

        [allArticBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        allArticBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        
        if (isHavePower) {
            [allArticBtn setImage:[UIImage imageNamed:@"bianji-0"] forState:UIControlStateNormal];
            [allArticBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -25)];
        }
        else{
            [allArticBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
            [allArticBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
            [allArticBtn setTitle:@"全部文章" forState:UIControlStateNormal];
            [allArticBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        }
        
        [allArticBtn addTarget:self action:@selector(goAllBeautifulArtController) forControlEvents:UIControlEventTouchUpInside];
        
        [firstV addSubview:allArticBtn];
        
        return view;
        
    }
    if (section==4) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 52)];
        view.backgroundColor = kSepLineColor;
        
        UIView *firstV = [[UIView alloc]initWithFrame:CGRectMake(0, 6, kSCREEN_WIDTH, 40)];
        firstV.backgroundColor = White_Color;
        
        
        
        [view addSubview:firstV];
        
        UILabel *caseL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-(70/2), 0, 70, firstV.height)];
        caseL.text = @"商品展示";
        caseL.textColor = COLOR_BLACK_CLASS_3;
        caseL.font = NB_FONTSEIZ_NOR;
        caseL.textAlignment = NSTextAlignmentCenter;
        
        UIView *SegmentLeftV = [[UIView alloc]initWithFrame:CGRectMake(caseL.left-caseL.width/2, firstV.height/2-0.5, caseL.width/2, 1)];
        SegmentLeftV.backgroundColor = kSepLineColor;
        
        UIView *SegmentRightV = [[UIView alloc]initWithFrame:CGRectMake(caseL.right, firstV.height/2-0.5, caseL.width/2, 1)];
        SegmentRightV.backgroundColor = kSepLineColor;
        
        [firstV addSubview:caseL];
        [firstV addSubview:SegmentLeftV];
        [firstV addSubview:SegmentRightV];
        
        UIButton *allArticBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allArticBtn.frame = CGRectMake(firstV.width-80,0,80,firstV.height);

        [allArticBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        allArticBtn.titleLabel.font = NB_FONTSEIZ_NOR;

        [allArticBtn addTarget:self action:@selector(goAllGoodsController) forControlEvents:UIControlEventTouchUpInside];
        
        [firstV addSubview:allArticBtn];
       
        if (isHavePower) {
            [allArticBtn setImage:[UIImage imageNamed:@"bianji-0"] forState:UIControlStateNormal];
            [allArticBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -25)];
        }
        else{
            [allArticBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
            [allArticBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
            [allArticBtn setTitle:@"全部商品" forState:UIControlStateNormal];
            [allArticBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        }
        
        return view;
        
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section==4) {
        UIView *view = [[UIView alloc]init];
        
        NSString *breowerStr = [NSString stringWithFormat:@"浏览量 %ld",self.cardModel.scanNumbers];
        UILabel *broserL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        broserL.text = breowerStr;
        broserL.textColor = COLOR_BLACK_CLASS_3;
        broserL.font = NB_FONTSEIZ_NOR;
        broserL.textAlignment = NSTextAlignmentCenter;
        CGSize sizeOne = [breowerStr boundingRectWithSize:CGSizeMake(120, 50) withFont:NB_FONTSEIZ_NOR];
        broserL.frame = CGRectMake(10, 0, sizeOne.width+5, 50);
        
        [view addSubview:broserL];
        
        
        UIView *zanV = [[UIView alloc]initWithFrame:CGRectMake(broserL.right+5,(50-20)/2,80,20)];
        [view addSubview:zanV];
        
        UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zanBtn.frame = CGRectMake(0,(zanV.height-16)/2,18,16);

        if (!isHaveZan) {
            [zanBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        }
        else{
            [zanBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        }
        [zanBtn addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [zanV addSubview:zanBtn];
        
        UILabel *zanL = [[UILabel alloc]initWithFrame:CGRectMake(zanBtn.right+5, zanBtn.top, 50, zanBtn.height)];
        zanL.text = [NSString stringWithFormat:@"%@",self.cardModel.likeNumbers];
        zanL.textColor = COLOR_BLACK_CLASS_3;
        zanL.font = NB_FONTSEIZ_NOR;
        zanL.textAlignment = NSTextAlignmentLeft;
        [zanV addSubview:zanL];
        return view;
    }
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (indexPath.section==0) {
        NewMyPersonCardTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMyPersonCardTwoCell"];
        [cell configData:self.cardModel];
        cell.delegate = self;
#if DELETEHUANXIN
        // (@"注释掉环信")
#else
        //(@"打开环信代码")
        cell.buttonSendMessage.hidden = self.cardModel.agencyId == userModel.agencyId ?true:false;
#endif
        cell.blockDidTouchButtonMessage = ^{
            SiteGroupChatViewController *controller = [[SiteGroupChatViewController alloc] initWithConversationChatter:self.cardModel.huanXinId conversationType:EMConversationTypeChat];
            controller.chatTitle = self.cardModel.trueName;
            [self.navigationController pushViewController:controller animated:true];
        };
        return cell;
    }
    else if (indexPath.section==1) {
        NewMyPersonCardThreeCell *cell = [NewMyPersonCardThreeCell cellWithTableView:tableView indexpath:indexPath];
        [cell configWith:self.cardModel.indu];
        _cellThreeh = cell.cellH;
        
        return cell;
    }
    else if (indexPath.section==2) {
        NewMyPersonCardFourCell *cell = [NewMyPersonCardFourCell cellWithTableView:tableView indexpath:indexPath];
        cell.delegate = self;
        [cell configData:self.conListArray];
        
        if (isHavePower) {
            [cell.allCaseBtn setImage:[UIImage imageNamed:@"bianji-0"] forState:UIControlStateNormal];
            [cell.allCaseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -25)];
        }
        else{
            [cell.allCaseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
            [cell.allCaseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
            [cell.allCaseBtn setTitle:@"全部案例" forState:UIControlStateNormal];
            [cell.allCaseBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        }
        
        _cellFourH = cell.cellH;
        return cell;
    }
    else if (indexPath.section==3) {
        NewMyPersonCardFiveCell *cell = [NewMyPersonCardFiveCell cellWithTableView:tableView indexpath:indexPath];
        [cell configData:self.artListArray[indexPath.row]];

        return cell;
    }
    
    else if (indexPath.section==4) {
        NewMyPersonCardSixCell *cell = [NewMyPersonCardSixCell cellWithTableView:tableView indexpath:indexPath];
        cell.delegate = self;
        [cell configData:self.goodListArray];
        _cellSixH = cell.cellH;

        return cell;
    }
    else{
        return [[UITableViewCell alloc]init];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==3) {
        BeautifulArtCardModel *model = self.artListArray[indexPath.row];
        if (model.type == 2) {
            //个人
            MyBeautifulArtShowController *vc = [[MyBeautifulArtShowController alloc]init];
            vc.designsId = model.designsId;
            vc.activityType = model.activityId?3:2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (model.type == 3) {
            //公司
            
            NewsActivityShowController *VC = [[NewsActivityShowController alloc] init];
            VC.activityType = 2;
            VC.designsId = model.designsId;
            VC.activityType = model.activityId?3:2;
            VC.companyId = [NSString stringWithFormat:@"%ld",model.companyId];
            VC.companyName = model.companyName;
            VC.companyLogo = model.companyLogo;
            VC.companyLandLine = model.companyLandline;
            VC.companyPhone = model.companyPhone;
            VC.origin = @"2";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/5033/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 三点按钮
- (void)moreBtnClicked:(UIButton *)sender {
    
    // 弹出的自定义视图
    NSArray *array;
    
    if (!isHavePower) {
        
        
        if ([self.cardModel.collectionId integerValue]<=0) {
            //未收藏
            array = @[@"收藏",@"分享"];
        }
        else{
            array = @[@"取消收藏",@"分享"];
        }
        
    } else {
        
        array = @[@"编辑封面", @"编辑资料", @"精英推荐", @"分享"];
    }
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        
        NSString *contStr = array[index];
        if ([contStr isEqualToString:@"收藏"]) {
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录
                //                LoginViewController *loginVC = [[LoginViewController alloc]init];
                //                [self.navigationController pushViewController:loginVC animated:YES];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
            }
            else{
                //调用收藏接口
                [self collectData];
            }
        }
        else if ([contStr isEqualToString:@"取消收藏"]) {
            BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            if (!isLogin) { // 未登录
                //                LoginViewController *loginVC = [[LoginViewController alloc]init];
                //                [self.navigationController pushViewController:loginVC animated:YES];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再取消收藏"];
            }
            else{
                //调用取消收藏接口
                [self cancleCollectData];
            }
        }
        else if ([contStr isEqualToString:@"分享"]) {
            self.shadowView.hidden = NO;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
            } completion:^(BOOL finished) {
                self.shadowView.hidden = NO;
            }];
        }
        
        else if ([contStr isEqualToString:@"编辑封面"]) {
            PersonCoverController *vc = [[PersonCoverController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        else if ([contStr isEqualToString:@"编辑资料"]) {
            EditInfoViewController *vc = [[EditInfoViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([contStr isEqualToString:@"精英推荐"]) {
            if (self.cardModel.eliteDesignId == 0) {//精英推荐Id（0没有，大于0有故事）
                PushToLocalViewController *controller = [PushToLocalViewController new];
                controller.companyId = self.cardModel.companyId;
                [self.navigationController pushViewController:controller animated:true];
            }else{//有精英故事
                EliteDetailViewController *vc = [[EliteDetailViewController alloc]init];
                vc.designsId = self.cardModel.eliteDesignId;
                vc.activityType = 2;
                vc.id = self.cardModel.agencyId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } animated:YES];
    
}

#pragma mark - 分享相关

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
    
    self.TwoDimensionCodeView.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
}

- (void)didClickShareContentBtn:(UIButton *)btn {
    
    NSString *shareTitle = [NSString stringWithFormat:@"%@的名片",self.cardModel.trueName];
    NSString *shareDescription = self.cardModel.comment.length>0?self.cardModel.comment:@"";
    if (shareDescription.length>30) {
        shareDescription = [shareDescription substringToIndex:30];
    }

    NSURL *shareImageUrl;

    shareImageUrl = [NSURL URLWithString:self.cardModel.photo];
    
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (img) {
                [message setThumbImage:img];
            } else {
                UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                [message setThumbImage:image];
            }
            
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%ld.htm",self.cardModel.agencyId]];
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                
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
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (img) {
                [message setThumbImage:img];
            } else {
                [message setThumbImage:[UIImage imageNamed:@"shareDefaultIcon"]];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%ld.htm",self.cardModel.agencyId]];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                
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
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%ld.htm",self.cardModel.agencyId]];
                
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];

                QQApiNewsObject *newObject;
                if (img) {
       
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    //                    NSData *dataOne = UIImagePNGRepresentation(image);
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    
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
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%ld.htm",self.cardModel.agencyId]];;
                //                NSURL *url = [NSURL URLWithString:shareURL];
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                
                QQApiNewsObject *newObject;
                if (img) {
                    //                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageURL:shareImageUrl];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    //                    NSData *data = UIImagePNGRepresentation(image);
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
//                    [MobClick event:@"ConstructionDiaryShare"];
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
        {// 生成二维码
            self.TwoDimensionCodeView.hidden = NO;
            self.navigationController.navigationBar.alpha = 0;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 添加二维码
- (void)addTwoDimensionCodeView{
    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    
    self.TwoDimensionCodeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    NSString *shareUrl = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%ld.htm",self.cardModel.agencyId]];
    
    UIImage *img;
    if (self.cardModel.photo&&self.cardModel.photo.length>0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.cardModel.photo]];
        img = [UIImage imageWithData:data];
    }
    else{
        img = [UIImage imageNamed:@"shareDefaultIcon"];
    }
    
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kSCREEN_WIDTH, 40)];
    
    nameL.textColor = COLOR_BLACK_CLASS_3;
    nameL.font = [UIFont boldSystemFontOfSize:24];
    nameL.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:self.cardModel.trueName?:@"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
    
    NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
    
    NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"的名片" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringThree];
    
    nameL.attributedText = tempAttrStringOne;
    [self.TwoDimensionCodeView addSubview:nameL];
    
    UIImageView *photoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/4, nameL.bottom+10, kSCREEN_WIDTH/2, kSCREEN_WIDTH/2)];
    photoImgV.layer.masksToBounds = YES;
    photoImgV.contentMode = UIViewContentModeScaleAspectFill;
    photoImgV.image = img;
    [self.TwoDimensionCodeView addSubview:photoImgV];
    
    UILabel *companyL = [[UILabel alloc]initWithFrame:CGRectMake(0, photoImgV.bottom+5, kSCREEN_WIDTH, 40)];
    companyL.text = self.cardModel.companyName;
    companyL.textColor = COLOR_BLACK_CLASS_3;
    companyL.font = [UIFont systemFontOfSize:20];
    companyL.textAlignment = NSTextAlignmentCenter;
    [self.TwoDimensionCodeView addSubview:companyL];
    
    
        UILabel *jobL = [[UILabel alloc]initWithFrame:CGRectMake(0, companyL.bottom, kSCREEN_WIDTH, 40)];
        jobL.text = self.cardModel.companyJob;
        jobL.textColor = COLOR_BLACK_CLASS_3;
        jobL.font = [UIFont systemFontOfSize:20];
        jobL.textAlignment = NSTextAlignmentCenter;
        [self.TwoDimensionCodeView addSubview:jobL];
    
    
    UIImageView *qrImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/3, jobL.bottom, kSCREEN_WIDTH/3, kSCREEN_WIDTH/3)];
    qrImgV.layer.masksToBounds = YES;
    qrImgV.contentMode = UIViewContentModeScaleAspectFill;
    [self.TwoDimensionCodeView addSubview:qrImgV];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *finallImg = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareUrl logoImageName:nil logoScaleToSuperView:0.3];
            qrImgV.image = finallImg;
        });
    });
    
    UILabel *bottomOneL = [[UILabel alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40-10, kSCREEN_WIDTH, 40)];
    bottomOneL.text = @"在微信环境下按住图片识别二维码打开";
    bottomOneL.textColor = COLOR_BLACK_CLASS_3;
    bottomOneL.font = [UIFont systemFontOfSize:14];
    bottomOneL.textAlignment = NSTextAlignmentCenter;
    [self.TwoDimensionCodeView addSubview:bottomOneL];
    
    
    UILabel *bottomTwoL = [[UILabel alloc]initWithFrame:CGRectMake(0, bottomOneL.top-40, kSCREEN_WIDTH, 40)];
    bottomTwoL.text = @"截屏保存到相册";
    bottomTwoL.textColor = COLOR_BLACK_CLASS_3;
    bottomTwoL.font = [UIFont systemFontOfSize:14];
    bottomTwoL.textAlignment = NSTextAlignmentCenter;
    [self.TwoDimensionCodeView addSubview:bottomTwoL];
    
    self.TwoDimensionCodeView.hidden = YES;
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

#pragma mark - NewMyPersonCardTwoCellDelegate

-(void)careSomeThing:(NewMyPersonCardTwoCell *)cell{
     [[PublicTool defaultTool] publicToolsHUDStr:@"暂未开通" controller:self sleep:1.5];
    return;
    
    if (isHaveGuanzhu) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已经关注过该名片了"];
        return;
    }
    
}

- (void)flowerSomeThing:(NewMyPersonCardTwoCell *)cell{
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (self.agencyId.integerValue == userModel.agencyId) {//自己
        FlowersListViewController *controller = [FlowersListViewController new];
        controller.personId = GETAgencyId;
        [self.navigationController pushViewController:controller animated:true];
    }else{//赠送鲜花
        SendFlowersViewController *controller = [SendFlowersViewController new];
        controller.agencyId = self.agencyId;
        controller.cell = cell;
        controller.blockIsPay = ^(BOOL isPay) {
            if (isPay) {
                [self requestInfo];
            }
        };
        [self.navigationController pushViewController:controller animated:true];
    }
}

-(void)flagSomeThing:(NewMyPersonCardTwoCell *)cell{
     UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (self.agencyId.integerValue == userModel.agencyId) {
        // 自己
        BannerListViewController *bannerList = [BannerListViewController new];
        bannerList.agencyID = self.agencyId;
        [self.navigationController pushViewController:bannerList animated:YES];
        
    } else {
        // 其他人
        
        JinQiViewController *jinqi =[[JinQiViewController alloc]init];
        jinqi.agencyId =self.agencyId;
        jinqi.isSendFromCompany=NO;
        jinqi.companyId =[NSString stringWithFormat:@"%d",self.cardModel.companyId];
      
         [self.navigationController pushViewController:jinqi animated:YES];
//        EditBannerViewController *vc = [EditBannerViewController new];
//        vc.agencyId = self.agencyId;
//        vc.companyId =  [NSString stringWithFormat:@"%d",self.cardModel.companyId];
//
//        vc.completionBlock = ^{
//            self.cardModel.banner = [NSString stringWithFormat:@"%d", self.cardModel.banner.integerValue + 1];
//            cell.bannerNumberLabel.text = [NSString stringWithFormat:@"锦旗：%ld", (long)self.cardModel.banner.integerValue];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)refreshData:(NSNotification *)noti{
 //   NSDictionary *dicr = noti.userInfo;
   // [self requestInfo];
   
    self.cardModel.banner = [NSString stringWithFormat:@"%d", self.cardModel.banner.integerValue + 1];
    NewMyPersonCardTwoCell *cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.bannerNumberLabel.text = [NSString stringWithFormat:@"锦旗：%ld", (long)self.cardModel.banner.integerValue];
    
}
-(void)callPhone{
    NSString *phoneNumber = self.cardModel.phone;
    if (phoneNumber&&phoneNumber.length>0&&![phoneNumber containsString:@"*"]) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    }
    
}

-(void)goCompanyYellowVc{
    NSString *companyId = self.companyDict[@"companyId"];
    NSInteger appVip = [self.companyDict[@"appVip"] integerValue];
    if (companyId&&companyId.length>0&&![companyId isEqualToString:@"0"]) {
        if (appVip==1) {
            if ([self.companyDict[@"companyType"] integerValue]==1018 || [self.companyDict[@"companyType"] integerValue]==1064 ||
                [self.companyDict[@"companyType"] integerValue]==1065) {
                CompanyDetailViewController *VC = [[CompanyDetailViewController alloc] init];
                VC.origin = @"0";
                VC.companyID = companyId;
                VC.companyName = self.companyDict[@"companyName"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{
                ShopDetailViewController *VC = [[ShopDetailViewController alloc] init];
                VC.origin = @"0";
                VC.shopID = companyId;
                VC.shopName = self.companyDict[@"companyName"];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"该公司还未开通企业网会员" controller:self sleep:1.5];
        }
    }
}

-(void)goCompanyAddress{
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.latitude = [self.cardModel.clatitude doubleValue];
    mapVC.longitude = [self.cardModel.clongitude doubleValue];
    //self.dataDic[@"companyAddress"];  // 北京市-北京市-昌平区- 详细地址哦哦哦哦
    mapVC.companyAddress = self.cardModel.companyAddress;
    mapVC.companyName = self.cardModel.companyName.length>0?self.cardModel.companyName:@"";
    [self.navigationController pushViewController: mapVC animated:YES];
}

-(void)goPersonAddress{
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.latitude = [self.cardModel.latitude doubleValue];
    mapVC.longitude = [self.cardModel.longitude doubleValue];
    //self.dataDic[@"companyAddress"];  // 北京市-北京市-昌平区- 详细地址哦哦哦哦
    mapVC.companyAddress = self.cardModel.detailAddress;
    mapVC.companyName = self.cardModel.companyName.length>0?self.cardModel.companyName:@"";
    [self.navigationController pushViewController: mapVC animated:YES];
}

#pragma mark - 查询全部文章

-(void)goAllBeautifulArtController{
    AllPersonBeautilArtController *vc = [[AllPersonBeautilArtController alloc]init];
    vc.isHavePower = isHavePower;
    vc.agencyId = self.agencyId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goAllGoodsController{
    
    if (isHavePower) {
        AllPersonGoodsController *vc = [[AllPersonGoodsController alloc]init];
        vc.companyId = [NSString stringWithFormat:@"%@",[self.companyDict objectForKey:@"companyId"]];
        vc.companyDict = self.companyDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        YellowGoodsListViewController *VC = [YellowGoodsListViewController new];
        VC.fromBack = NO;
        VC.shopId = self.companyDict[@"companyId"];
        VC.shopid = self.companyDict[@"companyId"];
        VC.origin = @"0";
        VC.companyName =  [self.companyDict objectForKey:@"companyName"];
        VC.shareCompanyLogoURLStr = [self.companyDict objectForKey:@"companyLogo"];
        VC.shareDescription = [self.companyDict objectForKey:@"companyIntroduction"];;
        
        //    VC.collectFlag = self.collectFlag;
        
        NSString *companytype = self.companyDict[@"companyType"];
        if (!companytype) {
            companytype = @"0";
        }
        VC.companyType = companytype;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.companyDict[@"companyId"],@"companyId",
                              self.companyDict[@"companyLandline"],@"companyLandline",
                              self.companyDict[@"companyPhone"],@"companyPhone",
                              companytype,@"companyType",
                              nil];
        VC.dataDic = dict;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - NewMyPersonCardFourCellDelegate

-(void)goAllCase{
    AllPersonCaseController *vc = [[AllPersonCaseController alloc]init];
    vc.isHavePower = isHavePower;
    vc.agencyId = self.agencyId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToDiayVC:(NSInteger)tag{
    PersonConListModel *model = self.conListArray[tag];
    if (![model.isConVip integerValue]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"主人还未开通云管理会员" controller:self sleep:1.5];
        return;
    }
    if ([model.companyType integerValue]==1018 ||
        [model.companyType integerValue]==1064 ||
        [model.companyType integerValue]==1065) {
        ConstructionDiaryTwoController *vc = [[ConstructionDiaryTwoController alloc]init];
        vc.consID = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        MainMaterialDiaryController *vc = [[MainMaterialDiaryController alloc]init];
        vc.consID = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - NewMyPersonCardSixCellDelegate
#pragma mark - 进入商品详情
-(void)goGoodsVc:(NSInteger)tag{
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    
    PersonGoodListModel *model = self.goodListArray[tag];
//    YSNLog(@"%@",model);
    vc.goodsID = model.id;
    vc.shopID = [self.companyDict objectForKey:@"companyId"];
    vc.origin = @"0";
    vc.fromBack = NO;
    vc.shopid = [self.companyDict objectForKey:@"companyId"];
    vc.companyType = [self.companyDict objectForKey:@"companyType"];
    vc.phone = [self.companyDict objectForKey:@"companyPhone"];
    vc.telPhone = [self.companyDict objectForKey:@"companyLandline"];

    NSString *merchanStr = [NSString stringWithFormat:@"%@",model.merchantId];
    NSDictionary *dicTwo= [NSDictionary dictionaryWithObjectsAndKeys:merchanStr,@"merchandiesId",
                           [self.companyDict objectForKey:@"companyLandline"]?[self.companyDict objectForKey:@"companyLandline"]:@"",@"companyLandline",
                           [self.companyDict objectForKey:@"companyPhone"]?[self.companyDict objectForKey:@"companyPhone"]:@"",@"companyPhone",
                           [self.companyDict objectForKey:@"companyId"]?[self.companyDict objectForKey:@"companyId"]:@"",@"companyId",
                           [self.companyDict objectForKey:@"companyType"]?[self.companyDict objectForKey:@"companyType"]:@"",@"companyType",
                           nil];

    vc.dataDic = dicTwo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查询名片信息

-(void)requestInfo{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    //personId为名片主人Id,agencyId登录人Id
    NSString *temStr;
    if (isHavePower) {
        temStr = [NSString stringWithFormat:@"businessCard/%ld/%ld.do",user.agencyId,user.agencyId];
    }
    else{
        temStr = [NSString stringWithFormat:@"businessCard/%@/%ld.do",self.agencyId,user.agencyId];
    }
//    temStr = [NSString stringWithFormat:@"businessCard/%ld/%ld.do",user.agencyId,user.agencyId];
//    NSString *defaultApi = [BASEURL stringByAppendingString:@"businessCard/getByAgencyId.do"];
    NSString *defaultApi = [BASEURL stringByAppendingString:temStr];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{
//                               @"agencyId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                //                [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:1.5];
                NSDictionary *cardDict = [[responseObj objectForKey:@"data"] objectForKey:@"cardModel"];
                
                self.cardModel = [PersonCardModel yy_modelWithJSON:cardDict];
                NSDictionary *companyDict = [[responseObj objectForKey:@"data"] objectForKey:@"company"];
                if (self.companyDict) {
                    [self.companyDict removeAllObjects];
                }
                
                //企业网会员：appVip 1
                self.companyDict = [NSMutableDictionary dictionaryWithDictionary:companyDict];
                
                self.cardModel.companyName = [companyDict objectForKey:@"companyName"]?[companyDict objectForKey:@"companyName"]:@"";
                NSString *clongitudeStr = [companyDict objectForKey:@"longitude"];
                self.cardModel.clongitude = clongitudeStr.length>0?clongitudeStr:@"0";
                NSString *clatitudeStr = [companyDict objectForKey:@"latitude"];
                self.cardModel.clatitude = clatitudeStr.length>0?clatitudeStr:@"0";
                
                self.cardModel.companyAddress = [companyDict objectForKey:@"companyAddress"]?[companyDict objectForKey:@"companyAddress"]:@"";
                
                [self addTwoDimensionCodeView];
                
                _videoPlayerView.url = [NSURL URLWithString:self.cardModel.video];
                _musicPlayerView.url = [NSURL URLWithString:self.cardModel.music];
                
                
                if (self.cardModel.music.length<=0) {
                    self.playMusicBtn.userInteractionEnabled = NO;
                } else {
                    self.playMusicBtn.userInteractionEnabled = YES;
                }
                if (self.cardModel.video.length<=0) {
                    self.palyVideoBtn.userInteractionEnabled = NO;
                } else {
                    self.palyVideoBtn.userInteractionEnabled = YES;
                }
                
                //音乐是否自动播放
                
                if (self.cardModel.autoPlay==1&&self.cardModel.music.length>0) {
                    //播放音乐
                    [self.playMusicBtn setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
                    [_musicPlayerView playVideo];
                    _isPlayingMusic = YES;
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
                }
                
                
                
                //工地
                [self.conListArray removeAllObjects];
                NSArray *conListArray = [[responseObj objectForKey:@"data"] objectForKey:@"conList"];
                
                NSArray *tempConListArray = [NSArray yy_modelArrayWithClass:[PersonConListModel class] json:conListArray];
                
                //
                [self.conListArray addObjectsFromArray:tempConListArray];
                
                //美文
                [self.artListArray removeAllObjects];
                NSArray *temArtArray = [[responseObj objectForKey:@"data"] objectForKey:@"designsList"];
                NSArray *artListArray = [NSArray yy_modelArrayWithClass:[BeautifulArtCardModel class] json:temArtArray];
                [self.artListArray addObjectsFromArray:artListArray];
                
                //商品
                NSArray *temGoodArray = [[responseObj objectForKey:@"data"] objectForKey:@"merchandiesList"];
                NSArray *goodsListArray = [NSArray yy_modelArrayWithClass:[PersonGoodListModel class] json:temGoodArray];
                [self.goodListArray removeAllObjects];
                [self.goodListArray addObjectsFromArray:goodsListArray];
                
                [self.tableView reloadData];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 视频播放按钮的隐藏与否

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (self.cardModel.videoImg&&self.cardModel.videoImg.length>0&&index==0){
        self.palyVideoBtn.hidden = NO;
    }
    else{
        self.palyVideoBtn.hidden = YES;
    }
}

#pragma mark - 播放视频

-(void)playVideoAction{
    // 停止音乐播放
    [_musicPlayerView pausePlay];
    [self.playMusicBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
    _isPlayingMusic = NO;
    [[CLGCDTimerManager sharedManager] suspendTimer:CLPlayer_musicTimer];
    
    self.palyVideoBtn.hidden = YES;
    _videoPlayerView.hidden = NO;
    [_videoPlayerView playVideo];
}


#pragma mark - 收藏接口
-(void)collectData{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    //NSString *defaultApi = [BASEURL stringByAppendingString:@"collection/add.do"];
    NSString *defaultApi = [BASEURL stringByAppendingString:POST_ADDSHOUCANG];
    [[UIApplication sharedApplication].keyWindow hudShow];
//    NSDictionary *paramDic = @{@"relId":self.agencyId, @"agencysId":@(user.agencyId),
//                               @"collectionId":@(0),
//                               @"type":@"2"
//                               };
//
    NSDictionary *paramDic = @{@"relId":self.agencyId,@"agencysId":@(user.agencyId),@"type":@"5"};
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"收藏成功" controller:self sleep:1.5];
                [self requestInfo];
                
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已收藏过该店铺" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"收藏失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"收藏失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 取消收藏接口
-(void)cancleCollectData{

    
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"collectionId":@([self.cardModel.collectionId integerValue])
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"已取消收藏" controller:self sleep:1.5];
                [self requestInfo];
                
            }
            
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"取消失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"取消失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
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

// 播放 音乐
- (void)playMusic:(UIButton *)sender {
    _isPlayingMusic = !_isPlayingMusic;
    if (_isPlayingMusic) {
        // 停止视频播放
        [_videoPlayerView pausePlay];
        
//        self.musicPlayerView.url = [NSURL URLWithString:self.cardModel.music];
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

}

#pragma mark - action

-(void)zanClick:(UIButton *)btn{
    if (!isHaveZan) {
      
        NSString *defaultApi = [BASEURL stringByAppendingString:@"businessCard/thumUp.do"];
        
        [[UIApplication sharedApplication].keyWindow hudShow];
        NSDictionary *paramDic = @{@"cardId":@(self.cardModel.cardId)
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                if (statusCode==1000) {
                    //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                    isHaveZan = YES;
                    [self requestInfo];
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞成功" controller:self sleep:1.5];
                
                    
                }
                else if (statusCode==2000) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞失败" controller:self sleep:1.5];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞失败" controller:self sleep:1.5];
                }
                
            }
            
            //        NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
            YSNLog(@"%@",errorMsg);
        }];
    }
}

// 头部视频播放
- (void)setupPlayerView:(UIView *)headerView {
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 265)];
    
    _videoPlayerView = playerView;
    [headerView addSubview:_videoPlayerView];
    _videoPlayerView.hidden = YES;
    _videoPlayerView.delegate = self;
    
    _videoPlayerView.progressBufferColor = Clear_Color;
    
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

#pragma mark - lazy

-(UIView *)headerView{
    if (!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 330)];
        _headerView.backgroundColor = kBackgroundColor;
        self.adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 265) delegate:self placeholderImage:nil];
        self.adScrollView.autoScroll = NO;
        self.adScrollView.showPageControl = YES;
        self.adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.adScrollView.backgroundColor = Black_Color;
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
        self.adFlagLabel.text = @"1/5";
        
        self.adFlagLabel.hidden = YES;
        
        [self setupPlayerView:self.headerView];
        
        UIButton *playVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playVideoBtn.frame = CGRectMake(kSCREEN_WIDTH/2-20, self.adScrollView.height/2-20, 40, 40);
        [self.headerView addSubview:playVideoBtn];
        [playVideoBtn setBackgroundImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        [playVideoBtn addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];

        // 歌曲视图
        UIView *musicView = [[UIView alloc] initWithFrame:CGRectMake(0, self.adScrollView.bottom + 5, kSCREEN_WIDTH, 60)];
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

    }
    return _headerView;
}

@end
