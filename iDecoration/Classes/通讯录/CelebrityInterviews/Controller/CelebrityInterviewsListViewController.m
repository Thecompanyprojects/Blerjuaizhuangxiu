//
//  CelebrityInterviewsListViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/19.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "CelebrityInterviewsListViewController.h"
#import "CelebrityInterviewsListTableViewCell.h"
#import "CelebrityInterviewsTypeSelected.h"
#import "CelebrityInterviewsArticleViewController.h"

@interface CelebrityInterviewsListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) CelebrityInterviewsTypeSelected *viewType;
@property (strong, nonatomic) NSString *stringType;
@end

@implementation CelebrityInterviewsListViewController
#pragma mark Lazy
- (UIView *)viewType {
    if (!_viewType) {
        WeakSelf(self)
        _viewType = [[[NSBundle mainBundle] loadNibNamed:@"CelebrityInterviewsTypeSelected" owner:self options:nil] lastObject];
        _viewType.frame = CGRectMake(0, 45 + kNaviHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNaviHeight - 45);
        _viewType.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _viewType.blockDidTouchCell = ^(NSString * _Nonnull title) {
            UIButton *button = weakself.arrayButtonTop[2];
            [button setTitle:title forState:(UIControlStateNormal)];
        };
    }
    return _viewType;
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

#pragma mark UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部专访";
    [self createTableView];
}

- (void)createTableView {
    WeakSelf(self)
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(weakself)
        [strongself.arrayData removeAllObjects];
//        strongself.pageNo = 1;
//        [strongself Network];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        StrongSelf(weakself)
//        strongself.pageNo ++;
//        [strongself Network];
    }];
//    [self.tableView.mj_header beginRefreshing];
}

#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor hexStringToColor:@"f2f2f2"]];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor hexStringToColor:@"f2f2f2"]];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
//    return self.arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CelebrityInterviewsListTableViewCell *cell = [CelebrityInterviewsListTableViewCell cellWithTableView:tableView AndIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.isListView = true;
            break;
        case 1:

            break;
        case 2:

            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CelebrityInterviewsArticleViewController *controller = [CelebrityInterviewsArticleViewController new];
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark else
- (IBAction)didTouchButtonTop:(UIButton *)sender {
    [self.viewType removeFromSuperview];
    [self.arrayButtonTop enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        if (button.tag == 2) {
            [button setImage:[UIImage imageNamed:@"caidan_btn_hi"] forState:(UIControlStateNormal)];
        }
        button.selected = false;
    }];
    if (sender.tag == 2) {
        [sender setImage:[UIImage imageNamed:@"caidan_btn_shouqi_hi"] forState:(UIControlStateNormal)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.viewType];
    }
    sender.selected = true;
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
