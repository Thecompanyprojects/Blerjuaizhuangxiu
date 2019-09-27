//
//  ZCHSettingChangeNetController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSettingChangeNetController.h"
#import "ZCHSettingChangeNetCell.h"

static NSString *reuseIdentifier = @"ZCHSettingChangeNetCell";
@interface ZCHSettingChangeNetController ()<UITableViewDelegate, UITableViewDataSource, ZCHSettingChangeNetCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *dic;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation ZCHSettingChangeNetController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"切换工地";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"isOuter" : @(self.isOuter)}];
    [self.dataArr addObject:dic];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHSettingChangeNetCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 80)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 36, BLEJWidth - 40, 44)];
    self.confirmBtn = btn;
    btn.backgroundColor = kMainThemeColor;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(didClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:btn];
    self.tableView.tableFooterView = bottomView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHSettingChangeNetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.dic = self.dataArr[indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.dataArr.count - 1) {
        
        return 50;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

#pragma mark - 确定按钮的点击事件
- (void)didClickConfirmBtn:(UIButton *)btn {
    
    if (self.indexPath) {
        
        if (self.indexPath.section == self.dataArr.count - 1) {
            
            [self changeOutNet];
        } else {
            
            [self changeInNet];
        }
    } else {
        
        [self.view hudShowWithText:@"请先选择你要切换的网络..."];
    }
    
}

#pragma mark - 切换至外网
- (void)changeOutNet {
    
    NSString *url = [BASEURL stringByAppendingString:@"companyAgencys/toOuterNet.do"];
    NSDictionary *param = @{
                            @"agencyId" : @([[[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"] integerValue])
                            };
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow showHudSuccess:@"切换成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.refreshBlock) {
                
                self.refreshBlock();
            }
        }
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

#pragma mark - 切换至内网
- (void)changeInNet {
    
    NSString *url = [BASEURL stringByAppendingString:@"companyAgencys/toInnerNet.do"];
    NSDictionary *param = @{
                            @"agencyId" : @([[[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"] integerValue]),
                            @"companyId" : self.dataArr[self.indexPath.section][@"companyId"]
                            };
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow showHudSuccess:@"切换成功"];
            
            if (self.refreshBlock) {
                
                self.refreshBlock();
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

#pragma mark - ZCHSettingChangeNetCellDelegate方法
- (void)didClickSelectedBtn:(UIButton *)btn withIndexpath:(NSIndexPath *)indexpath {
    
    self.indexPath = indexpath;
}

- (void)dealloc {
    
    self.dataArr = nil;
    self.isOuter = NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
