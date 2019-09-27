//
//  STYRedResultController.m
//  iDecoration
//
//  Created by sty on 2018/3/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "STYRedResultController.h"

@interface STYRedResultController ()


@property (nonatomic, strong) UIButton *useBtn;
@end

@implementation STYRedResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"红包";
    self.view.backgroundColor = RGB(250, 233, 180);
    
    if (self.fromTag==0) {
        [self getData];
    }
    else{
        [self setUI];
    }
    
}

-(void)setUI{
    UIImageView *compLogoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.navigationController.navigationBar.bottom+15, 80, 80)];
    compLogoImgV.userInteractionEnabled = YES;
    compLogoImgV.layer.masksToBounds = YES;
    compLogoImgV.contentMode = UIViewContentModeScaleAspectFill;
    [compLogoImgV sd_setImageWithURL:[NSURL URLWithString:self.model.companyLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
    
    [self.view addSubview:compLogoImgV];
    
    UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(compLogoImgV.right+5, compLogoImgV.bottom-30, kSCREEN_WIDTH-compLogoImgV.right-5-5, 20)];
    companyName.text = [NSString stringWithFormat:@"%@的红包",self.model.companyName];
    companyName.textColor = COLOR_BLACK_CLASS_3;
    companyName.font = NB_FONTSEIZ_NOR;
    companyName.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:companyName];
    
    UIImageView *bigRedImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, compLogoImgV.bottom+10, kSCREEN_WIDTH-30, 300)];
    
    bigRedImgV.image = [UIImage imageNamed:@"redpacket_bg_Two"];
    [bigRedImgV sizeToFit];
    
    CGFloat ww = kSCREEN_WIDTH-15*2;
    CGFloat height = ww*bigRedImgV.height/bigRedImgV.width;
    
    bigRedImgV.frame = CGRectMake(15, compLogoImgV.bottom+10, ww, height);
    
    [self.view addSubview:bigRedImgV];
    
    
    UILabel *typeNameL = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, bigRedImgV.width-15*2, 40)];
    if ([self.model.type integerValue]!=2) {
        typeNameL.text = @"代金券";
    }
    else{
        typeNameL.text = @"礼品券";
    }
    
    typeNameL.textColor = Yellow_Color;
    typeNameL.font = [UIFont boldSystemFontOfSize:35];
    typeNameL.textAlignment = NSTextAlignmentCenter;
    [bigRedImgV addSubview:typeNameL];
    
    if ([self.model.type integerValue]!=2) {
        //代金券
        UIImageView *centenImgV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 30, 30)];
        centenImgV.image = [UIImage imageNamed:@"red_square"];
        [centenImgV sizeToFit];
        
        CGFloat ww = bigRedImgV.width-20*2;
        CGFloat height = ww*centenImgV.height/centenImgV.width;
        centenImgV.frame = CGRectMake(20, bigRedImgV.height/2-height/2, ww, height);
        [bigRedImgV addSubview:centenImgV];
        
        UILabel *priceL = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, centenImgV.width-15*2, centenImgV.height-15*2)];
        priceL.textColor = COLOR_BLACK_CLASS_3;
        priceL.textAlignment = NSTextAlignmentCenter;
        [centenImgV addSubview:priceL];
        
        NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:self.model.money?self.model.money:@"0" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30], NSForegroundColorAttributeName: [UIColor blackColor]} ];
        
        NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:@"元代金券" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor blackColor]} ];
        [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
        priceL.attributedText = tempAttrStringOne;
        
    }
    else{
        CGFloat ww = bigRedImgV.width/8*3;
        UIImageView *centenImgV = [[UIImageView alloc]initWithFrame:CGRectMake(bigRedImgV.width/2-ww/2, bigRedImgV.height/2-ww/2, ww, ww)];
        centenImgV.userInteractionEnabled = Yellow_Color;
        centenImgV.layer.masksToBounds = Yellow_Color;
        centenImgV.contentMode = UIViewContentModeScaleAspectFill;
        [centenImgV sd_setImageWithURL:[NSURL URLWithString:self.model.faceImg] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        [bigRedImgV addSubview:centenImgV];
        
        UILabel *giftNameL = [[UILabel alloc]initWithFrame:CGRectMake(15, centenImgV.top-20-10, bigRedImgV.width-30, 20)];
        giftNameL.textColor = White_Color;
        giftNameL.font = [UIFont boldSystemFontOfSize:18];
        giftNameL.textAlignment = NSTextAlignmentCenter;
        giftNameL.text = [NSString stringWithFormat:@"小礼品：%@",self.model.giftName];
        [bigRedImgV addSubview:giftNameL];
    }
    CGFloat btnww = bigRedImgV.width/8*3+20;
    UIButton *useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    useBtn.frame = CGRectMake(kSCREEN_WIDTH/2-btnww/2,bigRedImgV.bottom-50-40,btnww,50);
    useBtn.backgroundColor = Yellow_Color;
    [useBtn setTitle:@"马 上 使 用" forState:UIControlStateNormal];
    useBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [useBtn setTitleColor:Red_Color forState:UIControlStateNormal];
    useBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    
    useBtn.layer.masksToBounds = YES;
    useBtn.layer.cornerRadius = 5;
    self.useBtn = useBtn;
    [self.useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.useBtn];
    
}

-(void)useBtnClick:(UIButton *)btn{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcouponcustomer/use.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"couponId":self.model.couponId,
                               @"companyId":self.model.companyId,
                               @"ccId":self.model.ccId,
                               @"receiveCode":self.model.receiveCode
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"使用成功" controller:self sleep:1.5];
                self.useBtn.userInteractionEnabled = NO;
                self.useBtn.backgroundColor = Gray_Color;
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"不是公司内部人员" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"券不存在" controller:self sleep:1.5];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已使用" controller:self sleep:1.5];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"更新数据出错" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

-(void)getData{
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [self.code stringByAppendingString:[NSString stringWithFormat:@"?agencyId=%@&isApp=1",@(user.agencyId)]];

    
    [[UIApplication sharedApplication].keyWindow hudShow];
//    NSDictionary *paramDic = @{@"unionLogo":self.photoUrl, @"unionPwd":self.unionPasswordText.text,
//                               @"unionNumber":self.unionNumberText.text,
//                               @"companyId":@(self.companyId),
//                               @"agencysId":@(user.agencyId),
//                               @"unionName":self.unionNameText.text
//                               };
    [NetManager afPostRequest:defaultApi parms:nil finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                self.model = [ZCHCouponModel yy_modelWithJSON:responseObj[@"data"][@"couponInfo"]];
                [self setUI];
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"不是公司内部人员" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"兑换码错误" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
