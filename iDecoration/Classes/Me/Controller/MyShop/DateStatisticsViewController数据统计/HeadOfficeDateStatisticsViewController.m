//
//  HeadOfficeDateStatisticsViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "HeadOfficeDateStatisticsViewController.h"
#import "HeadOfficeDataStatisticsCell.h"


@interface HeadOfficeDateStatisticsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
// 数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HeadOfficeDateStatisticsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    if (self.selectedIndex == 2) {
        [self.dataArray removeAllObjects];
        // 计算器 （仅公司的） 第0个是总公司
        [self.dataArray addObject:self.headCompanyDateModelArray[0]];
        for (int i = 1; i < self.headCompanyDateModelArray.count; i ++) {
            DateStatisticsModel *model = self.headCompanyDateModelArray[i];
            if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
                [self.dataArray addObject:model];
            }
        }
        
    } else if (self.selectedIndex == 4) {
        [self.dataArray removeAllObjects];
        // 商品 （仅店铺的） 第0个是总公司
        [self.dataArray addObject:self.headCompanyDateModelArray[0]];
        for (int i = 1; i < self.headCompanyDateModelArray.count; i ++) {
            DateStatisticsModel *model = self.headCompanyDateModelArray[i];
            if (![model.companyType isEqualToString:@"1018"] || ![model.companyType isEqualToString:@"1065"] || ![model.companyType isEqualToString:@"1064"]) {
                [self.dataArray addObject:model];
            }
        }
        
    } else {
        [self.dataArray removeAllObjects];
        self.dataArray = [self.headCompanyDateModelArray mutableCopy];
    }
    
    [self tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 55;
    } else {
        return 60;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 60)];
    if (section == 0) {
        bgView.frame = CGRectMake(0, 0, BLEJWidth, 55);
    }
    bgView.backgroundColor = kBackgroundColor;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, BLEJWidth, 50)];
    if (section == 0) {
        bottomView.frame = CGRectMake(0, 0, BLEJWidth, 50);
    }
    bottomView.backgroundColor = White_Color;
    [bgView addSubview:bottomView];
    
    UILabel *caseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH - 20, 50)];
    caseLabel.textAlignment = NSTextAlignmentLeft;
    caseLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:caseLabel];
    DateStatisticsModel *model = self.dataArray[section];
    
    if (section == 0) {
        caseLabel.text = [NSString stringWithFormat:@"%@（总公司）", model.companyName];
    } else {
        caseLabel.text = model.companyName;
    }
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HeadOfficeDataStatisticsCell *cell = [HeadOfficeDataStatisticsCell headOfficeDataStatisticsCellWith:tableView selectedIndex:self.selectedIndex];
    
    DateStatisticsModel *model = self.dataArray[indexPath.section];
    [cell setModel:model type:self.selectedIndex];
    
    if (indexPath.section == 0 && self.selectedIndex == 3) {
        // 公司的
        cell.ZeroZeroLabel.text = @"今日量房/预约";
        cell.ZeroOneLabel.text = @"总量房/预约";
        cell.ZeroTwoLabel.text = @"今日浏览量";
        cell.OneZeroLabel.text = @"总浏览量";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == 0) {
        return 210;
    } else {
        return 140;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - LazyMethod
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"HeadOfficeDataStatisticsCell" bundle:nil] forCellReuseIdentifier:@"HeadOfficeDataStatisticsCell"];
        
    }
    return _tableView;
}
@end
