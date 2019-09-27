//
//  SureIncomeController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SureIncomeController.h"
#import "MyOrderCell.h"
#import "SureIncomeDetailController.h"
#import "CompanyIncomeModel.h"
#import "CompanywithdrawalVC.h"

@interface SureIncomeController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewTopCon;
// 提现按钮
@property (weak, nonatomic) IBOutlet UIButton *makeMoneyBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic,copy) NSString *token;
@end

@implementation SureIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCustomColor(249, 249, 249);
    self.topImageViewTopCon.constant = self.navigationController.navigationBar.bottom + 5;
   
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
    
    switch (self.type) {
        case MoneyTypeSure: // 确认收钱
        {
            self.title = @"已到账收入";
            self.titleLabel.text = @"订单";
            self.makeMoneyBtn.hidden = NO;
        }
            break;
        case MoneyTypeUnsure: // 未确认收钱
        {
            self.title = @"未到账收入";
            self.titleLabel.text = @"订单";
            self.makeMoneyBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
    
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

// 提现
- (IBAction)makeMoneyAction:(id)sender {
    CompanywithdrawalVC *vc = [CompanywithdrawalVC new];
    vc.companyId = self.companyId;
    vc.type = @"1";
    vc.token = self.token;
    CompanyIncomeModel *model = self.dataArray.firstObject;
    vc.moneyStr = model.withdrawalsYes;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData {
    NSString *defaultAPi = [BASEURL stringByAppendingString:@"income/getSRLIst.do"];
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
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%@", model.withdrawalsYes];
            self.token = [responseObj objectForKey:@"token"];
            [self.tableView reloadData];
        }
        if ([responseObj[@"code"] integerValue] == 1002) {
            self.totalMoneyLabel.text = @"￥0.00";
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

#pragma mark - UItableViewDelegate
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
