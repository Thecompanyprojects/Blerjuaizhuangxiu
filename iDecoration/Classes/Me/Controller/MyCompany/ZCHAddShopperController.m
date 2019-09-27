//
//  ZCHAddShopperController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHAddShopperController.h"
#import "ZCHShopperManageModel.h"
#import "ZCHAddShopperCell.h"
#import "ZCHAddShopperPayController.h"

static NSString *reuseIdentifier = @"ZCHAddShopperCell";
@interface ZCHAddShopperController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTF;
@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) NSMutableArray *dataArr;
//@property (copy, nonatomic) NSMutableString *merchantId;

@end

@implementation ZCHAddShopperController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"添加品牌";
    self.dataArr = [NSMutableArray array];
//    self.dataDic = [NSMutableDictionary dictionary];
    [self setUI];
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
    self.searchTF.placeholder = @"请输入商家编号或手机号";
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHAddShopperCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHAddShopperCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.dic = self.dataArr[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchTF endEditing:YES];
    if ([[self.dataArr[indexPath.row] objectForKey:@"isAdd"] integerValue] == 1) {
        __weak typeof(self) weakSelf = self;
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您已添加过该商铺，是否续费" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                if ([weakSelf.VIPType isEqualToString:@"2"]) {
                    
                    [weakSelf addMoneyForShopperWithIndexPath:indexPath withId:[weakSelf.dataArr[indexPath.row] objectForKey:@"relationId"]];
                } else {
                    
                    ZCHAddShopperPayController *VC = [UIStoryboard storyboardWithName:@"ZCHAddShopperPayController" bundle:nil].instantiateInitialViewController;
                    VC.companyId = weakSelf.companyID;
                    VC.merchantId = [weakSelf.dataArr[indexPath.row] objectForKey:@"merchantId"];
                    VC.isAddJoin = YES;
                    // 0 是新增  1 是续费
                    VC.isHaveAdd = @"1";
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"续费", nil];
        
        [alertView show];
    } else {
        
        __weak typeof(self) weakSelf = self;
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否添加该商铺" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                if ([weakSelf.VIPType isEqualToString:@"2"]) {
                    
                    [weakSelf addMoneyForShopperWithIndexPath:indexPath withId:@"0"];
                } else {
                    
                    ZCHAddShopperPayController *VC = [UIStoryboard storyboardWithName:@"ZCHAddShopperPayController" bundle:nil].instantiateInitialViewController;
                    VC.companyId = weakSelf.companyID;
                    VC.merchantId = [weakSelf.dataArr[indexPath.row] objectForKey:@"merchantId"];
                    VC.isAddJoin = YES;
                    // 0 是新增  1 是续费
                    VC.isHaveAdd = @"0";
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
        
        [alertView show];
    }
}


#pragma mark - 数据获取
- (void)setData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/selectByMerchantNo.do"];
    NSDictionary *paramDic = @{@"merchantNo":self.searchTF.text,
                               @"companyId":self.companyID
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            [self.dataArr removeAllObjects];
            if ([[responseObj[@"data"] allKeys] containsObject:@"merchants"]) {
                
                self.dataArr = [NSMutableArray arrayWithArray:responseObj[@"data"][@"merchants"]];
            } else {
                
               [[UIApplication sharedApplication].keyWindow hudShowWithText:@"未搜索到内容"];
            }
        }
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 超级定制会员不需要付费就可以续费
- (void)addMoneyForShopperWithIndexPath:(NSIndexPath *)indexPath withId:(NSString *)relationId {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchantCompany/addMerchant.do"];
    NSDictionary *paramDic = @{@"id":relationId,
                               @"companyId":self.companyID,
                               @"merchantId":[self.dataArr[indexPath.row] objectForKey:@"merchantId"]
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        // 1000:成功 2000: 异常 1001: 查询公司出错 1002: 公司已不存在 1003: 该公司未开通超级定制版 1004: 数据重复，已添加此商家，需要主键id值
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            if ([relationId integerValue] == 0) {
                
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加成功"];
            } else {
                
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"续费成功"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            [self.view hudShowWithText:responseObj[@"msg"]];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}


#pragma mark - 数据刷新(搜索)
- (void)refreshData {
    
    [self setData];
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
    [self refreshData];
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
