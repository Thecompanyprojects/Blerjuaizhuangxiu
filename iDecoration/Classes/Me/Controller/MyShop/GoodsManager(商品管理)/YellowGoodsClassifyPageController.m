//
//  YellowGoodsClassifyPageController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "YellowGoodsClassifyPageController.h"
#import "GoodClassifyCell.h"
#import "GoodsListCell.h"
#import "GoodsListModel.h"
#import "GoodsDetailViewController.h"

static NSString *classifyTableViewCellIdentified = @"classifyTableViewCellIdentified";
static NSString *goodsCellIdentified = @"goodsCellIdentified";
static NSString *goodsCellSectionHeaderIdentified = @"goodsCellSectionHeaderIdentified";
@interface YellowGoodsClassifyPageController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

// 商品类别数组
@property (nonatomic, strong) NSMutableArray *classifyTitleArray;
// 商品类别列表
@property (nonatomic, strong) UITableView *classifyTableView;

// 商品数组
@property (nonatomic, strong) NSMutableArray *goodsArray;
// 商品列表
@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL isGird; // 0：列表视图，1：格子视图

@property (nonatomic, assign) NSInteger selectedCategoryID;

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation YellowGoodsClassifyPageController

#pragma mark - LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _isGird = [userDefault boolForKey:@"goodsLayoutIsGrid"];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLayout) name:kChangeGoodsListLayoutNotificationIdentify object:nil];
    
    [self getClassifyData];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NormalMethod
- (void)setupUI {
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
        [[UIApplication sharedApplication].keyWindow hiddleHud];
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

- (void)changeLayout {
    _isGird = !_isGird;
    [self.goodsCollectionView reloadData];
    
    self.flowLayout.minimumLineSpacing = _isGird ? 5 : 1;
    self.flowLayout.minimumInteritemSpacing = _isGird ? 5 : 0;
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
    
//    // scroll to selected index
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
    cell.cellWidth = (kSCREEN_WIDTH - 90)/2.0;
    cell.isGrid = _isGird;
    GoodsListModel *model = self.goodsArray[indexPath.row];
    model.isYellowPageClassifyLayout = YES;
    cell.model = model;
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
        return CGSizeMake((kSCREEN_WIDTH - 90)/2.0, (kSCREEN_WIDTH - 90)/2.0 + 68);
    } else {
        return CGSizeMake(kSCREEN_WIDTH - 85, 120);
    }
}



#pragma mark - lazyMethod

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
            make.top.equalTo(2);
            make.bottom.equalTo(0);
            make.width.equalTo(80);
        }];
        _classifyTableView.tableFooterView = [UIView new];
        _classifyTableView.delegate = self;
        _classifyTableView.dataSource = self;
    }
    return _classifyTableView;
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
        _flowLayout.minimumLineSpacing =  _isGird ? 5 : 1;
        _flowLayout.minimumInteritemSpacing =  _isGird ? 5 : 0;
        _flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH - 90)/2.0, (kSCREEN_WIDTH - 90)/2.0 + 68);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH - 80, 30);
        _flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH - 80, 0);
        _goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [self.view addSubview:_goodsCollectionView];
        [_goodsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.classifyTableView.mas_right).equalTo(5);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.right.equalTo(0);
        }];
        _goodsCollectionView.delegate = self;
        _goodsCollectionView.dataSource = self;
        _goodsCollectionView.showsVerticalScrollIndicator = NO;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.backgroundColor = [UIColor clearColor];
        [_goodsCollectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:goodsCellIdentified];
        [_goodsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:goodsCellSectionHeaderIdentified];
    }
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
