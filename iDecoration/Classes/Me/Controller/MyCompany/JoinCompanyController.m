//
//  JoinCompanyController.m
//  iDecoration
//
//  Created by Apple on 2017/5/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "JoinCompanyController.h"
#import "JoinCompanyModel.h"
#import "ShopDetailBottomCell.h"
#import "CategoryViewController.h"
#import "MeViewController.h"
#import "MyCompanyHeadCell.h"


#import "SearchCompanyController.h"

@interface JoinCompanyController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSDictionary *comPanyDict;
}
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JoinCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    self.title = @"申请公司";
    self.view.backgroundColor = White_Color;
    self.dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    
}

-(void)searchClick{
    [self requstInfo];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        MyCompanyHeadCell *cell = [MyCompanyHeadCell cellWithTableView:tableView];
        [cell configWith:comPanyDict];
        
        cell.editBtn.hidden = YES;
    
        return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCompanyController *vc = [[SearchCompanyController alloc]init];
    vc.comPanyDict = comPanyDict;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request


-(void)requstInfo{
    [self.view endEditing:YES];
    if (self.searchTF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写公司号" controller:self sleep:1.5];
        return;
    }
    [self.dataArray removeAllObjects];
    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/serch.do"];
    NSDictionary *paramDic = @{@"companyNumber":self.searchTF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    comPanyDict = responseObj[@"cblejCompanyModel"];
                    
                    if ([comPanyDict isKindOfClass:[NSNull class]]) {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
                        self.tableView.hidden = YES;
                    }
                    else{
                        self.tableView.hidden = NO;
                        [self.tableView reloadData];
                    }
                    
                    
                    
                    //                    if ([responseObj[@"agencysList"] isKindOfClass:[NSArray class]]) {
                    //                        NSArray *array = responseObj[@"agencysList"];
                    //                        NSArray *arr = [NSArray yy_modelArrayWithClass:[QueryPeopleListModel class] json:array];
                    //                        [self.dataArray addObjectsFromArray:arr];
                    //                        //
                    //                        //                        NSArray *arr2 = [NSArray yy_modelArrayWithClass:[AreaListModel class] json:[dic objectForKey:@"areaList"]];
                    //                        //                        [self.areaArray addObjectsFromArray:arr2];
                    //                        //
                    //                        //                        //刷新数据
                    //                        [self.tableView reloadData];
                    //
                    //                    };
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark -setter

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, kSCREEN_WIDTH-20, 46)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:16];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入公司号";
        [_searchTF addTarget:self action:@selector(textFieldDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _searchTF;
}

- (void)textFieldDidChangeAction:(UITextField *)textField {
    if ([[PublicTool defaultTool] publicToolsCheckTelNumber:textField.text]) {
        [self searchClick];
    }
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
    }
    return _tableView;
}


@end
