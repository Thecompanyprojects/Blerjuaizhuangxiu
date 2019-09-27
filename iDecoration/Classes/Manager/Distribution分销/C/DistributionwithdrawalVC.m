//
//  DistributionwithdrawalVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionwithdrawalVC.h"
#import "DistributionwithdrawalCell0.h"
#import "DistributionbindingCell0.h"
#import "DistributionwithdrawalCell1.h"


@interface DistributionwithdrawalVC ()<UITableViewDataSource,UITableViewDelegate,distriVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,strong) UILabel *bottomLab;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;

@property (nonatomic,copy) NSString *accountName0;//支付宝账号
@property (nonatomic,copy) NSString *accountName1;//微信账号
@end

static NSString *Distributionwithdrawalidentfid0 = @"Distributionwithdrawalidentfid0";
static NSString *Distributionwithdrawalidentfid1 = @"Distributionwithdrawalidentfid1";
static NSString *Distributionwithdrawalidentfid2 = @"Distributionwithdrawalidentfid2";


@implementation DistributionwithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    self.tag = @"0";
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    [self.view addSubview:self.bottomLab];
    [self setupUI];
    [self loaddata];
    if ([self.type isEqualToString:@"0"]) {
        [self.submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
     if ([self.type isEqualToString:@"1"])
    {
        [self.submitBtn addTarget:self action:@selector(mywallectclick) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([self.type isEqualToString:@"2"]) {
         [self.submitBtn addTarget:self action:@selector(redsubmitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                    self.accountName0 = accountName;
                    self.trueName = [dic objectForKey:@"trueName"];
                }
                if ([accountType isEqualToString:@"1"]) {
                    //微信账号信息
                    NSString *accountName = [dic objectForKey:@"accountName"];
                    self.accountName1 = accountName;
                }
            }
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
        DistributionwithdrawalCell0 *cell = [tableView dequeueReusableCellWithIdentifier:Distributionwithdrawalidentfid0];
        if (!cell) {
            cell = [[DistributionwithdrawalCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Distributionwithdrawalidentfid0];
        }
        [cell setdata:self.userName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        DistributionbindingCell0 *cell = [tableView dequeueReusableCellWithIdentifier:Distributionwithdrawalidentfid1];
        if (!cell) {
            cell = [[DistributionbindingCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Distributionwithdrawalidentfid1];
        }
        if ([self.tag isEqualToString:@"0"]) {
            cell.contentLab.text = @"提现方式:支付宝";
        }
        if ([self.tag isEqualToString:@"1"]) {
            cell.contentLab.text = @"提现方式:微信";
        }
        if ([self.tag isEqualToString:@"2"]) {
            cell.contentLab.text = @"提现方式:银行卡";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row==2) {
        DistributionwithdrawalCell1 *cell = [tableView dequeueReusableCellWithIdentifier:Distributionwithdrawalidentfid2];
        if (!cell) {
            cell = [[DistributionwithdrawalCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Distributionwithdrawalidentfid2];
        }
        [cell setdata:self.accountTotal];
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


    //0.不是分销员,1.审核通过(分销员),2.被拒绝,3.审核中,4.对接人
    
    UITextField *textfiled = [self.table viewWithTag:201];
    NSString *total = textfiled.text;
    int totlaint = [total intValue];
    if (totlaint < 1) {

        [[PublicTool defaultTool] publicToolsHUDStr:@"提现金额最少1元" controller:self sleep:1.5];
        return;
    }
    else
    {
        NSString *trueName = self.trueName;
        NSString *accountType = [NSString new];
        NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
        NSString *accountName = [NSString new];
        if ([self.tag isEqualToString:@"0"]) {
            accountType = @"0";
            accountName = self.accountName0;
            
            if (IsNilString(self.accountName0)) {
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"您没有绑定账号，请前去绑定账号" controller:self sleep:1.5];
                
                return;
            }
            
        }
        else
        {
            accountType = @"1";
            accountName = self.accountName1;
            accountName = @"微信号";
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
            return;
        }
        
        float totalfl = [total floatValue];
        if (totalfl<1) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"提现金额最少1元" controller:self sleep:1.5];
            return;
        }
        
        NSString *key = ZHIFU_KEY;

        NSDictionary *dict = @{@"trueName":trueName,@"accountType":accountType,@"agencyId":agencyId,@"accountName":accountName,@"total":total,@"token":self.token};
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
        //signString用于签名的原始参数集合
        NSString *signString = [signArray componentsJoinedByString:@"&"];
        NSLog(@"signString:%@",signString);
        NSString *newSignString = [NSString stringWithFormat:@"%@%@%@",signString,@"&key=",key];
        NSString *sign = [newSignString md532BitUpper];

        
        NSDictionary *para = @{@"trueName":trueName,@"accountType":accountType,@"agencyId":agencyId,@"accountName":accountName,@"total":total,@"sign":sign,@"token":self.token};
        NSString *url = [BASEURL stringByAppendingString:POST_moneytoMyWallet];
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"申请提现成功，请耐心等待" controller:self sleep:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if ([[responseObj objectForKey:@"code"] intValue]==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"失败" controller:self sleep:1.0];
            }
            if ([[responseObj objectForKey:@"code"] intValue]==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"提现金额大于你的账户总额" controller:self sleep:1.0];
            }
            if ([[responseObj objectForKey:@"code"] intValue]==1003) {

                NSString *msg = [responseObj objectForKey:@"msg"];
                [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self.navigationController sleep:1.5];
                

                
            }
            if ([[responseObj objectForKey:@"code"] intValue]==1005) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"提现失败" controller:self sleep:1.5];
            }
            if ([[responseObj objectForKey:@"code"] intValue]==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"出错" controller:self sleep:1.0];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }

}

-(void)mywallectclick
{
    NSString *money = self.accountTotal;
    NSString *transferType = [NSString new];
    if ([self.tag isEqualToString:@"0"]) {
        transferType = @"0";
    }
    if ([self.tag isEqualToString:@"1"]) {
        transferType = @"1";
    }
    NSString* agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    
    UITextField *textfiled = [self.table viewWithTag:201];
    NSString *total = textfiled.text;
    
    NSString *key = ZHIFU_KEY;
    
    NSDictionary *dict =@{@"money":total,@"transferType":transferType,@"agencysId":agencysId,@"token":self.token};
    
    
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
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@"&"];
    NSLog(@"signString:%@",signString);
    NSString *newSignString = [NSString stringWithFormat:@"%@%@%@",signString,@"&key=",key];
    NSString *sign = [newSignString md532BitUpper];
    
    NSDictionary *para = @{@"money":total,@"transferType":transferType,@"agencysId":agencysId,@"token":self.token,@"sign":sign};
    NSString *url = [BASEURL stringByAppendingString:POST_GRENTIXIAN];
    
    if (IsNilString(total)) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入提现金额" controller:self sleep:1.5];
        return;
    }
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        NSString *msg = [responseObj objectForKey:@"msg"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {

            
            float money0 = [money intValue];
            float money1 = [total intValue];
            
            float money = money0-money1;
            
            self.accountTotal = [NSString stringWithFormat:@"%.2f",money];
            
        
           
            
        }
        [self.table reloadData];
        
        //创建通知对象
        NSNotification *notification = [NSNotification notificationWithName:@"qianbaotixian" object:self.accountTotal];
        //Name是通知的名称 object是通知的发布者(是谁要发布通知,也就是对象) userInfo是一些额外的信息(通知发布者传递给通知接收者的信息内容，字典格式)
        //    [NSNotification notificationWithName:@"tongzhi" object:nil userInfo:nil];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self.navigationController sleep:1.5];
        
        [self.navigationController popViewControllerAnimated:YES];
       
    } failed:^(NSString *errorMsg) {
        
    }];
    
}


/**
 红包提现
 */
-(void)redsubmitbtnclick
{
    NSString *url = [BASEURL stringByAppendingString:GET_getRedPacketCashMoney];
    UITextField *textfiled = [self.table viewWithTag:201];
    NSString *total = textfiled.text;
    NSString *key = ZHIFU_KEY;
    int totlaint = [total intValue];
    if (totlaint < 1) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"提现金额最少1元" controller:self sleep:1.5];
        return;
    }
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    
    NSDictionary *dict =@{@"money":total,@"accountType":@"0",@"agencyId":agencyId,@"token":self.token};
    
    
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
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@"&"];
    NSLog(@"signString:%@",signString);
    NSString *newSignString = [NSString stringWithFormat:@"%@%@%@",signString,@"&key=",key];
    NSString *sign = [newSignString md532BitUpper];
    
    NSDictionary *para = @{@"money":total,@"accountType":@"0",@"agencyId":agencyId,@"token":self.token,@"sign":sign};
    
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        NSString *msg = [responseObj objectForKey:@"msg"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self.navigationController sleep:1.0];
            //[self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.0];
        }
        
        //创建通知对象
        NSNotification *notification = [NSNotification notificationWithName:@"fenxiaohongbaotixian" object:self.accountTotal];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
