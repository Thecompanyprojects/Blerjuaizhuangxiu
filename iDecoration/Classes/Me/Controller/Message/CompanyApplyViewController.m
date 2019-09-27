//
//  CompanyApplyViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyApplyViewController.h"
#import "CompanyApplyCell.h"
#import "CompanyApplyModel.h"
#import "NSObject+CompressImage.h"
#import "NewMyPersonCardController.h"

@interface CompanyApplyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
// 列表数组
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation CompanyApplyViewController
#pragma LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];

    // 收到通知刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kReciveRemoteNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSObject promptWithControllerName:@"CompanyApplyViewController"];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData:(NSNotification *)noti {
    if ([noti.userInfo[@"messageType"] integerValue] == 2 || [noti.userInfo[@"messageType"] integerValue] == 3) {
        _page = 1;
        [self getData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma NormalMehtod

-(void)createUI{
    self.title = @"员工申请";
}

// 获取数据列表
- (void)getData {
    [self.view hudShow];
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"apply/getListByApply.do"];
    NSDictionary *paramDic = @{
                               @"agencysId":@(agencyid),
                               @"page": @(_page),
                               @"pageSize": @(30)
                               };
    // 请求参数应该使用paramDic  目前没有数据，  设置为nil时有数据，做测试
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSArray *listArray = [responseObj objectForKey:@"applyList"];
            if (_page == 1) {
                [self.listArray removeAllObjects];
                for (NSDictionary *dict in listArray) {
                    CompanyApplyModel *applyModel = [CompanyApplyModel yy_modelWithJSON:dict];
                    if (![self.listArray containsObject:applyModel]) {
                        [self.listArray addObject:applyModel];
                    }
                }
            } else {
                for (NSDictionary *dict in listArray) {
                    CompanyApplyModel *applyModel = [CompanyApplyModel yy_modelWithJSON:dict];
                    if (![self.listArray containsObject:applyModel]) {
                        [self.listArray addObject:applyModel];
                    }
                }
            }
            [self.tableView reloadData];
        } else {
            
        }
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSString *errorMsg) {
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.view hiddleHud];
        [self.view hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
        //加载失败
    }];
}

//根据applID删除公司申请
-(void)deleteCompanyApplyByModel:(CompanyApplyModel*)model indexPath:(NSIndexPath *)indexpath{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"apply/delete.do"];
    NSDictionary *paramDic = @{
                               @"applyId":@(model.applyId),
                               };
    YSNLog(@"------%@", paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.0];
                [self.listArray removeObjectAtIndex:indexpath.row];
                [self.tableView reloadData];
            }
                break;
                
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.0];
                [self.tableView setEditing:NO animated:YES];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

// 同意公司申请
- (void)agreeCompanyApplyWithButton:(UIButton *)sender {
    YSNLog(@"%ld", (long)sender.tag);
    CompanyApplyModel *model = self.listArray[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CompanyApplyCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"apply/update.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{
                               @"applyId": @(model.applyId),
                               @"companyId": @(model.companyId),
                               @"applyJob": @(model.applyJob),
                               @"agencysId": @(model.agencysId),
                               @"currentPersonName":userModel.trueName,
                               @"companyName": model.companyName
                               };
    
    YSNLog(@"%@", paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                cell.rightBtn.enabled = NO;
                [cell.rightBtn setTitle:@"已通过" forState:UIControlStateDisabled];
                [cell.rightBtn setBackgroundColor:[UIColor whiteColor]];
            }
                break;
            case 1001:
                [[PublicTool defaultTool] publicToolsHUDStr:@"加入失败" controller:self sleep:1.0];
                break;
            case 1002:
                [[PublicTool defaultTool] publicToolsHUDStr:@"该人员已加入其他公司" controller:self sleep:1.0];
                break;
            case 2000:
                [[PublicTool defaultTool] publicToolsHUDStr:@"操作失败，请联系系统人员" controller:self sleep:1.0];
                break;
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"网络延迟，稍后再试" controller:self sleep:1.0];
                break;
        }
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"网络延迟，稍后再试" controller:self sleep:1.0];
    }];
}


#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyApplyCell" forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.applyModel = self.listArray[indexPath.row];
    cell.rightBtn.tag = indexPath.row;
    [cell.rightBtn addTarget:self action:@selector(agreeCompanyApplyWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.iconTapBlock = ^{
        
        NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
        CompanyApplyModel *model = self.listArray[indexPath.row];
        vc.agencyId = [NSString stringWithFormat:@"%ld",model.agencysId];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}




//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 76;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


//是否允许编辑，默认值是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CompanyApplyModel *model = self.listArray[indexPath.row];
        
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"删除后不可恢复，请慎重！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tableView setEditing:NO animated:YES];
        }];
        [alertC addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteCompanyApplyByModel:model indexPath:indexPath];
            YSNLog(@"删除 了");
        }];
        [alertC addAction:sureAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}




#pragma LazyMethod
-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"CompanyApplyCell" bundle:nil] forCellReuseIdentifier:@"CompanyApplyCell"];
    }
    return _tableView;
}


@end
