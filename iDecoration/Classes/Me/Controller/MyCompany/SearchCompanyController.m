//
//  SearchCompanyController.m
//  iDecoration
//
//  Created by Apple on 2017/5/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SearchCompanyController.h"
#import "JoinCompanyController.h"
#import "NewMeViewController.h"
#import "NewManagerViewController.h"
#import "MyCompanyHeadCell.h"
#import "MyCompanyMidCell.h"
#import "SubsidiaryModel.h"
#import "JoinCompanyModel.h"
#import "SearchCompanyCell.h"
#import "WWPickerView.h"

@interface SearchCompanyController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MyCompanyMidCellDelegate,UITextFieldDelegate>{
//    NSDictionary *comPanyDict;
    NSString *_jobName;//职位名称
    NSString *_applicationName;//申请人姓名
    NSInteger _selectCompanyTag;//选中的公司tag
//    NSInteger _selectJobTag;//选中的职位tag
}
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *branchCnyArray;
@property (nonatomic, strong) NSArray *companyJobArray;
@property (nonatomic, strong) NSArray *shopJobArray;
@property (nonatomic, strong) NSArray *companyJobIdArray;
@property (nonatomic, strong) NSArray *shopJobIdArray;

@end

@implementation SearchCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    self.branchCnyArray = [NSMutableArray array];
    _selectCompanyTag = 1;
//    _selectJobTag = 0;
    [self resetUI];
}

-(void)resetUI{
    self.title = @"申请公司";
    self.view.backgroundColor = White_Color;
    
//    [self.view addSubview:self.searchTF];
//    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
//    self.tableView.hidden = YES;
    
    _jobName = @"";
    self.companyJobArray = @[@"经理",@"客服",@"工程监理",@"主材部",@"辅材部",@"业务员",@"设计师",@"项目经理／工长",@"工程部"];
    self.shopJobArray = @[@"店面经理",@"店员",@"设计师",@"业务员",@"安装工",@"测量员"];
    self.companyJobIdArray = @[@"1003",@"1005",@"1006",@"1007",@"1008",@"1009",@"1010",@"1011",@"1023"];
    self.shopJobIdArray = @[@"1027",@"1028",@"1029",@"1030",@"1031",@"1033"];
    
    [self getBranchCompany];
}

#pragma mark - request

//-(void)requstInfo{
//    [self.view endEditing:YES];
//    [self.dataArray removeAllObjects];
//    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/serch.do"];
//    NSDictionary *paramDic = @{@"companyNumber":self.searchTF.text
//                               };
//    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
//        
//        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
//            
//            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
//            
//            switch (statusCode) {
//                case 1000:
//                    comPanyDict = responseObj[@"cblejCompanyModel"];
//                    
//                    if ([comPanyDict isKindOfClass:[NSNull class]]) {
//                        [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
//                        self.tableView.hidden = YES;
//                    }
//                    else{
//                        self.tableView.hidden = NO;
//                        [self getBranchCompany];
//                    }
//            
//                    
//                    
////                    if ([responseObj[@"agencysList"] isKindOfClass:[NSArray class]]) {
////                        NSArray *array = responseObj[@"agencysList"];
////                        NSArray *arr = [NSArray yy_modelArrayWithClass:[QueryPeopleListModel class] json:array];
////                        [self.dataArray addObjectsFromArray:arr];
////                        //
////                        //                        NSArray *arr2 = [NSArray yy_modelArrayWithClass:[AreaListModel class] json:[dic objectForKey:@"areaList"]];
////                        //                        [self.areaArray addObjectsFromArray:arr2];
////                        //
////                        //                        //刷新数据
////                        [self.tableView reloadData];
////                        
////                    };
//                    ////                    NSDictionary *dic = [NSDictionary ]
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//            
//            
//            
//            
//        }
//        
//        //        NSLog(@"%@",responseObj);
//    } failed:^(NSString *errorMsg) {
//        
//    }];
//}

-(void)searchClick{
//    [self requstInfo];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return self.branchCnyArray.count+1;
    }
    if (section==2) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 100;
    }
    return 0.0000000000000001;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 110;
    }
    else
    {
        return 50;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        UIView *view = [[UIView alloc]init];
        UIButton *applicationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        applicationBtn.frame = CGRectMake(kSCREEN_WIDTH/8, 20, kSCREEN_WIDTH/4*3, 44);
        [applicationBtn setTitle:@"提交申请" forState:UIControlStateNormal];
//        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [applicationBtn setTitleColor:White_Color forState:UIControlStateNormal];
        applicationBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        applicationBtn.layer.masksToBounds = YES;
        applicationBtn.layer.cornerRadius = 5;
//        _addBtn.layer.borderWidth = 1.0;
//        _addBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        applicationBtn.backgroundColor = Main_Color;
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        [applicationBtn addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:applicationBtn];
        return view;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        MyCompanyHeadCell *cell = [MyCompanyHeadCell cellWithTableView:tableView];
        [cell configWith:self.comPanyDict];
        
        cell.editBtn.hidden = YES;
        
        return cell;
    }
    else if(indexPath.section==1) {
        MyCompanyMidCell *cell = [MyCompanyMidCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row==0) {
            
            cell.contentL.text = @"公司架构";
            [cell.leftImg setImage:[UIImage imageNamed:@"comFrame-0"]];
            cell.rightRow.hidden = YES;
            
        }
        else{
            JoinCompanyModel *data = self.branchCnyArray[indexPath.row-1];
            [cell configWith:data];
            cell.path = indexPath;
            [cell.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(0);
                make.left.equalTo(cell.leftImg.mas_right).equalTo(-15);
                make.size.equalTo(CGSizeMake(20, 20));
            }];
            
            cell.delegate = self;
            cell.leftImg.hidden = YES;
            cell.rightRow.hidden = YES;
            cell.selectBtn.hidden = NO;
            
            if (_selectCompanyTag==indexPath.row) {
                [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
            }
            else{
                [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"meixuanzhong"] forState:UIControlStateNormal];
            }
        }
        return cell;
    }
    else{
        SearchCompanyCell *cell = [SearchCompanyCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
//        [cell configWith:comPanyDict];
        if (indexPath.row == 0) {
            cell.contentF.delegate = self;
            cell.contentF.tag = 100;
            cell.titleL.text = @"申请人";
            cell.titleL.font = [UIFont systemFontOfSize:17];
            cell.contentF.placeholder = @"请填写姓名";
            cell.contentF.font = [UIFont systemFontOfSize:17];
            cell.contentF.text = _applicationName;
        }else{
            cell.titleL.text = @"申请职位";
            cell.titleL.font = [UIFont systemFontOfSize:17];
            cell.contentF.placeholder = @"请选择职位";
            cell.contentF.text = _jobName;
            cell.contentF.userInteractionEnabled = NO;
            cell.contentF.font = [UIFont systemFontOfSize:17];
            
        }
        cell.contentF.textAlignment = NSTextAlignmentRight;
        return cell;
    }
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section==2&&indexPath.row==1) {
        if (self.branchCnyArray.count<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"没有分公司，不能选择职位" controller:self sleep:1.5];
        }
        else{
            JoinCompanyModel *model = self.branchCnyArray[_selectCompanyTag-1];
            
            WWPickerView *pickerView = [[WWPickerView alloc] init];
            
            if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
                [pickerView setDataViewWithItem:self.companyJobArray title:@"请选择公司职位"];
            }
            else{
                [pickerView setDataViewWithItem:self.shopJobArray title:@"请选择店铺职位"];
            }
            [pickerView showPickView:self];
            //block回调
            __weak typeof (self) wself = self;
            pickerView.block = ^(NSString *selectedStr) {
                _jobName = selectedStr;
                //一个cell刷新
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
                [wself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
    }
    if (indexPath.section == 1 && indexPath.row >= 1) {
        [self selectCompanyWith:indexPath];
    }
}


#pragma mark - 提交数据
-(void)postData{
    [self.view endEditing:YES];
    if (self.branchCnyArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"没有分公司，不能申请" controller:self sleep:1.5];
        return;
    }
    if (!_applicationName||_applicationName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写姓名" controller:self sleep:1.5];
        return;
    }
    if (!_jobName||_jobName.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择职位" controller:self sleep:1.5];
        return;
    }
    NSInteger jobId = 0;
    JoinCompanyModel *model = self.branchCnyArray[_selectCompanyTag-1];
    if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
        for (int i = 0; i<self.companyJobArray.count; i++) {
            NSString *str = self.companyJobArray[i];
            if (str==_jobName) {
                jobId = [self.companyJobIdArray[i] integerValue];
                break;
            }
        }
    }
    else{
        for (int i = 0; i<self.shopJobArray.count; i++) {
            NSString *str = self.shopJobArray[i];
            if (str==_jobName) {
                jobId = [self.shopJobIdArray[i] integerValue];
                break;
            }
        }
    }
//    NSString *str = @"http://192.168.0.104:8080/blej-api-blej/api/";
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"apply/save.do"];
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),
                               @"applyName":_applicationName,
                               @"applyJob":@(jobId),
                               @"companyId":model.companyId,
                               @"agencysName":user.trueName,
                               @"companyIds":[self.comPanyDict objectForKey:@"companyId"],
                               @"createPerson":model.createPerson
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"申请成功" controller:self sleep:1.0];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationSuccessNo" object:nil];
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[NewMeViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            return ;
                        }
                        if ([vc isKindOfClass:[NewManagerViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            return ;
                        }
                    }
                }
                    break;
                    
                case 1002:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"您已经提交过该公司的申请" controller:self sleep:1.0];
                    return ;
                    
                }
                    break;
                case 2000:{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"申请失败" controller:self sleep:1.0];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"申请失败" controller:self sleep:1.0];
                    break;
            }
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        _applicationName = textField.text;
        //一个cell刷新
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - MyCompanyMidCellDelegate

-(void)selectCompanyWith:(NSIndexPath *)path{
    if ((path.row)==_selectCompanyTag) {
        
    }
    else{
        NSInteger temTag = _selectCompanyTag;
        _selectCompanyTag = path.row;
        //一个cell刷新
        NSIndexPath *indexPathOne=[NSIndexPath indexPathForRow:temTag inSection:path.section];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathOne,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        //一个cell刷新
        NSIndexPath *indexPathTwo=[NSIndexPath indexPathForRow:_selectCompanyTag inSection:path.section];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathTwo,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        _jobName = @"";
        //一个cell刷新
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 查询分公司列表

-(void)getBranchCompany{
    [self.branchCnyArray removeAllObjects];
    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/findListByCompanyId.do"];
    NSDictionary *paramDic = @{@"companyId":[self.comPanyDict objectForKey:@"companyId"]
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"companyList"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = responseObj[@"companyList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[JoinCompanyModel class] json:array];
                        [self.branchCnyArray addObjectsFromArray:arr];
                        JoinCompanyModel *tempModel;
                        for (JoinCompanyModel *model in self.branchCnyArray) {
                            if ([model.companyId integerValue]==[[self.comPanyDict objectForKey:@"companyId"]integerValue]) {
                                tempModel = model;
                                break;
                            }
                        }
                        [self.branchCnyArray removeObject:tempModel];
                        [self.tableView reloadData];
                        
                    };
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
//            if (self.dataArray.count<=0) {
//                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
//            }
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - setter

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, kSCREEN_WIDTH-20, 36)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:14];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入公司号";
    }
    return _searchTF;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10-10, self.searchTF.top+(6), 24, 24);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                _tableView.backgroundColor = White_Color;
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
