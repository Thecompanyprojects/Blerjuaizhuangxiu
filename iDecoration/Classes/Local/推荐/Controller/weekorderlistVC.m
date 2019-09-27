//
//  weekorderlistVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "weekorderlistVC.h"
#import "orderlistheadView.h"
#import "orderlistCell.h"
#import "rankingModel.h"
#import "CompanyDetailViewController.h"

@interface weekorderlistVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int pagenum;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) orderlistheadView *headView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) rankingModel *headModel;

@end

static NSString *orderlistidentfid2 = @"orderlistidentfid2";

@implementation weekorderlistVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headModel = [[rankingModel alloc] init];
    [self.view addSubview:self.table];
    //self.view.backgroundColor = [UIColor hexStringToColor:@"4ABD87"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.table.tableHeaderView = self.headView;
    self.table.tableFooterView = [UIView new];
    [self layoutUI];
    pagenum = 1;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutUI
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-50);
    }];
}

#pragma mark - 数据方法

-(void)loadNewData
{
    pagenum = 1;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *orderType = @"2";
    NSDictionary *para = @{@"page":page,@"orderType":orderType,@"cityId":self.cityId,@"countryId":self.countryId,@"pageSize":@"30"};
    
    [self.dataSource removeAllObjects];
    NSMutableArray *array = [NSMutableArray new];
    NSString *url = [BASEURL stringByAppendingString:POST_getRangeList];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[rankingModel class] json:responseObj[@"data"][@"rngList"]]];
            [array addObjectsFromArray:data];
            self.headModel = [array firstObject];
            if (array.count!=0) {
                [array removeObjectAtIndex:0];
            }
            [self.dataSource addObjectsFromArray:array];
            [self.headView setdata:self.headModel];
        }
        //self.table.backgroundColor = [UIColor hexStringToColor:@"4ABD87"];
        [self.table.mj_header endRefreshing];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    pagenum++;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *orderType = @"2";
    NSDictionary *para = @{@"page":page,@"orderType":orderType,@"cityId":self.cityId,@"countryId":self.countryId,@"pageSize":@"30"};
    
    NSString *url = [BASEURL stringByAppendingString:POST_getRangeList];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[rankingModel class] json:responseObj[@"data"][@"rngList"]]];
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
        _table = [[UITableView alloc] init];
        _table.dataSource = self;
        _table.delegate = self;
        
    }
    return _table;
}

-(orderlistheadView *)headView
{
    if(!_headView)
    {
        _headView = [[orderlistheadView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 130)];
        _headView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_headView addGestureRecognizer:tapGesturRecognizer];
    }
    return _headView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderlistCell *cell = [tableView dequeueReusableCellWithIdentifier:orderlistidentfid2];
    cell = [[orderlistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderlistidentfid2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    NSString *num = [NSString stringWithFormat:@"%ld",indexPath.row+2];
    [cell setnumber:num];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tapAction
{
    CompanyDetailViewController *company = [CompanyDetailViewController new];
    company.companyName = self.headModel.companyName;
    company.companyID = [NSString stringWithFormat:@"%ld",self.headModel.companyId];
    [self.navigationController pushViewController:company animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rankingModel *model = self.dataSource[indexPath.row];
    CompanyDetailViewController *company = [CompanyDetailViewController new];
    company.companyName = model.companyName;
    company.companyID = [NSString stringWithFormat:@"%ld",model.companyId];
    [self.navigationController pushViewController:company animated:YES];
}

@end
