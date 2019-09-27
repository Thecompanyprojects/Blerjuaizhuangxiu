//
//  DistributionbindingVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionbindingVC.h"
#import "DistributionbindingCell0.h"
#import "DistributionbindingCell1.h"
#import "CGXPickerView.h"
#import "Nalabel.h"

@interface DistributionbindingVC ()<UITableViewDataSource,UITableViewDelegate,distriVdelegate,myTabVdelegate>
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

@end

static NSString *Distributionbindingidentfid0 = @"Distributionbindingidentfid0";
static NSString *Distributionbindingidentfid1 = @"Distributionbindingidentfid1";
static NSString *Distributionbindingidentfid2 = @"Distributionbindingidentfid2";

@implementation DistributionbindingVC

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
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *url = [BASEURL stringByAppendingString:POST_selectinsertinfo];
    NSDictionary *para = @{@"agencyId":agencyId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSDictionary* accountList = [responseObj objectForKey:@"accountList"];
            NSArray *accountModel = [accountList objectForKey:@"accountModel"];
            
            NSLog(@"arr-----%@",accountModel);
            for (int i = 0; i<accountModel.count; i++) {
                NSDictionary *dic = accountModel[i];
                NSString *accountType = [dic objectForKey:@"accountType"];
                if ([accountType isEqualToString:@"0"]) {
                    //支付宝账号信息
                    NSString *accountName = [dic objectForKey:@"accountName"];
                    NSString *trueName = [dic objectForKey:@"trueName"];
                    self.infodic0 = @{@"accountName":accountName,@"trueName":trueName};
                }
                if ([accountType isEqualToString:@"1"]) {
                    //微信账号信息
                    NSString *accountName = [dic objectForKey:@"accountName"];
                    self.infodic1 = @{@"accountName":accountName};
                }
            }
            [self.table reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - getters


-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Distributionbindingidentfid0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Distributionbindingidentfid0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"绑定你的提现账户";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            return cell;
        }
        if (indexPath.row==1) {
            DistributionbindingCell0 *cell = [tableView dequeueReusableCellWithIdentifier:Distributionbindingidentfid1];
            if (!cell) {
                cell = [[DistributionbindingCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Distributionbindingidentfid1];
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
        DistributionbindingCell1 *cell = [tableView dequeueReusableCellWithIdentifier:Distributionbindingidentfid1];
        if (!cell) {
            cell = [[DistributionbindingCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Distributionbindingidentfid1];
            
        }
        cell.delegate = self;
        
        if (indexPath.row==0) {
             if ([self.tag isEqualToString:@"0"]) {
                cell.leftLab.text = @"支付宝账号";
                cell.contentText.placeholder = @"请输入支付宝账号";
                cell.contentText.tag = 201;
                //self.infodic0 = @{@"accountName":accountName};
                cell.contentText.text = [self.infodic0 objectForKey:@"accountName"];
             }
             if ([self.tag isEqualToString:@"1"]) {
                cell.leftLab.text = @"微信账号";
                cell.contentText.placeholder = @"请输入微信账号";
                cell.contentText.tag = 301;
                cell.contentText.text = [self.infodic1 objectForKey:@"accountName"];
             }
        }
        if (indexPath.row==1) {
            if ([self.tag isEqualToString:@"0"]) {
                cell.leftLab.text = @"支付宝账号";
                cell.contentText.placeholder = @"请确认支付宝账号";
                cell.contentText.tag = 202;
                cell.contentText.text = [self.infodic0 objectForKey:@"accountName"];
                
            }
            if ([self.tag isEqualToString:@"1"]) {
                cell.leftLab.text = @"微信账号";
                cell.contentText.placeholder = @"请确认微信账号";
                cell.contentText.tag = 302;
                cell.contentText.text = [self.infodic1 objectForKey:@"accountName"];
            }
        }
        if (indexPath.row==2) {
            cell.leftLab.text = @"姓名";
            cell.contentText.placeholder = @"请输入姓名";
            cell.contentText.tag = 401;
            cell.contentText.text = [self.infodic0 objectForKey:@"trueName"];
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
    NSString *accountType = @"";
    self.namestr = [NSString new];
    if ([self.tag isEqualToString:@"0"]) {
        accountType = self.tag;
        UITextField *text1 = [self.table viewWithTag:201];
        UITextField *text2 = [self.table viewWithTag:202];
        UITextView *text3 = [self.table viewWithTag:401];
        
        self.accountName = text1.text;
        self.accountName2 = text2.text;
        self.namestr = text3.text;
    }
    if ([self.tag isEqualToString:@"1"]) {
        accountType = self.tag;
        UITextField *text1 = [self.table viewWithTag:301];
        UITextField *text2 = [self.table viewWithTag:302];
        
        self.accountName = text1.text;
        self.accountName2 = text2.text;
        
        self.namestr = @"分销员";
    }
    
    if (self.accountName.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"账号不能为空，请输入" controller:self sleep:1.5];
        return;
    }
    if (self.namestr.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入真实姓名" controller:self sleep:1.5];
        return;
    }
    if ([self.accountName isEqualToString:self.accountName2]&&self.accountName.length!=0) {
        NSString *accountName = self.accountName;
        NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
        NSDictionary *para = @{@"accountName":accountName,@"agencyId":agencyId,@"accountType":accountType,@"trueName":self.namestr};
        NSString *url = [BASEURL stringByAppendingString:POST_insertInfo];
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {

            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self.navigationController sleep:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSString *msg = [responseObj objectForKey:@"msg"];
                [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    else
    {
        if (![self.accountName isEqualToString:self.accountName2]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"账号不同，请重新输入" controller:self sleep:1.5];
        }

    }
}

@end
