//
//  localcompanyVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localcompanyVC.h"
#import "localcompanyCell.h"
#import "localcompanyModel.h"
#import <SDAutoLayout.h>
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"

@interface localcompanyVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
{
    int pagenum;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *localcompanyproductidentfid = @"localcompanyproductidentfid";


@implementation localcompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公司";
    self.dataSource = [NSMutableArray array];
    pagenum = 1;
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadNewData
{
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
     
    NSString *cityId = self.cityId;
    NSString *countyId = @"";
    countyId = self.countyId;
    

    NSString *page = @"1";
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_gongsi];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.dataSource removeAllObjects];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localcompanyModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table.mj_header endRefreshing];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
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
    NSString *countyId = @"";
    countyId = self.countyId;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_gongsi];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localcompanyModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table.mj_footer endRefreshing];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_footer endRefreshing];
    }];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    localcompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:localcompanyproductidentfid];
    cell = [[localcompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localcompanyproductidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}

//跳转公司详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    localcompanyModel *model = self.dataSource[indexPath.row];
    
    //公司
    if (model.companyType==1018||model.companyType==1064||model.companyType==1065) {
        CompanyDetailViewController *company = [CompanyDetailViewController new];
        company.companyName = model.companyName;
        company.origin = @"1";
        company.companyID = [NSString stringWithFormat:@"%ld",(long)model.companyId];
        [self.navigationController pushViewController:company animated:YES];
    }
    else//店铺
    {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc] init];
        vc.shopID = [NSString stringWithFormat:@"%ld", (long)model.companyId];
        vc.shopName = model.companyName;
        vc.origin = @"1";
               // vc.shopLogo = model.companyLogo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 电话

-(void)myphoneVClick:(UITableViewCell *)cell
{
    
}
@end
