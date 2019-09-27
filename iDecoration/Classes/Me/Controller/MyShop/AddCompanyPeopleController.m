//
//  AddCompanyPeopleController.m
//  iDecoration
//  ／／添加公司人员
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddCompanyPeopleController.h"
#import "ShopDetailBottomCell.h"
#import "QueryPeopleListModel.h"
#import "CategoryViewController.h"

@interface AddCompanyPeopleController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ShopDetailBottomCellDelegate>{
    NSInteger _tagIndex;//第几个cell的按钮被点击
    NSInteger _tagCell;//第几个cell被点击
    NSDictionary *_cateDic;
}
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic ,strong) UIButton *sucessBtn;

@end

@implementation AddCompanyPeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self resetUI];
    _tagCell = -1;
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:searchBtn];
    self.view.backgroundColor = kBackgroundColor;
    
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:White_Color forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.sucessBtn = editBtn;
    [self.sucessBtn addTarget:self action:@selector(sucessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sucessBtn];
    
}

-(void)resetUI{
    self.navigationItem.title = @"人员添加";
    self.view.backgroundColor = White_Color;
    
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetBtnTitle:) name:@"companyPeopleAddNoti" object:nil];
    
}

-(void)sucessBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    if (self.dataArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请先搜索再添加" controller:self sleep:1.5];
        return;
    }
    if (_tagCell==-1) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择职位" controller:self sleep:1.5];
        return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:_tagCell inSection:0];
    ShopDetailBottomCell *cell = [self.tableView cellForRowAtIndexPath:path];
    if ([cell.addBtn.currentTitle isEqualToString:@"选择职位"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择职位" controller:self sleep:1.5];
    }
    else{
        //调用添加人员的接口
        [self addCompanyPeople];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section == 0) {
//        return 100;
//    }else{
        return 60;
//    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailBottomCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.delegate = self;
    [cell configData:self.dataArray[indexPath.row]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - ShopDetailBottomCellDelegate

-(void)addPeopleWith:(NSInteger)tag{
    [self.view endEditing:YES];
    //YSNLog(@"%d",tag);
    _tagIndex = tag;
    _tagCell = tag;
    CategoryViewController *vc = [[CategoryViewController alloc]init];
    vc.index = 1;
    if (self.comPanyOrShop == 1) {
        vc.comOrShop = 1;
    }
    else{
        vc.comOrShop = 2;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request

-(void)requstInfo{
    [self.view endEditing:YES];
    [self.dataArray removeAllObjects];
    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/getListByPhone.do"];
    NSDictionary *paramDic = @{@"phone":self.searchTF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"agencysList"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = responseObj[@"agencysList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[QueryPeopleListModel class] json:array];
                        [self.dataArray addObjectsFromArray:arr];
//
//                        NSArray *arr2 = [NSArray yy_modelArrayWithClass:[AreaListModel class] json:[dic objectForKey:@"areaList"]];
//                        [self.areaArray addObjectsFromArray:arr2];
//                        
//                        //刷新数据
                        [self.tableView reloadData];
                        
                    };
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
            
            if (self.dataArray.count<=0) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"未搜到该人员" controller:self sleep:1.5];
            }
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(void)addCompanyPeople{
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    QueryPeopleListModel *model = self.dataArray[_tagCell];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/save.do"];
    NSDictionary *paramDic = @{@"agencysId":model.agencyId,
                               @"agencysJob":[_cateDic objectForKey:@"idJob"],
                               @"companyId":self.model.companyId,
                               @"companyName":self.model.companyName,
                               @"agencysName":model.trueName,
                               @"agencyId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPeopleList" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                case 1001:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加失败" controller:self sleep:1.5];
                }
                    break;
                case 1002:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"该员工已加入本公司" controller:self sleep:1.5];
                }
                    break;
                case 1003:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"该员工已加入其他公司，退出公司后才可添加" controller:self sleep:1.5];
                }
                    break;
                    
                case 1004:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"对不起，你没有权限" controller:self sleep:1.5];
                }
                    break;
                case 2000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加出现错误" controller:self sleep:1.5];   
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

- (void)textFieldDidChangeAction:(UITextField *)textField {
    if ([[PublicTool defaultTool] publicToolsCheckTelNumber:textField.text]) {
        [self requstInfo];
    }
}

#pragma mark - action

-(void)searchClick{
    if (self.searchTF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入手机号" controller:self sleep:1.5];
        return;
    }
    else{
        [self requstInfo];
    }
}

-(void)resetBtnTitle:(NSNotification *)notf{
    NSDictionary *dic = notf.userInfo;
    _cateDic = dic;
    NSIndexPath *path = [NSIndexPath indexPathForRow:_tagIndex inSection:0];
    ShopDetailBottomCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [cell.addBtn setTitle:dic[@"job"] forState:UIControlStateNormal];
}

#pragma mark - setter

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom + 11, kSCREEN_WIDTH-20, 36)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
//        _searchTF.layer.borderWidth = 1;
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.font = [UIFont systemFontOfSize:16];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入手机号";
        [_searchTF addTarget:self action:@selector(textFieldDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _searchTF;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-20-27, self.searchTF.top+(5), 25, 25);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.searchTF.bottom+10,kSCREEN_WIDTH,kSCREEN_HEIGHT-self.searchTF.bottom-10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kBackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:@"ShopDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"ShopDetailBottomCell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
