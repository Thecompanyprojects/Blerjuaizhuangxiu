//
//  DayStatisticsViewController.m
//  iDecoration
//
//  Created by 丁 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//
#import "DayStatisticsViewController.h"
#import "DataStatisticsModel.h"
#import "DataStatisticsTableViewCell.h"

@interface DayStatisticsViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *bgScrollView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *viewLine;
@property (strong, nonatomic) NSMutableArray *arrayTopButtons;
@property (strong, nonatomic) NSMutableArray *arrayTableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger typeTag;//0~5 黄~活

@end

@implementation DayStatisticsViewController

- (NSMutableArray *)arrayTableView {
    if (!_arrayTableView) {
        _arrayTableView = @[].mutableCopy;
    }
    return _arrayTableView;
}

- (NSMutableArray *)arrayTopButtons {
    if (!_arrayTopButtons) {
        _arrayTopButtons = @[].mutableCopy;
    }
    return _arrayTopButtons;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.height = 44;
        _topView.width = kSCREEN_WIDTH;
        [_topView addSubview:self.viewLine];
    }
    return _topView;
}

- (UIView *)viewLine {
    if (!_viewLine) {
        _viewLine = [UIView new];
        _viewLine.height = 2.5;
        _viewLine.width = 25;
        _viewLine.backgroundColor = basicColor;
    }
    return _viewLine;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:(CGRectZero)];
        _bgScrollView.delegate = self;
        _bgScrollView.backgroundColor = kBackgroundColor;
        _bgScrollView.pagingEnabled = true;
    }
    return _bgScrollView;
}

- (void)Network {
    NSString *URL = @"statistic/getStatic.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"companyId"] = self.companyId;
    parameters[@"currentPerson"] = self.currentPerson;
    parameters[@"type"] = @(self.type);
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            self.arrayData = [NSArray yy_modelArrayWithClass:[DataStatisticsModel class] json:result[@"data"][@"list"]].mutableCopy;
            [self tableViewReloadDataWithTag:self.typeTag];
        }
    } fail:^(id error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.scrollEnabled = false;
    [self makeUI];
    [self Network];
}

- (void)viewWillLayoutSubviews {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(isiPhoneX?88:64);
        make.height.equalTo(44);
    }];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.bottom.left.right.equalTo(0);
    }];
}

- (void)makeUI {
    self.bgScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * DataStatisticsModel.arrayTop.count, 0);
    [DataStatisticsModel.arrayTop enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.arrayTopButtons addObject:button];
        button.tag = idx;
        [button addTarget:self action:@selector(didTouchButtonTop:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitle:title forState:(UIControlStateNormal)];
        [button setTitleColor:basicColor forState:(UIControlStateSelected)];
        [button setTitleColor:[UIColor hexStringToColor:@"999999"] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.width = kSCREEN_WIDTH / DataStatisticsModel.arrayTop.count;
        button.height = 60;
        [self.topView addSubview:button];
        button.X = idx * button.width;
        button.centerY = self.topView.centerY;
        if (idx == 0) {
            button.selected = true;
            self.viewLine.centerX = button.centerX;
            self.viewLine.Y = self.topView.height - 2.5;
        }

        UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRect){ idx * kSCREEN_WIDTH,0,kSCREEN_WIDTH,isiPhoneX?(kSCREEN_HEIGHT - 64 - 48 - 55):(kSCREEN_HEIGHT - 64 - 48)} style:(UITableViewStyleGrouped)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = kBackgroundColor;
        tableView.tag = idx;
        tableView.emptyDataSetSource   = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200;
        [self.arrayTableView addObject:tableView];
        [self.bgScrollView addSubview:tableView];
    }];
}

- (void)tableViewReloadDataWithTag:(NSInteger)tag {
    UITableView *tableView = self.arrayTableView[tag];
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    DataStatisticsModel *model = self.arrayData[self.typeTag];
    return model.valuelist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataStatisticsTableViewCell *cell = [DataStatisticsTableViewCell cellWithTableView:tableView];
    DataStatisticsModel *model = self.arrayData[self.typeTag];
    DataStatisticsModel *modellist = model.valuelist[indexPath.section];
    [cell setModel:modellist WithScroll:[self.title isEqualToString:@"月统计"]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (DataStatisticsModel.arrayTitle.count > 0) {
        if (scrollView == self.bgScrollView) {
            UIButton *button;
            [self.arrayTopButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button = obj;
                button.userInteractionEnabled = false;
            }];
            NSString *str = [NSString stringWithFormat:@"%0.0f",self.bgScrollView.contentOffset.x/kSCREEN_WIDTH];
            if (self.bgScrollView.contentOffset.x == kSCREEN_WIDTH * str.integerValue) {
                button = self.arrayTopButtons[str.integerValue];
                [self didTouchButtonTop:button];
            }
        }
    }
}

- (void)didTouchButtonTop:(UIButton *)button {
    [self.arrayTopButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        button.selected = false;
        button.userInteractionEnabled = true;
    }];
    self.typeTag = button.tag;
    button.selected = true;
    [UIView animateWithDuration:0.2 animations:^{
        self.viewLine.centerX = button.centerX;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.bgScrollView.contentOffset = CGPointMake(kSCREEN_WIDTH * button.tag, 0);
    }];
    [self tableViewReloadDataWithTag:button.tag];
}

@end
