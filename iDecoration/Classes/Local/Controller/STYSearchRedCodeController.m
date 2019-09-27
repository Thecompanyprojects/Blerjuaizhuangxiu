//
//  STYSearchRedCodeController.m
//  iDecoration
//
//  Created by sty on 2018/3/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "STYSearchRedCodeController.h"
#import "ZCHCouponModel.h"
#import "ZCHcouponCashCell.h"

#import "STYRedResultController.h"

static NSString *reuseIdentifier = @"ZCHcouponCashCell";
@interface STYSearchRedCodeController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZCHCouponModel *model;
@end

@implementation STYSearchRedCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换码";
    [self setUI];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)setUI{
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UITableViewHeaderFooterView alloc]init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHcouponCashCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZCHCouponModel *model = self.dataArray[indexPath.row];
    STYRedResultController *vc = [[STYRedResultController alloc]init];
    vc.model = model;
    vc.fromTag = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchClick{
    [self.view endEditing:YES];
    self.searchTF.text = [self.searchTF.text ew_removeSpaces];
    if (self.searchTF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"兑换码不能为空" controller:self sleep:1.5];
        return;
    }
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"cblejcouponcustomer/%@.do?agencyId=%@&isApp=1",self.searchTF.text, @(user.agencyId)]];
    
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    //    NSDictionary *paramDic = @{@"unionLogo":self.photoUrl, @"unionPwd":self.unionPasswordText.text,
    //                               @"unionNumber":self.unionNumberText.text,
    //                               @"companyId":@(self.companyId),
    //                               @"agencysId":@(user.agencyId),
    //                               @"unionName":self.unionNameText.text
    //                               };
    [NetManager afPostRequest:defaultApi parms:nil finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                [self.dataArray removeAllObjects];
                self.model = [ZCHCouponModel yy_modelWithJSON:responseObj[@"data"][@"couponInfo"]];
                [self.dataArray addObject:self.model];
                [self.tableView reloadData];
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"不是公司内部人员" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"兑换码错误" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark -setter

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom+4, kSCREEN_WIDTH-20, 46)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:16];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入兑换码";
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
        [_tableView registerNib:[UINib nibWithNibName:@"ZCHcouponCashCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        
    }
    return _tableView;
}


@end
