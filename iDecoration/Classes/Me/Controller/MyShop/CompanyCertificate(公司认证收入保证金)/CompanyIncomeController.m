//
//  CompanyIncomeController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CompanyIncomeController.h"
#import "SureIncomeController.h"
#import "CompanyIncomeModel.h"
#import "companybindingVC.h"

@interface CompanyIncomeController ()
@property (weak, nonatomic) IBOutlet UILabel *nomeyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopCon;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (nonatomic,copy) NSString *token;
@end

@implementation CompanyIncomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司收入";
    self.topViewTopCon.constant = self.navigationController.navigationBar.bottom + 5;
    [self getData];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"绑定账户" style:UIBarButtonItemStylePlain target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)clickEvent
{
    companybindingVC * vc = [companybindingVC new];
    vc.companyId = self.companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sureMoneyAction:(id)sender {
    SureIncomeController *vc = [[SureIncomeController alloc ] initWithNibName:@"SureIncomeController" bundle:nil];
    vc.type = MoneyTypeSure;
    vc.companyId = self.companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData {
    NSString *defaultAPi = [BASEURL stringByAppendingString:@"income/getSRLIst.do"];
    NSDictionary *paramDic = @{
                               @"companyId": self.companyId,
                               @"page": @(1)
                               };
    [NetManager afGetRequest:defaultAPi parms:paramDic finished:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1000) {
            NSArray *dataList = [responseObj[@"data"] objectForKey:@"list"];
            NSArray *dataArray = [NSArray yy_modelArrayWithClass:[CompanyIncomeModel class] json:dataList];
            CompanyIncomeModel *model = dataArray.firstObject;
            self.nomeyLabel.text = [NSString stringWithFormat:@"￥%@",model.withdrawalsYes];
            self.token = [responseObj objectForKey:@"token"];
        }
        if ([responseObj[@"code"] integerValue] == 1002) {
            self.nomeyLabel.text = @"￥0.00";
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)buildUI {
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_one_gongsishouru"]];
    [self.view addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationController.navigationBar.mas_bottom).equalTo(5);
        make.left.equalTo(14);
        make.right.equalTo(-14);
        make.height.equalTo(60);
    }];
    
    UILabel *moneyNameLabel = [UILabel new];
    [topImageView addSubview:moneyNameLabel];
    [moneyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(25);
    }];
    moneyNameLabel.font = [UIFont systemFontOfSize:17];
    moneyNameLabel.text = @"总金额";
    moneyNameLabel.textColor = kCustomColor(255, 53, 51);
    
    UILabel *moneyLabel = [UILabel new];
//    self.moneyLabel = moneyLabel;
    [topImageView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(-25);
    }];
    moneyLabel.font = [UIFont systemFontOfSize:17];
    moneyLabel.text = @"￥8888.88";
    moneyLabel.textColor = kCustomColor(255, 53, 51);
    
    
    UIImageView *bottomIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_one_querenjiaqian"]];
    [self.view addSubview:bottomIV];
    [bottomIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom).equalTo(18);
        make.left.equalTo(14);
        make.right.equalTo(-14);
        make.height.equalTo(118);
    }];
}


@end
