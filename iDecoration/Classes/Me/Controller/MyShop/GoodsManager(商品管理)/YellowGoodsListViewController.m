//
//  YellowGoodsListViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "YellowGoodsListViewController.h"
#import <WMPageController.h>
#import "YellowGoodsNormalPageController.h"
#import "YellowGoodsClassifyPageController.h"
#import "WMSearchBar.h"
#import "BackGoodsSearchViewController.h"
#import "MeSearchBar.h"
#import "DecorateInfoNeedView.h"
#import "BLEJBudgetGuideController.h"
#import "DecorateNeedViewController.h"
#import "DecorateCompletionViewController.h"
#import <UIButton+LXMImagePosition.h>
#import "LYShareMenuView.h"

@interface YellowGoodsListViewController ()<WMPageControllerDelegate, WMPageControllerDataSource, WMMenuViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,LYShareMenuViewDelegate>

@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIImageView *trigangleIV;
@property (nonatomic, assign) BOOL priceDown;

@property (nonatomic, strong) MeSearchBar *searchBar; //search

@property (nonatomic, assign) BOOL isGrid; // 是否是方格，  控制图片样式

@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (strong, nonatomic) DecorateInfoNeedView *infoView;
@property (nonatomic,strong) LYShareMenuView *shareMenuView;
// QQ分享
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

@implementation YellowGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    _priceDown = YES;
    _isGrid = YES;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:@"goodsLayoutIsGrid"];
    [userDefault synchronize];
    [self pageController];
    
    CGFloat naviHeight = 64;
    if (IphoneX) {
        naviHeight = 84;
    } else {
        naviHeight = 64;
    }
    if (self.fromBack) {
        self.pageController.viewFrame = CGRectMake(0, naviHeight,kSCREEN_WIDTH , kSCREEN_HEIGHT - naviHeight);
    } else {
        self.pageController.viewFrame = CGRectMake(0, naviHeight,kSCREEN_WIDTH , kSCREEN_HEIGHT - naviHeight - 50);
    }
    
    [self.view addSubview:self.pageController.view];
    [self setright];
    
    [self setSearchBarUI];
    
    if (self.fromBack) {
        
    } else {
        [self addBottomView];
    }
    [self setupshare];
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NormlMethod
- (void)setSearchBarUI {
    CGFloat naviHeight = 64;
    if (IphoneX) {
        naviHeight = 84;
    } else {
        naviHeight = 64;
    }
    UIView *naviV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, naviHeight)];
    naviV.backgroundColor = [kMainThemeColor colorWithAlphaComponent:0.85];
    [self.view addSubview:naviV];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

    [naviV addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(0);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    [naviV addSubview:nameLabel];
    nameLabel.text = @"商品列表";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).equalTo(0);
        make.centerY.equalTo(backButton);
    }];
    
    _searchBar = [[MeSearchBar alloc] init];
    _searchBar.placeholder = @"";
    _searchBar.delegate = self;
    _searchBar.backgroundImage = [UIImage new];
    _searchBar.backgroundColor = [UIColor clearColor];
    [naviV addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backButton);
        make.left.equalTo(nameLabel.mas_right).equalTo(8);
        make.right.equalTo(-8);
        make.height.equalTo(30);
    }];
    _searchBar.contentInset = UIEdgeInsetsMake(1, 0, -1, 0);
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setright {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"layout_square"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0,0, self.pageController.menuItemWidth, self.pageController.menuHeight);
    [btn addTarget:self action:@selector(changeLayoutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.pageController.menuView.rightView = btn;
    [self.pageController.menuView resetFrames];
    
    self.pageController.menuView.delegate = self;
    
    WMMenuItem *item = [self.pageController.menuView itemAtIndex:3];
    UIView *tView = [[UIView alloc] initWithFrame:item.frame];
    tView.frame = CGRectMake(0, 0, item.frame.size.width, item.frame.size.height);
    [item addSubview:tView];
    
    tView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTitleTapAction:)];
    [tView addGestureRecognizer:tapGT];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.trigangleIV = imageView;
    self.trigangleIV.image = [UIImage imageNamed:@"price_none"];
    [tView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
}

- (void)priceTitleTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.pageController.selectIndex == 3) {
        _priceDown = !_priceDown;
         [[NSNotificationCenter defaultCenter] postNotificationName:kChangeGoodsPriceSort object:nil];
    }
    
    [self.pageController menuView:self.pageController.menuView didSelesctedIndex:3 currentIndex:3];
    [self.pageController.menuView selectItemAtIndex:3];
    
    self.trigangleIV.image = _priceDown ? [UIImage imageNamed:@"price_asc"] : [UIImage imageNamed:@"price_dec"];
    
}

- (void)changeLayoutAction:(UIButton *)sender {
    _isGrid = !_isGrid;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:_isGrid forKey:@"goodsLayoutIsGrid"];
    [userDefault synchronize];
    if (_isGrid) {
        [sender setImage:[UIImage imageNamed:@"layout_square"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"layout_list"] forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeGoodsListLayoutNotificationIdentify object:nil];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    
    BackGoodsSearchViewController *searchVC = [[BackGoodsSearchViewController alloc] init];
    searchVC.shopId = self.shopId;
    searchVC.fromBack = self.fromBack;
    
    searchVC.collectFlag = self.collectFlag;
    searchVC.shopid = self.shopid;
    searchVC.dataDic = self.dataDic;
    searchVC.companyType = self.companyType;
    searchVC.phone = self.phone;
    searchVC.telPhone = self.telPhone;
    searchVC.areaList = self.areaList;
    searchVC.baseItemsArr = self.baseItemsArr;
    searchVC.suppleListArr = self.suppleListArr;
    searchVC.constructionCase = self.constructionCase;
    searchVC.topCalculatorImageArr = self.topCalculatorImageArr;
    searchVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    searchVC.companyDic = self.companyDic;
    searchVC.calculatorTempletModel = self.calculatorModel;
    searchVC.code = self.code;
    
    [self.navigationController pushViewController:searchVC animated:YES];    
    
    return NO;
}


#pragma mark - WMMenuViewDelegate
// 重写WMMenuView的代理方法
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    if (index == 3) {
        return;
    }
    self.trigangleIV.image = [UIImage imageNamed:@"price_none"];
    [self.pageController menuView:menu didSelesctedIndex:index currentIndex:currentIndex];
    [self.pageController.menuView selectItemAtIndex:currentIndex];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    return [self.pageController menuView:menu widthForItemAtIndex:index];
}
- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    return [self.pageController menuView:menu itemMarginAtIndex:index];
}
- (CGFloat)menuView:(WMMenuView *)menu titleSizeForState:(WMMenuItemState)state atIndex:(NSInteger)index {
    return  [self.pageController menuView:menu titleSizeForState:state atIndex:index];
}
- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index {
    return [self.pageController menuView:menu titleColorForState:state atIndex:index];
}



#pragma mark - WMPageController
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    YellowGoodsNormalPageController *allVC = [YellowGoodsNormalPageController new];
    allVC.shopId = self.shopId;
    allVC.index = index;
    allVC.navigationController = self.navigationController;
    
    allVC.fromBack = self.fromBack;
    allVC.collectFlag = self.collectFlag;
    allVC.shopid = self.shopid;
    allVC.dataDic = self.dataDic;
    allVC.companyType = self.companyType;
    allVC.phone = self.phone;
    allVC.telPhone = self.telPhone;
    allVC.areaList = self.areaList;
    allVC.baseItemsArr = self.baseItemsArr;
    allVC.suppleListArr = self.suppleListArr;
    allVC.constructionCase = self.constructionCase;
    allVC.topCalculatorImageArr = self.topCalculatorImageArr;
    allVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    allVC.companyDic = self.companyDic;
    allVC.calculatorTempletModel = self.calculatorModel;
    allVC.code = self.code;
    
    
    YellowGoodsNormalPageController *hotVC = [YellowGoodsNormalPageController new];
    hotVC.shopId = self.shopId;
    hotVC.index = index;
    hotVC.navigationController = self.navigationController;
    
    hotVC.fromBack = self.fromBack;
    hotVC.collectFlag = self.collectFlag;
    hotVC.shopid = self.shopid;
    hotVC.dataDic = self.dataDic;
    hotVC.companyType = self.companyType;
    hotVC.phone = self.phone;
    hotVC.telPhone = self.telPhone;
    hotVC.areaList = self.areaList;
    hotVC.baseItemsArr = self.baseItemsArr;
    hotVC.suppleListArr = self.suppleListArr;
    hotVC.constructionCase = self.constructionCase;
    hotVC.topCalculatorImageArr = self.topCalculatorImageArr;
    hotVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    hotVC.companyDic = self.companyDic;
    hotVC.calculatorTempletModel = self.calculatorModel;
    hotVC.code = self.code;
    
    YellowGoodsClassifyPageController *classifyVC = [YellowGoodsClassifyPageController new];
    classifyVC.shopId = self.shopId;
    classifyVC.navigationController = self.navigationController;
    
    classifyVC.fromBack = self.fromBack;
    classifyVC.collectFlag = self.collectFlag;
    classifyVC.shopid = self.shopid;
    classifyVC.dataDic = self.dataDic;
    classifyVC.companyType = self.companyType;
    classifyVC.phone = self.phone;
    classifyVC.telPhone = self.telPhone;
    classifyVC.areaList = self.areaList;
    classifyVC.baseItemsArr = self.baseItemsArr;
    classifyVC.suppleListArr = self.suppleListArr;
    classifyVC.constructionCase = self.constructionCase;
    classifyVC.topCalculatorImageArr = self.topCalculatorImageArr;
    classifyVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    classifyVC.companyDic = self.companyDic;
    classifyVC.calculatorTempletModel = self.calculatorModel;
    classifyVC.code = self.code;
    YellowGoodsNormalPageController *priceVC = [YellowGoodsNormalPageController new];
    priceVC.shopId = self.shopId;
    priceVC.index = index;
    priceVC.navigationController = self.navigationController;
    
    priceVC.fromBack = self.fromBack;
    priceVC.collectFlag = self.collectFlag;
    priceVC.shopid = self.shopid;
    priceVC.dataDic = self.dataDic;
    priceVC.companyType = self.companyType;
    priceVC.phone = self.phone;
    priceVC.telPhone = self.telPhone;
    priceVC.areaList = self.areaList;
    priceVC.baseItemsArr = self.baseItemsArr;
    priceVC.suppleListArr = self.suppleListArr;
    priceVC.constructionCase = self.constructionCase;
    priceVC.topCalculatorImageArr = self.topCalculatorImageArr;
    priceVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    priceVC.companyDic = self.companyDic;
    priceVC.calculatorTempletModel = self.calculatorModel;
    priceVC.code = self.code;
    
    
    return @[allVC, hotVC, classifyVC, priceVC][index];
    
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"info%@", info);  // index title
    if ([info[@"index"] integerValue] != 3) {
        self.trigangleIV.image = [UIImage imageNamed:@"price_none"];
    } else {
        self.trigangleIV.image = _priceDown ? [UIImage imageNamed:@"price_asc"] : [UIImage imageNamed:@"price_dec"];
    }
}

#pragma mark - lazyMethod

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"综合", @"热度", @"分类", @"价格"];
    }
    return _titles;
}


- (WMPageController *)pageController {
    if (!_pageController) {
        _pageController = [[WMPageController alloc] init];
        _pageController.menuHeight = 40;
        _pageController.menuBGColor = [UIColor whiteColor];
        _pageController.menuView.backgroundColor = [UIColor whiteColor];
        _pageController.titleColorNormal = [UIColor blackColor];
        _pageController.titleColorSelected = [UIColor redColor];
        _pageController.titleSizeNormal = 14;
        _pageController.titleSizeSelected = 14;
        
        
        _pageController.delegate = self;
        _pageController.dataSource = self;
    }
    return _pageController;
}



#pragma mark - 添加底部视图
- (void)addBottomView {
    
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
        
        
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.frame = CGRectMake(phoneBtn.right, 0, 76, bottomView.height);
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [shareBtn setImage:[UIImage imageNamed:@"icon_fenxiang_hi"] forState:normal];
        [shareBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        //[shareBtn setImagePosition:LXMImagePositionLeft spacing:15];
        [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:shareBtn];
        
        
        UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareBtn.right, 0, (BLEJWidth - shareBtn.right) * 0.5, bottomView.height)];
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
//     if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1065"] || [self.companyType isEqualToString:@"1064"]) {
//    } else {
//        
//        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, bottomView.height)];
//        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
//        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
//        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:phoneBtn];
//        
//        
//        UIButton *shareBtn = [[UIButton alloc] init];
//        shareBtn.frame = CGRectMake(phoneBtn.right, 0, 76, bottomView.height);
//        shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [shareBtn setImage:[UIImage imageNamed:@"icon_fenxiang_hi"] forState:normal];
//        [shareBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//        //[shareBtn setImagePosition:LXMImagePositionLeft spacing:15];
//        [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:shareBtn];
//        
//        UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareBtn.right, 0, BLEJWidth - shareBtn.right, bottomView.height)];
//        appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//        appointmentBtn.backgroundColor = kMainThemeColor;
//        [appointmentBtn setTitleColor:White_Color forState:UIControlStateNormal];
//        [appointmentBtn setTitle:@"在线预约" forState:UIControlStateNormal];
//        [appointmentBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:appointmentBtn];
//    }
}

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    [self.phoneArr removeAllObjects];
    
    NSString *landLine = [self.dataDic objectForKey:@"companyLandline"];
    NSString *managerLine = [self.dataDic objectForKey:@"companyPhone"];
    
    if (!(!landLine || [landLine isKindOfClass:[NSNull class]] || [landLine isEqualToString:@""])) {
        [self.phoneArr addObject:landLine];
    }
    if (!(!managerLine || [managerLine isKindOfClass:[NSNull class]] || [managerLine isEqualToString:@""])) {
        [self.phoneArr addObject:managerLine];
    }
    
    if (!(!self.phone || [self.phone isKindOfClass:[NSNull class]] || [self.phone isEqualToString:@""])) {
        [self.phoneArr addObject:self.phone];
    }
    if (!(!self.telPhone || [self.telPhone isKindOfClass:[NSNull class]] || [self.telPhone isEqualToString:@""])) {
        [self.phoneArr addObject:self.telPhone];
    }
    
    
    
    if (self.phoneArr.count == 0) {
        return;
    }
    
    UIActionSheet *actionSheet;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    }
    
    [actionSheet showInView:self.view];
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
    } else {
        
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
    }
}




#pragma mark - 预约
- (void)didClickAppointmentBtn:(UIButton *)btn {// 预约
    
    // 在线预约浏览量
    [NSObject needDecorationStatisticsWithConpanyId:self.shopid];
    
    //    DecorateNeedViewController *vc = [[DecorateNeedViewController alloc] init];
    //    vc.companyType = self.dataDic[@"companyType"];
    //    vc.companyID = self.shopid;
    //    [self.navigationController pushViewController:vc animated:YES];
    
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
}

- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    
    // 装修报价
    if (self.code == 1000) {
        
     
            
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.origin = self.origin;
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
           VC.calculatorModel= self.calculatorModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.shopid;
            VC.topImageArr = self.topCalculatorImageArr;
            VC.bottomImageArr = self.bottomCalculatorImageArr;
            VC.isConVip = self.companyDic[@"conVip"];
            [self.navigationController pushViewController:VC animated:YES];
//           if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
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
    decoration.companyID = self.shopid;
    decoration.areaList = self.areaList;
    decoration.companyType = self.companyType;
    [self.navigationController pushViewController:decoration animated:YES];
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
    [param setObject:self.dataDic[@"companyId"] forKey:@"companyId"];
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
    [dic setObject:self.dataDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.dataDic[@"companyType"] forKey:@"companyType"];
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
                completionVC.companyType = weakSelf.dataDic[@"companyType"];
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

#pragma mark - 分享

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}

-(void)setupshare
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.shareMenuView];
    //配置item
    NSMutableArray *array = NSMutableArray.new;
    LYShareMenuItem *item0 = nil;
    item0 = [LYShareMenuItem shareMenuItemWithImageName:@"qq" itemTitle:@"QQ"];
    [array addObject:item0];
    
    LYShareMenuItem *item1 = nil;
    item1 = [LYShareMenuItem shareMenuItemWithImageName:@"qqkongjian" itemTitle:@"QQ空间"];
    [array addObject:item1];
    
    LYShareMenuItem *item2 = nil;
    item2 = [LYShareMenuItem shareMenuItemWithImageName:@"weixin-share" itemTitle:@"微信好友"];
    [array addObject:item2];
    
    LYShareMenuItem *item3 = nil;
    item3 = [LYShareMenuItem shareMenuItemWithImageName:@"pengyouquan" itemTitle:@"朋友圈"];
    [array addObject:item3];
    
    self.shareMenuView.shareMenuItems = [array copy];
}

-(void)shareClick
{
    [self.shareMenuView show];
}

- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",@"store/merchantList/",self.shopId,@".htm"];
    NSString *shareUrl = [BASEURL stringByAppendingString:url];
    
    NSString *sharetitle = self.companyName;
    NSString *shareimgurl = self.shareCompanyLogoURLStr;
    NSString *sharenewtitle = self.shareDescription;
    switch (index) {
        case 0:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareimgurl]]];
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                NSURL *url = [NSURL URLWithString:shareUrl];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:sharenewtitle previewImageData:data];
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                    
                }

            }
        }
            break;
        case 1:
        {
            // QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareimgurl]]];
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                NSURL *url = [NSURL URLWithString:shareUrl];
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:sharenewtitle previewImageData:data];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                    
                }
            }
        }
            break;
        case 2:
        {
            //微信好友
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = sharetitle;
            message.description = sharenewtitle;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareimgurl]]];
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = shareUrl;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];
                
            }

            
        }
            break;
        case 3:
        {
            // 微信朋友圈

            WXMediaMessage *message = [WXMediaMessage message];
            message.title = sharetitle;
            message.description = sharenewtitle;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareimgurl]]];
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = shareUrl;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];
                
            }
        }
            break;
        default:
            break;
    }
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}


@end
