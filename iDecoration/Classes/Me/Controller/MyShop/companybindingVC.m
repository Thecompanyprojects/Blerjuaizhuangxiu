//
//  companybindingVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "companybindingVC.h"
#import "DistributionbindingCell0.h"
#import "DistributionbindingCell1.h"
#import "CGXPickerView.h"
#import "Nalabel.h"
#import "SettingViewController.h"

@interface companybindingVC ()<UITableViewDataSource,UITableViewDelegate,distriVdelegate,myTabVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy)  NSString *tag;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *sumitBtn;
@property (nonatomic,copy) NSString *accountType;//()账号类型(0.支付宝 1.微信)
@property (nonatomic,copy) NSString *accountName;//账户名
@property (nonatomic,copy) NSString *accountName2;//账户名
@property (nonatomic,copy) NSString *namestr;


@property (nonatomic,strong) NSDictionary *infodic0;
@property (nonatomic,strong) NSDictionary *infodic1;

@property (nonatomic,strong) NSDictionary *company;

@end

static NSString *companybindingidentfid0 = @"companybindingidentfid0";
static NSString *companybindingidentfid1 = @"companybindingidentfid1";
static NSString *companybindingidentfid2 = @"companybindingidentfid2";

@implementation companybindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定账户";
    self.tag = @"0";
    [self loaddata];
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:POST_CHAXUNGONGSI];
    NSDictionary *para = @{@"companyId":self.companyId};
    self.company = [NSDictionary new];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            self.company = [data objectForKey:@"comapny"];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}


-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        [_bgView addSubview:self.sumitBtn];
    }
    return _bgView;
}


-(UIButton *)sumitBtn
{
    if(!_sumitBtn)
    {
        _sumitBtn = [[UIButton alloc] init];
        _sumitBtn.frame = CGRectMake(20, 20, kSCREEN_WIDTH-40, 46);
        [_sumitBtn setTitle:@"确定" forState:normal];
        [_sumitBtn setTitleColor:[UIColor whiteColor] forState:normal];
        _sumitBtn.backgroundColor = Main_Color;
        _sumitBtn.layer.masksToBounds = YES;
        _sumitBtn.layer.cornerRadius = 5;
        [_sumitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sumitBtn;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        if ([self.tag isEqualToString:@"1"]) {
            return 2;
        }
        else
        {
            return 3;
        }
        //return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companybindingidentfid0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companybindingidentfid0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"绑定你的提现账户";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            return cell;
        }
        if (indexPath.row==1) {
            DistributionbindingCell0 *cell = [tableView dequeueReusableCellWithIdentifier:companybindingidentfid1];
            if (!cell) {
                cell = [[DistributionbindingCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companybindingidentfid1];
            }
            if ([self.tag isEqualToString:@"0"]) {
                cell.contentLab.text = @"绑定方式:支付宝";
            }
            if ([self.tag isEqualToString:@"1"]) {
                cell.contentLab.text = @"绑定方式:微信";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }
    if (indexPath.section==1) {
        DistributionbindingCell1 *cell = [tableView dequeueReusableCellWithIdentifier:companybindingidentfid2];
        if (!cell) {
            cell = [[DistributionbindingCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companybindingidentfid2];
            
        }
        cell.delegate = self;
        
        if (indexPath.row==0) {
            if ([self.tag isEqualToString:@"0"]) {
                cell.leftLab.text = @"支付宝账号";
                cell.contentText.placeholder = @"请输入支付宝账号";
                cell.contentText.tag = 201;
                
                cell.contentText.text = [self.company objectForKey:@"aliUser"];
            }
            if ([self.tag isEqualToString:@"1"]) {
                cell.leftLab.text = @"微信账号";
                cell.contentText.placeholder = @"请输入微信账号";
                cell.contentText.tag = 301;
                cell.contentText.text = [self.company objectForKey:@"wxAccount"];
            }
        }
        if (indexPath.row==1) {
            if ([self.tag isEqualToString:@"0"]) {
                cell.leftLab.text = @"确认账号";
                cell.contentText.placeholder = @"请再次输入支付宝账号";
                cell.contentText.tag = 202;
                cell.contentText.text = [self.company objectForKey:@"aliUser"];
                
            }
            if ([self.tag isEqualToString:@"1"]) {
                cell.leftLab.text = @"确认账号";
                cell.contentText.placeholder = @"请再次输入微信账号";
                cell.contentText.tag = 302;
                cell.contentText.text = [self.company objectForKey:@"wxAccount"];
            }
        }
        if (indexPath.row==2) {
            cell.leftLab.text = @"姓名";
            cell.contentText.placeholder = @"请输入支付宝账号对应的姓名";
            cell.contentText.tag = 401;
            cell.contentText.text = [self.company objectForKey:@"aliUserName"];
        }
        [cell.leftLab setAlightLeftAndRightWithWidth:80];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

-(void)myTabVClick:(UITableViewCell *)cell andtagstr:(NSString *)str
{
    self.tag = str;
    
    [self.table reloadData];
}

-(void)myTabVClick:(UITableViewCell *)cell andtextstr:(NSString *)textstr
{
    //NSIndexPath *index = [self.table indexPathForCell:cell];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 50*HEIGHT_SCALE;
        }
        else
        {
            return 90*HEIGHT_SCALE;
        }
    }
    if (indexPath.section==1) {
        return 50*HEIGHT_SCALE;
    }
    return 0.01f;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - 实现方法

-(void)submitbtnclick
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
    NSString *wxOpenId = [dic objectForKey:@"wxToken"];
    NSString *aliUser = [NSString new];
    NSString *aliUserName = [NSString new];
    NSString *type = [NSString new];
    
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = [NSDictionary new];
    if ([self.tag isEqualToString:@"0"])
    {
        type = @"0";
        UITextField *text1 = [self.table viewWithTag:201];
        UITextField *text2 = [self.table viewWithTag:202];
        
        if (text1.text.length==0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"账号不能为空，请输入" controller:self sleep:1.4];
            return;
        }
        
        if ([text1.text isEqualToString:text2.text]&&text1.text.length!=0) {
            aliUser = text1.text;
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:@"两次输入的账户不一致" controller:self sleep:1.4];
            return;
        }
        
        UITextField *text3 = [self.table viewWithTag:401];
        if (text3.text.length!=0) {
            aliUserName = text3.text;
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请输入真实姓名" controller:self sleep:1.5];
            return;
        }
        para = @{@"wxOpenId":@"",@"aliUser":aliUser,@"aliUserName":aliUserName,@"companyId":self.companyId,@"type":type,@"agencysId":agencysId,@"wxAccount":@""};
    }
    else
    {
        type = @"1";
        UITextField *text1 = [self.table viewWithTag:301];
        UITextField *text2 = [self.table viewWithTag:302];
        
        if (text1.text.length==0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"账号不能为空，请输入" controller:self sleep:1.4];
            return;
        }
        
        NSString *wxAccount = [NSString new];
        if ([text1.text isEqualToString:text2.text]&&text1.text!=0) {
            aliUser = text1.text;
            wxAccount = aliUser;
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:@"两次输入的账户不一致" controller:self sleep:1.4];
            return;
        }
        
        if (IsNilString(wxOpenId)) {
          //  [[PublicTool defaultTool] publicToolsHUDStr:@"您还没有绑定微信" controller:self sleep:1.5];
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置界面进行微信绑定" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SettingViewController *vc = [SettingViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [control addAction:action0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:nil];
        }
        
        para = @{@"wxOpenId":wxOpenId,@"aliUser":@"",@"aliUserName":@"",@"companyId":self.companyId,@"type":type,@"agencysId":agencysId,@"wxAccount":@""};
    }
    NSString *url = [BASEURL stringByAppendingString:POST_bindAccountcompany];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self.navigationController sleep:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
