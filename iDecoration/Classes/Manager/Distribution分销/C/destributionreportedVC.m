//
//  destributionreportedVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "destributionreportedVC.h"
#import "reportedCell0.h"
#import "reportedCell1.h"
#import "CGXPickerView.h"

@interface destributionreportedVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UILabel *bottomLab;
@property (nonatomic,copy) NSString *time;
@end

static NSString *reportedidentfid0 = @"reportedidentfid0";
static NSString *reportedidentfid1 = @"reportedidentfid1";

@implementation destributionreportedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开会员报单";
    self.time = @"";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _table.backgroundColor = kBackgroundColor;
    }
    return _table;
}


-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        _footView.backgroundColor = kBackgroundColor;
        [_footView addSubview:self.submitBtn];
        [_footView addSubview:self.bottomLab];
    }
    return _footView;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.frame = CGRectMake(15, 20, kSCREEN_WIDTH-30, 40);
        _submitBtn.backgroundColor = Main_Color;
        _submitBtn.layer.cornerRadius = 4;
        [_submitBtn setTitle:@"确定" forState:normal];
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _submitBtn;
}

-(UILabel *)bottomLab
{
    if(!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.frame = CGRectMake(15, 80, kSCREEN_WIDTH-30, 80);
        _bottomLab.textColor = [UIColor hexStringToColor:@"9b9c9d"];
        _bottomLab.font = [UIFont systemFontOfSize:12];
        _bottomLab.numberOfLines = 0;
        _bottomLab.text = @"1.请务必在开通会员后48小时内完成报单，48小时后系统将不再受理您的报单申请。\n2.输入公司开通会员的时间，与公司开通时间的误差不能超过半小时。";
    }
    return _bottomLab;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        reportedCell0 *cell = [tableView dequeueReusableCellWithIdentifier:reportedidentfid0];
        if (!cell) {
            cell = [[reportedCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reportedidentfid0];
            cell.codetext.tag = 201;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        reportedCell1 *cell = [tableView dequeueReusableCellWithIdentifier:reportedidentfid1];
        if (!cell) {
            cell = [[reportedCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reportedidentfid1];
        }
        cell.timeLab.text = self.time;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        [CGXPickerView showDatePickerWithTitle:@"日期和时间" DateType:UIDatePickerModeDateAndTime DefaultSelValue:nil MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            NSLog(@"%@",selectValue);
            self.time = selectValue;
            [self.table reloadData];
        }];
    }
}


#pragma mark - 实现方法

-(void)submitbtnclick
{
    NSString *companyId = @"";
    NSString *startTime = @"";
    startTime = self.time;
    UITextField *text = [self.table viewWithTag:201];
    if (text.text.length==0) {
        companyId = @"";
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司ID不能为空" controller:self sleep:1.5];
        return;
    }
    else
    {
        companyId = text.text;
    }
    NSDictionary *para = @{@"companyId":companyId,@"spreadId":self.spreadId,@"startTime":startTime};
    NSString *url = [BASEURL stringByAppendingString:POST_spreadMerchantVip];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        NSString *hud = [responseObj objectForKey:@"msg"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.navigationController popViewControllerAnimated:YES];
           
            [[PublicTool defaultTool] publicToolsHUDStr:hud controller:self.navigationController sleep:1.5];
        }

        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:hud controller:self sleep:1.5];
        }
        
        //1000,1001,1002,1003,1004,1005,1006,2000
       // 成功,失败,信息已存在,不符合条件,公司不存在,误差时间超过两小时,误差时间超过半小时,出错
        
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

@end
