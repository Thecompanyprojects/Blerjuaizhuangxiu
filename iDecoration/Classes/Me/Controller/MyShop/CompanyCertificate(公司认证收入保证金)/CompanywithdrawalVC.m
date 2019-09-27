//
//  CompanywithdrawalVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CompanywithdrawalVC.h"
#import "DistributionwithdrawalCell0.h"
#import "DistributionbindingCell0.h"
#import "DistributionwithdrawalCell1.h"

@interface CompanywithdrawalVC ()<UITableViewDataSource,UITableViewDelegate,distriVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,strong) UILabel *bottomLab;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;

@property (nonatomic,copy) NSString *accountName0;//支付宝账号
@property (nonatomic,copy) NSString *accountName1;//微信账号

@property (nonatomic,copy) NSString *trueName;

@end

static NSString *Companywithdrawalidentfid0 = @"Companywithdrawalidentfid0";
static NSString *Companywithdrawalidentfid1 = @"Companywithdrawalidentfid1";
static NSString *Companywithdrawalidentfid2 = @"Companywithdrawalidentfid2";

@implementation CompanywithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    self.tag = @"0";
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    [self.view addSubview:self.bottomLab];
    [self setupUI];
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    self.trueName = model.trueName;
    [self loaddata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    if ([self.type isEqualToString:@"0"]) {
        
        NSString *url = [BASEURL stringByAppendingString:POST_companymoney];
        NSDictionary *para = @{@"companyId":self.companyId};
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                id data = [responseObj objectForKey:@"data"];
                id companyMoney = [data objectForKey:@"companyMoney"];
                NSString *companyActivityBond = [companyMoney objectForKey:@"companyActivityBond"];
                NSString *frozenActivityMoney = [companyMoney objectForKey:@"frozenActivityMoney"];
                
                float money0 = [companyActivityBond floatValue];
                float money1 = [frozenActivityMoney floatValue];
                float moneyfl = money0-money1;
                self.moneyStr = [NSString stringWithFormat:@"%.2f",moneyfl];
                [self.table reloadData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }
}

-(void)setupUI
{
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(20);
    }];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

-(UILabel *)bottomLab
{
    if(!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.font = [UIFont systemFontOfSize:12];
        _bottomLab.textColor = [UIColor hexStringToColor:@"CFCFCF"];
        _bottomLab.text = @"北京比邻而居科技有限公司支持";
    }
    return _bottomLab;
}


-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 120);
        [_footView addSubview:self.submitBtn];
    }
    return _footView;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.frame = CGRectMake(kSCREEN_WIDTH/2-150, 40, 300, 44);
        _submitBtn.backgroundColor = [UIColor hexStringToColor:@"24B764"];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 5;
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_submitBtn setTitle:@"确认提现" forState:normal];
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        DistributionwithdrawalCell0 *cell = [tableView dequeueReusableCellWithIdentifier:Companywithdrawalidentfid0];
        if (!cell) {
            cell = [[DistributionwithdrawalCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Companywithdrawalidentfid0];
        }
        [cell setdata:self.trueName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        DistributionbindingCell0 *cell = [tableView dequeueReusableCellWithIdentifier:Companywithdrawalidentfid1];
        if (!cell) {
            cell = [[DistributionbindingCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Companywithdrawalidentfid1];
        }
        if ([self.tag isEqualToString:@"0"]) {
            cell.contentLab.text = @"提现方式:支付宝";
        }
        if ([self.tag isEqualToString:@"1"]) {
            cell.contentLab.text = @"提现方式:微信";
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row==2) {
        DistributionwithdrawalCell1 *cell = [tableView dequeueReusableCellWithIdentifier:Companywithdrawalidentfid2];
        if (!cell) {
            cell = [[DistributionwithdrawalCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Companywithdrawalidentfid2];
        }
        [cell setdata:self.moneyStr];
        cell.moneyText.tag = 201;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 60.0f;
    }
    if (indexPath.row==1) {
        return 90*HEIGHT_SCALE;
    }
    if (indexPath.row==2) {
        return 120;
    }
    return 0.01f;
}

-(void)myTabVClick:(UITableViewCell *)cell andtagstr:(NSString *)str
{
    self.tag = str;
    [self.table reloadData];
}

-(void)submitbtnclick
{
    if (self.moneyStr.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"可提现金额不足" controller:self sleep:1.5];
        return;
    }
    
    NSString *url = [BASEURL stringByAppendingString:POST_companytixian];
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *transferType = [NSString new];
    if ([self.tag isEqualToString:@"0"]) {
        transferType = @"0";
    }
    else
    {
        transferType = @"1";
        [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
        return;
    }
    UITextField *text1 = [self.table viewWithTag:201];
    NSString *money = text1.text;
    if (IsNilString(money)) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入提现金额" controller:self sleep:1.5];
        return;
    }
    
    NSDictionary *dict = @{@"companyId":self.companyId,@"money":money,@"type":self.type,@"transferType":transferType,@"agencysId":agencyId,@"token":self.token};
    
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",afterSortKeyArray[i],valueArray[i]];
        [signArray addObject:keyValue];
    }
    NSString *key = ZHIFU_KEY;
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@"&"];
    NSLog(@"signString:%@",signString);
    NSString *newSignString = [NSString stringWithFormat:@"%@%@%@",signString,@"&key=",key];
    NSString *sign = [newSignString md532BitUpper];
    
    NSDictionary *para = @{@"companyId":self.companyId,@"money":money,@"type":self.type,@"transferType":transferType,@"agencysId":agencyId,@"sign":sign,@"token":self.token};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
//        1001:参数错误，1003：没有提现权限，1002：可提现金额不足，1004：没有绑定提现账号，1005：提现失败1007：提现状态不明确，请重新查询
        
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self.navigationController sleep:1.0];
        }
        else
        {
            NSString *msg = [responseObj objectForKey:@"msg"];
            [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self.navigationController sleep:1.5];
        }
        
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
        
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

@end
