//
//  UnionInviteMessageController.m
//  iDecoration
//  邀请消息
//  Created by sty on 2017/10/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UnionInviteMessageController.h"
#import "UnionInviteMessageModel.h"
#import "ZCHApplyCooperateCell.h"
#import "UnionActivityListController.h"

static NSString *reuseIdentifier = @"ZCHApplyCooperateCell";
@interface UnionInviteMessageController ()<UITableViewDelegate, UITableViewDataSource, ZCHApplyCooperateCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation UnionInviteMessageController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"联盟邀请";
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHApplyCooperateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.unionMsgModel = self.dataArray[indexPath.row];

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

//是否允许编辑，默认值是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"删除后数据不可恢复，是否确认删除?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {

            if (buttonIndex == 1) {

                //这个按钮需要处理的代码块
                UnionInviteMessageModel *model = weakSelf.dataArray[indexPath.row];
                [weakSelf deleteUnionWithModel:model];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }];
    
    
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"拒绝" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"拒绝邀请?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                //这个按钮需要处理的代码块
                [weakSelf dealMesWithType:@"2" withIndexPath:indexPath];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"拒绝", nil];
        [alertView show];
        
    }];
    topAction.backgroundColor = [UIColor lightGrayColor];
    
    UnionInviteMessageModel *model = self.dataArray[indexPath.row];
    if (![model.invitationStatus isEqualToString:@"0"]) {
        
        return [NSArray arrayWithObjects:deleteAction, nil];
    } else {
        
        return [NSArray arrayWithObjects:topAction, deleteAction, nil];
    }
}


//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return UITableViewCellEditingStyleDelete;
//}
//
////修改删除按钮的title
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return @"删除";
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        UnionInviteMessageModel *model = self.dataArray[indexPath.row];
//        [self deleteUnionWithModel:model];
//    }
//}

- (void)getData {
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *apiStr = [BASEURL stringByAppendingString:@"invitation/getList.do"];
    NSDictionary *param = @{
                            @"agencysId" : @(user.agencyId),
                            @"page": @(_page),
                            @"pageSize": @(30)
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode == 1000) {
                NSArray *array = responseObj[@"data"][@"invitationList"];
                if (_page == 1) {
                    [self.dataArray removeAllObjects];
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[UnionInviteMessageModel class] json:array];
                    [self.dataArray addObjectsFromArray:arr];
                } else {
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[UnionInviteMessageModel class] json:array];
                    [self.dataArray addObjectsFromArray:arr];
                }
            } else if (statusCode == 1002) {
                
                [self.dataArray removeAllObjects];
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:2.0];
            } else {
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
        }
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        if (_page == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:2.0];
    }];
}

#pragma mark - 代理方法
- (void)didClickApplyBtnWithIndexPath:(NSIndexPath *)indexPath {
    
    // 1: 同意加入  2: 拒绝加入
    [self dealMesWithType:@"1" withIndexPath:indexPath];
}

- (void)deleteUnionWithModel:(UnionInviteMessageModel *)model {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"invitation/delete.do"];
    NSDictionary *param = @{
                            @"invitationId" : model.invitationId
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            _page = 1;
            [self getData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"删除失败"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (void)dealMesWithType:(NSString *)type withIndexPath:(NSIndexPath *)indexPath {
    
    UnionInviteMessageModel *model = self.dataArray[indexPath.row];
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"invitation/invitation.do"];
    NSDictionary *param = @{
                            @"invitationId" : model.invitationId,
                            @"type" : type,
                            @"unionName" : model.unionName,
                            @"companyName" : model.companyName
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            _page= 1;
            [self getData];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"成功加入联盟"];
            // 同意加入联盟跳转到活动列表
            if ([type isEqualToString:@"1"]) {
                NSDictionary *bacDict = responseObj;
                if ([bacDict objectForKey:@"unionLogo"] != nil) {
                    NSString *unionLogo = [NSString stringWithFormat:@"%@", responseObj[@"unionLogo"]];
                    NSString *unionNumber = [NSString stringWithFormat:@"%@", responseObj[@"unionNumber"]];
                    NSString *unionName = [NSString stringWithFormat:@"%@", responseObj[@"unionName"]];
                    NSString *unionId = [NSString stringWithFormat:@"%@", responseObj[@"unionId"]];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:unionLogo forKey:@"unionLogo"];
                    [dict setObject:unionNumber forKey:@"unionNumber"];
                    [dict setObject:unionName forKey:@"unionName"];
                    [dict setObject:unionId forKey:@"unionId"];
                    [self performSelector:@selector(gotoUnionActivityListWithDict:) withObject:dict afterDelay:1.0];
                }
            }
            
        } else if([responseObj[@"code"] integerValue] == 1003) {
             [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已经加入过该联盟了"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"处理失败"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 同意申请 跳转到活动列表页面
- (void)gotoUnionActivityListWithDict:(NSDictionary *)dict {
     UnionActivityListController *unionApctivityVC = [[UnionActivityListController alloc] init];
    unionApctivityVC.isLeader = NO;
    unionApctivityVC.unionLogo = dict[@"unionLogo"];
    unionApctivityVC.unionNumber = dict[@"unionNumber"];
    unionApctivityVC.unionName = dict[@"unionName"];
    unionApctivityVC.unionId = [dict[@"unionId"] integerValue];
    [self.navigationController pushViewController:unionApctivityVC animated:YES];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = White_Color;
        [_tableView registerNib:[UINib nibWithNibName:@"ZCHApplyCooperateCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
