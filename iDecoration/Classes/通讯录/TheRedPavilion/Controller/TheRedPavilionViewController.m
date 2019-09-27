//
//  TheRedPavilionViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "TheRedPavilionViewController.h"
#import "TheRedPavilionTableViewCell.h"
#import "TheRedPavilionModel.h"
#import "NewMyPersonCardController.h"
#import "BannerListViewController.h"
#import "FlowersListViewController.h"

@interface TheRedPavilionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) UIButton *buttonToTop;
@property (assign, nonatomic) NSInteger pageNo;
@property (assign, nonatomic) NSInteger orderType;//0:默认排序 1:鲜花默认 2:鲜花递增 3:锦旗默认 4:锦旗递增
@property (assign, nonatomic) BOOL isBannerTop;
@property (assign, nonatomic) BOOL isFlowerTop;

@end

@implementation TheRedPavilionViewController

- (UIButton *)buttonToTop {
    if (!_buttonToTop) {
        _buttonToTop = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _buttonToTop.frame = CGRectMake(kSCREEN_WIDTH - 70, kSCREEN_HEIGHT - 70, 50, 50);
        [_buttonToTop setImage:[UIImage imageNamed:@"icon_huadongjiantou"] forState:(UIControlStateNormal)];
        [_buttonToTop addTarget:self action:@selector(didTouchButtonTop) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buttonToTop;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
    }
    return _tableView;
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (void)Network {
    NSMutableDictionary *dic = [[CacheData sharedInstance] objectForKey:KDictionaryOfCityIdCountyId];
    NSString *URL = @"businessCard/famouse.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = @(self.pageNo);
    parameters[@"pageSize"] = @(15);
    parameters[@"countyId"] = dic?dic[@"countyId"]:@"110000";
    parameters[@"cityId"] = dic?dic[@"cityId"]:@"0";
    parameters[@"orderType"] = @(self.orderType);
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        [self endRefresh];
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[TheRedPavilionModel class] json:result[@"data"][@"list"]];
            [self.arrayData addObjectsFromArray:array];
            if (array.count < 15) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
    } fail:^(id error) {
        [self endRefresh];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红人馆";
    self.topViewToTop.constant = isiPhoneX?88:64;
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.buttonToTop];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.buttonToTop removeFromSuperview];
}

- (void)viewWillLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(self.buttonAll.mas_bottom).offset(1);
    }];
}

- (void)createTableView {
    WeakSelf(self)
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
    TheRedPavilionTableViewCell *cell = [TheRedPavilionTableViewCell cellWithTableView:tableView];
    TheRedPavilionModel *model = self.arrayData[indexPath.row];
    [cell setModel:model];
    cell.blockDidTouchButton = ^(NSInteger tag) {
        if (tag == 0) {//锦旗
            BannerListViewController *controller = [BannerListViewController new];
            controller.agencyID = model.agencyId;
            [self.navigationController pushViewController:controller animated:true];
        }else{//鲜花
            FlowersListViewController *controller = [FlowersListViewController new];
            controller.personId = @([model.agencyId integerValue]);
            [self.navigationController pushViewController:controller animated:true];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TheRedPavilionModel *model = self.arrayData[indexPath.row];
    NewMyPersonCardController *controller = [NewMyPersonCardController new];
    controller.agencyId = model.agencyId;
    [self.navigationController pushViewController:controller animated:true];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (IBAction)didTouchButtonTop:(UIButton *)sender {
    [self.buttonBanner setImage:[UIImage imageNamed:@"icon_jiantou_red"] forState:(UIControlStateNormal)];
    [self.buttonFlower setImage:[UIImage imageNamed:@"icon_jiantou_red"] forState:(UIControlStateNormal)];
    switch (sender.tag) {
        case 0:
            self.orderType = 0;
            break;
        case 1:
            if (self.orderType != 4 && self.orderType != 3) {
                self.isBannerTop = false;
            }else{
                self.isBannerTop = !self.isBannerTop;
            }
            self.orderType = self.isBannerTop?4:3;
            [sender setImage:[UIImage imageNamed:self.isBannerTop?@"icon_jiantou_pre_up_red":@"icon_jiantou_pre_dn_red"] forState:(UIControlStateNormal)];
            break;
        case 2:
            if (self.orderType != 2 && self.orderType != 1) {
                self.isFlowerTop = false;
            }else{
                self.isFlowerTop = !self.isFlowerTop;
            }
            self.orderType = self.isFlowerTop?2:1;
            [sender setImage:[UIImage imageNamed:self.isFlowerTop?@"icon_jiantou_pre_up_red":@"icon_jiantou_pre_dn_red"] forState:(UIControlStateNormal)];
            break;

        default:
            break;
    }
    [self.tableView.mj_header beginRefreshing];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"未找到相关信息";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)didTouchButtonTop {
    [self.tableView setContentOffset:CGPointZero animated:true];
}

- (void)dealloc {
    [self.buttonToTop removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
