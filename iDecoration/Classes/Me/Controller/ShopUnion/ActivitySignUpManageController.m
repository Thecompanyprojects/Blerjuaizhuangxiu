//
//  ActivitySignUpManageController.m
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivitySignUpManageController.h"
#import "SignUpManageListModel.h"
#import "ActivitySignUpManageCell.h"
#import "EventdetailsVC.h"


@interface ActivitySignUpManageController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ActivitySignUpManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报名管理";
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    
    [self.view addSubview:self.tableView];
    [self requestData];
    
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
    
    return 120;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivitySignUpManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivitySignUpManageCell"];
    [cell configData:self.dataArray[indexPath.row]];
    cell.callBtn.tag = indexPath.row;
    cell.callPhoneBlock = ^(NSInteger tag) {
        SignUpManageListModel *model = self.dataArray[indexPath.row];
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.userPhone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    };
    return cell;
}

#pragma mark - action

-(void)searchClick{
    [self requestData];
}

-(void)requestData{
    [self.view endEditing:YES];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signUp/signUpList.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *str;
    if (!self.searchTF||self.searchTF.text.length<=0) {
        str = @"";
    }
    else{
        str = self.searchTF.text;
    }
    NSDictionary *paramDic = @{@"activityId":self.activityId, @"serchContent":str,
                               @"agencysId":@(user.agencyId),
                               @"unionId":@(self.unionId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *array = responseObj[@"data"][@"signUpList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[SignUpManageListModel class] json:array];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
               
                [self.tableView reloadData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:2.0];
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

#pragma mark - lazy

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 68, kSCREEN_WIDTH-20, 46)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:16];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入姓名或手机号";
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.searchTF.bottom,kSCREEN_WIDTH,kSCREEN_HEIGHT-self.searchTF.bottom) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = White_Color;
        //        [_tableView addHeaderWithTarget:self action:@selector(loadData)];
        //        [_tableView addFooterWithTarget:self action:@selector(upLoadData)];
        [_tableView registerNib:[UINib nibWithNibName:@"ActivitySignUpManageCell" bundle:nil] forCellReuseIdentifier:@"ActivitySignUpManageCell"];
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SignUpManageListModel *model = self.dataArray[indexPath.row];
    EventdetailsVC *vc = [[EventdetailsVC alloc] init];
    vc.state = Mytypecompany;
    vc.smodel = model;
    [self.navigationController pushViewController:vc animated:YES];

}

@end
