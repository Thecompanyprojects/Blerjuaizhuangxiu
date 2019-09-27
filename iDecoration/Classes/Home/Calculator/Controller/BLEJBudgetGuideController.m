//
//  BLEJBudgetGuideController.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//
#import "BLEJBudgetGuideController.h"
#import "SubsidiaryModel.h"
#import "VIPExperienceShowViewController.h"
#import "BLEJBudgetGuideCell.h"
#import "BLEJBudgetPriceController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "CoatingCalculaterController.h"
#import "FloorBoardCalculaterController.h"
#import "WallPaperCalculatorController.h"
#import "WallTitleCalculaterController.h"
#import "CurtainCalculateController.h"
#import "FloorTitleCalculaterController.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseCell.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "ConstructionDiaryViewController.h"
#import "ZCHCalculatorSelectRoomNumView.h"
#import "ZCHCalculatorSimpleOfferModel.h"
#import "SDCycleScrollView.h"
#include <CoreGraphics/CoreGraphics.h>
#include <ImageIO/ImageIOBase.h>
#import <ImageIO/ImageIO.h>
#import <sys/utsname.h>
#import "AdvertisementWebViewController.h"
#import "ConstructionDiaryTwoController.h"
#import "ComplainViewController.h"
#import "ZCHCooperateListModel.h"
#import "ZCHPublicWebViewController.h"
#import "senceModel.h"
#import "HomeDefaultModel.h"
#import "senceWebViewController.h"
#import "YellowPageCompanyTableViewCell.h"
#import "CompanyDetailViewController.h"
#import "shopDetailView.h"
#import "ShopDetailViewController.h"
#import "BuildCaseViewController.h"
#import "PanoramaViewController.h"
#import "YellowGoodsListViewController.h"
#import "HistoryActivityViewController.h"
#import "WQLPaoMaView.h"
#import "BLEJGuideVcCollectionViewCell.h"
#import "BLEJGuideCollectionLayout.h"

@interface BLEJBudgetGuideController ()<UITableViewDataSource, UITableViewDelegate, BLEJBudgetGuideCellDelegate, ZCHCalculatorSelectRoomNumViewDelegate, SDCycleScrollViewDelegate,YellowPageCompanyTableViewCellDelegate,shopDetailViewDelagate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource> {
    NSString * _bottomImageURL;
    dispatch_source_t _timer;
    NSIndexPath *currentIndex;
    NSInteger   _selectedIndex;
    CGFloat  _dragEndX;
    CGFloat  _dragStartX;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionV;
// 顶部图片
@property (strong, nonatomic) UIImageView *iconView;
// 标记验证码是否发送
@property (assign, nonatomic) BOOL isSendCode;
// 标记发送的验证码是那种类型(主要处理1000 用户已经用这个手机号验证过了就不需要发送验证码  也就是不需要填写验证码)
@property (assign, nonatomic) NSInteger testCodeType;

@property (strong, nonatomic) ZCHCalculatorSelectRoomNumView *bottomView;

@property (strong, nonatomic) SDCycleScrollView *topScrollVew;
@property (strong, nonatomic) SDCycleScrollView *topCycleSV2;
@property (strong, nonatomic) UITextField *signUpNumberLabel;
@property (strong, nonatomic) UIImageView *bottomImage;

@property (nonatomic, assign) BOOL hasSupport; // 是否点赞
@property (nonatomic, strong) UIButton *supportButton;
@property(nonatomic,assign)CGSize bottomSize;
@property (nonatomic, strong) UILabel *scanCountLabel; // 浏览量
@property (nonatomic, strong) UIView *btnCollectionView; // 浏览量
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) NSMutableArray *picArrHref;
@property(nonatomic,weak)NSTimer *timerScrollView;
@end

static NSString *reuseIdentifier = @"ZCHBudgetGuideConstructionCaseCell";
static NSString *reuseShopIdentifier = @"shop";
static NSString *reuseCompanyIdentifier = @"company";

@implementation BLEJBudgetGuideController

- (void)Network {
    ShowMB
    NSString *URL = @"calculator/v2/getTempletByCompanyId.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"companyId"] = self.companyID;
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        HiddenMB
        if ([result[@"code"] integerValue] == 1000) {
            NSDictionary *dicData = result[@"data"];
          
            //了解我们
            self.homeModel = [HomeDefaultModel yy_modelWithJSON:dicData[@"company"]];
            //全景图viewList
            self.viewList = [NSArray yy_modelArrayWithClass:[senceModel class] json:dicData[@"viewList"]].mutableCopy;
            //广告(上)
            self.topImageArr = dicData[@"headImages"];
            //广告(下)
            self.bottomImageArr = dicData[@"footImages"];
            //经典案例
            self.constructionCase = [NSArray yy_modelArrayWithClass:[ZCHBudgetGuideConstructionCaseModel class] json:dicData[@"conList"]].mutableCopy;
            //合作企业
            self.cooperateArr = [NSArray yy_modelArrayWithClass:[ZCHCooperateListModel class] json:dicData[@"enterPriseList"]].mutableCopy;
            //播报
            self.userPhoneArray = dicData[@"phoneList"];
            if (self.topImageArr.count > 0) {
                self.topCycleSV2.imageURLStringsGroup = [self.topImageArr  valueForKeyPath:@"picUrl"];
            }
            [self makeWQLPaoMaView];
            [self addFootview];
            [self.tableView reloadData];
        }
    } fail:^(id error) {
        HiddenMB
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"装修快速预算";
    _picArr =[NSMutableArray array];
    _picArrHref=[NSMutableArray array];
    self.isSendCode = NO;
    self.testCodeType = -1;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     self.tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHBudgetGuideConstructionCaseCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:@"YellowPageCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:reuseCompanyIdentifier];
    [self Network];
    [self clickChooseRoomCountView];
    [self setScrollView];
}

-(void)setupTimer{
    _timerScrollView = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(switchItems) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timerScrollView forMode:NSRunLoopCommonModes];
}
- (void)invalidateTimer
{
    [_timerScrollView invalidate];
    _timerScrollView = nil;
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}


- (void)setScrollView {
    NSString *path =   [[NSBundle mainBundle]pathForResource:@"decorationProject.jpg" ofType:nil];
    
    self.topCycleSV2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJWidth*0.6) delegate:self placeholderImage:[UIImage imageWithContentsOfFile:path]];
    self.topCycleSV2.backgroundColor = [UIColor blackColor];
    self.topCycleSV2.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.topCycleSV2.autoScrollTimeInterval = BANNERTIME;
    self.tableView.tableHeaderView = self.topCycleSV2;
    
}
-(UICollectionView*)collectionV{
    if (_collectionV ==nil) {
        BLEJGuideCollectionLayout *layout = [BLEJGuideCollectionLayout new];
        layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
       _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth,BLEJWidth*0.6) collectionViewLayout:layout];
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.showsVerticalScrollIndicator = YES;
        _collectionV.showsHorizontalScrollIndicator = YES;
        [_collectionV registerNib:[UINib nibWithNibName:NSStringFromClass([BLEJGuideVcCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"BLEJGuideVcCollectionViewCell"];
    }
    return _collectionV;
}

- (void)makeWQLPaoMaView {
    // 跑马视图
    NSMutableAttributedString *mulattrStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < self.userPhoneArray.count; i ++) {
        if ([self.userPhoneArray[i] integerValue] == 0 || [self.userPhoneArray[i] isEqualToString:@""]) {
            continue ;
        }
        NSString *phoneStr =[NSString stringWithFormat:@"%@", self.userPhoneArray[i]];
        if (phoneStr.length > 6) {
            phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        NSString *str = [NSString stringWithFormat:@"手机号为%@的业主已经报名成功            ",phoneStr];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:225/255.0 green:56/255.0 blue:45/255.0 alpha:1.0] range:NSMakeRange(4, 11)];
        [mulattrStr appendAttributedString:attrStr];
    }
    UIView *paomaBackView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJWidth*0.6 -20, BLEJWidth, 20)];
    paomaBackView.backgroundColor =[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    WQLPaoMaView *paomaView = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(32, 0, kSCREEN_WIDTH - 32, 20) withAttributeTitle:mulattrStr];
    [paomaBackView addSubview:paomaView];
    UIView *imageBackViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
    imageBackViews.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    UIImageView *imaga = [[UIImageView alloc] initWithFrame:CGRectMake(8, 1, 20, 18)];
    imaga.image = [UIImage imageNamed:@"yellowPage_singup_ad"];
    [imageBackViews addSubview:imaga];
    [paomaBackView addSubview:imageBackViews];
    if (  mulattrStr ==nil || mulattrStr.length ==0) {
        imageBackViews.hidden =YES;
        paomaBackView.hidden=YES;
    }else{
        imageBackViews.hidden=NO;
        paomaBackView.hidden=NO;
    }
    [self.topCycleSV2 addSubview:paomaBackView];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }
    
      [self.tableView reloadData];
}

// 设置浏览量视图
- (UIView *)setScanFooterView {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];
    
    UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 0, 50)];
    [footView addSubview:scanLabel];
    scanLabel.font = [UIFont systemFontOfSize:14];
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
    
    UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(displayCount.right + 10, 0, 44, 44)];
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
    
    self.tableView.tableFooterView = footView;
    
    UIView *v = footView;
    return v;
    
}
#pragma mark - 点赞按钮的点击事件
- (void)didClickGoodBtn:(UIButton *)btn {
    
    if (!_hasSupport) {
        _hasSupport = YES;
        
        [btn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        self.goodCountLabel.text = [NSString stringWithFormat:@"%ld", [self.goodCountLabel.text integerValue] + 1];
        [self.goodCountLabel sizeToFit];
        
        NSString *apiStr = [BASEURL stringByAppendingString:@"company/calculatorLike.do"];
        NSDictionary *param = @{
                                @"companyId" : self.companyID
                                };
        [NetManager afGetRequest:apiStr parms:param finished:^(id responseObj) {
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    
}
#pragma mark - 投诉按钮的点击事件
- (void)didClickComplainBtn:(UIButton *)btn {
    
    ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
    ComplainVC.companyID = self.companyID.integerValue;
    ComplainVC.complainFrom = 3;
    [self.navigationController pushViewController:ComplainVC animated:YES];
}

#pragma mark - 获取点赞量和浏览量数据

- (void)getLikeNumAndScanNum {

  NSString *strings=   [BASEURL stringByAppendingFormat:BLEJCalculatorGetTempletByCompanyIdUrl];

    NSString *url = strings;;
    NSDictionary *param = @{
                            @"companyId": @(self.companyID.integerValue)
                            };
    [NetManager afGetRequest:url parms:param finished:^(id responseObj) {
        //NSDictionary *dataDic = [responseObj objectForKey:@"data"];
        
    } failed:^(NSString *errorMsg) {
        
    }];
}


#pragma mark - 添加底部视图
- (void)addFootview {
    if (self.bottomImageArr.count > 0) {
        // 有底部图片
        __weak typeof(self) weakSelf = self;
       
         dispatch_async(dispatch_get_main_queue(), ^{
            if ([((NSString *)self.bottomImageArr.firstObject[@"picUrl"]) containsString:@".webp"]) {
                // webp格式的图片不显示
                [self  setScanFooterView];
            } else {
                NSString *url = self.bottomImageArr.firstObject[@"picUrl"];
                CGSize bottomSize = [weakSelf calculateImageSizeWithSize:[weakSelf getImageSizeWithURL:[NSURL URLWithString:url]] andType:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 底部视图
                    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100 + bottomSize.height)];
                    UIImageView *bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bottomSize.width, bottomSize.height)];
                    [bottomImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
                    bottomImage.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBottomImageWebSite:)];
                    [bottomImage addGestureRecognizer:tapGR];
                    [bottomBgView addSubview:bottomImage];
                    weakSelf.bottomImage = bottomImage;
                    // 浏览量
                    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomSize.height, kSCREEN_WIDTH, 100)];
                    
                    //    UIImageView *scanIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
                    //    scanIV.frame = CGRectMake(16, 15, 30, 15);
                    //    [footView addSubview:scanIV];
                    
                    UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 0, 50)];
                    [footView addSubview:scanLabel];
                    scanLabel.font = [UIFont systemFontOfSize:14];
                    scanLabel.textColor = [UIColor darkGrayColor];
                    scanLabel.text = @"浏览量";
                    [scanLabel sizeToFit];
                    
                    UILabel *displayCount = [[UILabel alloc] initWithFrame:CGRectMake(scanLabel.right + 10, 0, 0, 50)];
                    self.scanCountLabel = displayCount;
                    [footView addSubview:displayCount];
                    displayCount.textAlignment = NSTextAlignmentRight;
                    displayCount.font = [UIFont systemFontOfSize:16];
                    displayCount.textColor = [UIColor darkGrayColor];
                    displayCount.text = self.display;
                    [displayCount sizeToFit];
                    
                    UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(displayCount.right + 10, 0, 44, 44)];
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
                    goodCount.text = self.goodcount;
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
                    
                    [bottomBgView addSubview:footView];
                    
                    weakSelf.tableView.tableFooterView = bottomBgView;
                //    [weakSelf.tableView reloadData];
                });
            }
        });
    }
    
}
-(void)clickChooseRoomCountView{
    
    ZCHCalculatorSelectRoomNumView *bottomView = [[ZCHCalculatorSelectRoomNumView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    bottomView.hidden = YES;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return self.viewList.count > 0 ? 1 : 0;
    }else if (section == 3) {
        return 1;
    }else if (section == 4) {
        return self.cooperateArr.count > 0 ? 1 : 0;
    }else if (section == 5) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//装修报价
        BLEJBudgetGuideCell *cell = [BLEJBudgetGuideCell blej_viewFromXib];
        cell.BLEJBudgetGuideCellDelegate = self;
        if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
            cell.isShowTelNum = true;
        }
        return cell;
    } else if(indexPath.section == 1){//经典案例
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        // 图片 5：3  左右边距 8  图片底部文字高度20 上下边距8   (kSCREEN_WIDTH - 32)/2.0 * 3/5.0 + (20 + 16)
        NSInteger imageWith = (kSCREEN_WIDTH - 32)/2.0;
        NSInteger imageHeigt = imageWith * 3/5.0;
        NSInteger margin = 8;
        NSInteger textHeigt = 20;
        NSInteger viewHeight = imageHeigt + margin * 2 + textHeigt;
        NSInteger viewWidht = margin * 2 + imageWith;
        NSInteger count =self.constructionCase.count<6 ?self.constructionCase.count:6;
        for (int i = 0; i < count ; i ++) {
            
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
    }else if (indexPath.section ==2){//全景视图
      
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJWidth * 0.6)];
        [self setupTimer];
        
        [self.picArr removeAllObjects];
        if (self.viewList.count > 0) {
            
            for (int i = 0; i < self.viewList.count; i ++) {
                senceModel *model =self.viewList[i];
                [self.picArr addObject:model.picUrl];
            }

        }
           [cell.contentView addSubview: self.collectionV ];
        UIButton *rightB =[[UIButton alloc]init];
        [rightB setFrame:CGRectMake(BLEJWidth*0.8, BLEJWidth*0.6/2 , BLEJWidth/15, BLEJWidth*0.6/5)];
        //rightB.backgroundColor =[UIColor blueColor];
        [rightB setImage:[UIImage imageNamed:@"icon_you"]   forState:UIControlStateNormal];
        [rightB addTarget:self action:@selector(switchItems) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightL =[[UIButton alloc]init];
        [rightL setFrame:CGRectMake(BLEJWidth*0.2, BLEJWidth*0.6/2 , BLEJWidth/15, BLEJWidth*0.6/5)];
        
        [rightL setImage:[UIImage imageNamed:@"icon_zuojiantou"]   forState:UIControlStateNormal];
       // rightL.backgroundColor =[UIColor blueColor];
        [rightL addTarget:self action:@selector(switchIndex:animated:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:rightL];
        [cell.contentView addSubview:rightB];
     
    
        return cell;


            
        
        
    }else if (indexPath.section ==3){//了解我们
        HomeDefaultModel *model = self.homeModel;
        YellowPageCompanyTableViewCell *cell = (YellowPageCompanyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseCompanyIdentifier];
        cell.cellType = YellowPageCompanyTableViewCellTypeAboutUs;
        cell.model = model;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 4){ //合作企业
            self.cooperateCell = [[UITableViewCell alloc] init];
            self.cooperateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.cooperateCell.layer.masksToBounds = YES;
            for (int i = 0; i < self.cooperateArr.count; i ++) {
                
                UIButton *btn = [self  cooperateViewWithModel:self.cooperateArr[i]];
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
               return self.cooperateCell;
        
    }else if (indexPath.section == 5){//算量器
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.btnCollectionView];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > 0) {
        
        if ([self.isConVip integerValue] == 0) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"主人暂未开通云管理会员"];
            return;
        }
        if (indexPath.section == 1){
        ZCHBudgetGuideConstructionCaseModel *model = self.constructionCase[indexPath.row];
        if (model.constructionId && ![model.constructionId isEqualToString:@""] && ![model.constructionId isEqualToString:@"0"]) {
            
            ConstructionDiaryTwoController *diaryVC = [[ConstructionDiaryTwoController alloc]init];
            diaryVC.consID = [model.constructionId integerValue];
            [self.navigationController pushViewController:diaryVC animated:YES];
        }
        } else {
            if (indexPath.section == 3) {
                [self.navigationController popViewControllerAnimated:false];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
            return 350;
        }
            return 220;
    }
    if (indexPath.section == 1 ) {//经典案例
        NSInteger count = 0;
        if (self.constructionCase.count % 2 == 0) {
            
            count = self.constructionCase.count / 2;
        } else {
            
            count =self.constructionCase.count / 2 + 1;
        }
      
        return count * ((kSCREEN_WIDTH - 32) * 0.3 + 36);
    }else if (indexPath.section == 2){//全景视图
        if (self.viewList.count > 0) {
            return BLEJWidth * 0.6;
        } else {
            return 0.001;
        }
    }else if (indexPath.section == 3 ){//了解我们
        return self.homeModel? 120:0.001;
    }else if (indexPath.section == 4 ){//合作企业
        return ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1));
    }else if (indexPath.section == 5 ){//算量器
        return   (kSCREEN_WIDTH/3.0 * 2 + 10);
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
          if (self.userPhoneArray.count)  {
             return 30;
        }else{
            return 0.001;
        }
       
       
    } if (section == 1 && self.constructionCase.count > 0) {
        return 44;
    }else if (section == 2 && self.viewList.count > 0) {
        return 44;
    }else if (section == 3  && self.homeModel) {
        return 44;
    }else if (section == 4 && self.cooperateArr.count > 0) {
        return 44;
    }else if (section == 5) {
        return 44;
    }
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 70;
    }
    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 70)];
        bgView.backgroundColor = kBackgroundColor;
        UIButton *footerView = [[UIButton alloc] initWithFrame:CGRectMake((BLEJWidth - 200) * 0.5, 10, 200, 50)];
        footerView.backgroundColor = kMainThemeColor;
        footerView.layer.cornerRadius = 5;
        footerView.layer.masksToBounds = YES;
        [footerView setTitle:@"生成装修预算" forState:UIControlStateNormal];
        [footerView addTarget:self action:@selector(didClickfooterBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [bgView addSubview:footerView];
        return bgView;
    }
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section ==0) {
     //   UIView *backView =[[UIView alloc]init];
        
        self.signUpNumberLabel=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, 30)];
     //   [backView addSubview:self.signUpNumberLabel];
        self.signUpNumberLabel.textAlignment=NSTextAlignmentCenter;
        // 报名人数
        if (self.userPhoneArray.count) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
            NSString *str0 = [NSString stringWithFormat:@"%ld位", self.userPhoneArray.count];
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
            self.signUpNumberLabel.attributedText = attributedString;
            
            
            if (  self.userPhoneArray.count>0 ) {
                self.signUpNumberLabel.hidden =NO;
            }else{
                self.signUpNumberLabel.hidden =YES;
            }
            return self.signUpNumberLabel;
        }
    }else if (section == 1 && self.constructionCase.count > 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
        caseLabel.backgroundColor = White_Color;
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.textColor = [UIColor lightGrayColor];
        caseLabel.font = [UIFont systemFontOfSize:16];
        NSString *contentStr = @"—— 经典案例 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
        
        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 6)];
        caseLabel.attributedText = str;
        [bgView addSubview:caseLabel];
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 80, 0, 70, 50)];
        [nextBtn setTitle:@"全部案例" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [nextBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(didClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
        [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, -61)];
        [bgView addSubview:nextBtn];
        
        
        return bgView;
    }else if (section == 2 && self.viewList.count > 0) {
        
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
        caseLabel.attributedText = str;
        
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
    }else if (section == 3 ) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [bgView addSubview:bottomView];
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 80, 0, 160, 50)];
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:caseLabel];
        NSString *contentStr = @"—— 了解我们 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 6)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(8, 2)];
        
        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 6)];
        caseLabel.attributedText = str;
       
        
        return bgView;
    }else if (section == 4 && self.cooperateArr.count > 0) {
        
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
        caseLabel.attributedText = str;
        
        return bgView;
    }else if (section ==5) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
        bgView.backgroundColor = kBackgroundColor;
        
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
        Label.backgroundColor = White_Color;
        Label.textAlignment = NSTextAlignmentCenter;
        Label.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:Label];
        NSString *contentStr = @"—— 算量器 ——";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 5)];
        [str addAttribute:NSForegroundColorAttributeName value:kDisabledColor range:NSMakeRange(7, 2)];
        
        [str addAttribute:NSFontAttributeName value: [UIFont fontWithName:@"Helvetica" size:16] range:NSMakeRange(2, 5)];
         Label.attributedText = str;
        return bgView;
    }
    
    
    return [[UIView alloc] init];
    
    
    
}

#pragma  mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *webUrl = self.topImageArr[index][@"picHref"];
    
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
#pragma mark UICollectionViewDelegate 前后切换，滑动，放大，点击切换等
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   

    return  self.picArr.count?:0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    [self.picArrHref removeAllObjects];
    if (self.viewList.count > 0) {
        for (int i = 0; i < self.viewList.count; i ++) {
            senceModel *model =self.viewList[i];
            [self.picArrHref addObject:model.picHref];
        }
    }
    
     BLEJGuideVcCollectionViewCell*CV    = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BLEJGuideVcCollectionViewCell class]) forIndexPath:indexPath];

   
    
    //  CV.IV.contentMode =UIViewContentModeScaleAspectFit;
     CV.IV.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.picArr[indexPath.row]]]];
     return CV;
}

    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *webUrl  = self.picArrHref[indexPath.row];
    if (webUrl.length > 0) {
        if (![webUrl ew_isUrlString]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
            return;
        }
        
        senceWebViewController *sence = [[senceWebViewController alloc]init];
        sence.model.picHref = webUrl;
        sence.companyLogo = self.companyDic[@"companyLogo"];
        sence.companyName = self.companyName;
        [self.navigationController pushViewController:sence animated:YES];
    }
}

-(void)switchIndex:(NSIndexPath*)indexPath animated:(BOOL)animated{
 
    _selectedIndex = _selectedIndex - 1;
    _selectedIndex = _selectedIndex < 0 ? 0 : _selectedIndex;
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    BLEJGuideVcCollectionViewCell*CV    = ( BLEJGuideVcCollectionViewCell*) [self.collectionV cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    CV.IV.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.picArr[_selectedIndex]]]];
}

-(void)switchItems{
    _selectedIndex = _selectedIndex + 1;
    _selectedIndex= _selectedIndex > self.picArrHref.count - 1 ? 0: _selectedIndex;
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow: _selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:nil];
    BLEJGuideVcCollectionViewCell*CV    = ( BLEJGuideVcCollectionViewCell*) [self.collectionV cellForItemAtIndexPath:[NSIndexPath indexPathForRow: _selectedIndex inSection:0]];
    CV.IV.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.picArr[_selectedIndex]]]];
}

//在不使用分页滚动的情况下需要手动计算当前选中位置 -> _selectedIndex
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
  
    if (!self.collectionV.visibleCells.count) {return; }
    if (!scrollView.isDragging) {return;}
        
    CGRect currectRect =self.collectionV.bounds;
    currectRect.origin.x =self.collectionV.contentOffset.x;
    for (BLEJGuideVcCollectionViewCell *cellGuide in self.collectionV.visibleCells) {
      NSInteger indexP =[self.collectionV indexPathForCell:cellGuide].row;
       
        if (indexP != _selectedIndex) {
            _selectedIndex = indexP;
        }
    }
 }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
if ([scrollView isKindOfClass:[UICollectionView class]]) {
   
    _dragStartX =scrollView.contentOffset.x;
     [self invalidateTimer];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 if ([scrollView isKindOfClass:[UICollectionView class]]) {

    
    _dragEndX =scrollView.contentOffset.x;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
      [self setupTimer];
 }
}
//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.collectionV.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionV numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    [self scrollToCenter];
}

//滚动到中间
- (void)scrollToCenter {
        [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
        BLEJGuideVcCollectionViewCell*CV    = ( BLEJGuideVcCollectionViewCell*) [self.collectionV cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    
        CV.IV.image= [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.picArr[_selectedIndex]]]];

}

#pragma mark -
#pragma mark CollectionDelegate

- (void)gotoBottomImageWebSite:(UITapGestureRecognizer *)tapGR {
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
    panorama.origin = self.origin;
    panorama.areaList = self.areaArr;
    panorama.phone = self.companyDic[@"companyLandline"];
    panorama.telPhone = self.companyDic[@"companyPhone"];
    panorama.baseItemsArr = self.baseItemsArr;
    panorama.suppleListArr = self.suppleListArr;
    panorama.calculatorModel = self.calculatorModel;
    panorama.constructionCase = self.constructionCase;
    panorama.topCalculatorImageArr = self.topCalculatorImageArr;
    panorama.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    panorama.companyDic = self.companyDic;
    panorama.code = self.code;
    
    [self.navigationController pushViewController:panorama animated:YES];
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
    VC.topCalculatorImageArr =self.topCalculatorImageArr;;
    VC.bottomCalculatorImageArr =self.bottomCalculatorImageArr;
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
#pragma mark - 跳转到详情
- (void)gotoAnliDetail:(UITapGestureRecognizer *)tapGR {
    
    UIView *view = tapGR.view;
    NSInteger index = view.tag;
    if ([self.isConVip integerValue] == 0) {
        
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


#pragma mark - 生成装修预算点击事件

- (void)didClickfooterBtn:(UIButton *)btn {
    
    BLEJBudgetGuideCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([cell.areaTF.text isEqualToString:@""]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先输入您家的面积！"];
        return;
    }

    NSString *agencyId;
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        
        agencyId = @"";
    } else {
        
        agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    }
    NSString *number = USERDEFAULTSGET(@"account");
    NSDictionary *param = @{
                            @"phone" : cell.phoneNumTF.text.length?cell.phoneNumTF.text:number,
                            @"code" : cell.testCodeTF.text.length?cell.testCodeTF.text:@"0",
                            @"companyId" : self.companyID,
                            @"agencyId" : agencyId,
                            @"area" : cell.areaTF.text,
                            @"bedRoom" : cell.bedroomBtn.titleLabel.text,
                            @"sitingRoom" : cell.sittingRoomBtn.titleLabel.text,
                            @"balcony" : cell.balconyBtn.titleLabel.text,
                            @"kitchen" : cell.kitchenBtn.titleLabel.text,
                            @"diningRoom" : cell.diningRoomBtn.titleLabel.text,
                             @"wash" : cell.bathroomBtn.titleLabel.text,
                            @"salseId" : @"0",
                            @"wechat" : @"1",
                            @"origin":self.origin
                            };
    NSString *api = [BASEURL stringByAppendingString:@"calculatorCustomer/v3/save.do"];
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:api parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj) {
            
            NSInteger code = [responseObj[@"code"] integerValue];

            switch (code) {
                case 1000:
                {
                    BLEJBudgetPriceController *VC = [[BLEJBudgetPriceController alloc] init];
                    VC.houseArea = cell.areaTF.text;
                    VC.bedroomNum = cell.bedroomBtn.titleLabel.text;
                    VC.bathroomNum = cell.bathroomBtn.titleLabel.text;
                    VC.balconyNum = cell.balconyBtn.titleLabel.text;
                    VC.hallNum = cell.sittingRoomBtn.titleLabel.text;
                    VC.kitchenNum = cell.kitchenBtn.titleLabel.text;
                    VC.diningRoomNum = cell.diningRoomBtn.titleLabel.text;
                    VC.calculatorModel = self.calculatorModel;
                    VC.suppleListArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:responseObj[@"data"][@"supplement"]]];
                    if ([responseObj[@"data"][@"hasSimple"] boolValue] == 1) {
                        
                        VC.calculatorTotalModel = [ZCHCalculatorSimpleOfferModel yy_modelWithJSON:responseObj[@"data"][@"simpleOffer"]];
                    }
                    if ([responseObj[@"data"][@"hasHardcover"] boolValue] == 1) {
                        
                        VC.calculatorRefineModel = [ZCHCalculatorSimpleOfferModel yy_modelWithJSON:responseObj[@"data"][@"hardOffer"]];
                    }
                    
                    [self.navigationController pushViewController:VC animated:YES];
                }
                    break;
                case 1001:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证失败，请稍后重试"];
                    break;
                case 1002:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取公司模板失败"];
                    break;
                case 1003:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误或不存在"];
                    break;
                case 1005:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司还没有设置简/精装设置"];
                    break;
                case 2000:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证失败，请稍后重试"];
                    break;
                case 3000:
                {
                    ZCHPublicWebViewController *controller = [[ZCHPublicWebViewController alloc] init];
                    NSDictionary *newdic = [responseObj objectForKey:@"data"];
                    NSString *type = [newdic objectForKey:@"type"];
//                    NSString *typestr = [NSString new];
//                    if (self.isTaocan) {
//                        typestr = @"0";
//                    }
//                    else
//                    {
//                        typestr = @"1";
//                    }
                    NSString *URL = [NSString stringWithFormat:@"api/calculatorpackage/budget.do?companyId=%@&area=%@&type=%@",self.companyID,cell.areaTF.text,type];
                    controller.titleStr = self.title;
                    controller.webUrl = URL;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];

}

#pragma mark - BLEJBudgetGuideCellDelegate方法
- (void)didClickSendTestCodeBtnWithPhoneNumber:(NSString *)phoneNum withBtn:(UIButton *)btn{
    
    if ([phoneNum isEqualToString:@""]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先输入手机号"];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.companyID forKey:@"companyId"];
    [param setObject:phoneNum forKey:@"phone"];
    
    NSString *api = [BASEURL stringByAppendingString:@"calculatorCustomer/checkPhone.do"];
    
    [NetManager afPostRequest:api parms:param finished:^(id responseObj) {
        
        if (responseObj) {
            
            NSInteger code = [responseObj[@"code"] integerValue];
            self.testCodeType = code;
            switch (code) {
                case 1000:
                {
                    BLEJBudgetGuideCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.testCodeTF.text = @"此号码已在该公司验证过";
                    cell.sendTestCodeBtn.hidden = YES;
                    [cell.testCodeTF resignFirstResponder];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.rightMargin.constant = 10;
                    });
                    self.isSendCode = YES;
                }
                    break;
                case 1001:
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"短信发送成功"];
                    self.isSendCode = YES;
                    __block int timeout = 120; //倒计时时间
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(_timer, ^{
                        
                        if(timeout <= 0) { //倒计时结束，关闭
                            
                            dispatch_source_cancel(_timer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示 根据自己需求设置
                                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
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
                    break;
                case 1002:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司已不存在"];
                    self.isSendCode = NO;
                    break;
                case 1003:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"发送失败，请稍后重试"];
                    self.isSendCode = NO;
                    break;
                case 1004:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"今日短信次数已用完，请明日再试"];
                    self.isSendCode = NO;
                    break;
                default:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"发送失败，请稍后重试"];
                    self.isSendCode = NO;
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (void)didClickSelectRoomCount:(NSInteger)count andTitle:(NSString *)title andCurrentIndex:(NSInteger)index andShowZero:(BOOL)showZero {
    
    
    self.bottomView.isFromZero = showZero;
    self.bottomView.count = count;
    self.bottomView.title = title;
    self.bottomView.index = index;
    self.bottomView.hidden = NO;
}

#pragma mark - ZCHCalculatorSelectRoomNumViewDelegate方法(选择完各种类型房间的数量)
- (void)didClickRoomCount:(NSInteger)roomCount {
    
    self.bottomView.hidden = YES;
    BLEJBudgetGuideCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.currentBtn setTitle:[NSString stringWithFormat:@"%ld", roomCount] forState:UIControlStateNormal];
}
#pragma mark 计算器视图
- (UIView *)btnCollectionView {
    
    if (_btnCollectionView == nil) {
        
        _btnCollectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, (kSCREEN_WIDTH/3.0 * 2 + 10))];
        _btnCollectionView.backgroundColor = kBackgroundColor;
        
        NSArray *imageArr = @[@"coating-1",@"floor-1",@"wallpaper-1",@"brick",@"blind",@"tiles"];
        NSArray *titleArr = @[@"涂料计算器",@"地板计算器",@"壁纸计算器",@"墙砖计算器",@"窗帘计算器",@"地砖计算器"];
        CGFloat kWidth = kSCREEN_WIDTH/3.0 ;
        for (int i = 0; i < titleArr.count; i ++) {
            
            CGFloat X = (i < titleArr.count/2 ? i * kWidth:(i - titleArr.count/2)*kWidth);
            CGFloat Y = (i < titleArr.count/2 ? 0:kWidth) + 5;
            
            shopDetailView *btnView = [[shopDetailView alloc]initWithFrame:CGRectMake(X, Y, kWidth - 1, kWidth - 1)];
            
            [_btnCollectionView addSubview:btnView];
            
            btnView.bgImage.image = [UIImage imageNamed:imageArr[i]];
            [btnView.bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(0);
                make.centerY.equalTo(-10);
                make.size.equalTo(CGSizeMake(kSCREEN_WIDTH/7, kSCREEN_WIDTH/7));
            }];
            btnView.titleLabel.text = titleArr[i];
            CGPoint center = btnView.titleLabel.center;
            center.y = center.y - 10;
            btnView.titleLabel.center = center;
            
            btnView.shopTag = i + 100;
            btnView.delegate = self;
        }
    }
    
    return _btnCollectionView;
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
    
//    if (self.times && [self.times isEqualToString:@"2"]) {
//        return;
//    }
//
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
          //  店铺的详情;
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = model.companyName;
            shop.shopID = model.companyId;
            shop.times = @"2";
            shop.origin = self.origin;
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
    
    //    NSError *err;
    //    if ([url checkResourceIsReachableAndReturnError:&err]) {
    //
    //        NSLog(@"URL is reachable");
    //    } else {
    //        return CGSizeMake(BLEJWidth, 0.001);
    //    }
    //    [self validateUrl:url];
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

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    BLEJBudgetGuideCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.areaTF.text = @"";
    cell.phoneNumTF.text = @"";
    cell.testCodeTF.text = @"";
    [cell.bedroomBtn setTitle:@"1" forState:UIControlStateNormal];
    [cell.sittingRoomBtn setTitle:@"1" forState:UIControlStateNormal];
    [cell.bathroomBtn setTitle:@"1" forState:UIControlStateNormal];
    [cell.balconyBtn setTitle:@"1" forState:UIControlStateNormal];
    [cell.kitchenBtn setTitle:@"1" forState:UIControlStateNormal];
    [cell.diningRoomBtn setTitle:@"1" forState:UIControlStateNormal];
    self.isSendCode = NO;
    if (cell.testCodeTF.hidden == NO) {
        
        cell.rightMargin.constant = 120;
        cell.sendTestCodeBtn.alpha = 0.4;
        [cell.sendTestCodeBtn setEnabled:NO];
        cell.sendTestCodeBtn.hidden = NO;
    }
    
    if (_timer) {
        
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置界面的按钮显示 根据自己需求设置
            [cell.sendTestCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            cell.sendTestCodeBtn.userInteractionEnabled = YES;
            cell.sendTestCodeBtn.backgroundColor = kMainThemeColor;
        });
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
