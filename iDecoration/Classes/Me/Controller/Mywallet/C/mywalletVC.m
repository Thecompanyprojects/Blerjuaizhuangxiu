//
//  mywalletVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "mywalletVC.h"
#import "wallentmingxiVC.h"
#import "DistributionwithdrawalVC.h"
#import <UIButton+LXMImagePosition.h>
#import "wallentinstructionsVC.h"
#import "DistributionbindingVC.h"

@interface mywalletVC ()
@property (nonatomic,strong) UIImageView *moneyImg;
@property (nonatomic,strong) UILabel *moneyLab;
@property (nonatomic,strong) UIButton *tixianBtn;
@property (nonatomic,strong) UIButton *mingxiBtn;
@property (nonatomic,strong) UIButton *instructionsBtn;
@property (nonatomic,strong) UIImageView *yuanimg;
@property (nonatomic,copy) NSString *rewardkyMoney;//可提现金额
@property (nonatomic,copy) NSString *token;
@end

@implementation mywalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的钱包";
    [self.view addSubview:self.moneyImg];
    [self.view addSubview:self.moneyLab];
    [self.view addSubview:self.tixianBtn];
    [self.view addSubview:self.mingxiBtn];
    [self.view addSubview:self.instructionsBtn];
    [self.view addSubview:self.yuanimg];
    [self setupUI];
    self.rewardkyMoney = @"0.00";
    self.token = [NSString new];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"绑定账户" style:UIBarButtonItemStylePlain target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"¥",self.rewardkyMoney];
    [self loadNewData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"qianbaotixian" object:nil];
}

-(void)notice:(id)sender{
    NSLog(@"%@",sender);
    //NSString *str = [sender object];
    
    [self loadNewData];
}

-(void)loadNewData
{
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *page = @"1";
  
    NSString *url = [BASEURL stringByAppendingString:POST_CHAXUNDASHANG];
    NSDictionary *para = @{@"page":page,@"type":@"0",@"agencysId":agencysId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            id data = [responseObj objectForKey:@"data"];
            NSArray *list = [data objectForKey:@"list"];
            if (list.count!=0) {
                NSDictionary *dic = [list firstObject];
                self.rewardkyMoney = [dic objectForKey:@"rewardkyMoney"];
                self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"¥",self.rewardkyMoney];
            }
            self.token = [responseObj objectForKey:@"token"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickEvent
{
    DistributionbindingVC *vc = [DistributionbindingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupUI
{
    [self.moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(112);
        make.width.mas_offset(103);
        make.height.mas_offset(103);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.top.equalTo(self.moneyImg.mas_bottom).with.offset(14);
        make.height.mas_offset(45);
    }];
    [self.tixianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(38);
        make.centerX.equalTo(self.view);
        make.height.mas_offset(43);
        make.top.equalTo(self.moneyLab.mas_bottom).with.offset(20);
    }];
    [self.mingxiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(38);
        make.centerX.equalTo(self.view);
        make.height.mas_offset(43);
        make.top.equalTo(self.tixianBtn.mas_bottom).with.offset(20);
    }];

    [self.instructionsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mingxiBtn);
        make.top.equalTo(self.mingxiBtn.mas_bottom).with.offset(15);
        make.height.mas_offset(16);
        make.width.mas_offset(90);
    }];
    [self.yuanimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.instructionsBtn.mas_left);
        make.centerY.equalTo(self.instructionsBtn);
        make.width.mas_offset(12);
        make.height.mas_offset(12);
    }];
}

#pragma mark - getters


-(UIImageView *)moneyImg
{
    if(!_moneyImg)
    {
        _moneyImg = [[UIImageView alloc] init];
        _moneyImg.image = [UIImage imageNamed:@"qian"];
    }
    return _moneyImg;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.font = [UIFont systemFontOfSize:39];
        _moneyLab.textColor = [UIColor hexStringToColor:@"282828"];
    }
    return _moneyLab;
}

-(UIButton *)tixianBtn
{
    if(!_tixianBtn)
    {
        _tixianBtn = [[UIButton alloc] init];
        _tixianBtn.backgroundColor = [UIColor hexStringToColor:@"38CF7A"];
        _tixianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tixianBtn setTitle:@"提现" forState:normal];
        [_tixianBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        [_tixianBtn addTarget:self action:@selector(tixianBtnclick) forControlEvents:UIControlEventTouchUpInside];
        _tixianBtn.layer.masksToBounds = YES;
        _tixianBtn.layer.borderWidth = 0.6;
        _tixianBtn.layer.cornerRadius = 5;
        _tixianBtn.layer.borderColor = [UIColor hexStringToColor:@"FFFFFF"].CGColor;
    }
    return _tixianBtn;
}

-(UIButton *)mingxiBtn
{
    if(!_mingxiBtn)
    {
        _mingxiBtn = [[UIButton alloc] init];
        _mingxiBtn.backgroundColor = [UIColor hexStringToColor:@"F7F7F7"];
        [_mingxiBtn setTitleColor:[UIColor hexStringToColor:@"1E1E1E"] forState:normal];
        [_mingxiBtn setTitle:@"零钱明细" forState:normal];
        _mingxiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_mingxiBtn addTarget:self action:@selector(mingxiBtnclick) forControlEvents:UIControlEventTouchUpInside];
        _mingxiBtn.layer.masksToBounds = YES;
        _mingxiBtn.layer.borderWidth = 0.6;
        _mingxiBtn.layer.cornerRadius = 5;
        _mingxiBtn.layer.borderColor = [UIColor hexStringToColor:@"F7F7F7"].CGColor;
    }
    return _mingxiBtn;
}


-(UIButton *)instructionsBtn
{
    if(!_instructionsBtn)
    {
        _instructionsBtn = [[UIButton alloc] init];
        [_instructionsBtn setTitle:@"我的钱包说明" forState:normal];
        [_instructionsBtn addTarget:self action:@selector(instructionsBtnclick) forControlEvents:UIControlEventTouchUpInside];
        _instructionsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_instructionsBtn setTitleColor:[UIColor hexStringToColor:@"FAC089"] forState:normal];
        _instructionsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _instructionsBtn;
}

-(UIImageView *)yuanimg
{
    if(!_yuanimg)
    {
        _yuanimg = [[UIImageView alloc] init];
        _yuanimg.image = [UIImage imageNamed:@"gantan"];
    }
    return _yuanimg;
}

#pragma mark - 实现方法

-(void)tixianBtnclick
{
    DistributionwithdrawalVC *vc = [DistributionwithdrawalVC new];
    vc.type = @"1";
    vc.accountTotal = self.rewardkyMoney;
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    vc.userName = model.trueName;
    vc.token = self.token;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mingxiBtnclick
{
    wallentmingxiVC *vc = [wallentmingxiVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)instructionsBtnclick
{
    wallentinstructionsVC *vc = [wallentinstructionsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"qianbaotixian" object:nil];
}

@end
