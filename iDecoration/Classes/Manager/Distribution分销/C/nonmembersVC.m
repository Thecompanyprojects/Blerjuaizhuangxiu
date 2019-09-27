//
//  nonmembersVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "nonmembersVC.h"
#import "reportedCell0.h"
#import "reportedCell1.h"
#import "CGXPickerView.h"
#import "newWSRedPacketView.h"
#import "newWSRewardConfig.h"
#import "detailsofenvelopeVC.h"

@interface nonmembersVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UILabel *bottomLab;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,strong) NSDictionary *modelDic;
@end

static NSString *nonmembersidentfid0 = @"nonmembersidentfid0";
static NSString *nonmembersidentfid1 = @"nonmembersidentfid1";

@implementation nonmembersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"免费版商家报单";
    self.time = @"";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openRedPacketAction
{
    newWSRewardConfig *info = ({
        newWSRewardConfig *info   = [[newWSRewardConfig alloc] init];
        
        float moneyfl = [[self.modelDic objectForKey:@"money"] floatValue];
        NSString *moneystr = [NSString stringWithFormat:@"%.2f",moneyfl];
        info.money = [moneystr floatValue];
        
        info.avatarImage = [self.modelDic objectForKey:@"photo"];
        info.content = @"恭喜发财，大吉大利";
        info.userName  = [self.modelDic objectForKey:@"trueName"];

        info;
        
    });
    
    [newWSRedPacketView showRedPackerWithData:info cancelBlock:^{
        NSLog(@"取消领取");
        
    } finishBlock:^(float money) {
        NSLog(@"领取金额：%f",money);
        detailsofenvelopeVC *vc = [detailsofenvelopeVC new];
        vc.modelDic = [NSDictionary dictionary];
        vc.modelDic = self.modelDic;
        [self.navigationController pushViewController:vc animated:YES];

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
        _bottomLab.text = @"*非装饰行业商家请勿邀请注册，违者永久关停分销员账号。";
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
        reportedCell0 *cell = [tableView dequeueReusableCellWithIdentifier:nonmembersidentfid0];
        if (!cell) {
            cell = [[reportedCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nonmembersidentfid0];
            cell.codetext.tag = 201;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        reportedCell1 *cell = [tableView dequeueReusableCellWithIdentifier:nonmembersidentfid1];
        if (!cell) {
            cell = [[reportedCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nonmembersidentfid1];
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
            self.time = [NSString stringWithFormat:@"%@%@",selectValue,@":00"];
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
    if (startTime.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择时间" controller:self sleep:1.5];
        return;
    }
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"companyId":companyId,@"agencyId":agencyId,@"startTime":startTime};
    NSString *url = [BASEURL stringByAppendingString:GET_authenticReport];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        NSString *hud = [responseObj objectForKey:@"msg"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            self.modelDic = [NSDictionary dictionary];
            self.modelDic = [responseObj objectForKey:@"model"];
            
            
           
            NSString *status = [responseObj objectForKey:@"status"];//0.认证公司、1.非认证公司（注：非认证公司没红包）
            
            if ([status isEqualToString:@"1"]) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"提交成功" controller:self sleep:1.5];
            }
            else
            {
                [self openRedPacketAction];
                [[PublicTool defaultTool] publicToolsHUDStr:hud controller:self.navigationController sleep:1.5];
            }
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
