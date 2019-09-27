//
//  SystemMessageViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "ComplainListApi.h"
#import "SystemMessageModel.h"
#import "SystemMessageCell.h"
#import "SystemMessageDetailViewController.h"
#import "InformationBackDetailViewController.h"
#import "NSObject+CompressImage.h"

@interface SystemMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation SystemMessageViewController
#pragma LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNum += 1;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSObject promptWithControllerName:@"SystemMessageViewController"];
}


-(void)createUI{
    self.title = @"系统消息";
}
#pragma mark - NormalMethod
- (void)getData {
    [self.view hudShow];
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *agencyIdStr = [NSString stringWithFormat:@"%ld", (long)agencyid];
    NSString *pageNumStr = [NSString stringWithFormat:@"%ld", (long)self.pageNum];
    
    UserInfoModel *userInfoModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"complain/selectNews.do"];

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:agencyIdStr forKeyedSubscript:@"agencysId"];
    [paramDic setObject:pageNumStr forKeyedSubscript:@"pageNo"];
    [paramDic setObject:userInfoModel.phone forKeyedSubscript:@"phone"];
    
    
    // 请求参数应该使用paramDic  目前没有数据，  设置为nil时有数据，做测试
    
    YSNLog(@"%@", paramDic);
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSDictionary *dataDict = [responseObj objectForKey:@"data"];
            NSArray *listArray = [dataDict objectForKey:@"list"];
            if (self.pageNum == 1) {
                [self.listArray removeAllObjects];
                for (NSDictionary *dict in listArray) {
                    SystemMessageModel *sysMessageModel = [SystemMessageModel yy_modelWithJSON:dict];
                    YSNLog(@"%@", dict[@"managerId"]);
                    [self.listArray addObject:sysMessageModel];
                }
            } else {
                for (NSDictionary *dict in listArray) {
                    SystemMessageModel *applyModel = [SystemMessageModel yy_modelWithJSON:dict];
                    [self.listArray addObject:applyModel];
                }
            }
            
            [self.tableView reloadData];
        } else if(code == 1001) {
            [self.tableView.mj_footer endRefreshing];
            if (self.pageNum > 1 && self.listArray.count > 0) {
                [self.view hudShowWithText:@"已没有更多消息"];
            }
            
        }

        if (self.pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [self.view hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
        if (self.pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    

}

- (void)deleteSystemMessageByModel:(SystemMessageModel *)model indexPath:(NSIndexPath *)indexPath {
    
    if (model.type == 0) { // 数据类型（0：投诉，1：反馈回复）
        NSString *defaultApi = [BASEURL stringByAppendingString:@"complain/getDelete.do"];
        NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
        if (!agencyid||agencyid == 0) {
            agencyid = 0;
        }
        
        
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        
        [paramDic setObject:@(model.messageId) forKeyedSubscript:@"id"];
        [paramDic setObject:@(agencyid) forKeyedSubscript:@"agencyId"];
        
        [paramDic setObject:@(model.generalManagerId.integerValue) forKeyedSubscript:@"generalManagerId"];
        
        [paramDic setObject:@(model.deal.integerValue) forKeyedSubscript:@"deal"];
        
        if ([model.managerId isEqualToString:@""] || model.managerId.length <= 0 || [model.managerId isEqual:nil]) {
            [paramDic setObject:@"" forKeyedSubscript:@"managerIds"];
        } else {
            [paramDic setObject:model.managerId forKeyedSubscript:@"managerIds"];
        }
        YSNLog(@"%@", paramDic);
        [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            switch (code) {
                case 1000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.0];
                    [self.listArray removeObjectAtIndex:indexPath.row];
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
    
    if (model.type == 1) {
        // 删除反馈内容
        NSString *defaultApi = [BASEURL stringByAppendingString:@"feedback/updateByIdAndType.do"];
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:@(model.messageId) forKeyedSubscript:@"id"];
        [paramDic setObject:@(1) forKeyedSubscript:@"type"];

        YSNLog(@"%@", paramDic);
        [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            switch (code) {
                case 1000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.0];
                    [self.listArray removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.0];
                    [self.tableView setEditing:NO animated:YES];
                    break;
            }
        } failed:^(NSString *errorMsg) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.0];
        }];
    }
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMessageCell" forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.model = self.listArray[indexPath.row];
    SystemMessageModel *sysMessageModel = self.listArray[indexPath.row];
    if (sysMessageModel.type == 0) { // 数据类型（0：投诉，1：反馈回复）
        NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
        if (!agencyid||agencyid == 0) {
            agencyid = 0;
        }
        
        
        if (agencyid == sysMessageModel.generalManagerId.integerValue) {
            cell.flagLabel.hidden = sysMessageModel.generalManagerRead.integerValue;
        }
        
        if ([sysMessageModel.managerId containsString:@","]) {
            NSArray *managerArray = [cell.model.managerId componentsSeparatedByString:@","];
            [managerArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (agencyid == obj.integerValue) {
                    cell.flagLabel.hidden = cell.model.managerRead.integerValue;
                }
            }];
        } else if(sysMessageModel.managerId.integerValue == agencyid){
            cell.flagLabel.hidden = sysMessageModel.managerRead.integerValue;
            YSNLog(@"%d", cell.flagLabel.hidden);
        }
    }
    
    if (sysMessageModel.type == 1) {
        // 反馈内容是否已读状态
        cell.flagLabel.hidden = sysMessageModel.read;  // read 反馈回复（0：未读，1：已读））
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SystemMessageModel *model = self.listArray[indexPath.row];
    SystemMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.flagLabel.hidden = YES;
    
    if (model.type == 0) { // （0：投诉，1：反馈回复）
        SystemMessageDetailViewController *vc = [[SystemMessageDetailViewController alloc] init];
        vc.messageId = model.messageId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.type == 1) {
        InformationBackDetailViewController *backVC = [[InformationBackDetailViewController alloc] init];
        backVC.messageModel = model;
        [self.navigationController pushViewController:backVC animated:YES];
    }
    
    
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
        
        SystemMessageModel *model = self.listArray[indexPath.row];
        
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"删除后不可恢复，请慎重！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tableView setEditing:NO animated:YES];
        }];
        [alertC addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteSystemMessageByModel:model indexPath:indexPath];
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
        [_tableView registerNib:[UINib nibWithNibName:@"SystemMessageCell" bundle:nil] forCellReuseIdentifier:@"SystemMessageCell"];
    }
    return _tableView;
}



@end
