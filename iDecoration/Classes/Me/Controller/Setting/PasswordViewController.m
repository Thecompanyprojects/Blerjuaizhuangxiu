//
//  PasswordViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "PasswordViewController.h"
#import "LoginViewController.h"
#import "PasswordTableViewCell.h"
#import "ModifyPwdApi.h"
#import "JPUSHService.h"


#define TableViewHeight 44*3+15

@interface PasswordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (nonatomic, strong) UITableView *passwordTableView;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
}

-(void)createUI{
    
    self.title = @"修改密码";
    self.view.backgroundColor = Bottom_Color;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:Main_Color];
    sureBtn.layer.cornerRadius = 5;
    [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.equalTo(@44);
        make.top.equalTo(self.view.mas_top).offset(TableViewHeight+20+64);
    }];
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, TableViewHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]init];
//    tableView.scrollEnabled = NO;
    
    [self.view addSubview:tableView];
    
    self.passwordTableView = tableView;
    
    [self.passwordTableView registerNib:[UINib nibWithNibName:@"PasswordTableViewCell" bundle:nil] forCellReuseIdentifier:@"PasswordTableViewCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PasswordTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"原密码";
            cell.passwordTF.placeholder = @"请输入原密码";
            cell.passwordTF.secureTextEntry = YES;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"新密码";
            cell.passwordTF.placeholder = @"请输入新密码";
            cell.passwordTF.secureTextEntry = YES;
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"确认密码";
            cell.passwordTF.placeholder = @"请输入确认密码";
            cell.passwordTF.secureTextEntry = YES;
        }
    }
    
    return cell;
}

- (void)sureClick:(UIButton*)sender {

    [self.view endEditing:YES];
    NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    PasswordTableViewCell *oldCell = (PasswordTableViewCell*)[self.passwordTableView cellForRowAtIndexPath:oldIndex];
    NSIndexPath *newIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    PasswordTableViewCell *newCell = (PasswordTableViewCell*)[self.passwordTableView cellForRowAtIndexPath:newIndex];
    NSIndexPath *againIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    PasswordTableViewCell *againCell = (PasswordTableViewCell*)[self.passwordTableView cellForRowAtIndexPath:againIndex];
    
    
    if (oldCell.passwordTF.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入原密码" controller:self sleep:1.5];

        return;
    }
    
    if (newCell.passwordTF.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入新密码" controller:self sleep:1.5];
        
        return;
    }
    
    if (againCell.passwordTF.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入确认密码" controller:self sleep:1.5];
        
        return;
    }
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *oldPwd = [MyMD5 md5:oldCell.passwordTF.text];
    
    if (![oldPwd isEqualToString:user.password]) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"原密码输入不正确，请重新输入" controller:self sleep:1.5];
        return;
    }
    
    if (![newCell.passwordTF.text isEqualToString:againCell.passwordTF.text]) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"新密码与确认密码不一致，请重新输入" controller:self sleep:1.5];
        
        return;
    } else {
        
        if ([newCell.passwordTF.text isEqualToString:oldCell.passwordTF.text]) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"新密码不能与原密码相同，请重新输入" controller:self sleep:1.5];
            
            return;
        }
        
        if (newCell.passwordTF.text.length < 6 || newCell.passwordTF.text.length > 16) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"请勿输入非法字符，密码长度在6-16之间" controller:self sleep:1.5];
            
            return;
        }
        
        ModifyPwdApi *modApi = [[ModifyPwdApi alloc]initWithPhone:user.phone oldPwd:oldCell.passwordTF.text  newPwd:newCell.passwordTF.text];
        
        [modApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                NSString *newPwd = [MyMD5 md5:newCell.passwordTF.text];
                user.password = newPwd;
                
                NSDictionary *dict = [user yy_modelToJSONObject];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:AGENCYDICT];
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"密码修改成功" controller:self sleep:1];
                
                __weak typeof(self) weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [weakSelf.navigationController pushViewController:loginVC animated:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AGENCYDICT];
                        
//                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alias"];
                        //            极光推送退出账号
//                        [JPUSHService setTags:nil alias:nil callbackSelector:nil object:nil];
                        
//                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceTokenData"];
//                        [JPUSHService registerDeviceToken:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserState" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];
                    });
                });
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"%@",request.responseJSONObject);
        }];
    }

}

//销毁
- (void)dealloc
{
    self.returnKeyHandler = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
