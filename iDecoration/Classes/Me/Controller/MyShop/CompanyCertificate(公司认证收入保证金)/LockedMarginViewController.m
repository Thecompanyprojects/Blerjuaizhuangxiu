//
//  LockedMarginViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "LockedMarginViewController.h"
#import "MyOrderCell.h"
#import "MyOrderDetailViewController.h"
#import "CompanyIncomeModel.h"
#import "SureIncomeDetailController.h"


@interface LockedMarginViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageViewTopCon;
@property (weak, nonatomic) IBOutlet UILabel *mondyLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end



@implementation LockedMarginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"锁定保证金";
    self.bgImageViewTopCon.constant = kNaviBottom + 5;
    self.mondyLabel.text = self.money;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
    
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

- (void)getData {
    NSString *defaultAPi = [BASEURL stringByAppendingString:@"signUp/getDJList.do"];
    NSDictionary *paramDic = @{
                               @"companyId": self.companyId,
                               @"page": @(_page)
                               };
    [NetManager afGetRequest:defaultAPi parms:paramDic finished:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] ==  1000) {
            NSArray *dataList = [responseObj[@"data"] objectForKey:@"list"];
            
            if (_page == 1) {
                [self.dataArray removeAllObjects];
            } else {
            }
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CompanyIncomeModel class] json:dataList]];
            CompanyIncomeModel *model = self.dataArray.firstObject;
            if (model.frozenActivityMoney != nil && model.frozenActivityMoney.doubleValue > 0) {
//                self.mondyLabel.text = [NSString stringWithFormat:@"￥%@", model.frozenActivityMoney];
            } else {
//                self.mondyLabel.text = @"￥0.00";
            }
            
            [self.tableView reloadData];
        }
        if ([responseObj[@"code"] integerValue] == 1002) {
//            self.mondyLabel.text = [NSString stringWithFormat:@"￥%@",self.money?:@"0.00"];
        }
        
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSString *errorMsg) {
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.companyIncomeModel = self.dataArray[indexPath.section];
    cell.gotoDetailBlock = ^{
        YSNLog(@"去订单详情");
        SureIncomeDetailController *detailVC = [[SureIncomeDetailController alloc] initWithNibName:@"SureIncomeDetailController" bundle:nil];
        detailVC.companyIncomeModel = self.dataArray[indexPath.section];
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

#pragma lazyMethod
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
