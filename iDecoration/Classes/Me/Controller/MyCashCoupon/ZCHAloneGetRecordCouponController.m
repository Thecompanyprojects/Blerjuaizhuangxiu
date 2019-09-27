//
//  ZCHAloneGetRecordCouponController.m
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ZCHAloneGetRecordCouponController.h"
#import "ZCHAloneGetRecordCell.h"
#import "ZCHCouponGettingRecordModel.h"

static NSString *reuseIdentifier = @"ZCHAloneGetRecordCell";
@interface ZCHAloneGetRecordCouponController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
//@property (nonatomic, strong) UITextField *searchTF;
//@property (assign, nonatomic) NSInteger pageNum;

@end

@implementation ZCHAloneGetRecordCouponController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"领取记录";
    [self setUpUI];
}

- (void)setUpUI {
    
//    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom + 11, kSCREEN_WIDTH-20, 36)];
//    self.searchTF.delegate = self;
//    self.searchTF.backgroundColor = White_Color;
//    self.searchTF.layer.borderColor = Bottom_Color.CGColor;
//    self.searchTF.layer.cornerRadius = 5;
//    self.searchTF.layer.borderWidth = 1;
//    self.searchTF.returnKeyType = UIReturnKeySearch;
//    self.searchTF.font = [UIFont systemFontOfSize:14];
//    self.searchTF.placeholder = @"搜索";
//
//    [self.view addSubview:self.searchTF];
    
//    [[PublicTool defaultTool] publicToolsAddLeftViewWithTextField:self.searchTF];
//
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:searchBtn];
//
//    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.searchTF.mas_top).offset(5);
//        make.left.equalTo(self.searchTF.mas_right).offset(-27);
//        make.width.equalTo(@25);
//        make.height.equalTo(@25);
//    }];
//
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHAloneGetRecordCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.pageNum = 0;
//        [self getData];
//    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageNum++;
//        [self getData];
//    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //self.tableView.rowHeight = 65;
    ZCHCouponGettingRecordModel *model = self.dataArray[indexPath.row];
    if (![model.type isEqualToString:@"2"]) {
        return 65;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHAloneGetRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

//#pragma mark - 获取数据
//- (void)getData {
//
//    //    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
//    //    if (!agencyid||agencyid == 0) {
//    //        agencyid = 0;
//    //    }
//
//    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
//
//    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcouponcustomer/getByCompanyId.do"];
//    NSDictionary *param = @{
//                            @"companyId" : self.companyId,
//                            @"phone" : model.phone,
//                            @"page" : @(self.pageNum),
//                            @"pageSize" : @"20"
//                            };
//    [[UIApplication sharedApplication].keyWindow hudShow];
//    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
//
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
//        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
//
//            if (self.pageNum == 0) {
//                [self.dataArray removeAllObjects];
//                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZCHCouponGettingRecordModel class] json:responseObj[@"data"][@"list"]]];
//                if (self.dataArray.count == 0) {
//                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还没有人领取哦"];
//                }
//            } else {
//                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZCHCouponGettingRecordModel class] json:responseObj[@"data"][@"list"]]];
//            }
//
//        } else {
//
//            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
//        }
//        [self.tableView reloadData];
//    } failed:^(NSString *errorMsg) {
//
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
//    }];
//}

//#pragma mark - 搜索按钮点击事件
//- (void)searchClick:(UIButton *)sender{
//    
//    [self textFieldShouldReturn:self.searchTF];
//}
//
//#pragma mark - UITextFieldDelegate
//// 输入搜索内容之后进行页面的刷新
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    
////    [self getData];
//    return YES;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    [self.view endEditing:YES];
//    return YES;
//}
//
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    [self.view endEditing:YES];
//}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
