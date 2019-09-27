//
//  LocalactivityVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "LocalactivityVC.h"
#import "localactivityCell.h"
#import <SDAutoLayout.h>
#import "localactivityModel.h"
#import "NewsActivityShowController.h"

@interface LocalactivityVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int pagenum;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *localactivityidentfid = @"localactivityidentfid";

@implementation LocalactivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动";
    pagenum = 1;
    self.dataSource = [NSMutableArray array];
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
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_huodong];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.dataSource removeAllObjects];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localactivityModel class] json:responseObj[@"data"][@"list"]]];
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
    NSString *countyId = self.countyId;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_huodong];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localactivityModel class] json:responseObj[@"data"][@"list"]]];
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
    localactivityCell *cell = [tableView dequeueReusableCellWithIdentifier:localactivityidentfid];
    cell = [[localactivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localactivityidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    localactivityModel *model = self.dataSource[indexPath.row];
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.origin = @"1";
    vc.designsId = model.designId;
    vc.activityType = 3;
    vc.companyPhone = model.companyPhone;
    vc.companyLandLine = model.companyLandline;
    vc.companyLogo = model.companyLogo;
    vc.companyName = model.companyName;
    vc.companyId = [NSString stringWithFormat:@"%ld",model.companyId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
