//
//  ZCHCashCouponController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCashCouponController.h"
#import "ZCHcouponCashCell.h"
#import "ZCHNewCashCouponController.h"
#import "ZCHNewProductCouponController.h"
#import "ZCHCashCouponShowController.h"
#import "ZCHProductCouponShowController.h"
#import "ZCHCouponModel.h"
#import "ZCHAllGetRecordCouponController.h"
#import "STYNewCashCouponController.h"
#import "STYNewProductCouponController.h"
#import "ZCHPublicWebViewController.h"
#import "STYCouponSelectModel.h"
#import "UIButton+LXMImagePosition.h"

static NSString *reuseIdentifier = @"ZCHcouponCashCell";
@interface ZCHCashCouponController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *createBtn;

@end

@implementation ZCHCashCouponController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"促销代金券";
    self.dataArray = [NSMutableArray array];
    [self setUpUI];
    [self getData];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self addSuspendedButton];
}

- (void)setUpUI {
    
    if (self.isCanNewCoupon) {
        // 设置导航栏最右侧的按钮
        UIButton *getRecordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        getRecordBtn.frame = CGRectMake(0, 0, 60, 44);
        [getRecordBtn setTitle:@"领取记录" forState:UIControlStateNormal];
        
        [getRecordBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        getRecordBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        getRecordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        getRecordBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [getRecordBtn addTarget:self action:@selector(didClickGetRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:getRecordBtn];
        
        CGFloat naviBottom = kSCREEN_HEIGHT - self.navigationController.navigationBar.bottom - 44;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        self.tableView.backgroundColor = kBackgroundColor;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = 120;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
        [self.view addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"ZCHcouponCashCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        
        UIButton *newBtn = [[UIButton alloc] init];
        self.createBtn = newBtn;
        newBtn.hidden = YES;
        newBtn.frame = CGRectMake(0, BLEJHeight - 44, BLEJWidth, 44);
        [newBtn setBackgroundColor:[UIColor whiteColor]];
        [newBtn setTitleColor:Main_Color forState:normal];
        [newBtn setImage:[UIImage imageNamed:@"greenAddBtn"] forState:normal];
        [newBtn setTitle:@"创建促销劵" forState:UIControlStateNormal];
        [newBtn setImagePosition:LXMImagePositionLeft spacing:10];
        [newBtn addTarget:self action:@selector(didClickNewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newBtn];
    } else {
        
        CGFloat naviBottom = kSCREEN_HEIGHT - self.navigationController.navigationBar.bottom;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        self.tableView.backgroundColor = kBackgroundColor;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = 120;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
        [self.view addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"ZCHcouponCashCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    }
}




-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/6973/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 新建红包的点击事件
- (void)didClickNewBtn:(UIButton *)btn {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建代金券", @"创建礼品券", nil];
    [sheet showInView:self.view];
}

#pragma mark - 领取记录
- (void)didClickGetRecordBtn:(UIButton *)btn {
    
    ZCHAllGetRecordCouponController *VC = [[ZCHAllGetRecordCouponController alloc] init];
    VC.companyId = self.companyId;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {// 代金券
        
        STYNewCashCouponController *VC = [[STYNewCashCouponController alloc]init];
        VC.companyId = self.companyId;
        VC.companyName = self.companyName;
        __weak typeof(self) weakSelf = self;
        VC.block = ^{
            [weakSelf getData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    } else if (buttonIndex == 1) {// 礼品券
        
        STYNewProductCouponController *VC = [[STYNewProductCouponController alloc]init];
        VC.companyId = self.companyId;
        VC.companyName = self.companyName;
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHcouponCashCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.isCanNew) {
        cell.model = self.dataArray[indexPath.row];
    } else {
        cell.myModel = self.dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
        ZCHCouponModel *model = self.dataArray[indexPath.row];
        [self getCouponDetailInfo:model.couponId];
 
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

//是否允许编辑，默认值是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
        if (self.isCanNewCoupon) {
            return YES;
        } else {
            return NO;
        }
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否确认删除该代金券?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
//                if (weakSelf.isCanNew) {
//                    ZCHCouponModel *model = weakSelf.dataArray[indexPath.row];
//                    if (![model.numbers isEqualToString:model.remainNumbers]) {
//                        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"已经有人领取此代金券，不能删除" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
//
//                        } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                        [alertView show];
//                    } else {
//                        //这个按钮需要处理的代码块
//                        [weakSelf deleteCouponWithIndex:indexPath];
//                    }
//                } else {
//                    //这个按钮需要处理的代码块
//                    [weakSelf deleteCouponWithIndex:indexPath];
//                }
            [self deleteCouponWithIndex:indexPath];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    
    
    return [NSArray arrayWithObjects:deleteAction, nil];
}

#pragma mark - 删除
- (void)deleteCouponWithIndex:(NSIndexPath *)index {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    ZCHCouponModel *model = self.dataArray[index.row];
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcoupon/delete.do"];
    NSDictionary *param = @{
                            @"couponId" : model.couponId,
                            @"agencyId":@(user.agencyId)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow:@"删除中..."];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArray removeObjectAtIndex:index.row];
        }
        else if (responseObj && [responseObj[@"code"] integerValue] == 1001) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"有人领取不能删除" controller:self sleep:1.5];
        }else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
    }];
}

#pragma mark - 获取数据
- (void)getData {
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcoupon/getList.do"];
    NSDictionary *param = @{
                            @"companyId" : self.companyId,
                            @"expired" : @"0",
                            @"agencyId":@(user.agencyId)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:responseObj[@"data"][@"list"]]];
            
            NSDictionary *companyDict = responseObj[@"data"][@"companyModel"];

            for (ZCHCouponModel *model in self.dataArray) {
                model.companyName = [companyDict objectForKey:@"companyName"]?[companyDict objectForKey:@"companyName"]:@"";
                model.companyLogo = [companyDict objectForKey:@"companyLogo"]?[companyDict objectForKey:@"companyLogo"]:@"";
                
            }
            
            
            self.createBtn.hidden = [responseObj[@"data"][@"companyModel"][@"calVip"] integerValue] == 0 ? YES : NO;
            if (self.dataArray.count == 0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还没有任何代金券"];
            }
        } else {
            self.createBtn.hidden = YES;
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

- (void)getMyData {
    
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcouponcustomer/getByAgencyId.do"];
    NSDictionary *param = @{
                            @"agencyId" : @(model.agencyId),
                            @"phone" : model.phone
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:responseObj[@"data"][@"list"]]];
            if (self.dataArray.count == 0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还没有任何代金券"];
            }
        } else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
    
}

#pragma mark - 查询代金券或礼品券的基本信息

-(void)getCouponDetailInfo:(NSString *)couponId{
    //UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcoupon/getById.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"couponId":couponId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                
                NSDictionary *data = [responseObj objectForKey:@"data"];
                NSDictionary *company = [data objectForKey:@"company"];
                NSString *companyName = [company objectForKey:@"companyName"];
                
                NSArray *giftsArray = responseObj[@"data"][@"gifts"];
                ZCHCouponModel *model = [ZCHCouponModel yy_modelWithJSON:responseObj[@"data"][@"model"]];
                
                if ([model.type integerValue]!=2) {
                    //代金券
                    STYNewCashCouponController *vc = [[STYNewCashCouponController alloc]init];
                    if (self.isCanNewCoupon) {
                        vc.ischoose = YES;
                    }
                    else
                    {
                        vc.ischoose = NO;
                    }
                    vc.isEdit = YES;
                    vc.companyId = self.companyId;
                    if ([model.remainNumbers isEqualToString:model.remainNumbers]) {
                        vc.isHaveRecive = NO;
                    }
                    else{
                        vc.isHaveRecive = YES;
                    }
                    
                    vc.CouponId = model.couponId;
                    vc.CouponNameStr = model.couponName;
                    vc.CouponType = model.type;
                    vc.CouponNumStr = model.numbers;
                    vc.CouponFaceValueStr = model.price;
                    model.startDate  = [self getDateFormatStrFromTimeStamp:model.startDate];
                    model.endDate  = [self getDateFormatStrFromTimeStamp:model.endDate];
                    vc.CouponStartTimeStr = model.startDate;
                    vc.CouponEndTimeStr = model.endDate;
                    vc.CouponScopeStr = model.exchangeScope;
                    vc.CouponAddressStr = model.exchangeAddress;
                    vc.lantitude = [model.latitude doubleValue];
                    vc.longitude = [model.longitude doubleValue];
                    vc.CouponRemarks = model.remark;
                    vc.companyName = companyName;
                    
                    
                    __weak typeof(self) weakSelf = self;
                    vc.block = ^{
                        [weakSelf getData];
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                else{
                    //礼品券
                    STYNewProductCouponController *vc = [[STYNewProductCouponController alloc]init];
                    vc.isEdit = YES;
                    vc.companyId = self.companyId;
                    if (self.isCanNewCoupon) {
                        vc.ischoose = YES;
                    }
                    else
                    {
                        vc.ischoose = NO;
                    }
                    if ([model.remainNumbers isEqualToString:model.remainNumbers]) {
                        vc.isHaveRecive = NO;
                    }
                    else{
                        vc.isHaveRecive = YES;
                    }

                    vc.couponId = model.couponId;
                    vc.CouponNameStr = model.couponName;
                    vc.CouponNumStr = model.numbers;
                    vc.CouponFaceValueStr = model.price;
                    model.startDate  = [self getDateFormatStrFromTimeStamp:model.startDate];
                    model.endDate  = [self getDateFormatStrFromTimeStamp:model.endDate];
                    vc.CouponStartTimeStr = model.startDate;
                    vc.CouponEndTimeStr = model.endDate;
                    vc.CouponScopeStr = model.exchangeScope;
                    vc.CouponAddressStr = model.exchangeAddress;
                    vc.lantitude = [model.latitude doubleValue];
                    vc.longitude = [model.longitude doubleValue];
                    vc.CouponRemarks = model.remark;
                    vc.companyName = companyName;
                    
                    //STYCouponSelectModel
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[STYCouponSelectModel class] json:giftsArray];
                    [vc.couponArray addObjectsFromArray:arr];
                    
                    __weak typeof(self) weakSelf = self;
                    vc.block = ^{
                        [weakSelf getData];
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
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

#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}




@end
