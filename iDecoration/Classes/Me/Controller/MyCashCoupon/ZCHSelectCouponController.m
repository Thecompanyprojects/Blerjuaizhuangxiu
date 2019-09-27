//
//  ZCHSelectCouponController.m
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ZCHSelectCouponController.h"
#import "STYNewCashCouponController.h"
#import "STYNewProductCouponController.h"
#import "ZCHCashCouponShowController.h"
#import "ZCHProductCouponShowController.h"
#import "ZCHSelectCouponCell.h"


static NSString *reuseIdentifier = @"ZCHSelectCouponCell";
@interface ZCHSelectCouponController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, ZCHSelectCouponCellDelegate>{
    NSDictionary *_companyDict;
}


@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger selectIndex;


@property (nonatomic, strong) NSMutableDictionary *selectDict;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ZCHSelectCouponController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)haveSelectArray{
    if (!_haveSelectArray) {
        _haveSelectArray = [NSMutableArray array];
    }
    return _haveSelectArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"添加红包";
    self.selectDict = [NSMutableDictionary dictionary];
    
    
    
    self.selectIndex = -1;
    [self setUpUI];
    [self getData];
}

- (void)setUpUI {
    
    // 设置导航栏最右侧的按钮
    UIButton *newBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    newBtn.frame = CGRectMake(0, 0, 44, 44);
    [newBtn setTitle:@"新建" forState:UIControlStateNormal];

    [newBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    newBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    newBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    newBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [newBtn addTarget:self action:@selector(didClickNewBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.btn = newBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    
    CGFloat naviBottom = kSCREEN_HEIGHT - self.navigationController.navigationBar.bottom - 44;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 120;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHSelectCouponCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    UIButton *finishBtn = [[UIButton alloc] init];
    if (BLEJHeight > 736) {

        finishBtn.frame = CGRectMake(0, BLEJHeight - 59, BLEJWidth, 59);
        [finishBtn setBackgroundColor:kMainThemeColor];
        [finishBtn addTarget:self action:@selector(didClickFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:finishBtn];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = White_Color;
        label.text = @"完 成";
        label.font = [UIFont systemFontOfSize:16];
        [finishBtn addSubview:label];
    } else {

        finishBtn.frame = CGRectMake(0, BLEJHeight - 44, BLEJWidth, 44);
        [finishBtn setBackgroundColor:kMainThemeColor];
        [finishBtn setTitle:@"完 成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(didClickFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:finishBtn];
    }
}



- (void)didClickNewBtn:(UIButton *)btn {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建代金券", @"创建礼品券", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {// 代金券
        
        STYNewCashCouponController *VC = [[STYNewCashCouponController alloc]init];
        VC.companyId = self.companyId;
        __weak typeof(self) weakSelf = self;
        VC.block = ^{
            [weakSelf getData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    } else if (buttonIndex == 1) {// 礼品券
        
        STYNewProductCouponController *VC = [[STYNewProductCouponController alloc]init];
        VC.companyId = self.companyId;
        __weak typeof(self) weakSelf = self;
        VC.block = ^{
            [weakSelf getData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHSelectCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    ZCHCouponModel *model = self.dataArray[indexPath.row];
//    BOOL isSelect = NO;
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSInteger tag = [[self.selectDict objectForKey:str] integerValue];
    if (!tag) {
        model.isSelect = NO;
    }
    else{
        model.isSelect = YES;
    }
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSInteger selectTag = [[self.selectDict objectForKey:str] integerValue];
    
    //代金券和礼品券每样最多选一个，可同时选代金券和礼品券
    //未被选中
    if (!selectTag){
        NSArray *keyArray = [self.selectDict allKeys];
        if (keyArray.count>=2) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"最多选两个" controller:self sleep:1.5];
        }
        else if (keyArray.count<=0){
            [self.selectDict setObject:@(1) forKey:str];
        }
        else{
            //已经选了一个，判断如果是0:不能再选0和1，如果是1：不能再选0和1，如果是2:不能再选2
            NSInteger haveTag = [[NSString stringWithFormat:@"%@",keyArray.firstObject] integerValue];
            ZCHCouponModel *haveModel = self.dataArray[haveTag];
            
            ZCHCouponModel *selectModel = self.dataArray[indexPath.row];
            
            if ([haveModel.type integerValue]==0||[haveModel.type integerValue]==1) {
                if ([selectModel.type integerValue]==2) {
                    [self.selectDict setObject:@(1) forKey:str];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"只能选一个代金券" controller:self sleep:1.5];
                }
            }
            else{
                if ([selectModel.type integerValue]==0||[selectModel.type integerValue]==1) {
                    [self.selectDict setObject:@(1) forKey:str];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"只能选一个礼品券" controller:self sleep:1.5];
                }
                
            }
            
            
        }
    }
    else{
        //       [self.selectDict setObject:@(0) forKey:str];
        [self.selectDict removeObjectForKey:str];
    }
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

////是否允许编辑，默认值是YES
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return NO;
//}
//
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    //    __weak typeof(self) weakSelf = self;
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"删除后数据不可恢复，是否确认删除?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//            
//            if (buttonIndex == 1) {
//                
//                //这个按钮需要处理的代码块
//                
//            }
//        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        [alertView show];
//    }];
//    deleteAction.backgroundColor = [UIColor lightGrayColor];
//    
//    //    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"拒绝" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//    //
//    //        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"拒绝邀请?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//    //
//    //            if (buttonIndex == 1) {
//    //
//    //                //这个按钮需要处理的代码块
//    //                [weakSelf dealMesWithType:@"2" withIndexPath:indexPath];
//    //            }
//    //        } cancelButtonTitle:@"取消" otherButtonTitles:@"拒绝", nil];
//    //        [alertView show];
//    //
//    //    }];
//    //    topAction.backgroundColor = [UIColor lightGrayColor];
//    //
//    //    UnionInviteMessageModel *model = self.dataArr[indexPath.row];
//    //    if (![model.applyStatus isEqualToString:@"0"]) {
//    //
//    //        return [NSArray arrayWithObjects:deleteAction, nil];
//    //    } else {
//    //
//    //        return [NSArray arrayWithObjects:topAction, deleteAction, nil];
//    //    }
//    return [NSArray arrayWithObjects:deleteAction, nil];
//}


#pragma mark - 获取数据
- (void)getData {
    
//    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
//    if (!agencyid||agencyid == 0) {
//        agencyid = 0;
//    }
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcoupon/getList.do"];
    NSDictionary *param = @{
                            @"companyId" : self.companyId,
                            @"expired" : @"1", // （1:没有过期的，在添加到美文时使用，0为包含已过期,我的公司中查询使用）
                            @"agencyId":@(user.agencyId)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            _companyDict = responseObj[@"data"][@"companyModel"];
            
            //vip和权限必须都满足，才能新建
            if ([[_companyDict objectForKey:@"calVip"]integerValue]&&[[_companyDict objectForKey:@"hasAuth"]integerValue]) {
                self.btn.hidden = NO;
            }
            else{
                self.btn.hidden = YES;
            }
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:responseObj[@"data"][@"list"]]];
            
            if (self.dataArray.count == 0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还没有任何代金券"];
            }
            else{
                NSDictionary *dict = responseObj[@"data"][@"companyModel"];
                for (ZCHCouponModel *model in self.dataArray) {
                    model.companyName = [dict objectForKey:@"companyName"];
                    model.companyLogo = [dict objectForKey:@"companyLogo"];
                    model.calVip = [dict objectForKey:@"calVip"];
                }
                
                //
                if (self.haveSelectArray.count>0) {
                    //[[self.selectDict objectForKey:str] integerValue];
                    for (int i = 0; i<self.dataArray.count; i++) {
                        ZCHCouponModel *modelOne = self.dataArray[i];
                        for (int j = 0; j<self.haveSelectArray.count; j++) {
                            ZCHCouponModel *modelTwo = self.haveSelectArray[j];
                            if ([modelOne.couponId isEqualToString:modelTwo.couponId]) {
                                NSString *str = [NSString stringWithFormat:@"%d",i];
                                [self.selectDict setObject:@(1) forKey:str];
                            }
                        }
                    }
                    
                }
            }
        } else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        }
        
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

#pragma mark - cell中选择按钮的点击事件
- (void)didClickSelectWithIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSInteger selectTag = [[self.selectDict objectForKey:str] integerValue];
    
    //代金券和礼品券每样最多选一个，可同时选代金券和礼品券
    //未被选中
    if (!selectTag){
        NSArray *keyArray = [self.selectDict allKeys];
        if (keyArray.count>=2) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"最多选两个" controller:self sleep:1.5];
        }
        else if (keyArray.count<=0){
            [self.selectDict setObject:@(1) forKey:str];
        }
        else{
            //已经选了一个，判断如果是0:不能再选0和1，如果是1：不能再选0和1，如果是2:不能再选2
            NSInteger haveTag = [[NSString stringWithFormat:@"%@",keyArray.firstObject] integerValue];
            ZCHCouponModel *haveModel = self.dataArray[haveTag];
            
            ZCHCouponModel *selectModel = self.dataArray[indexPath.row];
            
            if ([haveModel.type integerValue]==0||[haveModel.type integerValue]==1) {
                if ([selectModel.type integerValue]==2) {
                    [self.selectDict setObject:@(1) forKey:str];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"只能选一个代金券" controller:self sleep:1.5];
                }
            }
            else{
                if ([selectModel.type integerValue]==0||[selectModel.type integerValue]==1) {
                    [self.selectDict setObject:@(1) forKey:str];
                }
                else{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"只能选一个礼品券" controller:self sleep:1.5];
                }
                
            }
            
            
        }
    }
    else{
//       [self.selectDict setObject:@(0) forKey:str];
        [self.selectDict removeObjectForKey:str];
    }
    [self.tableView reloadData];
    
}

#pragma mark - 完成按钮的点击事件
- (void)didClickFinishBtn:(UIButton *)btn {
    
    NSArray *keyArray = [self.selectDict allKeys];
    if (keyArray.count<=0||self.dataArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择代金券" controller:self sleep:1.5];
        return;
    }
    
    NSMutableArray *selectArray = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSInteger tag = [[self.selectDict objectForKey:str] integerValue];
        if (tag) {
            NSString *temStr = [NSString stringWithFormat:@"%d",i];
            [selectArray addObject:temStr];
        }
    }
    if (selectArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择代金券" controller:self sleep:1.5];
        return;
    }
    //ZCHCouponModel
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in selectArray) {
        NSInteger tag = [str integerValue];
        ZCHCouponModel *model = self.dataArray[tag];
        [array addObject:model];
    }
    
    if (self.backBlock) {
        self.backBlock(array);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
