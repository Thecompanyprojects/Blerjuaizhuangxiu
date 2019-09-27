//
//  communitymanagerVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "communitymanagerVC.h"
#import "communitymanagerHeader.h"
#import "communitymanagerCell.h"
#import "addcommunityVC.h"
#import "communitymanagerModel.h"
#import "communitymanagerModel2.h"
#import "doormodelVC.h"

@interface communitymanagerVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int pageNum;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) NSString *type;
@end

static NSString *communityidentfid = @"communityidentfid";

@implementation communitymanagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageNum = 1;
    self.type = @"1";
    self.title = self.comModel.communityName?:@"";
    [self.view addSubview:self.collectionView];
    if (self.ischange) {
        [self.view addSubview:self.footView];
    }
  
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
    pageNum = 1;
    NSString *page = [NSString stringWithFormat:@"%d",pageNum];
    NSString *pageSize = @"30";
    [self.dataSource removeAllObjects];
    NSString *communityId = [NSString stringWithFormat:@"%ld",self.comModel.communityId];
    self.dataSource = [NSMutableArray array];
    NSString *url = [NSString new];
    if ([self.type isEqualToString:@"0"]) {
        url = [BASEURL stringByAppendingString:@"cblejCommunity/getCommunityCons.do"];
    }
    else
    {
        url = [BASEURL stringByAppendingString:@"cblejCommunity/getMobelList.do"];
    }
    
    NSDictionary *para = @{@"page":page,@"pageSize":pageSize,@"communityId":communityId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            if ([self.type isEqualToString:@"0"]) {
                NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[communitymanagerModel2 class] json:responseObj[@"data"][@"list"]]];
                [self.dataSource addObjectsFromArray:data];
            }
            else
            {
                NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[communitymanagerModel class] json:responseObj[@"data"][@"list"]]];
                [self.dataSource addObjectsFromArray:data];
            }
            
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_header endRefreshing];
    }];
    
}

-(void)loadMoreData
{
    pageNum++;
    NSString *page = [NSString stringWithFormat:@"%d",pageNum];
    NSString *pageSize = @"30";
    NSString *communityId = [NSString stringWithFormat:@"%ld",self.comModel.communityId];
    NSString *url = [NSString new];
    if ([self.type isEqualToString:@"0"]) {
        url = [BASEURL stringByAppendingString:@"cblejCommunity/getCommunityCons.do"];
    }
    else
    {
        url = [BASEURL stringByAppendingString:@"cblejCommunity/getMobelList.do"];
    }
    NSDictionary *para = @{@"page":page,@"pageSize":pageSize,@"communityId":communityId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            if ([self.type isEqualToString:@"0"]) {
                NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[communitymanagerModel2 class] json:responseObj[@"data"][@"list"]]];
                [self.dataSource addObjectsFromArray:data];
            }
            else
            {
                NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[communitymanagerModel class] json:responseObj[@"data"][@"list"]]];
                [self.dataSource addObjectsFromArray:data];
            }
      
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - getters

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat naviBottom = kSCREEN_HEIGHT-52;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 52, kSCREEN_WIDTH, naviBottom-5) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH-2)/2, 169);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 1;
        [_collectionView registerClass:[communitymanagerCell class] forCellWithReuseIdentifier:communityidentfid];
        
        flowLayout.sectionInset =UIEdgeInsetsMake(0,0, 0, 0);
        flowLayout.headerReferenceSize =CGSizeMake(kSCREEN_WIDTH,167);//头视图大小
        [_collectionView registerClass:[communitymanagerHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, kSCREEN_HEIGHT-44, kSCREEN_WIDTH, 44);
        _footView.backgroundColor = [UIColor hexStringToColor:@"25B764"];
        [_footView addSubview:self.submitBtn];
    }
    return _footView;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        [_submitBtn setTitle:@"添加户型" forState:normal];
        [_submitBtn setImage:[UIImage imageNamed:@"whiteadd"] forState:normal];
        [_submitBtn setTitleColor:White_Color forState:normal];
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

#pragma mark -UICollectionViewDataSource&&UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    communitymanagerCell *cell = (communitymanagerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:communityidentfid forIndexPath:indexPath];
    cell.backgroundColor = White_Color;
    if ([self.type isEqualToString:@"0"]) {
        [cell setdata2:self.dataSource[indexPath.item]];
    }
    else
    {
        [cell setdata:self.dataSource[indexPath.item]];
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    communitymanagerHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    [header setdata:self.comModel];
    header.backgroundColor = White_Color;
    [header.chooseleftBtn addTarget:self action:@selector(headerchoosebtn0) forControlEvents:UIControlEventTouchUpInside];
    [header.chooserightBtn addTarget:self action:@selector(headerchoosebtn1) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 167);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    communitymanagerModel *model = self.dataSource[indexPath.item];
    doormodelVC *vc = [doormodelVC new];
    vc.communityId = [NSString stringWithFormat:@"%ld",self.comModel.communityId];
    vc.companyId = [NSString stringWithFormat:@"%@",self.comModel.companyId];
    vc.mobelId = [NSString stringWithFormat:@"%ld",model.mobelId];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)submitbtnclick
{
    addcommunityVC *vc = [addcommunityVC new];
    vc.communityId = [NSString stringWithFormat:@"%ld",self.comModel.communityId];
    vc.companyId = self.companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headerchoosebtn0
{
    self.type = @"1";
    [self loadNewData];
}

-(void)headerchoosebtn1
{
    self.type = @"0";
    [self loadNewData];
}

@end
