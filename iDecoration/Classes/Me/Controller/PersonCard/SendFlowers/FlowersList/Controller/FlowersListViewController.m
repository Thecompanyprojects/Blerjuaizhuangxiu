//
//  FlowersListViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "FlowersListViewController.h"
#import "FlowersListTableViewCell.h"
#import "FlowersListModel.h"
#import "FlowersStoryDetailViewController.h"
#import "NewMyPersonCardController.h"

@interface FlowersListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger pageNo;

@end

@implementation FlowersListViewController

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (void)NetworkOfList {
    NSString *URL = @"cblejflower/getByPersonId.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"personId"] = self.personId;
    parameters[@"page"] = @(self.pageNo);
    parameters[@"pageSize"] = @(15);
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        NSArray *array = result[@"data"][@"list"];
        for (NSDictionary *dic in array) {
            FlowersListModel *model = [FlowersListModel yy_modelWithJSON:dic];
            [self.arrayData addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"鲜花榜";
    [self createTableView];
}

- (void)createTableView {
    WeakSelf(self)
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(weakself)
        [strongself.arrayData removeAllObjects];
        strongself.pageNo = 1;
        [strongself NetworkOfList];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        StrongSelf(weakself)
        strongself.pageNo ++;
        [strongself NetworkOfList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillLayoutSubviews {
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowersListTableViewCell *cell0 = [FlowersListTableViewCell cellWithTableView:tableView AndIndex:0];
    FlowersListTableViewCell *cell1 = [FlowersListTableViewCell cellWithTableView:tableView AndIndex:1];
    FlowersListModel *model = self.arrayData[indexPath.section];
    NSArray *array = @[cell0, cell1];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FlowersListTableViewCell *cell = obj;
        [cell setModel:model];
        cell.blockDidTouchButton = ^{
            [self pushToDetailViewControllerWith:model];
        };
        cell.blockDidTouchIcon = ^{
            [self pushToCardViewControllerWith:model];
        };
    }];

    if (model.title.length || model.story.length) {//有故事或标题
        if (model.story.length && !model.title.length) {
            cell0.buttonStory.userInteractionEnabled = true;
            return cell0;//有故事没标题
        }else{
            cell0.buttonStory.userInteractionEnabled = false;
            return cell1;//有标题没故事
        }
    }else{//没有故事和标题
        cell0.buttonStory.userInteractionEnabled = false;
        return cell0;
    }
}

- (void)pushToDetailViewControllerWith:(FlowersListModel *)model {
    FlowersStoryDetailViewController *controller = [FlowersStoryDetailViewController new];
    controller.model = model;
    [self.navigationController pushViewController:controller animated:true];
}

- (void)pushToCardViewControllerWith:(FlowersListModel *)model {
    NewMyPersonCardController *controller = [NewMyPersonCardController new];
    controller.agencyId = model.agencyId;
    [self.navigationController pushViewController:controller animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
