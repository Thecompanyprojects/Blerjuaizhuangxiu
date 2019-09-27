//
//  CooperativeConstructionListViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CooperativeConstructionListViewController.h"
#import "SiteTableViewCell.h"

static NSString *reuseIdentifier = @"SiteTableViewCell";
@interface CooperativeConstructionListViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTF;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation CooperativeConstructionListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工地列表";
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
    self.searchTF.placeholder = @"请输入户主名称";
    
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
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SiteTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - 数据获取(初始)
- (void)setData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getConstructionListByCompanyId.do"];
    NSDictionary *paramDic = @{@"companyId":self.companyId,
                               @"name":self.searchTF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj) {
            if (responseObj[@"list"]) {
                [self.dataArr removeAllObjects];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[SiteModel class] json:responseObj[@"list"]];
                [self.dataArr addObjectsFromArray:arr];
//                [self.dataArr addObjectsFromArray:responseObj[@"list"]];
            }
        }
        
        [self.tableView reloadData];
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
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
    
//    SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteTableViewCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.houseHoldLabel.font = [UIFont systemFontOfSize:16];
//    cell.stateBtn.hidden = YES;
//    cell.locationLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8 - 4;
//    cell.companyLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8;
//    
//
//    cell.houseHoldLabel.text = [NSString stringWithFormat:@"户主：%@", self.dataArr[indexPath.row][@"ccHouseholderName"]];
//    
//    NSInteger constructionNodeId = [self.dataArr[indexPath.row][@"ccConstructionNodeId"] integerValue];
//    cell.nodeLabel.text = (constructionNodeId == 2000 || constructionNodeId == 6000)? @"新日志" : self.dataArr[indexPath.row][@"crRoleName"];
//    if ([self isBlankString:self.dataArr[indexPath.row][@"crRoleName"]]) {
//        cell.nodeLabel.text = @"新日志";
//    }
//    
//    cell.signDateLabel.text = [NSString stringWithFormat:@"开工日期：%@", self.dataArr[indexPath.row][@"ccSrartTime"]];
//    cell.locationLabel.text = [NSString stringWithFormat:@"小区名称：%@", self.dataArr[indexPath.row][@"ccAreaName"]];
//    cell.constructionCompanyLabel.hidden = YES;
//
//    return cell;
    
    SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.houseHoldLabel.font = [UIFont systemFontOfSize:16];
    cell.stateBtn.hidden = YES;
    cell.locationLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8 - 4;
    cell.companyLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8;
    //    cell.siteModel = self.siteArray[indexPath.section - 1];
    if (self.dataArr.count>0) {
        id data = self.dataArr[indexPath.row];
        ((SiteModel *)data).ccBuilder = self.companyName;
        [cell configData:data];
    }
    //    cell.siteModel = self.siteArray[indexPath.section];
    //    cell.stateBtn.hidden = YES;
    //    id data = self.siteArray[indexPath.section - 1];
    
    //    cell.delegate = self;
    //    cell.path = indexPath;
    //    cell.finishBlock = ^(SiteModel *site, UIButton *stateBtn) {
    //        selectModel = site;
    //        [self sureCComplete];
    //    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
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
