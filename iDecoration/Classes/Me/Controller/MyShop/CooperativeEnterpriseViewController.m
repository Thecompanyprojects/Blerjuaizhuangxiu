//
//  CooperativeEnterpriseViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CooperativeEnterpriseViewController.h"
#import "CooperativeEnterpriseCell.h"
#import "CooperativeConstructionListViewController.h"

static NSString *reuseIdentifier = @"CooperativeEnterpriseCell";
@interface CooperativeEnterpriseViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTF;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation CooperativeEnterpriseViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"入驻企业";
    self.dataArr = [NSMutableArray array];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUI {
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 75, kSCREEN_WIDTH-20, 36)];
    self.searchTF.delegate = self;
    self.searchTF.backgroundColor = White_Color;
    self.searchTF.layer.borderColor = Bottom_Color.CGColor;
    self.searchTF.layer.cornerRadius = 5;
    self.searchTF.layer.borderWidth = 1;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.placeholder = @"请输入企业名称";
    
    [self.view addSubview:self.searchTF];
    
    [[PublicTool defaultTool] publicToolsAddLeftViewWithTextField:self.searchTF];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.searchTF.mas_top).offset(5);
        make.left.equalTo(self.searchTF.mas_right).offset(-27);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,120, kSCREEN_WIDTH, kSCREEN_HEIGHT - 120) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"CooperativeEnterpriseCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - 数据获取(初始)
- (void)setData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchantCompany/getCompanyListByMerchantId.do"];
    NSDictionary *paramDic = @{@"merchantId":self.companyID,
                               @"companyName":self.searchTF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj) {
            if (responseObj[@"list"]) {
                [self.dataArr removeAllObjects];
                [self.dataArr addObjectsFromArray:responseObj[@"list"]];
            }
        }
        if (self.dataArr.count == 0) {
            [self.view hudShowWithText:@"还没有入驻企业"];
        }
        [self.tableView reloadData];
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}


#pragma mark - 数据刷新(搜索)
- (void)refreshData {
    
    [self setData];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CooperativeEnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *urlStr = self.dataArr[indexPath.row][@"companyLogo"];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    cell.tittleLabel.text = self.dataArr[indexPath.row][@"companyName"];
    cell.subTitleLabel.text = self.dataArr[indexPath.row][@"zCompanyName"];
   // self.dataArr[indexPath.row][@"endTime"];
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = @"yyyy-MM-HH";
    NSTimeInterval timeInterval = [self.dataArr[indexPath.row][@"endTime"] doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *endTimeStr = [formattor stringFromDate:date];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@到期", endTimeStr];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CooperativeConstructionListViewController *cooConListVC = [[CooperativeConstructionListViewController alloc] init];
    
    cooConListVC.companyId = self.dataArr[indexPath.row][@"companyId"];
    cooConListVC.companyName = self.dataArr[indexPath.row][@"companyName"];
    [self.navigationController pushViewController:cooConListVC animated:YES];

}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}



#pragma mark - 搜索按钮点击事件
- (void)searchClick:(UIButton *)sender{
    
    [self textFieldShouldReturn:self.searchTF];
}

#pragma mark - UITextFieldDelegate
// 输入搜索内容之后进行页面的刷新
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self refreshData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}





@end
