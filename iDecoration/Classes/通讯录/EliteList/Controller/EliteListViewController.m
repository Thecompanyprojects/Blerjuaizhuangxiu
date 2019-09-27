//
//  EliteListViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EliteListViewController.h"

@interface EliteListViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@end

@implementation EliteListViewController

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (void)Network {
    NSDictionary *dic = [[CacheData sharedInstance] objectForKey:KDictionaryOfCityIdCountyId];
    NSString *URL = @"citywiderecomend/allElite.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = @(self.pageNo);
    parameters[@"pageSize"] = @(15);
    parameters[@"countyId"] = dic?dic[@"countyId"]:@"110000";
    parameters[@"cityId"] = dic?dic[@"cityId"]:@"0";
    parameters[@"content"] = self.content?:@"";
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        [self endRefresh];
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[GeniusSquareListModel class] json:result[@"data"][@"list"]].mutableCopy;
            if (array.count < 15) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.arrayData addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self endRefresh];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群英列表";
    [self createTableView];
}

- (void)createTableView {
    WeakSelf(self)
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(weakself)
        [strongself.arrayData removeAllObjects];
        strongself.pageNo = 1;
        [strongself Network];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        StrongSelf(weakself)
        strongself.pageNo ++;
        [strongself Network];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EliteListTableViewCell *cell = [EliteListTableViewCell cellWithTableView:tableView];
    GeniusSquareListModel *model = self.arrayData[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EliteDetailViewController *vc = [[EliteDetailViewController alloc]init];
    GeniusSquareListModel *model = self.arrayData[indexPath.row];
    vc.designsId = [model.eliteDesignId integerValue];
    vc.activityType = 2;
    vc.id = [model.agencyId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据";
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
