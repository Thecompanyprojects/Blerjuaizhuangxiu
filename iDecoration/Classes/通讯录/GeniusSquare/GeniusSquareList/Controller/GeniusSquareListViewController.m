//
//  GeniusSquareListViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "GeniusSquareListViewController.h"
#import "GeniusSquareListModel.h"

#import "AddressBookCollectionViewCell0.h"
#import "GeniusSquareLabelModel.h"
#import "EliteListTableViewCell.h"
@interface GeniusSquareListViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewLayout *flowLayout;
@property (strong, nonatomic) NSMutableArray *arrayDataLabel;
@property (strong, nonatomic) UIView *viewBG;
@property (strong, nonatomic) UIButton *buttonRight;
@property (strong, nonatomic) UITableView *tableV;
@property (assign, nonatomic) BOOL  showAll;
@end

@implementation GeniusSquareListViewController{
    NSInteger pageNo;
}

- (NSMutableArray *)arrayDataLabel {
    if (!_arrayDataLabel) {
        _arrayDataLabel = @[].mutableCopy;
    }
    return _arrayDataLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部分类";
    [self setupRightButton];
    [self createCollectionView];
    self.showAll =YES;
    
    

    self.tableV =[[UITableView alloc]init];
    self.tableV.frame = CGRectMake(0, isiPhoneX?88 :64, BLEJWidth, BLEJHeight);
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableV];
    
    self.tableV.rowHeight = UITableViewAutomaticDimension;
    self.tableV.estimatedRowHeight = 60;
    

    WeakSelf(self)
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        StrongSelf(weakself)
//        [strongself.arrayData removeAllObjects];
//        strongself.pageNo =1;
//        [strongself Network];
//    }];
//    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//        StrongSelf(weakself)
//        strongself.pageNo ++;
//        [strongself Network];
//    }];
    [self Network];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.arrayData = [[CacheData sharedInstance] objectForKey:KGeniusSquareLabelList];
    NSInteger i = self.arrayData.count / 3;
    if (self.arrayData.count % 3 == 2) {
        i = i + 1;
    }
    self.collectionView.frame = (CGRect){0, 0, kSCREEN_WIDTH, i * 55};
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewBG removeFromSuperview];
}
- (void)Network {
    NSString *URL = @"agency/talentSquare.do";
    //    NSMutableDictionary *dic = [[CacheData sharedInstance] objectForKey:KDictionaryOfCityIdCountyId];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (self.showAll) {
          parameters[@"content"] = @"";
    }else{
        parameters[@"content"] = self.controllerTitle;
    }
    parameters[@"pageSize"] = @"";
    parameters[@"page"] = @"";
  
    parameters[@"countyId"] = self.countyId?:@"";
    parameters[@"cityId"] = self.cityId?:@"0";
    
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        [self endRefresh];
        [self.arrayDataLabel removeAllObjects];
        if ([result[@"code"] isEqualToString:@"1000"]) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[GeniusSquareListModel class] json:result[@"data"][@"list"]];
            [self.arrayDataLabel addObjectsFromArray:array];
//            if (array.count < 15) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
            [self.tableV reloadData];
        }
    } fail:^(NSError *error) {
        [self endRefresh];
    }];
}
- (void)createCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AddressBookCollectionViewCell0" bundle:nil] forCellWithReuseIdentifier:@"AddressBookCollectionViewCell0"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = false;
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonRight = rightButton;
    
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"icon_shaixuan"] forState:(UIControlStateNormal)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItem =rightItem;
    [rightButton addTarget:self  action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.arrayDataLabel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeniusSquareListModel *model = self.arrayDataLabel[indexPath.row];
    EliteListTableViewCell *cell = [EliteListTableViewCell cellWithTableView:tableView];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GeniusSquareListModel *model = self.arrayData[indexPath.row];
    NewMyPersonCardController *controller = [NewMyPersonCardController new];
    controller.agencyId = model.agencyId;
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark collectionView
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Width_Layout(100), Height_Layout(50));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 12, 15, 12);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookCollectionViewCell0 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddressBookCollectionViewCell0" forIndexPath:indexPath];
    GeniusSquareLabelModel *model = self.arrayData[indexPath.item];
    cell.labelTitle.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GeniusSquareLabelModel *model = self.arrayData[indexPath.item];
    self.controllerTitle = model.name;
    self.title = self.controllerTitle;
  
    [self.viewBG removeFromSuperview];
  
    
    
    self.showAll =NO;
    [self Network];
}

- (void)didTouchRightButton {

    UIView *viewBG = [UIView new];
    viewBG.frame = (CGRect){0, isiPhoneX?88:64, kSCREEN_WIDTH, isiPhoneX?kSCREEN_HEIGHT - 88:kSCREEN_HEIGHT - 64};
    [self.view insertSubview:viewBG aboveSubview:self.tableV];
    viewBG.userInteractionEnabled = true;
    [viewBG setBackgroundColor: [[UIColor blackColor ]colorWithAlphaComponent:0.4]];
    [viewBG addSubview:self.collectionView];
    self.viewBG = viewBG;
   
    
   
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBG)];
    tap.delegate = self;
    [self.viewBG addGestureRecognizer:tap];
}

// 手势和didSelectItemAtIndexPath会起冲突,判断touch.view是否是collectionView 如果是collectionView则不走手势方法


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
}
- (void)removeBG {
    
  //  self.buttonRight.userInteractionEnabled = true;
    [self.viewBG removeFromSuperview];
}

- (void)endRefresh {
    [self.tableV.mj_footer endRefreshing];
    [self.tableV.mj_header endRefreshing];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"未找到相关信息";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
