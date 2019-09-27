//
//  BackGoodsSearchViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BackGoodsSearchViewController.h"
#import "WMSearchBar.h"
#import "GoodsListCell.h"
#import "GoodsListModel.h"
#import "GoodsDetailViewController.h"


@interface BackGoodsSearchViewController ()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UISearchBar *searchBar;

// 商品数组
@property (nonatomic, strong) NSMutableArray *goodsArray;
// 商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL isGird; // 0：列表视图，1：格子视图


@property (nonatomic, strong) UILabel *promptLabel;
@end

static NSString *goodsCellIdentified = @"goodsCellIdentified";
@implementation BackGoodsSearchViewController
#pragma mark - LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self setupUI];
    [self promptLabel];
    _isGird = NO;
    [self goodsCollectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NormalMethod
- (void)setupUI {
    
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 11.0) {
        
        self.definesPresentationContext = YES;
        
        WMSearchBar *searchBar = [[WMSearchBar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 2 * 44 - 2 * 15, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索商品";
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
        self.searchBar.placeholder = @"搜索商品";
        self.searchBar.delegate = self;
        self.searchBar.userInteractionEnabled = YES;
        self.searchBar.backgroundImage = [UIImage new];
        self.searchBar.backgroundColor = [UIColor clearColor];
        self.searchBar.tintColor = kDisabledColor;
        self.navigationItem.titleView = self.searchBar;
    }

}

- (void)getData {
    [[UIApplication sharedApplication].keyWindow hudShow];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getMerchandiesList.do"];
    NSDictionary *paramDic = @{
                 @"merchantId": @(self.shopId.integerValue),
                 @"agencysId": @(userModel.agencyId),
                 @"type": @(0),
                 @"sign": @(0),
                 @"serchName": self.searchBar.text
                 };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.goodsArray removeAllObjects];
            
            [weakSelf.goodsArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            if (weakSelf.goodsArray.count == 0) {
                self.promptLabel.hidden = NO;
            } else {
                self.promptLabel.hidden = YES;
            }
            
            [weakSelf.goodsCollectionView reloadData];
            
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"商品数据加载失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
    }];
}



- (void)changeLayout {
    _isGird = !_isGird;
    [self.goodsCollectionView reloadData];
    
    self.flowLayout.minimumLineSpacing = _isGird ? 5 : 1;
    self.flowLayout.minimumInteritemSpacing = _isGird ? 5 : 0;
}

#pragma  mark - UICollecitonViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCellIdentified forIndexPath:indexPath];
    cell.cellWidth = (kSCREEN_WIDTH - 5)/2.0;
    cell.isGrid = _isGird;
    cell.model = self.goodsArray[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.fromBack = self.fromBack;
    vc.goodsID = ((GoodsListModel *)self.goodsArray[indexPath.row]).goodsID;
    vc.shopID = self.shopId;
    vc.origin = @"0";
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGird) {
        return CGSizeMake((kSCREEN_WIDTH - 5)/2.0, (kSCREEN_WIDTH - 5)/2.0 + 68);
    } else {
        return CGSizeMake(kSCREEN_WIDTH, 120);
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [self getData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - lazyMethod
- (NSMutableArray *)goodsArray {
    if (_goodsArray == nil) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

- (UICollectionView *)goodsCollectionView {
    if (_goodsCollectionView == nil) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [self.flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
        _flowLayout.minimumLineSpacing =  _isGird ? 5 : 1;
        _flowLayout.minimumInteritemSpacing =  _isGird ? 5 : 0;
        _flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH - 5)/2.0, (kSCREEN_WIDTH - 5)/2.0 + 68);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [self.view addSubview:_goodsCollectionView];
        [_goodsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(64);
            make.bottom.equalTo(0);
            make.right.equalTo(0);
        }];
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.backgroundColor = [UIColor clearColor];
        [_goodsCollectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:goodsCellIdentified];    }
    return _goodsCollectionView;
}

- (UILabel *)promptLabel {
    if (_promptLabel == nil) {
        _promptLabel = [UILabel new];
        [self.view addSubview:_promptLabel];
        [self.view bringSubviewToFront:_promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.goodsCollectionView);
        }];
        _promptLabel.text = @"未找到相关信息";
        _promptLabel.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
        _promptLabel.font = [UIFont systemFontOfSize:16];
        _promptLabel.hidden = YES;
    }
    return _promptLabel;
}
@end
