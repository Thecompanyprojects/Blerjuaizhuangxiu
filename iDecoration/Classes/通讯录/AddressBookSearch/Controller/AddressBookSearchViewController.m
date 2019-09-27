//
//  AddressBookSearchViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookSearchViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "GeniusSquareListModel.h"
#import "EliteListTableViewCell.h"
#import <MagicalRecord/MagicalRecord.h>
#import "SearchHistoryModel+CoreDataClass.h"
#import "AddressBookSearchHistoryTableViewCell.h"
#import "NewMyPersonCardController.h"
#import "AddressBookSearchListViewController.h"

@interface AddressBookSearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) NSMutableArray *arrayDataTitle;
@property (strong, nonatomic) NSArray *arrayHistory;
@property (copy, nonatomic) NSString *agencyId;
@property (copy, nonatomic) NSString *searchText;

@end

@implementation AddressBookSearchViewController

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (NSMutableArray *)arrayDataTitle {
    if (!_arrayDataTitle) {
        _arrayDataTitle = @[].mutableCopy;
    }
    return _arrayDataTitle;
}

- (void)Network {
    NSDictionary *dic = [[CacheData sharedInstance] objectForKey:KDictionaryOfCityIdCountyId];
    NSString *URL = @"citywiderecomend/searchPerson.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"content"] = self.searchText;
    parameters[@"countyId"] = dic?dic[@"countyId"]:@"110000";
    parameters[@"cityId"] = dic?dic[@"cityId"]:@"0";
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            [self.arrayDataTitle removeAllObjects];
            [self.arrayData removeAllObjects];
            NSArray *arrayCards = [NSArray yy_modelArrayWithClass:[GeniusSquareListModel class] json:result[@"data"][@"businessCards"]];
            NSArray *arrayElites = [NSArray yy_modelArrayWithClass:[GeniusSquareListModel class] json:result[@"data"][@"elites"]];
            if (arrayCards.count > 0) {
                [self.arrayDataTitle addObject:@"名片"];
                [self.arrayData addObject:arrayCards];
            }
            if (arrayElites.count > 0) {
                [self.arrayDataTitle addObject:@"精英推荐"];
                [self.arrayData addObject:arrayElites];
            }
            [self reloadDataWithBool:false];
        }
    } fail:^(id error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger i = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict].agencyId;
    self.agencyId = @(i).stringValue;
    [self createSearchBar];
    [self createIQ];
    [self createTableView];
    [self getAllHistory];
}

- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 0, kSCREEN_WIDTH - 80 - 40, 44)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.backgroundColor = [UIColor clearColor];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.masksToBounds = YES;
    }
    self.navigationItem.titleView = self.searchBar;
}

- (void)createIQ {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = YES;
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(0);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.width = kSCREEN_WIDTH;
    UILabel *label = [UILabel new];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.bottom.equalTo(0);
    }];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.top.bottom.equalTo(0);
        make.right.equalTo(-5);
    }];
    [button addTarget:self action:@selector(didTouchButtonRightInSectionHeader:) forControlEvents:(UIControlEventTouchUpInside)];
    button.tag = section;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    if (self.isHistory) {
        view.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"icon_shanchu"] forState:(UIControlStateNormal)];
        label.text = @"历史记录";
        [label setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:14]];
        [label setTextColor:[UIColor blackColor]];
        [button setTitle:@"" forState:(UIControlStateNormal)];
        [imageView removeFromSuperview];
    }else{
        view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00]];
        NSString *sectionName = self.arrayDataTitle[section];
        [label setText:sectionName];
        [button setTitle:@"更多" forState:(UIControlStateNormal)];
        [button setImage:nil forState:(UIControlStateNormal)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00] forState:(UIControlStateNormal)];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-5);
        }];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isHistory) {
        return 1;
    }
    return self.arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isHistory) {
        return self.arrayHistory.count;
    }
    NSArray *array = self.arrayData[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isHistory) {
        AddressBookSearchHistoryTableViewCell *cell = [AddressBookSearchHistoryTableViewCell cellWithTableView:tableView];
        SearchHistoryModel *model = self.arrayHistory[indexPath.row];
        cell.labelTitle.text = model.searchTitle;
        return cell;
    }
    NSArray *array = self.arrayData[indexPath.section];
    GeniusSquareListModel *model = array[indexPath.row];
    EliteListTableViewCell *cell = [EliteListTableViewCell cellWithTableView:tableView];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isHistory) {
        SearchHistoryModel *model = self.arrayHistory[indexPath.row];
        self.searchText = model.searchTitle;
        [self Network];
        [self addToHistoryWithSearchString:self.searchText];
        self.searchBar.text = self.searchText;
    }else{
        NSArray *array = self.arrayData[indexPath.section];
        GeniusSquareListModel *model = array[indexPath.row];
        NewMyPersonCardController *controller = [NewMyPersonCardController new];
        controller.agencyId = model.agencyId;
        [self.navigationController pushViewController:controller animated:true];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length) {
        [searchBar resignFirstResponder];
        self.searchText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (self.searchText.length > 0) {
            [self Network];
            [self addToHistoryWithSearchString:self.searchText];
        }else
            SHOWMESSAGE(@"请输入搜索内容")
    }else
        SHOWMESSAGE(@"请输入搜索内容")
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        [self reloadDataWithBool:true];
    }
}

- (void)addToHistoryWithSearchString:(NSString *)string {
    SearchHistoryModel *history = [SearchHistoryModel MR_createEntity];
    history.searchTitle = string;
    history.agencyId = self.agencyId;
    for (SearchHistoryModel *m in self.arrayHistory) {
        if ([m.searchTitle isEqualToString:string]) {
            [m MR_deleteEntity];
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self getAllHistory];
}

- (void)getAllHistory {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"agencyId = %@",self.agencyId];
    self.arrayHistory = [SearchHistoryModel MR_findAllWithPredicate:predicate];
    [self reloadDataWithBool:true];
}

- (void)didTouchButtonRightInSectionHeader:(UIButton *)sender {
    if (self.isHistory) {
        [self deleteAllHistory];
    }else{
        [self pushToListControllerWithButton:sender];
    }
}

- (void)deleteAllHistory {
    [ZYCTool alertControllerTwoButtonWithTitle:@"确认删除全部历史记录?" message:@"" target:self notarizeButtonTitle:nil cancelButtonTitle:nil notarizeAction:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"agencyId = %@",self.agencyId];
        [SearchHistoryModel MR_deleteAllMatchingPredicate:predicate];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self getAllHistory];
    } cancelAction:^{

    }];
}

- (void)reloadDataWithBool:(BOOL)isHistory {
    self.isHistory = isHistory;
    [self.tableView reloadData];
}

- (void)pushToListControllerWithButton:(UIButton *)sender {
    AddressBookSearchListViewController *controller = [[AddressBookSearchListViewController alloc] initWithNibName:@"EliteListViewController" bundle:nil];
    controller.content = self.searchText;
    NSString *sectionName = self.arrayDataTitle[sender.tag];
    if ([sectionName isEqualToString:@"名片"]) {
        controller.listType = SearchListTypeCard;
    }else if ([sectionName isEqualToString:@"精英推荐"]) {
        controller.listType = SearchListTypeElite;
    }
    [controller.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:controller animated:true];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"未找到相关信息";
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
