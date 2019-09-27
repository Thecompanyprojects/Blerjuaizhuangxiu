//
//  HomeBroadcastListViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/9.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "HomeBroadcastListViewController.h"
#import "HomeBroadcastListTableViewCell.h"
#import "NetworkOfHomeBroadcast.h"
#import "HomeBroadcastListTableViewCell2.h"

@interface HomeBroadcastListViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong, nonatomic) NSMutableArray *arrayTableView;
@property (strong, nonatomic) NSMutableArray *arrayPage;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger tag;//0 1
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation HomeBroadcastListViewController

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (NSMutableArray *)arrayTableView {
    if (!_arrayTableView) {
        _arrayTableView = @[].mutableCopy;
    }
    return _arrayTableView;
}

- (NSMutableArray *)arrayPage {
    if (!_arrayPage) {
        _arrayPage = @[@(1), @(1)].mutableCopy;
    }
    return _arrayPage;
}

#pragma mark UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收单详情";
    [self makeUI];
    self.modelCompany = [NetworkOfHomeBroadcast new];
    self.modelCompany.isCompany = true;
    self.modelEmployee = [NetworkOfHomeBroadcast new];
    self.modelEmployee.isCompany = false;
    ShowMB
    [self setupRightButton];
    [self NetworkWithIdx:0];
    [self NetworkWithIdx:1];
}

- (void)makeUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"企业订单", @"员工订单"]];
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.tintColor = Main_Color;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(didTouchSegmentedControl:) forControlEvents:(UIControlEventValueChanged)];
    self.tag = 0;
    [self createTableView];
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    BOOL isPlay = [[NSUserDefaults standardUserDefaults] boolForKey:@"HomeBroadcastPlaySound"];
    rightButton.selected = isPlay;
    [rightButton setImage:[UIImage imageNamed:@"icon_laba"] forState:(UIControlStateSelected)];
    [rightButton setImage:[UIImage imageNamed:@"icon_guanbilaba"] forState:(UIControlStateNormal)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItems = @[item,rightItem];
    [rightButton addTarget:self action:@selector(didTouchRightButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTableView {
    [self.arrayPage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        [self.view addSubview:tableView];
        [self.arrayTableView addObject:tableView];
        tableView.tag = idx;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.tableFooterView = [UIView new];
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 60;
        if (idx == 1) {
            tableView.hidden = true;
        }else
            tableView.hidden = false;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.arrayPage insertObject:@(1) atIndex:idx];
            [self NetworkWithIdx:tableView.tag];
        }];
        tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            NSNumber *number = self.arrayPage[idx];
            NSInteger n = number.integerValue;
            n ++;
            [self.arrayPage insertObject:@(n) atIndex:idx];
            [self NetworkWithIdx:tableView.tag];
        }];
        [tableView.mj_header beginRefreshing];
    }];
}

- (void)viewWillLayoutSubviews {
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(20);
        make.height.mas_offset(30);
    }];
    [self.arrayTableView enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITableView *tableView = obj;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segmentedControl.mas_bottom).with.offset(20);
            make.left.bottom.right.equalTo(0);
        }];
    }];
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.tag == 0) {
        return self.modelCompany.list.count;
    }else
        return self.modelEmployee.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NetworkOfHomeBroadcast *model;
    if (self.tag == 0) {
        model = self.modelCompany.list[section];
    }else
        model = self.modelEmployee.list[section];
    if (model.isOpen) {
        return model.phoneList.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeBroadcastListTableViewCell *cell = [HomeBroadcastListTableViewCell cellWithTableView:tableView];
    HomeBroadcastListTableViewCell2 *cell2 = [HomeBroadcastListTableViewCell2 cellWithTableView:tableView];
    NetworkOfHomeBroadcast *modelMain;
    if (self.tag == 0) {
        modelMain = self.modelCompany.list[indexPath.section];
    }else{
        modelMain = self.modelEmployee.list[indexPath.section];
    }
    if (indexPath.row == 0) {
        cell2.labelTitle.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:modelMain.createDateStr];
        cell2.labelDetail.text = [NSString stringWithFormat:@"共收%ld单", modelMain.phoneList.count];
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI*0.5);
        CGAffineTransform transformNormal = CGAffineTransformMakeRotation(0);
        cell2.imageViewArrow.transform = modelMain.isOpen?transformNormal:transform;
        return cell2;
    }
    NetworkOfHomeBroadcast *model = modelMain.phoneList[indexPath.row - 1];
    if (self.tag == 0) {
        model.isCompany = true;
    }else
        model.isCompany = false;
    if (model.type == 0) {//0:在线预约
        [cell.imageViewIcon setImage:[UIImage imageNamed:@"icon_yuyue_H"]];
    }else if (model.type == 1) {//1:计算器
        [cell.imageViewIcon setImage:[UIImage imageNamed:@"icon_baojia"]];
    }else if (model.type == 2) {//2:活动线下
        [cell.imageViewIcon setImage:[UIImage imageNamed:@"icon_huodong"]];
    }else if (model.type == 4) {//4:线上活动
        [cell.imageViewIcon setImage:[UIImage imageNamed:@"icon_huodong"]];
    }
    cell.labelTitle.text = model.title;
    cell.labelDate.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithMin:model.createDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NetworkOfHomeBroadcast *modelMain;
        if (self.tag == 0) {
            modelMain = self.modelCompany.list[indexPath.section];
        }else
            modelMain = self.modelEmployee.list[indexPath.section];
        modelMain.isOpen = !modelMain.isOpen;
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"未找到相关信息";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)didTouchRightButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:@"HomeBroadcastPlaySound"];
}

- (void)didTouchSegmentedControl:(UISegmentedControl *)sender {
    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    self.tag = sender.selectedSegmentIndex;
    [self.arrayTableView enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITableView *tableView = obj;
        tableView.hidden = true;
        if (self.tag == idx) {
            tableView.hidden = false;
            [tableView reloadData];
        }
    }];
}

- (void)endRefreshWithTableView:(UITableView *)tableView {
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}

- (void)NetworkWithIdx:(NSInteger)idx {
    UITableView *tableView = self.arrayTableView[idx];
    NetworkOfHomeBroadcast *model;
    if (idx == 0) {
        model = self.modelCompany;
    }else if (idx == 1) {
        model = self.modelEmployee;
    }
    NSNumber *number = self.arrayPage[idx];
    [model NetworkOfListType:idx AndPage:number AndSuccess:^{
        [tableView reloadData];
        HiddenMB
        [self endRefreshWithTableView:tableView];
    } AndFailed:^{
        HiddenMB
        [self endRefreshWithTableView:tableView];
    }];
}

@end
