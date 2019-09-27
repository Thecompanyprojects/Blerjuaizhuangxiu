//
//  UnionAddBusinessController.m
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UnionAddBusinessController.h"
#import "MyCompanyHeadCell.h"
#import "ZCHCooperateListModel.h"
#import "ZCHCooperateAndUnionCell.h"

static NSString *reuseIdentifier = @"ZCHCooperateAndUnionCell";
@interface UnionAddBusinessController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ZCHCooperateAndUnionCellDelegate> {
    
    NSInteger selectTag;
    NSInteger _pageNum;
}

@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation UnionAddBusinessController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"添加联盟企业";
    _pageNum = 0;
    self.dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.searchTF];
    [[PublicTool defaultTool] publicToolsAddLeftViewWithTextField:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
    [self loadMoreData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 86;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MyCompanyHeadCell *cell = [MyCompanyHeadCell cellWithTableView:tableView];
////    SearchUnionModel *model = self.dataArray[indexPath.row];
//    cell.editBtn.hidden = YES;
//    [cell configWith:self.dataArray[indexPath.row]];
//    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 79, kSCREEN_WIDTH-10, 1)];
//    lineV.backgroundColor = kSepLineColor;
//    [cell addSubview:lineV];
    
    ZCHCooperateAndUnionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
//    cell.currentCompanyId = self.companyId;
    cell.unionModel = self.dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    selectTag = indexPath.row;
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否邀请该企业加入联盟？"
//                                                        message:@""
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//
//                                              otherButtonTitles:@"确定", nil];
//    alertView.tag = 100;
//    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
//            NSDictionary *dict = self.dataArray[selectTag];
            ZCHCooperateListModel *model = self.dataArray[selectTag];
            [self requestJoinUnionWith:model.companyId companyName:model.companyName];
        }
    }
}

#pragma mark - 邀请企业加入联盟
-(void)requestJoinUnionWith:(NSString *)companyId companyName:(NSString *)companyName{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"invitation/save.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"unionId":@(self.unionId),
                               @"agencysId":@(user.agencyId),
                               @"companyId":companyId,
                               @"companyName":companyName,
                               @"unionName":self.unionName
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"邀请成功" controller:self sleep:2.0];
                if (self.UnionAddBusBlock) {
                    self.UnionAddBusBlock();
                }
//                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已加入联盟" controller:self sleep:2.0];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已经邀请过" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 搜索按钮点击事件
- (void)searchClick {
    
    self.searchTF.text = [self.searchTF.text ew_removeSpaces];
    [self textFieldShouldReturn:self.searchTF];
    
//    if (self.searchTF.text.length<=0) {
//        [self loadMoreData];
//    }
//    else{
//        [self requsetInfo];
//    }
//    [self requsetInfo];
    
}



#pragma mark - UITextFieldDelegate
// 输入搜索内容之后进行页面的刷新
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self requsetInfo];
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


- (void)requsetInfo {
    
    [self.view endEditing:YES];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/serchByCompanyName.do"];
    NSString *str;
    NSInteger pageNum = 0;
    if (!self.searchTF||self.searchTF.text.length<=0) {
        str = @"";
//        pageNum = _pageNum;
    }
    else{
        str = self.searchTF.text;
//        pageNum = 0;
    }
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"serchContent":str,
                               @"unionId":@(self.unionId),
                               @"page":@(pageNum)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
//        [self.tableView.mj_footer endRefreshing];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *array = responseObj[@"data"][@"companyList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[ZCHCooperateListModel class] json:array];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                
                _pageNum = 0;
                [self.tableView reloadData];
                
            }
            else if (statusCode==1002) {
                
                [self.dataArray removeAllObjects];
                [[PublicTool defaultTool] publicToolsHUDStr:@"没有相关内容" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
//        [self.tableView.mj_footer endRefreshing];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 加载更多数据

- (void)loadMoreData {
    
    [self.view endEditing:YES];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/serchByCompanyName.do"];
    NSString *str;
    if (!self.searchTF||self.searchTF.text.length<=0) {
        str = @"";
    }
    else{
        str = self.searchTF.text;
    }
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{
                               @"serchContent":str,
                               @"unionId":@(self.unionId),
                               @"page":@(_pageNum)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.tableView.mj_footer endRefreshing];
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode == 1000) {
                NSArray *array = responseObj[@"data"][@"companyList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[ZCHCooperateListModel class] json:array];
                if (str.length <= 0) {
                    [self.dataArray addObjectsFromArray:arr];
                    _pageNum++;
                }
                else{
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:arr];
                }
                [self.tableView reloadData];
                
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"没有相关内容" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [self.tableView.mj_footer endRefreshing];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
    }];
}


#pragma mark - 代理方法(申请按钮的点击事件)
- (void)didClickApplyBtnWithIndexPath:(NSIndexPath *)indexPath {
    
    selectTag = indexPath.row;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否邀请该企业加入联盟？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                              
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

#pragma mark -setter
- (UITextField *)searchTF {
    if (!_searchTF) {
        
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom + 11, kSCREEN_WIDTH - 20, 36)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.placeholder = @"请输入公司名称或业务经理电话";
        
//        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//        [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
//
//        [self.view addSubview:searchBtn];
//
//        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(self.searchTF.mas_top).offset(5);
//            make.left.equalTo(self.searchTF.mas_right).offset(-27);
//            make.width.equalTo(@25);
//            make.height.equalTo(@25);
//        }];
        
//        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 68, kSCREEN_WIDTH-20, 46)];
//        _searchTF.delegate = self;
//        _searchTF.backgroundColor = White_Color;
//        _searchTF.layer.borderColor = Bottom_Color.CGColor;
//        _searchTF.layer.cornerRadius = 5;
//        _searchTF.layer.borderWidth = 1;
//        _searchTF.font = [UIFont systemFontOfSize:16];
//        _searchTF.placeholder = @"请输入公司名称或业务经理电话";
    }
    return _searchTF;
}

//- (void)textFieldDidChangeAction:(UITextField *)textField {
//    if ([[PublicTool defaultTool] publicToolsCheckTelNumber:textField.text]) {
//        [self searchClick];
//    }
//}

- (UIButton *)searchBtn {
    
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10-10, self.searchTF.top+(7.5), 30, 30);
        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-30-27, self.searchTF.top+5, 25, 25);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchTF.bottom + 9, kSCREEN_WIDTH, kSCREEN_HEIGHT-(self.searchTF.bottom + 9)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kBackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:@"ZCHCooperateAndUnionCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        //        [_tableView addHeaderWithTarget:self action:@selector(loadData)];
        //        [_tableView addFooterWithTarget:self action:@selector(upLoadData)];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
