//
//  MyOrderPageController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "MyOrderPageController.h"
#import "MyOrderCell.h"
#import "MyOrderDetailViewController.h"
#import "MyOrderModel.h"

@interface MyOrderPageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation MyOrderPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRandomColor;
    [self tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)getData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signUp/signUpListByAgencysId.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];

    [paramDic setObject:@(self.agencyId) forKeyedSubscript:@"agencysId"];
    [paramDic setObject:@(_page) forKey:@"page"];
    [paramDic setObject:@(30) forKey:@"pageSize"];
    [paramDic setObject:@(self.orderType) forKey:@"status"]; // 0:全部，1：待确认，2：已确认
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSArray *listArray = [responseObj objectForKey:@"data"][@"list"];
            if (_page == 1) {
                [self.dataArray removeAllObjects];
            } else {
            }
            
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MyOrderModel class] json:listArray]];
            [self.tableView reloadData];
        }
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma  mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.model = self.dataArray[indexPath.section];
    
    cell.gotoDetailBlock = ^{
        NSLog(@"去订单详情");
        MyOrderDetailViewController *detailVC = [[MyOrderDetailViewController alloc] initWithNibName:@"MyOrderDetailViewController" bundle:nil];
        detailVC.myOrderModel = self.dataArray[indexPath.section];
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 91;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v= [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UITableViewHeaderFooterView new];
}


#pragma mark - LazyMethod
-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = kCustomColor(242, 242, 242);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.bottom.equalTo(0);
        }];
        [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
        tableFooterView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = tableFooterView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
