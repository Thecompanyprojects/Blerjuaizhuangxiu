//
//  StaffPageViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//


#import "StaffPageViewController.h"
#import "StaffCell.h"
#import "StaffModel.h"
#import "DesignTeamDetailController.h"


@interface StaffPageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *dateArray;

@end

@implementation StaffPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionView];
//    测试数据
//    self.companyId = @"631";
//    self.teamType = @"1010";
    [self getDate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeGoTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification

-(void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kHomeGoTopNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
        }
    }else if([notificationName isEqualToString:kHomeLeaveTopNotification]){
        self.collectionView.contentOffset = CGPointZero;
        self.canScroll = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
    }
}


- (void)getDate {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASEURL, @"constructionPerson/v2/teamPersonInf.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.companyId forKey:@"companyId"];
    [paramDic setObject:self.teamType forKey:@"teamType"];
    [paramDic setObject:@"1" forKey:@"page"];
    [paramDic setObject:@"999" forKey:@"pageSize"];
    [paramDic setObject:@"0" forKey:@"firstLoad"];
    YSNLog(@"%@", paramDic);
    [NetManager afGetRequest:urlString parms:paramDic finished:^(id responseObj) {
        YSNLog(@"%@", responseObj);
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            [self.dateArray addObjectsFromArray:[[NSArray yy_modelArrayWithClass:[StaffModel class] json:responseObj[@"data"][@"agencysList"]] mutableCopy]];
            [self.collectionView reloadData];
            
            if (self.dateArray.count == 0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还没有员工信息"];
            }
            
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请求数据出错"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - UICollecitonView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StaffCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StaffCell" forIndexPath:indexPath];
    StaffModel *model = self.dateArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DesignTeamDetailController *vc = [[DesignTeamDetailController alloc] init];
    vc.titleStr = self.titleStr;
    vc.staffModel = self.dateArray[indexPath.item];
    vc.isShop = self.isShop;
    vc.companyId = self.companyId;
    vc.companyType = self.companyType;
    vc.phone = self.phone;
    vc.telPhone = self.telPhone;
    vc.areaList = self.areaList;
    vc.baseItemsArr = self.baseItemsArr;
    vc.suppleListArr = self.suppleListArr;
    vc.calculatorTempletModel = self.calculatorTempletModel;
    vc.constructionCase = self.constructionCase;
    vc.companyId = self.companyId;
    vc.topCalculatorImageArr = self.topCalculatorImageArr;
    vc.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    vc.companyDic = self.companyDic;
    vc.code = self.code;
    vc.teamType = self.teamType;
    vc.dispalyNum = self.dispalyNum;
    vc.origin = @"0";
    [self.nav pushViewController:vc animated:YES];
}


#pragma mark - LazyMethod
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"StaffCell" bundle:nil] forCellWithReuseIdentifier:@"StaffCell"];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 10;
        CGFloat itemWidth = (kSCREEN_WIDTH - margin *4)/3.0;
        _flowLayout.itemSize = CGSizeMake( itemWidth, itemWidth + 72);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _flowLayout;
}
- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}
@end
