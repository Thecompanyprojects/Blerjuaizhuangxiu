//
//  ConstructsDetailViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ConstructsDetailViewController.h"

@interface ConstructsDetailViewController ()

@property (nonatomic, strong) NSMutableArray *phoneArray;

@end

@implementation ConstructsDetailViewController

-(NSMutableArray*)phoneArray{
    
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray array];
    }
    return _phoneArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getData];
    [self createUI];
}


// 该页面数据使用的是喊装修列表中的数据，没有使用到喊装修详情的数据（喊装修列表跳转传的model已满足数据需求-- 之前人写好的）， 此处做详情请求处理是为了根据消息详情请求数据是未读消息变为已读数据
- (void)getData {
    [self.view hudShow];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"hanzhuangxiu/getHanWo.do"];
    NSInteger hanId = self.hanModel.hanId;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(hanId) forKeyedSubscript:@"id"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
           [self.view hiddleHud];
            
        } else {
            [self.view hiddleHud];
            [self.view showHudFailed:@"没有内容"];
            
        }
        
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [self.view hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
    }];
    
    
}

-(void)createUI{
    
    self.title = @"订单详情";
    
    self.view.backgroundColor = Bottom_Color;
    
    [self getInfoFromModel:self.hanModel];
}

-(void)getInfoFromModel:(HanZXModel*)model{
    
    self.houseHoldNameLabel.text = model.name;
    self.remarkLabel.text = [NSString stringWithFormat:@"%@ 需要装修服务，请您在合适的时间尽快联系他",model.name];
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"电话：%@ %@",model.phone,model.elephone];
    self.styleLabel.text = [NSString stringWithFormat:@"装修房屋类型：%@",model.houseType];
    self.areaLabel.text = [NSString stringWithFormat:@"房屋建筑面积：%@平米",model.areaHouse];
    self.budgetLabel.text = [NSString stringWithFormat:@"不包括家具家电预算：%@",model.pay];
    self.timeLabel.text = [NSString stringWithFormat:@"准备装修时间：%@",model.houseDate];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",model.dingdate];
    
    if (model.phone.length != 0) {
        [self.phoneArray addObject:model.phone];
    }
    
    if (model.elephone.length != 0) {
        [self.phoneArray addObject:model.elephone];
    }
    
}

- (IBAction)contact:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨打电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i<self.phoneArray.count; i++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",self.phoneArray[i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArray[i]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
