//
//  MaterialCalculatorController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MaterialCalculatorController.h"
#import "shopDetailView.h"
#import "WallPaperCalculatorController.h"
#import "CurtainCalculateController.h"
#import "FloorBoardCalculaterController.h"
#import "FloorTitleCalculaterController.h"
#import "WallTitleCalculaterController.h"
#import "CoatingCalculaterController.h"
#import "SDCycleScrollView.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "MainMaterialDiaryController.h"
#import "ZCHBudgetGuideConstructionCaseCell.h"
#import "AdvertisementWebViewController.h"
#import "ComplainViewController.h"

@interface MaterialCalculatorController ()<UITableViewDelegate, UITableViewDataSource, shopDetailViewDelagate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *adScrollView;
@property (nonatomic, strong) UIView *btnCollectionView;

@property (nonatomic, strong) UITableView *tableView;
// 图片URL数组(上)
@property (nonatomic, strong) NSMutableArray *imageTopArray;
// 图片信息字典数组（上）
@property (nonatomic, strong) NSMutableArray *topImageDictArray;
// 图片URL数组(下)
@property (nonatomic, strong) NSMutableArray *imageBottomArray;
// 施工案例
@property (nonatomic, strong) NSMutableArray *dataList;
@property (strong, nonatomic) UIImageView *defaultTopView;

@property (nonatomic, assign) BOOL hasSupport; // 是否点赞
@property (nonatomic, strong) UIButton *supportButton;
@property (strong, nonatomic) UILabel *goodCountLabel; // 底部点赞数量
@property (nonatomic, strong) UILabel *scanCountLabel; // 浏览量

@end

@implementation MaterialCalculatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"材料计算器";
    
    self.dataList = [NSMutableArray array];
    self.imageTopArray = [NSMutableArray array];
    self.topImageDictArray = [NSMutableArray array];
    self.imageBottomArray = [NSMutableArray array];
    [self tableView];
    [self setScanFooterView];
    [self adScrollView];
    [self getData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }
}

// 设置浏览量视图
- (UIView *)setScanFooterView {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];
    
    //    UIImageView *scanIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
    //    scanIV.frame = CGRectMake(16, 15, 30, 15);
    //    [footView addSubview:scanIV];
    
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
                                @"companyId" : self.shopID
                                };
        [NetManager afGetRequest:apiStr parms:param finished:^(id responseObj) {
            
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    
}
#pragma mark - 投诉按钮的点击事件
- (void)didClickComplainBtn:(UIButton *)btn {
    
    ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
    ComplainVC.companyID = self.shopID.integerValue;
    ComplainVC.complainFrom = 3;
    [self.navigationController pushViewController:ComplainVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (SDCycleScrollView *)adScrollView {
    
    if (_adScrollView == nil) {
        
        _adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6) delegate:self placeholderImage:nil];
        _adScrollView.autoScrollTimeInterval = BANNERTIME;
        self.defaultTopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6)];
        self.tableView.tableHeaderView = self.defaultTopView;
    }
    
    return _adScrollView;
}


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

#pragma mark - 获取数据
- (void)getData {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"construction/getCalImgAndConByCompanyId.do"];
    NSDictionary *param = @{
                            @"companyId" : self.shopID
                            };
    
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            [self.imageTopArray removeAllObjects];
            [self.imageBottomArray removeAllObjects];
            [self.dataList removeAllObjects];
            
            for (NSDictionary *dic in responseObj[@"data"][@"calFootImages"]) {
                
                [self.imageBottomArray addObject:dic[@"picUrl"]];
            }
            [self.topImageDictArray removeAllObjects];
            [self.topImageDictArray addObjectsFromArray:responseObj[@"data"][@"calHeadImages"]];
            for (NSDictionary *dic in responseObj[@"data"][@"calHeadImages"]) {
                
                [self.imageTopArray addObject:dic[@"picUrl"]];
            }
            if (self.imageTopArray.count > 0) {
                
                _adScrollView.imageURLStringsGroup = self.imageTopArray;
                self.tableView.tableHeaderView = _adScrollView;
            } else {
                self.defaultTopView.image = [UIImage imageNamed:@"top_default"];
            }
            for (NSDictionary *dict in responseObj[@"data"][@"conList"]) {
                
                ZCHBudgetGuideConstructionCaseModel *caseListModel = [ZCHBudgetGuideConstructionCaseModel yy_modelWithJSON:dict];
                
                if (![self.dataList containsObject:caseListModel]) {
                    [self.dataList addObject:caseListModel];
                }
            }
            
            NSInteger linkeNum = [responseObj[@"data"][@"calculatorLikeNumbers"] integerValue];
            self.goodCountLabel.text = [NSString stringWithFormat:@"%ld", linkeNum];
            [self.goodCountLabel sizeToFit];
            NSInteger scanNum = [responseObj[@"data"][@"calculatorBrowse"] integerValue];
            self.scanCountLabel.text = [NSString stringWithFormat:@"%ld", scanNum];
            [self.scanCountLabel sizeToFit];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark -  shopDetailViewDelagate (顶部视图的代理方法)
-(void)shopDetailAction:(NSInteger)tag{
    switch (tag) {
        case 100:
            //涂料计算器
        {
            CoatingCalculaterController *coatingVC = [UIStoryboard storyboardWithName:@"CoatingCalculaterController" bundle:nil].instantiateInitialViewController;
            coatingVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:coatingVC animated:YES];
        }
            break;
        case 101:
            //地板
        {
            FloorBoardCalculaterController *floorBoardVC = [UIStoryboard storyboardWithName:@"FloorBoardCalculaterController" bundle:nil].instantiateInitialViewController;
            floorBoardVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:floorBoardVC animated:YES];
        }
            break;
        case 102:
            //壁纸
        {
            WallPaperCalculatorController *wallVC = [UIStoryboard storyboardWithName:@"WallPaperCalculatorController" bundle:nil].instantiateInitialViewController;
            wallVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:wallVC animated:YES];
        }
            break;
        case 103:
            //墙砖
        {
            WallTitleCalculaterController *wallTitleVC = [UIStoryboard storyboardWithName:@"WallTitleCalculaterController" bundle:nil].instantiateInitialViewController;
            wallTitleVC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:wallTitleVC animated:YES];
        }
            break;
        case 104:
            //窗帘 CurtainCalculateController
        {
            CurtainCalculateController *VC = [UIStoryboard storyboardWithName:@"CurtainCalculateController" bundle:nil].instantiateInitialViewController;
            VC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:VC animated:YES];
        }
            
            break;
        case 105:
            //地砖计算
        {
            FloorTitleCalculaterController *VC = [UIStoryboard storyboardWithName:@"FloorTitleCalculaterController" bundle:nil].instantiateInitialViewController;
            VC.dispalyNum = self.dispalyNum;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
    }
    
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *webUrl = self.topImageDictArray[index][@"picHref"];
    
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

#pragma  mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        if (self.dataList.count > 0) {
            return 1;
        } else {
            return 0;
        }
        
//        return self.dataList.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.btnCollectionView];
        return cell;
    } else if (indexPath.section == 1) {
        //施工案例
//        ZCHBudgetGuideConstructionCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCHBudgetGuideConstructionCaseCell" forIndexPath:indexPath];
//        cell.model = self.dataList[indexPath.row];
//        return cell;
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        // 图片 5：3  左右边距 8  图片底部文字高度20 上下边距8   (kSCREEN_WIDTH - 32)/2.0 * 3/5.0 + (20 + 16)
        NSInteger imageWith = (kSCREEN_WIDTH - 32)/2.0;
        NSInteger imageHeigt = imageWith * 3/5.0;
        NSInteger margin = 8;
        NSInteger textHeigt = 20;
        NSInteger viewHeight = imageHeigt + margin * 2 + textHeigt;
        NSInteger viewWidht = margin * 2 + imageWith;
        for (int i = 0; i < self.dataList.count; i ++) {
            ZCHBudgetGuideConstructionCaseModel *model = self.dataList[i];
            
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
            
            UILabel *nounLabel = [UILabel new];
            nounLabel.font = [UIFont systemFontOfSize:12];
            nounLabel.textColor = [UIColor whiteColor];
            nounLabel.text = model.ccAreaName;
            nounLabel.textAlignment = NSTextAlignmentCenter;
            [middleBgView addSubview:nounLabel];
            [nounLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0);
                make.right.equalTo(0);
                make.top.equalTo(0);
                make.height.equalTo(middleBgViewHeight);
            }];
        }
        
        return cell;
        
    } else {
        
        return [[UITableViewCell alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return (kSCREEN_WIDTH/3.0 * 2 + 10);
    } else if(indexPath.section == 1) {
//        return 80;
        // 经典案例
        NSInteger count = 0;
        if (self.dataList.count % 2 == 0) {
            
            count = self.dataList.count / 2;
        } else {
            
            count = self.dataList.count / 2 + 1;
        }
        return count * ((kSCREEN_WIDTH - 32) * 0.3 + 36);
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1 && self.dataList.count > 0) {
        return 55;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1 && self.dataList.count > 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 55)];
        bgView.backgroundColor = kBackgroundColor;
        
        UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
        caseLabel.backgroundColor = White_Color;
        caseLabel.textAlignment = NSTextAlignmentCenter;
        caseLabel.textColor = [UIColor lightGrayColor];
        caseLabel.font = [UIFont systemFontOfSize:16];
        caseLabel.text = @"————— 经典案例 —————";
        [bgView addSubview:caseLabel];
        
        return bgView;
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        return;
    }
    
    if (indexPath.section == 1) {
        
        if ([self.isConVip integerValue] == 0) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"主人暂未开通云管理会员"];
            return;
        }
        
        ZCHBudgetGuideConstructionCaseModel *model = self.dataList[indexPath.row];
        if (model.constructionId && ![model.constructionId isEqualToString:@""] && ![model.constructionId isEqualToString:@"0"]) {
            
            MainMaterialDiaryController *constructionVC = [[MainMaterialDiaryController alloc] init];
            constructionVC.consID = [model.constructionId integerValue];
            [self.navigationController pushViewController:constructionVC animated:YES];
        } else {
            
            [self.view showHudFailed:@"该工地已不存在..."];
        }
    }
}

#pragma mark - 跳转到案例详情
- (void)gotoAnliDetail:(UITapGestureRecognizer *)tapGR {
    
    UIView *view = tapGR.view;
    NSInteger index = view.tag;
    if ([self.isConVip integerValue] == 0) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"主人暂未开通云管理会员"];
        return;
    }
    
    ZCHBudgetGuideConstructionCaseModel *model = self.dataList[index];
    MainMaterialDiaryController *vc = [[MainMaterialDiaryController alloc] init];
    vc.consID = [model.constructionId integerValue];
 
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(64);
            make.left.right.bottom.equalTo(0);
        }];
        [self.tableView registerNib:[UINib nibWithNibName:@"ZCHBudgetGuideConstructionCaseCell" bundle:nil] forCellReuseIdentifier:@"ZCHBudgetGuideConstructionCaseCell"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
//        _tableView.tableFooterView = footerView;
    }
    
    return _tableView;
}

@end
