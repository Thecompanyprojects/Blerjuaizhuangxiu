//
//  localbroadcastVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localbroadcastVC.h"
#import "localbroadcastCell.h"
#import "localbroadcastModel.h"

@interface localbroadcastVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int page;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *localbroadcastidentfid = @"localbroadcastidentfid";

@implementation localbroadcastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家播报";
    page = 1;
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
    page = 1;
    [self.dataSource removeAllObjects];
    NSString *url = [BASEURL stringByAppendingString:GET_LOCALBOBAO];
    NSDictionary *para = @{@"countyId":self.countyId,@"cityId":self.cityId,@"page":@"1",@"pageSize":@"30"};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localbroadcastModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
        [self.table.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
    }];
    
}

-(void)loadMoreData
{
    page++;
    NSString *pagestr = [NSString stringWithFormat:@"%d",page];
    NSString *url = [BASEURL stringByAppendingString:GET_LOCALBOBAO];
    NSDictionary *para = @{@"countyId":self.countyId,@"cityId":self.cityId,@"page":pagestr,@"pageSize":@"30"};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localbroadcastModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
        [self.table.mj_footer endRefreshing];
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
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, naviBottom);
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    localbroadcastCell *cell = [tableView dequeueReusableCellWithIdentifier:localbroadcastidentfid];
    cell = [[localbroadcastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localbroadcastidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
