//
//  STYMyCashCouponController.m
//  iDecoration
//
//  Created by sty on 2018/3/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "STYMyCashCouponController.h"
#import "MTSegmentedControl.h"
#import "ZCHCouponModel.h"
#import "ZCHcouponCashCell.h"

#import "MyCashCouponDetailOneController.h"
#import "ZCHPublicWebViewController.h"

static NSString *reuseIdentifier = @"ZCHcouponCashCell";
@interface STYMyCashCouponController ()<MTSegmentedControlDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MTSegmentedControl *segmentView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger selectType;//0：，1：，2：@"未使用",@"已使用",@"已过期"
@end

@implementation STYMyCashCouponController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的代金券";
    
    [self setUI];
    
    [self getData];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self addSuspendedButton];
}

-(void)setUI{
    self.segmentView = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, 50)];
    [self.segmentView segmentedControl:@[@"未使用",@"已使用",@"已过期"] Delegate:nil];
    self.segmentView.delegate = self;
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
}

-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/6974/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHcouponCashCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    ZCHCouponModel *model = self.dataArray[indexPath.row];
    [cell configData:model];
    cell.backgroundColor = White_Color;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //只有未使用的可以查看
    if (self.selectType == 0) {
        MyCashCouponDetailOneController *vc = [[MyCashCouponDetailOneController alloc]init];
        ZCHCouponModel *model = self.dataArray[indexPath.row];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//是否允许编辑，默认值是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否确认删除该代金券?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
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
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcouponcustomer/getDelete.do"];
    NSDictionary *param = @{
                            @"ccId" : model.ccId,
                            @"agencyId":@(user.agencyId)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow:@"删除中..."];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArray removeObjectAtIndex:index.row];
        }
        else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
    }];
}


#pragma mark - MTSegmentedControlDelegate
-(void)segumentSelectionChange:(NSInteger)selection{
    self.selectType = selection;
    [self getData];
}

-(void)getData{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcouponcustomer/getByAgencyId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"phone":user.phone,
                               @"type":@(self.selectType)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                
                NSArray *arr = [NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:responseObj[@"data"][@"list"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                [self.tableView reloadData];
                
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom, BLEJWidth, kSCREEN_HEIGHT-self.segmentView.bottom) style:UITableViewStylePlain];
        _tableView.backgroundColor = White_Color;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ZCHcouponCashCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
