//
//  AddressBookViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookModel.h"
#import "AddressBookTableViewCell.h"
#import "AddressBookSearchView.h"
#import "GeniusSquareViewController.h"//人才广场全部
#import "EliteListViewController.h"//群英列表
#import "TheRedPavilionViewController.h"//红人馆
#import "GeniusSquareLabelModel.h"
#import "CacheData.h"
#import "GeniusSquareListViewController.h"
#import "EliteListModel.h"
#import "EliteDetailViewController.h"
#import "AddressBookSearchViewController.h"
#import "CelebrityInterviewsListViewController.h"//名人专访全部

@interface AddressBookViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) AddressBookSearchView *searchView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) NSMutableArray *arrayDataEliteList;
@end

@implementation AddressBookViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStyleGrouped)];
    }
    return _tableView;
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (AddressBookSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[AddressBookSearchView alloc] init];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.frame = CGRectMake(0, 0, screenW, 45);
    }
    return _searchView;
}


/**
 人才广场更多标签
 */
- (void)Network {
    NSString *URL = @"cblejnamelist/list.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] isEqualToString:@"1000"]) {
            self.arrayData = [NSArray yy_modelArrayWithClass:[GeniusSquareLabelModel class] json:result[@"data"][@"list"]].mutableCopy;
            [[CacheData sharedInstance] setObject:self.arrayData forKey:KGeniusSquareLabelList];
        }
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:(UITableViewRowAnimationNone)];
    } fail:^(NSError *error) {

    }];
}


/**
 获取精英推荐列表
 */
- (void)NetworkOfGetEliteList {
    NSMutableDictionary *dic = [[CacheData sharedInstance] objectForKey:KDictionaryOfCityIdCountyId];
    NSString *URL = @"citywiderecomend/allElite.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"countyId"] = dic?dic[@"countyId"]:@"110000";
    parameters[@"cityId"] = dic?dic[@"cityId"]:@"0";
    parameters[@"pageSize"] = @(3);
    parameters[@"page"] = @(1);
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            self.arrayDataEliteList = [NSArray yy_modelArrayWithClass:[GeniusSquareListModel class] json:result[@"data"][@"list"]].mutableCopy;
            NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
            [self.tableView reloadSections:set withRowAnimation:(UITableViewRowAnimationNone)];
        }
    } fail:^(id error) {

    }];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createTableView];
    [self Network];
    [self NetworkOfGetEliteList];
    self.searchView.searchBar.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableHeaderView = self.searchView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self NetworkOfGetEliteList];
    }];
}

- (void)viewWillLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(isiPhoneX? - 83 - 44: - 49 - 44);
    }];
}

#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger height = 80;
    switch (indexPath.section) {
        case 0:
            height = 30 + Height_Layout(75);
            break;
        case 1:
            height = 30 + 370;
            break;
        case 2:
            height = 30 + 80;
            break;
        case 3:
            height = 30 + Height_Layout(400);
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00]];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AddressBookModel.arrayViewCircleColor.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookTableViewCell *cell = [AddressBookTableViewCell cellWithTableView:tableView];
    [cell.labelTitle setText:AddressBookModel.arrayLabelTitle[indexPath.section]];
    if (indexPath.section == 0) {//人才广场
        NSMutableArray *array = [self.arrayData mutableCopy];
        if (array.count > 5) {
            [array removeObjectsInRange:(NSMakeRange(5, self.arrayData.count - 5))];
        }
        [cell reloadDataWithArray:array AndIndex:indexPath.section];
        cell.blockDidTouchButtonAll = ^{
            GeniusSquareViewController *controller = [GeniusSquareViewController new];
            controller.arrayData = self.arrayData;
            [self.navigationController pushViewController:controller animated:true];
        };
        cell.blockDidTouchItem = ^(NSString *string) {
            GeniusSquareListViewController *controller = [[GeniusSquareListViewController alloc] initWithNibName:@"EliteListViewController" bundle:nil];
            controller.controllerTitle = string;
            [self.navigationController pushViewController:controller animated:true];
        };
    }else if (indexPath.section == 1) {//精英推荐
        [cell reloadDataWithArray:self.arrayDataEliteList AndIndex:indexPath.section];
        cell.blockDidTouchButtonAll = ^{
            EliteListViewController *controller = [EliteListViewController new];
            [self.navigationController pushViewController:controller animated:true];
        };
        cell.blockDidTouchTableViewCell = ^(GeniusSquareListModel *model) {
            EliteDetailViewController *vc = [[EliteDetailViewController alloc]init];
            vc.designsId = [model.eliteDesignId integerValue];
            vc.activityType = 2;
            vc.id = [model.agencyId integerValue];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }else if (indexPath.section == 2) {//诚信档案
        [cell reloadDataWithArray:@[@"1", @"2"].mutableCopy AndIndex:indexPath.section];
        cell.blockDidTouchItem = ^(NSString *string) {
            if ([string isEqualToString:@"2"]) {
                [ZYCTool alertControllerOneButtonWithTitle:@"敬请期待" message:@"" target:self defaultButtonTitle:nil defaultAction:^{}];
            }else{
                TheRedPavilionViewController *controller = [TheRedPavilionViewController new];
                [self.navigationController pushViewController:controller animated:true];
            }
        };
    }else if (indexPath.section == 3) {//名人专访
        [cell reloadDataWithArray:self.arrayDataEliteList AndIndex:indexPath.section];
        cell.blockDidTouchButtonAll = ^{
//            [ZYCTool alertControllerOneButtonWithTitle:@"敬请期待" message:@"" target:self defaultButtonTitle:nil defaultAction:^{}];
            CelebrityInterviewsListViewController *controller = [CelebrityInterviewsListViewController new];
            [self.navigationController pushViewController:controller animated:true];
        };
        cell.blockDidTouchTableViewCell = ^(GeniusSquareListModel *model) {
            [ZYCTool alertControllerOneButtonWithTitle:@"敬请期待" message:@"" target:self defaultButtonTitle:nil defaultAction:^{}];
        };
    }
    return cell;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    AddressBookSearchViewController *vc = [AddressBookSearchViewController new];
    [vc.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

#pragma mark else
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
