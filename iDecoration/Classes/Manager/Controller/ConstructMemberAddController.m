//
//  ConstructMemberAddController.m
//  iDecoration
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ConstructMemberAddController.h"
#import "ShopDetailBottomCell.h"
#import "MemberViewController.h"
#import "MainMaterialDiaryController.h"

@interface ConstructMemberAddController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,EMGroupManagerDelegate>
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ConstructMemberAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = kBackgroundColor;
    
}

-(void)creatUI{
    self.title = @"搜索人员";
    self.view.backgroundColor = White_Color;
    
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
    if (self.index == 2) {
        [self requstOrdinaryJob];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (indexPath.section == 0) {
    //        return 100;
    //    }else{
    return 59;
    //    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailBottomCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    [cell configData:self.dataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSInteger agecyId = [[dict objectForKey:@"agencyId"]integerValue];
    [self judgePeopleHaveJoin:agecyId];
    self.huanxinID = dict[@"huanXinId"];
    
    YSNLog(@"%@",dict);
}

#pragma mark - 搜索普通员工的职位
-(void)requstOrdinaryJob{
    [self.view endEditing:YES];
    if (!self.searchTF||self.searchTF.text.length<=0) {
        self.searchTF.text = @"";
    }
    [self.dataArray removeAllObjects];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/selectPersonInfromInitPage.do"];
   
    NSDictionary *paramDic = @{@"pageSize":@(99),
                               @"page":@(0),
                               @"participanId":self.participanId,
                               @"constructionId":@(self.consID),
                               @"searchContent":self.searchTF.text
                               ,@"flag":self.companyFlag};
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if ([responseObj[@"recordList"] isKindOfClass:[NSArray class]]) {
            NSArray *tempArr = responseObj[@"recordList"];
            [self.dataArray addObjectsFromArray:tempArr];
            [self.tableView reloadData];
        }
        if (self.dataArray.count<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂未搜到人员" controller:self sleep:1.5];
        }
        
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(void)searchClick{
    if (self.index == 1) {
        [self requstWorkerJob];
    }else{
        [self requstOrdinaryJob];
    }
}

#pragma mark - 搜索工人的职位
-(void)requstWorkerJob{
    [self.view endEditing:YES];
    [self.dataArray removeAllObjects];
    if (![self.searchTF.text ew_checkPhoneNumber]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的手机格式" controller:self sleep:1.5];
        return;
    }
    [self.dataArray removeAllObjects];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/byPhoneGetPsersion.do"];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"phone":self.searchTF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
                if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
        
                    NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
        
                    switch (statusCode) {
                        case 100000:
        
        
                            if ([responseObj[@"listEntity"] isKindOfClass:[NSArray class]]) {
                                NSArray *array = responseObj[@"listEntity"];
                                [self.dataArray addObjectsFromArray:array];
                                
        
                            };
                            ////                    NSDictionary *dic = [NSDictionary ]
                            break;
        
                        default:
                            break;
                    }
                    if (self.dataArray.count<=0) {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
                    }
                    //刷新数据
                    [self.tableView reloadData];
                    
                    
                    
                }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

#pragma mark - 判断人员是否加入工地

-(void)judgePeopleHaveJoin:(NSInteger)tag{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/psersionExistence.do"];
    NSDictionary *paramDic = @{@"agencyId":@(tag),
                               @"constructionId":@(self.consID)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10001:
                {
                    [self joinToContruct:tag];
                }
                    
                    break;
                case 10000:{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"该人员已加入该工地" controller:self sleep:1.5];
                
                }
                    break;
                default:
                    break;
            }
  
        }
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

#pragma mark - 添加人员到工地

-(void)joinToContruct:(NSInteger)tag{
    [self.view endEditing:YES];
    [[UIApplication sharedApplication].keyWindow hudShow];
    //工人（1025），业主（1001）其他：普通员工
    NSInteger temJob = 0;
    if (self.jobId==1025) {
        temJob=0;
    }
    else if(self.jobId==1001) {
        temJob=2;
    }
    else{
        temJob=1;
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/addPersonInfrom.do"];
    NSDictionary *paramDic = @{@"agencyId":@(tag),
                               @"constructionId":@(self.consID),
                               @"participanId":self.participanId,
                               @"type":@(temJob),
                               @"flag":self.companyFlag
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加成功" controller:self sleep:1.5];

#if DELETEHUANXIN
                    // (@"注释掉环信")
#else
                    //(@"打开环信代码")
                    //进入群组
                    if (self.huanxinID.length > 0) {
                        
                        //登录环信账号
                        BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
                        if (!isLoggedIn) {
                            UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                            EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                            if (!EMerror) {
                                [[EMClient sharedClient].options setIsAutoLogin:YES];
                            }
                        }
                        
                        EMError *error = nil;
                        
                        //获取该人参与过的所有的群组
                        [[EMClient sharedClient].groupManager   getJoinedGroupsFromServerWithPage:nil pageSize: -1 error:nil];
                        
                        EMGroup *group = [[EMClient sharedClient].groupManager  addOccupants:@[self.huanxinID] toGroup:self.groupid welcomeMessage:nil error:&error];
                        
                        YSNLog(@"聊天群组ID: %@",group.occupants);
                    }

#endif


                   
                    
                    if (self.fromIndex == 1) {
                        //施工日志添加人员
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddmemberOfContrution" object:nil];
                        
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[MemberViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }
                    else{
                        //主材日志添加人员
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddmemberOfMaterial" object:nil];
                        
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[MemberViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
//                            if ([vc isKindOfClass:[MemberViewController class]]) {
//                                [self.navigationController popToViewController:vc animated:YES];
//                            }
                        }
                    }
                    
                }
                    
                    
                    
                    
                    break;
                case 10001:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加失败" controller:self sleep:1.5];
                    break;
                default:
                    
                    break;
            }
            
            
            
            
            
        }
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}




- (void)textFieldDidChangeAction:(UITextField *)textField {
    if ([[PublicTool defaultTool] publicToolsCheckTelNumber:textField.text]) {
        if (self.index == 1) {
            [self requstWorkerJob];
        }else{
            [self requstOrdinaryJob];
        }
    }
}

#pragma mark - setter

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 74, kSCREEN_WIDTH-20, 36)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:14];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入手机号";
        [_searchTF addTarget:self action:@selector(textFieldDidChangeAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTF;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-20 - 27, self.searchTF.top+(6), 25, 25);
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
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ShopDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"ShopDetailBottomCell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
