//
//  BackGoodsListViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BackGoodsListViewController.h"
#import "BackGoodsListBottomView.h"
#import "BackGoodsSearchViewController.h"
#import "GoodClassifyCell.h"
#import "GroupManagerViewController.h"
#import "BatchManagerViewController.h"
#import "GoodsListCell.h"
#import "GoodsListModel.h"
#import "ClassifyModel.h"
#import "GoodsEditViewController.h"
#import "TZImagePickerController.h"
#import "GoodsDetailViewController.h"
#import "GoodsPromotionController.h"


static NSString *classifyTableViewCellIdentified = @"classifyTableViewCellIdentified";
static NSString *goodsCellIdentified = @"goodsCellIdentified";
static NSString *goodsCellSectionHeaderIdentified = @"goodsCellSectionHeaderIdentified";

@interface BackGoodsListViewController ()<BackGoodsListBottomViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

// 商品类别数组
@property (nonatomic, strong) NSMutableArray *classifyTitleArray;
// 商品类别列表
@property (nonatomic, strong) UITableView *classifyTableView;
// 底部视图
@property (nonatomic, strong) BackGoodsListBottomView *bottomView;
// 顶部搜索条
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;

// 商品数组
@property (nonatomic, strong) NSMutableArray *goodsArray;
// 商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger selectedCategoryID;

@property (nonatomic, strong) UILabel *promptLabel;
@end

@implementation BackGoodsListViewController
#pragma mark - LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";
    self.view.backgroundColor = kBackgroundColor;
    
    [self setupUI];
    
    [self getClassifyData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kEditingGoodsCompletionNotificationIdentify object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NormalMethod
- (void)setupUI {
    [self bottomView];
    [self searchView];
    [self classifyTableView];
    [self goodsCollectionView];
    [self promptLabel];
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
                               @"categoryId": @(_selectedCategoryID)
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.goodsArray removeAllObjects];
            
            [weakSelf.goodsArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
//            if (weakSelf.goodsArray.count == 0) {
//
//                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该分组暂无数据"];
//            }
            if (weakSelf.goodsArray.count > 0) {
                self.promptLabel.hidden = YES;
            } else {
                self.promptLabel.hidden = NO;
            }
            [weakSelf.goodsCollectionView reloadData];
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"商品数据加载失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}
// 没有提示的刷新数据
- (void)refreshData {
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getMerchandiesList.do"];
    NSDictionary *paramDic = @{
                               @"merchantId": @(self.shopId.integerValue),
                               @"agencysId": @(userModel.agencyId),
                               @"type": @(0),
                               @"sign": @(0),
                               @"categoryId": @(_selectedCategoryID)
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.goodsArray removeAllObjects];
            
            [weakSelf.goodsArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            if (weakSelf.goodsArray.count > 0) {
                self.promptLabel.hidden = YES;
            } else {
                self.promptLabel.hidden = NO;
            }
            [weakSelf.goodsCollectionView reloadData];
        } else {
        }

    } failed:^(NSString *errorMsg) {
    }];
}

// 获取分组数据
- (void)getClassifyData {
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getCategoryList.do"];
    NSDictionary *paramDic = @{
                               @"merchantId": self.shopId
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"categoryList"];
            [weakSelf.classifyTitleArray removeAllObjects];
            
            [weakSelf.classifyTitleArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ClassifyModel class] json:array]];
            self.selectedCategoryID = ((ClassifyModel *)weakSelf.classifyTitleArray[0]).categoryID;
            [self.classifyTableView reloadData];
            [self tableView:self.classifyTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        } else {
             [[UIApplication sharedApplication].keyWindow hudShowWithText:@"产品类别加载失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
    }];
}
// 没有提示的刷新
- (void)refreshClassifyData {
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getCategoryList.do"];
    NSDictionary *paramDic = @{
                               @"merchantId": self.shopId
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"categoryList"];
            [weakSelf.classifyTitleArray removeAllObjects];
            
            [weakSelf.classifyTitleArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ClassifyModel class] json:array]];
            self.selectedCategoryID = ((ClassifyModel *)weakSelf.classifyTitleArray[0]).categoryID;
            [self.classifyTableView reloadData];
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"产品类别加载失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
    }];
}
#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classifyTitleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:classifyTableViewCellIdentified];
    if (cell == nil) {
        cell = [[GoodClassifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:classifyTableViewCellIdentified];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIView *backGorundView = [[UIView alloc] initWithFrame:cell.frame];
        backGorundView.backgroundColor = kBackgroundColor;
        cell.selectedBackgroundView = backGorundView;
    }
    cell.model = self.classifyTitleArray[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        GoodClassifyCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    GoodClassifyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor redColor];
    
    ClassifyModel *model = self.classifyTitleArray[indexPath.row];
    self.selectedCategoryID = model.categoryID;
    [self getData];
    
    // scroll to selected index
//    NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
//    UICollectionViewLayoutAttributes* attr = [self.goodsCollectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
//    UIEdgeInsets insets = self.goodsCollectionView.scrollIndicatorInsets;
//
//    CGRect rect = attr.frame;
//    rect.size = self.goodsCollectionView.frame.size;
//    rect.size.height -= insets.top + insets.bottom;
//    CGFloat offset = (rect.origin.y + rect.size.height) - self.goodsCollectionView.contentSize.height;
//    if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
//
//    [self.goodsCollectionView scrollRectToVisible:rect animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodClassifyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor blackColor];
}

#pragma  mark - UICollecitonViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return self.classifyTitleArray.count;
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCellIdentified forIndexPath:indexPath];
    cell.cellWidth = (kSCREEN_WIDTH - 95)/2.0;
    cell.isGrid = 1;
    cell.model = self.goodsArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:goodsCellSectionHeaderIdentified forIndexPath:indexPath];
//    UILabel *label = [UILabel new];
//    label.backgroundColor = kBackgroundColor;
//    [headerView removeAllSubViews];
//    [headerView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(0);
//        make.left.equalTo(5);
//    }];
//    label.font = [UIFont systemFontOfSize:13];
//    label.text = @"";
//    label.text = self.classifyTitleArray[indexPath.section];
    return headerView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.section inSection:0];
//    GoodClassifyCell *cell = [self.classifyTableView cellForRowAtIndexPath:indexP];
//    cell.titleLabel.textColor = [UIColor redColor];
//    [self.classifyTableView selectRowAtIndexPath:indexP animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    
    MJWeakSelf;
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.fromBack = YES;
    vc.origin = @"0";
    vc.goodsID = ((GoodsListModel *)self.goodsArray[indexPath.row]).goodsID;
    vc.shopID = self.shopId;
    vc.companyType = self.companyType;
    vc.agencJob = [NSString stringWithFormat:@"%ld",self.agencJob];
    vc.implement = self.implement;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - BackGoodsListBottomViewDelegate
- (void)bottomView:(BackGoodsListBottomView *)View BtnClicked:(NSInteger)index {
    switch (index) {
        case 0:
        {
            YSNLog(@"添加商品0000");
            MJWeakSelf;
            
            GoodsEditViewController *editVC = [[GoodsEditViewController alloc] init];
            editVC.agencJob = self.agencJob;
            editVC.implement = self.implement;
//            editVC.originImageArray = photos;
            editVC.shopId = weakSelf.shopId;
//            editVC.originImageURLArray = imageURLArray;
            editVC.EditingCompletionBlock = ^{
                [self refreshData];
            };
            [weakSelf.navigationController pushViewController:editVC animated:YES];
        }
            break;
        case 1:
        {
            YSNLog(@"商品推广");
            GoodsPromotionController *promotionVC = [GoodsPromotionController new];
            promotionVC.shopId = self.shopId;
            [self.navigationController pushViewController:promotionVC animated:YES];
            
        }
            break;
        case 2:
        {
            YSNLog(@"批量管理");
            MJWeakSelf;
            BatchManagerViewController *batchVC = [[BatchManagerViewController alloc] init];
            batchVC.shopId = self.shopId;
            batchVC.categoryId = self.selectedCategoryID;
            batchVC.agencyJob = self.agencJob;
            batchVC.CompletionBlock = ^{
                [weakSelf refreshData];
            };
            [self.navigationController pushViewController:batchVC animated:YES];
        }
            break;
        case 3:
        {
            YSNLog(@"分组管理");
            MJWeakSelf;
            GroupManagerViewController *groupManagerVC = [[GroupManagerViewController alloc] init];
            groupManagerVC.shopId = self.shopId;
            groupManagerVC.ClasifyBrushBloack = ^{
                [weakSelf refreshClassifyData];
                [weakSelf refreshData];
            };
            [self.navigationController pushViewController:groupManagerVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    BackGoodsSearchViewController *searchVC = [[BackGoodsSearchViewController alloc] init];
    searchVC.shopId = self.shopId;
    searchVC.fromBack = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
//    [searchBar resignFirstResponder];
//    [self getData];
}

#pragma mark - lazyMethod
- (BackGoodsListBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[BackGoodsListBottomView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 44, kSCREEN_WIDTH, 44)];
        [self.view addSubview:_bottomView];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, 44)];
        [self.view addSubview:_searchView];
        _searchView.backgroundColor = [UIColor whiteColor];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(16, 6, kSCREEN_WIDTH - 32, 32)];
        searchBar.delegate = self;
        searchBar.backgroundImage = [UIImage new];
        searchBar.backgroundColor = [UIColor clearColor];

        UIImage* searchBarBg = [self GetImageWithColor:kBackgroundColor andHeight:32.0f];
        [searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
        UITextField *searchField = [searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        
        [_searchView addSubview:searchBar];
    }
    return _searchView;
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (NSMutableArray *)classifyTitleArray {
    if (!_classifyTitleArray) {
        _classifyTitleArray = [NSMutableArray array];
    }
    return _classifyTitleArray;
}
- (UITableView *)classifyTableView {
    if (!_classifyTableView) {
        _classifyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_classifyTableView];
        [_classifyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.searchView.mas_bottom).equalTo(2);
            make.bottom.equalTo(self.bottomView.mas_top).equalTo(-2);
            make.width.equalTo(80);
        }];
        _classifyTableView.tableFooterView = [UIView new];
        _classifyTableView.delegate = self;
        _classifyTableView.dataSource = self;
    }
    return _classifyTableView;
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
    }
    return _promptLabel;
}

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
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH - 95)/2.0, (kSCREEN_WIDTH - 95)/2.0 + 68);
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        _flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH - 80, 30);
        _flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH - 80, 0);
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [self.view addSubview:_goodsCollectionView];
        [_goodsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.classifyTableView.mas_right).equalTo(0);
            make.top.equalTo(self.searchView.mas_bottom).equalTo(2);
            make.bottom.equalTo(self.bottomView.mas_top).equalTo(-2);
            make.right.equalTo(0);
        }];
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.backgroundColor = kCustomColor(228, 228, 228);
        [_goodsCollectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:goodsCellIdentified];
        [_goodsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:goodsCellSectionHeaderIdentified];
    }
    return _goodsCollectionView;
}
@end
