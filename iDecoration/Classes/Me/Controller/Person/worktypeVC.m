//
//  worktypeVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "worktypeVC.h"
#import "LJCollectionViewFlowLayout.h"
#import "CollectionViewCell.h"
#import "CollectionViewController.h"
#import "LeftTableViewCell.h"
#import "NSObject+Property.h"
#import "WorkTypeModel.h"

@interface worktypeVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end


static float kCollectionViewMargin = 3.f;


@implementation worktypeVC
{
    BOOL _isScrollDown;
    float kLeftTableViewWidth;
}

- (WorkTypeModel *)model {
    if (!_model) {
        _model = [WorkTypeModel new];
    }
    return _model;
}

- (NSMutableArray *)arrayDataTableView {
    if (!_arrayDataTableView) {
        _arrayDataTableView = @[].mutableCopy;
    }
    return _arrayDataTableView;
}

- (NSMutableArray *)arrayDataCollectionView {
    if (!_arrayDataCollectionView) {
        _arrayDataCollectionView = @[].mutableCopy;
    }
    return _arrayDataCollectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        kLeftTableViewWidth = Width_Layout(120);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftTableViewWidth, kSCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 70;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
        _tableView.separatorStyle = 0;
        [_tableView setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]];
    }
    return _tableView;
}

- (LJCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[LJCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = Width_Layout(30);
        _flowLayout.minimumLineSpacing = Height_Layout(30);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCollectionViewMargin + kLeftTableViewWidth, kCollectionViewMargin, kSCREEN_WIDTH - kLeftTableViewWidth - 2 * kCollectionViewMargin, kSCREEN_HEIGHT - 2 * kCollectionViewMargin) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
    }
    return _collectionView;
}

- (void)Network {
    NSString *URL = @"cblejpersonjob/list.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        self.model = [WorkTypeModel yy_modelWithJSON:result[@"data"]];
        self.arrayDataTableView = self.model.list.mutableCopy;
        if (!self.arrayDataTableView.count) {
            return;
        }
        WorkTypeModel *modelCollectionView = self.arrayDataTableView[0];
        self.arrayDataCollectionView = modelCollectionView.children.mutableCopy;
        [self.tableView reloadData];
        [self.model.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WorkTypeModel *m = obj;
            NSArray *array = m.children;
            for (int i = 0; i < array.count; i ++) {
                WorkTypeModel *mm = array[i];
                if ([mm.name isEqualToString:self.stringJob]) {
                    mm.isSelected = true;
                    WorkTypeModel *modelCollectionView = self.arrayDataTableView[idx];
                    self.arrayDataCollectionView = modelCollectionView.children.mutableCopy;
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]
                                                animated:YES
                                          scrollPosition:UITableViewScrollPositionNone];
                    *stop = YES;
                }
            }
        }];
        [self.collectionView reloadData];
        [[CacheData sharedInstance] setObject:self.model forKey:KRoleTypeList];
    } fail:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职业类别";
    _selectIndex = 0;
    _isScrollDown = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    [self Network];
}


#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDataTableView.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
    WorkTypeModel *model = self.arrayDataTableView[indexPath.row];
    cell.name.text = model.name;
    cell.selected = model.isSelected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    WorkTypeModel *modelCollectionView = self.arrayDataTableView[_selectIndex];
    self.arrayDataCollectionView = modelCollectionView.children.mutableCopy;
    [self.arrayDataTableView enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WorkTypeModel *modelTableView = obj;
        modelTableView.isSelected = false;
        if (idx == indexPath.row) {
            modelTableView.isSelected = true;
        }
    }];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.collectionView reloadData];
}

#pragma mark - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated {
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [self.collectionView setContentOffset:topOfHeader animated:animated];
}

- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayDataCollectionView.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    WorkTypeModel *model = self.arrayDataCollectionView[indexPath.item];
    cell.name.text = model.name;
    cell.selected = model.isSelected;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkTypeModel *model = self.arrayDataCollectionView[indexPath.item];
    if (self.blockDidTouchItem) {
        self.blockDidTouchItem(model);
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Width_Layout(90), 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(Height_Layout(15), Width_Layout(15), Height_Layout(15), Width_Layout(15));
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffsetY = 0;
    if (self.collectionView == scrollView) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

@end
