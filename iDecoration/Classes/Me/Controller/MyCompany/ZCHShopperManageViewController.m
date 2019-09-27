//
//  ZCHShopperManageViewController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHShopperManageViewController.h"
#import "ZCHShopperManageModel.h"
#import "ZCHShopperManageCell.h"
#import "ZCHAddShopperController.h"
#import "ZCHAddShopperPayController.h"


static NSString *reuseIdentifier = @"ZCHShopperManageCell";
@interface ZCHShopperManageViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ZCHShopperManageCellDelegate>

@property (nonatomic, strong) UITextField *searchTF;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation ZCHShopperManageViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"商家管理";
    self.dataArr = [NSMutableArray array];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setData];
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
    self.searchTF.placeholder = @"请输入店铺名称或手机号";
    
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHShopperManageCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 44, 44);
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(didClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightbarItem;
}

#pragma mark - 数据获取(初始)
- (void)setData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchantCompany/getListByCompanyId.do"];
    NSDictionary *paramDic = @{
                               @"companyId" : self.companyID,
                               @"merchantName" : self.searchTF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            [self.dataArr removeAllObjects];
            
            self.dataArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHShopperManageModel class] json:(responseObj[@"data"])[@"list"]]];
            
            if (self.dataArr.count == 0 && ([self.searchTF.text isEqualToString:@""] || self.searchTF.text == nil)) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"暂无商家"];
            }
            if (self.dataArr.count == 0 && (![self.searchTF.text isEqualToString:@""] && self.searchTF.text != nil)) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"未搜索到内容"];
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
    
    ZCHShopperManageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHShopperManageModel *model = self.dataArr[indexPath.row];
    
    if ([self.VIPType isEqualToString:@"2"]) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否续费" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
    
            if (buttonIndex == 1) {
    
                [self addMoneyForShopperWithIndexPath:indexPath];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"续费", nil];
        
        [alertView show];
    } else {
        
        ZCHAddShopperPayController *VC = [UIStoryboard storyboardWithName:@"ZCHAddShopperPayController" bundle:nil].instantiateInitialViewController;
        VC.companyId = self.companyID;
        VC.merchantId = model.merchantId;
        VC.isAddJoin = NO;
        // 0 是新增  1 是续费
        VC.isHaveAdd = @"1";
        [self.navigationController pushViewController:VC animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - 这里是开启滑动删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ZCHShopperManageModel *model = self.dataArr[indexPath.row];
//    return [model.times integerValue] < 0;
    
    return [self.VIPType isEqualToString:@"2"];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteShopperWithIndex:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

#pragma mark - 添加按钮的点击事件
- (void)didClickAddBtn:(UIButton *)btn {
    
    ZCHAddShopperController *VC = [[ZCHAddShopperController alloc] init];
    VC.companyID = self.companyID;
    VC.VIPType = self.VIPType;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - ZCHShopperManageCellDelegate方法
- (void)didClickContinueBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath {
    
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 搜索按钮点击事件
- (void)searchClick:(UIButton *)sender{
    
    [self textFieldShouldReturn:self.searchTF];
}

#pragma mark - 删除商家
- (void)deleteShopperWithIndex:(NSIndexPath *)indexPath {
    
    ZCHShopperManageModel *model = self.dataArr[indexPath.row];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchantCompany/delete.do"];
    NSDictionary *paramDic = @{
                               @"id":model.relationId,
                               @"times":model.times
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        // 1000:成功，1001：该商家广告时间未到期,不能删除，2000：失败
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArr removeObjectAtIndex:indexPath.row];
        }
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 超级定制会员不需要付费就可以续费
- (void)addMoneyForShopperWithIndexPath:(NSIndexPath *)indexPath {
    
    ZCHShopperManageModel *model = self.dataArr[indexPath.row];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchantCompany/addMerchant.do"];
    NSDictionary *paramDic = @{
                               @"id":model.relationId,
                               @"companyId":self.companyID,
                               @"merchantId":model.merchantId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        // 1000:成功 2000: 异常 1001: 查询公司出错 1002: 公司已不存在 1003: 该公司未开通超级定制版 1004: 数据重复，已添加此商家，需要主键id值
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.view hudShowWithText:@"续费成功"];
        } else {
            
            [self.view hudShowWithText:responseObj[@"msg"]];
        }
        
        [self setData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
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


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
