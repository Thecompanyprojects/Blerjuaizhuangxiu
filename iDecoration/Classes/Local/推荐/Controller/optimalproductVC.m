//
//  optimalproductVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "optimalproductVC.h"
#import "optimalproductCell.h"
#import "optimalgoodsModel.h"
#import "GoodsDetailViewController.h"

@interface optimalproductVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int pagenum;
}
@property (nonatomic,strong)  UICollectionView *collectionView;
@property (nonatomic,strong)  NSMutableArray *dataSource;
@end

static NSString *optimalproductidentfid = @"optimalproductidentfid";

@implementation optimalproductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优品";
    self.dataSource = [NSMutableArray array];
    pagenum = 1;
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadNewData
{
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    
    NSString *cityId = self.cityId;
    NSString *countyId = self.countyId;
    NSString *page = @"1";
    NSString *pageSize = @"10";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    [self.dataSource removeAllObjects];
    NSString *url = [BASEURL stringByAppendingString:Local_shangping];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
           
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[optimalgoodsModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    pagenum++;
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    NSString *cityId = self.cityId;
    NSString *countyId = self.countyId;
    
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *pageSize = @"10";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_shangping];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[optimalgoodsModel class] json:responseObj[@"data"][@"list"]]];
            
            
            [self.dataSource addObjectsFromArray:data];
        }
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}



#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, AD_height+10);//头部大小
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom-5, kSCREEN_WIDTH, naviBottom-5) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH-5)/2, 300);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 1;
        [_collectionView registerClass:[optimalproductCell class] forCellWithReuseIdentifier:optimalproductidentfid];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = kBackgroundColor;
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    optimalproductCell *cell = (optimalproductCell *)[collectionView dequeueReusableCellWithReuseIdentifier:optimalproductidentfid forIndexPath:indexPath];
    cell.backgroundColor = kBackgroundColor;
    [cell setdata:self.dataSource[indexPath.item]];
    return cell;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    optimalgoodsModel *model = self.dataSource[indexPath.item];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.fromBack = NO;
    vc.goodsID = [model.Newid integerValue];
    vc.shopID = [NSString stringWithFormat:@"%ld",model.merchantId];
    vc.companyType = [NSString stringWithFormat:@"%ld",model.companyType];
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];

}

@end
