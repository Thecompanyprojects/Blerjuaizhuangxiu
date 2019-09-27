//
//  BannerListViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BannerListViewController.h"
#import "BannerListCell.h"
#import "BannerListModel.h"
#import "BannerStoryViewController.h"
#import "NewMyPersonCardController.h"

@interface BannerListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
// 列表数组
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, assign) NSInteger page;
@end

@implementation BannerListViewController

#pragma LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma NormalMehtod

-(void)createUI{
    self.title = @"锦旗墙";
    self.view.backgroundColor = kCustomColor(242, 242, 242);
}

// 获取数据列表
- (void)getData {
    [self.view hudShow];
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"pennant/getListPage.do"];
    NSDictionary *paramDic = @{
                               @"pesonId": self.agencyID,
                               @"page": @(_page),
                               @"pageSize": @(30)
                               };
    // 请求参数应该使用paramDic  目前没有数据，  设置为nil时有数据，做测试
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSArray *listArray = [responseObj objectForKey:@"data"][@"list"];
            if (_page == 1) {
                [self.listArray removeAllObjects];
            }
            [self.listArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[BannerListModel class] json:listArray]];
            [self.tableView reloadData];
        } else {
            
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
        [self.view hiddleHud];
        [self.view hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
        //加载失败
    }];
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BannerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BannerListCell" forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.bannerListModel = self.listArray[indexPath.section];
    MJWeakSelf;
    cell.IconIVTapBlock = ^{
        NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
        BannerListModel *model = weakSelf.listArray[indexPath.section];
        vc.agencyId = model.agencyId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BannerListModel *model = self.listArray[indexPath.section];
    if (model.type.integerValue < 2000) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BannerStoryViewController *vc = [BannerStoryViewController new];
        vc.model = self.listArray[indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"此锦旗不能查看锦旗故事"];
        return;
    }
    
}

#pragma LazyMethod
-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"BannerListCell" bundle:nil] forCellReuseIdentifier:@"BannerListCell"];
    }
    return _tableView;
}


@end
