//
//  RegisterInfoViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RegisterInfoViewController.h"
#import "EditInfoTableViewCell.h"
#import "GenderTableViewCell.h"
#import "JobsTableViewCell.h"
#import "GetJobListApi.h"
#import "JobModel.h"
#import "RegisterApi.h"
//#import "SNTabBarController.h"
#import "LoginViewController.h"
#import "RegisterselectVC.h"

@interface RegisterInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

//@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@property (nonatomic, strong) UITableView *editInfoTableView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) NSInteger roleTypeId;
@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) NSMutableArray *jobArray;
@property (nonatomic, strong) UIView *footerView;


@end

@implementation RegisterInfoViewController

-(NSMutableArray*)jobArray{
    
    if (!_jobArray) {
        _jobArray = [NSMutableArray array];
    }
    return _jobArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.roleTypeId = 0;
    self.gender = -1;
    [self createUI];
    [self createTableView];
}

-(void)createUI{
    
    self.title = @"注册";
    self.view.backgroundColor = Bottom_Color;
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [finishBtn setBackgroundColor:Main_Color];
    finishBtn.layer.cornerRadius = 5;
    [finishBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [finishBtn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150)];
    self.footerView.backgroundColor = kBackgroundColor;
    [self.footerView addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.height.equalTo(44);
        make.left.equalTo(20);
        make.right.equalTo(-20);
    }];
    
}

-(void)createTableView{
    
    self.editInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom + 10, kSCREEN_WIDTH,kSCREEN_HEIGHT - self.navigationController.navigationBar.height + 10) style:UITableViewStylePlain];
    self.editInfoTableView.delegate = self;
    self.editInfoTableView.dataSource = self;
    self.editInfoTableView.showsVerticalScrollIndicator = NO;
    self.editInfoTableView.showsHorizontalScrollIndicator = NO;
    self.editInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.editInfoTableView.backgroundColor = kBackgroundColor;
    self.editInfoTableView.scrollEnabled = NO;
    self.editInfoTableView.tableFooterView = self.footerView;
    
    [self.view addSubview:self.editInfoTableView];
    
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"EditInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditInfoTableViewCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"GenderTableViewCell" bundle:nil] forCellReuseIdentifier:@"GenderTableViewCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"JobsTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobsTableViewCell"];
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        EditInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"姓名";
        cell.infoTF.placeholder = @"请输入姓名";
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        GenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenderTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) weakSelf = self;
        
//        男
        cell.maleBlock = ^(NSString *male){
            weakSelf.gender = [male integerValue]; //性别 （0：女，1：男）
        };
//        女
        cell.femaleBlock = ^(NSString *female){
            weakSelf.gender = [female integerValue];
        };
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        EditInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"密码";
        cell.infoTF.placeholder = @"请输入密码";
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)getJobList{
    
    GetJobListApi *jobApi = [[GetJobListApi alloc]init];
    
    [jobApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
         NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        
        switch (code) {
                
//                成功
            case 1000:
            {
                NSArray *jobArr = [request.responseJSONObject objectForKey:@"list"];
                
                for (NSDictionary *dic in jobArr) {
                    
                    JobModel *model = [JobModel yy_modelWithJSON:dic];
                    [self.jobArray addObject:model];
                    
                }
//                选择职位
                [self selectJob];
            }
                break;
                
            case 1001:
            {
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码失效" controller:self];
                
                return ;
            }
                break;
                
            case 1002:
            {
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码错误" controller:self];
                
                return ;
            }
                break;
                
            case 1004:
            {
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"手机号有误" controller:self];
                
                return ;
            }
                break;

            default:
                break;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(void)selectJob{
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    bottomView.backgroundColor = Clear_Color;
    
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-240, kSCREEN_WIDTH, 40)];
    btnView.backgroundColor = White_Color;
    
    [self.bottomView addSubview:btnView];
    
//    取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(8, 0, 60, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:cancelBtn];
    
//    确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(kSCREEN_WIDTH-68, 0, 60, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    sureBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:sureBtn];
    
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-200, kSCREEN_WIDTH, 200)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = Bottom_Color;
    
    [self.bottomView addSubview:pickerView];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.jobArray.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return kSCREEN_WIDTH;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    JobModel *model = [self.jobArray objectAtIndex:row];
    
    return model.cJobTypeName;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc]init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    
    JobModel *model = [self.jobArray objectAtIndex:row];
    pickerLabel.text = model.cJobTypeName;
    
//    转换为字典以便保存
    NSDictionary *jobDict = [model yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:jobDict forKey:@"jobName"];
    
    [self.editInfoTableView reloadData];
    
    return pickerLabel;
}

#pragma mark --注册
-(void)finish:(UIButton*)sender{
    
    [self.view endEditing:YES];
//    姓名
    NSIndexPath *nameIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    EditInfoTableViewCell *nameCell = (EditInfoTableViewCell *)[self.editInfoTableView cellForRowAtIndexPath:nameIndex];
    NSString *name = nameCell.infoTF.text;
    NSString *strName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (strName.length == 0) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入姓名"];
        return;
    }
    

//    密码
    NSIndexPath *pwdIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    EditInfoTableViewCell *pwdCell = (EditInfoTableViewCell*)[self.editInfoTableView cellForRowAtIndexPath:pwdIndex];
    NSString *password = pwdCell.infoTF.text;
    NSString *strPassword = [password stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (strPassword.length == 0) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入密码"];
        return;
    }
    
    if (self.gender == -1) {
        
        self.gender = 1;
    }
    
    NSString *genderstr = [NSString stringWithFormat:@"%ld",self.gender];
    
    
    
    NSDictionary *para = @{@"phone":self.phone,@"password":password,@"inviteCode":self.inviteCode,@"gender":genderstr,@"trueName":name,@"roleTypeId":@"-1",@"phoneCode":self.phoneCode};
    NSString *url = [BASEURL stringByAppendingString:@"agency/registNewUserSingle.do"];
   
    NSLog(@"para---%@",para);
    NSLog(@"url---%@",url);
    
   
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            NSDictionary *dict = [responseObj objectForKey:@"agency"];
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

                if ([obj isEqual:[NSNull null]]) {
                    obj = @"";
                }
                [dictM setObject:obj forKey:key];
            }];

            [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:AGENCYDICT];
            NSString *alias = [responseObj objectForKey:@"agencyId"];
            [[NSUserDefaults standardUserDefaults] setObject:alias forKey:@"alias"];
            
            //[self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
            
            //移除保存过的选择的职位
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jobName"];
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"恭喜您，注册成功!" controller:self sleep:1];
            
            RegisterselectVC *vc = [RegisterselectVC new];
            vc.companyNumber = self.phone;
            [self.navigationController pushViewController:vc animated:YES];
            
        
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1001) {
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码失效" controller:self];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1002) {
             [[PublicTool defaultTool] publicToolsSureAlertInfo:@"对不起，您已经注册过该账号" controller:self];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1003) {
             [[PublicTool defaultTool] publicToolsSureAlertInfo:@"注册超时" controller:self];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1004) {
             [[PublicTool defaultTool] publicToolsSureAlertInfo:@"手机号有误" controller:self];
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

-(void)cancel:(UIButton*)sender{
    
    [self.bottomView removeFromSuperview];
}

-(void)sure:(UIButton*)sender{
    
    [self.bottomView removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jobName"];
}

- (void)dealloc {
    
//    self.returnKeyHandler = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
