//
//  SearchUnionController.m
//  iDecoration
//
//  Created by sty on 2017/10/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SearchUnionController.h"
#import "SearchUnionModel.h"
#import "MyCompanyHeadCell.h"

#import "JoinUnionController.h"

@interface SearchUnionController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger _pageNum;
}
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SearchUnionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索联盟";
    _pageNum = 0;
    
    self.dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
    [self requsetInfo];
//    self.tableView.hidden = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000000000001;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCompanyHeadCell *cell = [MyCompanyHeadCell cellWithTableView:tableView];
    SearchUnionModel *model = self.dataArray[indexPath.row];
    [cell configWith:model];
    
    cell.editBtn.hidden = YES;
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 79, kSCREEN_WIDTH-10, 1)];
    lineV.backgroundColor = kSepLineColor;
    [cell addSubview:lineV];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchUnionModel *model = self.dataArray[indexPath.row];
    JoinUnionController *vc = [[JoinUnionController alloc]init];
    vc.model = model;
    vc.companyId = self.companyId;
    vc.companyName = self.companyName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)searchClick{
    self.searchTF.text = [self.searchTF.text ew_removeSpaces];
    [self requsetInfo];
}

-(void)requsetInfo{
    [self.view endEditing:YES];
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"union/getListByNameAndNumber.do"];
    NSString *str;
    if (!self.searchTF||self.searchTF.text.length<=0) {
        str = @"";
    }
    else{
        str = self.searchTF.text;
    }
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"serchContent":str,
                               @"companyId":@(self.companyId),
                               @"page":@(0)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *array = responseObj[@"data"][@"unionList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[SearchUnionModel class] json:array];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                _pageNum = 0;
                [self.tableView reloadData];
                
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"抱歉，未找到相关信息" controller:self sleep:2.0];
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

#pragma mark - 加载更多数据

-(void)loadMoreData{
    [self.view endEditing:YES];
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"union/getListByNameAndNumber.do"];
    NSString *str;
    if (!self.searchTF||self.searchTF.text.length<=0) {
        str = @"";
    }
    else{
        str = self.searchTF.text;
    }
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"serchContent":str,
                               @"companyId":@(self.companyId),
                               @"page":@(_pageNum)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.tableView.mj_footer endRefreshing];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *array = responseObj[@"data"][@"unionList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[SearchUnionModel class] json:array];
//                [self.dataArray removeAllObjects];
//                [self.dataArray addObjectsFromArray:arr];
                
                if (str.length<=0) {
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
                [[PublicTool defaultTool] publicToolsHUDStr:@"抱歉，未找到相关信息" controller:self sleep:2.0];
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
        [self.tableView.mj_footer endRefreshing];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark -setter

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, kNaviBottom + 4, kSCREEN_WIDTH-20, 46)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 10;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:16];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入联盟编号或者联盟名称";
//        [_searchTF addTarget:self action:@selector(textFieldDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _searchTF;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10-10, self.searchTF.top+(7.5), 30, 30);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.searchTF.bottom + 4,kSCREEN_WIDTH,kSCREEN_HEIGHT-self.searchTF.bottom - 4) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = White_Color;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
        //        [_tableView addHeaderWithTarget:self action:@selector(loadData)];
        //        [_tableView addFooterWithTarget:self action:@selector(upLoadData)];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
