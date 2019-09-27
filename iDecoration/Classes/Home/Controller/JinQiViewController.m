//
//  JinQiViewController.m
//  iDecoration
//
//  Created by john wall on 2018/9/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "JinQiViewController.h"
#import "AppDelegate.h"
#import "JinQiGiftTableViewCell.h"

#import "FlowersStoryViewController.h"
#import "LoginViewController.h"
#import "AppleIAPManager.h"
#import "SendFlowersModel.h"
#import "EditBannerViewController.h"
#import "SendFlowersViewController.h"
#import "NewMyPersonCardController.h"
#import "CompanyDetailViewController.h"
@interface JinQiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton * BigJinQiBtn;
@property(nonatomic,strong)UIButton * smallJinQi;
@property(nonatomic,strong)UIButton *aliPayBtn;
@property(nonatomic,strong)UIButton *weixinPayBtn;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)  NSInteger payType ;

@end

@implementation JinQiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title =@"购买锦旗";
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight*0.5) style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JinQiGiftTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JinQiGiftTableViewCell class])];
    
    UIView *view =[UIView new];
    view.frame =CGRectMake(0, BLEJHeight*0.7, BLEJWidth, 100);
    UIButton *iconBtn =[[UIButton alloc]init];
    iconBtn.backgroundColor=kMainThemeColor;
    
    [iconBtn setTitle:@"确定支付" forState:UIControlStateNormal];
    [iconBtn setTitle:@"正在跳转" forState:UIControlStateSelected];
    [iconBtn addTarget:self action:@selector(PayMoneyAction) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.layer.cornerRadius=10;
    iconBtn.layer.masksToBounds=YES;
    iconBtn.frame =CGRectMake(40, 25, BLEJWidth-80, 45);
   
    [view addSubview:iconBtn];
    [self.view addSubview:view];
    
    
    
            UIButton *iconIv =[[UIButton alloc]init];
            [self.view addSubview:iconIv];
            [iconIv setTitle:@"北京比邻而居有限公司提供技术支持"  forState:UIControlStateNormal];
           [iconIv setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
           [iconBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
            [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(self.view);
                make.top.mas_equalTo(self.view).offset(BLEJHeight-50);
    
            }];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayResult:) name:@"AlipayResult" object:nil];
    
    
  
}
#pragma mark 支付宝，微信的支付qing
-(void)ConfirmToPay{
    
    
    if (!self.aliPayBtn.selected && !self.weixinPayBtn.selected) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择支付方式"];
        return ;
    }
    UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
    
    
    NSDictionary *paramDic = @{
                               @"companyId": @(self.companyId.integerValue),
                               @"agencysId": @(model.agencyId),
                               @"money": self.payMoney,
                               @"payType": self.weixinPayBtn.selected ?@(1):@(0)
                               };
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/activityBond.do"];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                if (self.weixinPayBtn.selected) {
                    // 微信支付
                    NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"],
                                          @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"],
                                          @"noncestr" : responseObj[@"noncestr"], @"timestamp" :@([responseObj[@"timestamp"] intValue]),
                                          @"sign" : responseObj[@"sign"]};
                    
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
                }
                
                if (self.aliPayBtn.selected) {
                    NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
                }
            }
                break;
            case 1001: {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取信息失败， 参数错误！"];
            }
                break;
            case 1003: {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"金额错误， 请稍后再试！"];
            }
                break;
            case 1004: {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"公司未认证或认证过期"];
            }
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"获取信息失败， 请稍后再试！"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
    
}

#pragma mark - 微信支付回调结果
- (void)WXPayResult:(NSNotification *)noc {
    
    // 0: 支付成功  -1: 支付失败  -2: 支付取消  (其他的都是失败)
    if ([noc.object integerValue] == 0) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//
//            self.successBgView.hidden = NO;
//            if (self.successBlock) {
//                self.successBlock();
//            }
        });
        
    } else if ([noc.object integerValue] == -2) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付取消"];
    } else {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付失败"];
    }
}

#pragma mark - 支付宝支付回调结果
- (void)AlipayResult:(NSNotification *)noc {
    
    if ([noc.object[@"resultStatus"] integerValue] == 9000) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [self.navigationController popViewControllerAnimated:YES];
        
        });
        
        
    } else if ([noc.object[@"resultStatus"] integerValue] == 6001) {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付取消"];
    } else {
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window hudShowWithText:@"支付失败"];
    }
}


#pragma mark  UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0 ) {
        return 2;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.section ==0 ) {
        return 100;
    }else

    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.002;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 
      UIView *footer=   [[UIView alloc]init];
 
    return footer;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
      UIView *header=   [[UIView alloc]init];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
 
 
        JinQiGiftTableViewCell*cellJin= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JinQiGiftTableViewCell class]) forIndexPath:indexPath];
        
        cellJin.selectionStyle= UITableViewCellSeparatorStyleSingleLine;
        if (cellJin ==nil) {
                cellJin= [[[UINib nibWithNibName:@"JinQiGiftTableViewCell" bundle:nil]instantiateWithOwner:self options:nil]firstObject];
        }
        /* 字体选中按钮点击 */
        [cellJin.fuckBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
       
        if (indexPath.row ==0) {
     
           cellJin.labelMoney.text = @"¥18";
            cellJin.imageV.image=[UIImage imageNamed:@"bg_big_jinqi_one"];
        
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToJinQiEditVC)];
                [cellJin.imageV addGestureRecognizer:tap];
           
            cellJin.bottomLA =[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 40, 10) ];
            [cellJin.contentView addSubview:cellJin.bottomLA];
            cellJin.bottomLA.text =@"点击编辑";
            [cellJin.bottomLA setAdjustsFontSizeToFitWidth:YES];
            cellJin.fuckBtn.tag =1000;
            
            self.BigJinQiBtn =cellJin.fuckBtn;
            self.indexPathup =indexPath;
        }else if (indexPath.row ==1) {
            cellJin.labelMoney.text = @"¥8";
            cellJin.imageV.image=[UIImage imageNamed:@"bg_big_jinqi_two"];
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToJinQiEditVC)];
            [cellJin.imageV addGestureRecognizer:tap];
            cellJin.bottomLA =[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 40, 10) ];
            [cellJin.contentView addSubview:cellJin.bottomLA];
            cellJin.bottomLA.text =@"点击编辑";
            [cellJin.bottomLA setAdjustsFontSizeToFitWidth:YES];
            
            cellJin.fuckBtn.tag =2000;
                  self.smallJinQi =cellJin.fuckBtn;
            self.indexPathdown =indexPath;
        }
        
       
        
   
        return  cellJin;
    }
        
      
      
//        UIButton *iconH =[[UIButton alloc]init];
////        iconH.backgroundColor =kMainThemeColor;
//         [iconH addTarget:self action:@selector(ExpressionActionShow) forControlEvents:UIControlEventAllEvents];
//        [iconH setImage:[UIImage imageNamed:@"icon_jihuo"] forState:UIControlStateNormal];
//        [cellBottom addSubview:iconH];
//        [cellBottom setContentMode:UIViewContentModeScaleAspectFill];
//        [iconH mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(iconBtn.mas_bottom).offset(10);
//            make.left.mas_equalTo(iconBtn.mas_left);
//            make.height.mas_equalTo(30);
//            make.width.mas_equalTo(30);
//        }];
//
//        UILabel *iconLa =[[UILabel alloc]init];
//        iconLa.text=@"支付协议";
//        [cellBottom addSubview:iconLa];
//        [iconLa mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(iconBtn.mas_bottom).offset(10);
//            make.left.equalTo(iconH.mas_right).offset(15);
//            make.height.mas_equalTo(30);
//            make.width.mas_equalTo(100);
//        }];
       
    

    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)ExpressionActionShow{
    
    [[UIApplication sharedApplication].delegate.window  showHud:@"请观看说明书" andImg:nil];
}
-(void)ToJinQiEditVC{
    EditBannerViewController *edit=[EditBannerViewController new];
  
    if (self.agencyId) {
         edit.agencyId =self.agencyId;
    }else{
          edit.companyId =self.companyId;
    }
    
   
    edit.isSendToCompany =self.isSendFromCompany;
   
  
    [self.navigationController pushViewController:edit animated:YES];
    
}

    

- (void)buttonClick:(UIButton *)sender{
  //  sender.selected = !sender.selected;
    sender.selected =YES;
   JinQiGiftTableViewCell *jinqiCellup =  [self.tableView cellForRowAtIndexPath:self.indexPathup];
      JinQiGiftTableViewCell *jinqiCelldown =  [self.tableView cellForRowAtIndexPath:self.indexPathdown];
    if (sender.selected ==YES)     {
        //    [self.fuckBtn setSelected:YES];
       [sender setImage:[UIImage imageNamed:@"icon_duigou_jihuo"] forState:UIControlStateSelected];
        
          if (sender.tag ==1000 &&jinqiCelldown.fuckBtn.selected) {
             
              [jinqiCelldown.fuckBtn  setImage:nil forState:UIControlStateSelected];
              self.IsSelectedBigJinQi =NO;
          }
        if (sender.tag ==2000 &&jinqiCellup.fuckBtn.selected ){
            
            [jinqiCellup.fuckBtn  setImage:nil forState:UIControlStateSelected];
            self.IsSelectedBigJinQi =YES;
        }
        if (sender.tag == 1000) {
            self.IsSelectedBigJinQi=YES;
        }
        if (sender.tag ==2000) {
            self.IsSelectedBigJinQi=NO;
        }
            
        
    }else  {
        // [self.fuckBtn setSelected:NO];
      //  [sender setImage:nil forState:UIControlStateNormal];
//        if (sender.tag ==1000 &&jinqiCelldown.fuckBtn.selected) {
//            [jinqiCelldown.fuckBtn  setImage:nil forState:UIControlStateSelected];
//        }
//        }
       
    }
}

    







#pragma mark  支付相关
-(void)PayMoneyAction{
    
    if (!self.penentID) {
       // SHOWMESSAGE(@"请先编辑锦旗");
        [self finishiAction];
    }
    
    if (!self.BigJinQiBtn.selected && !self.smallJinQi.selected) {
         SHOWMESSAGE(@"请先选择价格");
        return;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"马上送给TA，您需要支付%d元费用", self.IsSelectedBigJinQi?18: 8]  preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"下次吧" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去购买" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return ;
        }
        MJWeakSelf;
        NSString *selectName =self.IsSelectedBigJinQi?@"大锦旗":@"小锦旗";
        [[AppleIAPManager sharedManager] buyFlowerWithIAP:selectName completion:^(NSString *orderId) {
            if (self.agencyId) {
                [weakSelf sendPersonBannerWithOrderID:orderId];
            }else{
                 [weakSelf sendcompanyBannerWithOrderID:orderId];
            }
           
            
        }];
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}


//    tradeNo    支付单号 integer
//    companyId  integer
//     type      类型（1：9.9,0:19.9） integer
//    agencyId   false string 当前用户Id
//    pennantId   false string 锦旗Id


//    1000：成功,1001:订单重复,2000:异常
//    http://testapi.bilinerju.com/api/applpay/companyPennant.do
//给公司送锦旗的
- (void)sendcompanyBannerWithOrderID:(NSString *)orderId {
    NSString *defaultApi = [BASEURL stringByAppendingString: @"applpay/companyPennant.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
   
    
    NSMutableDictionary *parameters =[NSMutableDictionary dictionary];
     [ parameters setObject:self.penentID ?:@"" forKey:@"pennantId"];
     [ parameters setObject: self.IsSelectedBigJinQi  ?@(0):@(1) forKey:@"type"];
     [ parameters setObject:@(userModel.agencyId) ?:@"" forKey:@"agencyId"];
     [ parameters setObject:orderId?:@"" forKey:@"tradeNo"];
    [ parameters setObject:self.companyId ?:@"" forKey:@"companyId"];
        


    
    
    
    [NetManager afPostRequest:defaultApi parms:parameters finished:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"code"] integerValue] == 1000) {
//           [[NSNotificationCenter defaultCenter] postNotificationName:@"kRealeaseToRefreshData" object:nil];
           SHOWMESSAGE(@"成功支付")
            if (self.completionBlock) {
                self.completionBlock(@"1");
            }
            CompanyDetailViewController *company =[CompanyDetailViewController new];
            company.companyID =self.companyId;
           
            [self.navigationController   popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

        }else
            SHOWMESSAGE(@"与服务器连接失败请重试")
            } failed:^(NSString *errorMsg) {
                SHOWMESSAGE(errorMsg)
            }];
}
//给个人送锦旗，
- (void)sendPersonBannerWithOrderID:(NSString *)orderId {
    NSString *defaultApi = [BASEURL stringByAppendingString: @"applpay/pennant.do"];
                            

    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    
    NSMutableDictionary *parameters =[NSMutableDictionary dictionary];
    [ parameters setObject:self.penentID ?:@"" forKey:@"pennantId"];
    [ parameters setObject: self.IsSelectedBigJinQi  ?@(0):@(1) forKey:@"type"];
    [ parameters setObject:@(userModel.agencyId) ?:@"" forKey:@"agencyId"];
    [ parameters setObject:orderId?:@"" forKey:@"tradeNo"];
    [ parameters setObject:self.agencyId ?:@"" forKey:@"personId"];
    
    
    
    
    [NetManager afPostRequest:defaultApi parms:parameters finished:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"code"] integerValue] == 1000) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRealeaseToRefreshData" object:nil];
            SHOWMESSAGE(@"成功支付")
            //refreshData
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRealeaseToRefreshNewPerson" object:nil];
         
          
//            if (self.completionBlock) {
//                self.completionBlock(@"1");
//            }
         

            
        }else
            SHOWMESSAGE(@"与服务器连接失败请重试")
            } failed:^(NSString *errorMsg) {
                SHOWMESSAGE(errorMsg)
            }];
}







//如果没有编辑给默认的额
- (void)finishiAction {
    //    if (![self showAction]) {
    //        return;
    //    }
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"pennant/save.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    // 参数的type：解释
    /*
     大锦旗：1000 ~ 1005 六个
     小锦旗： 2000 ~
     */
    NSMutableDictionary *paramDic =[NSMutableDictionary dictionary];
    NSInteger bannerType = 1000 + 3;
    [paramDic setObject:@(userModel.agencyId) forKey:@"agencyId"];
    [paramDic setObject:self.agencyId?:@(0) forKey:@"personId"];
    [paramDic setObject:@(bannerType) forKey:@"type"];
    [paramDic setObject:@(userModel.agencyId) forKey:@"signName"];
      [paramDic  setObject:@""forKey:@"receName"];
    [paramDic  setObject:  @"留言内容" forKey:@"story"];
    [paramDic  setObject:@"故事内容" forKey:@"leaveWord"];
     [paramDic setObject:@"工艺精湛  服务一流" forKey:@"content"];
     [paramDic  setObject:@(0) forKey: @"id"];
     [paramDic  setObject:self.companyId ?:@(0) forKey:@"companyId"];
     [paramDic  setObject:self.agencyId?@(0):@(1) forKey: @"receiveType"];
    
    
  
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1000) {
            self.penentID = [NSString stringWithFormat:@"%d", [responseObj[@"data"][@"pennantId"] integerValue]];
            
//            JinQiViewController *jinqi =[[JinQiViewController alloc]init];
//            if (self.isSendToCompany) {
//                jinqi.companyId =self.companyId;
//            }else{
//                jinqi.agencyId=self.agencyId;
//            }
//            jinqi.penentID =self.bannerID;
//            [self.navigationController pushViewController:jinqi animated:YES];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
    
}
@end
