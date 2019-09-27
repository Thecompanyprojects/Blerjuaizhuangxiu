//
//  ZCHCooperateController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/10/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCooperateController.h"
#import "BLEJBudgetGuideController.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "DecorateNeedViewController.h"
#import "ZCHCooperateListModel.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "VIPExperienceShowViewController.h"

@interface ZCHCooperateController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UILabel *companyName;

// 案例
@property (nonatomic, strong) UILabel *constructionLabel;
@property (nonatomic, strong) UILabel *constructionNumLabel;
// 施工中
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) UILabel *dispalyNumLabel;
// 商品
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *numLabel3;
// 展现量
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *numLabel4;


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSMutableArray *cooperateArr;
@property (strong, nonatomic) UITableViewCell *cooperateCell;
@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@end

@implementation ZCHCooperateController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"合作企业";
    
    self.cooperateArr = [NSMutableArray array];
    self.phoneArr = [NSMutableArray array];
    [self setUI];
    [self addBottomView];
    [self getData];
}

#pragma mark - action
- (void)setUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64 - 50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.topV;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
    self.tableView.tableFooterView = view;
    
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    [self.view addSubview:self.tableView];
}

#pragma mark - 添加底部视图
- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
   
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, bottomView.height)];
        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:phoneBtn];
        
        UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, (BLEJWidth - phoneBtn.right) * 0.5, bottomView.height)];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        priceBtn.backgroundColor = kCustomColor(242, 105, 71);
        [priceBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [priceBtn setTitle:@"免费报价" forState:UIControlStateNormal];
        [priceBtn addTarget:self action:@selector(didClickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:priceBtn];
        
        UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, priceBtn.width, bottomView.height)];
        houseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        houseBtn.backgroundColor = kMainThemeColor;
        [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];
//        [houseBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [houseBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:houseBtn];
//       if (self.iscompany) {
//    } else {
//        
//        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, bottomView.height)];
//        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
//        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
//        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:phoneBtn];
//        
//        UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, BLEJWidth - phoneBtn.right, bottomView.height)];
//        appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//        appointmentBtn.backgroundColor = kMainThemeColor;
//        [appointmentBtn setTitleColor:White_Color forState:UIControlStateNormal];
//        [appointmentBtn setTitle:@"在线预约" forState:UIControlStateNormal];
//        [appointmentBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:appointmentBtn];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cooperateCell == nil) {
        
        self.cooperateCell = [[UITableViewCell alloc] init];
        self.cooperateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cooperateCell.layer.masksToBounds = YES;
        for (int i = 0; i < self.cooperateArr.count; i ++) {
            
            UIButton *btn = [self cooperateViewWithModel:self.cooperateArr[i]];
            btn.frame = CGRectMake((i % 3) * BLEJWidth * 1 / 3, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (i / 3), BLEJWidth * 1 / 3, (BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20);
            btn.tag = i;
            [self.cooperateCell addSubview:btn];
        }
        for (int i = 0; i < self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1); i ++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (i + 1) - 1, BLEJWidth, 1)];
            line.backgroundColor = kBackgroundColor;
            [self.cooperateCell addSubview:line];
        }
        
        for (int i = 0; i < 2; i ++) {
            
            if (i == 0) {
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake((BLEJWidth * 1 / 3) * (i + 1) - 1, 0, 1, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1)))];
                line.backgroundColor = kBackgroundColor;
                [self.cooperateCell addSubview:line];
            } else {
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake((BLEJWidth * 1 / 3) * (i + 1) - 1, 0, 1, ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 2 ? 1 : 0)))];
                line.backgroundColor = kBackgroundColor;
                [self.cooperateCell addSubview:line];
            }
            
        }
    }
    
    return self.cooperateCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return ((BLEJWidth * 1 / 3 - 20) * 3 / 8 + 30 + 20) * (self.cooperateArr.count / 3 + (self.cooperateArr.count % 3 == 0 ? 0 : 1));;
    }
    return 0.0001;
}

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    [self.phoneArr removeAllObjects];
    
    NSString *landLine = [self.dataDic objectForKey:@"companyLandline"];
    NSString *managerLine = [self.dataDic objectForKey:@"companyPhone"];
    
    if (!(!landLine || [landLine isKindOfClass:[NSNull class]] || [landLine isEqualToString:@""])) {
        [self.phoneArr addObject:landLine];
    }
    if (!(!managerLine || [managerLine isKindOfClass:[NSNull class]] || [managerLine isEqualToString:@""])) {
        [self.phoneArr addObject:managerLine];
    }
    
    if (self.phoneArr.count == 0) {
        return;
    }
    UIActionSheet *actionSheet;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    }
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.phoneArr.count == 1) {
        if (buttonIndex == 0) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else {
            
        }
    } else {
        
        if (buttonIndex == 0) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else if (buttonIndex == 1) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[1]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else {
            
        }
    }
}

- (void)didClickAppointmentBtn:(UIButton *)btn {// 预约
    
//    DecorateNeedViewController *vc = [[DecorateNeedViewController alloc] init];
//    vc.companyType = self.companyDic[@"companyType"];
//    vc.companyID = self.companyId;
//    [self.navigationController pushViewController:vc animated:YES];
    
    self.infoView = [[NSBundle mainBundle] loadNibNamed:@"DecorateInfoNeedView" owner:nil options:nil].lastObject;
    self.infoView.frame = self.view.frame;
    [self.infoView.finishButton addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.infoView];
    // 店铺和公司的界面区别
    [self.infoView.areaTF removeFromSuperview];
    [self.infoView.timeTF removeFromSuperview];
    self.infoView.tipLabel.text = @"本公司业务人员会与您电话沟通，请确保电话畅通！     ";
//    self.infoView.tipLabelHeight.constant = 30;
    self.infoView.protocolImageTopToPhoneTFCon.constant = 6;
    
    MJWeakSelf;
    self.infoView.sendVertifyCodeBlock = ^{
        [weakSelf sendvertifyAction];
    };
    self.infoView.hidden = NO;
    
    // 在线预约浏览量
    [NSObject needDecorationStatisticsWithConpanyId:self.companyId];
   
}

- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    
    // 装修报价
    if (self.code == 1000) {
        
     
            
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
            VC.origin = self.origin;
        VC.calculatorModel= self.calculatorModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.companyId;
            VC.topImageArr = self.topCalculatorImageArr;
            VC.bottomImageArr = self.bottomCalculatorImageArr;
            VC.isConVip = self.companyDic[@"conVip"];
            [self.navigationController pushViewController:VC animated:YES];
//           if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置简装/精装报价"];
//        }
    } else if (self.code == -1) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络不畅，请稍后重试"];
    } else {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置模板"];
    }
}

- (void)didClickHouseBtn:(UIButton *)btn {// 量房
    
    DecorateNeedViewController *decoration = [[DecorateNeedViewController alloc]init];
    decoration.companyID = self.companyId;
    decoration.areaList = self.areaArr;
    [self.navigationController pushViewController:decoration animated:YES];
}

#pragma mark - action
- (void)getData {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cooperateEnterprise/getBaseInfo.do"];
    NSDictionary *param = @{
                           @"companyId" : self.companyId
                           };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObj[@"data"];
                NSMutableDictionary *dict = [[dic objectForKey:@"companyModel"] mutableCopy];
                self.dataDic = [NSDictionary dictionary];
                self.dataDic = [dict copy];
                //刷新数据
                [self reloadDataWithDic:dict];
                
                // 合作企业
                NSArray *cooperateArr = [responseObj[@"data"] objectForKey:@"enterPriseList"];
                [self.cooperateArr removeAllObjects];
                self.cooperateCell = nil;
                for (NSDictionary *dict in cooperateArr) {
                    
                    ZCHCooperateListModel *cooperateModel = [ZCHCooperateListModel yy_modelWithJSON:dict];
                    if (![self.cooperateArr containsObject:cooperateModel]) {
                        [self.cooperateArr addObject:cooperateModel];
                    }
                }
            };
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}



// dict为返回的公司信息数据
- (void)reloadDataWithDic:(NSDictionary *)dict {
    
    self.companyName.text = [dict objectForKey:@"companyName"];
    
    self.constructionNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"caseTotla"]];
    self.dispalyNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"constructionTotal"]];
    self.numLabel3.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"merchandiesCount"]];
    self.numLabel4.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"displayNumbers"]];
    
    
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
}

#pragma mark - 合作企业视图
- (UIButton *)cooperateViewWithModel:(ZCHCooperateListModel *)model {
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = White_Color;
    [btn addTarget:self action:@selector(didClickCooperate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, BLEJWidth * 1 / 3 - 20, (BLEJWidth * 1 / 3 - 20) * 3 / 8)];
    [logoView sd_setImageWithURL:[NSURL URLWithString:model.sloganLogo] placeholderImage:nil];
    [btn addSubview:logoView];
    
    CGSize size = [model.companyName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:12]];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, logoView.bottom, size.width > BLEJWidth * 1 / 3 - 20 - 17 ? BLEJWidth * 1 / 3 - 20 - 17 : size.width, 20)];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.text = model.companyName;
    [btn addSubview:nameLabel];
    
    UIImageView *vipLogo = [[UIImageView alloc] initWithFrame:CGRectMake(nameLabel.right + 3, logoView.bottom + 3, 14, 14)];
    vipLogo.image = [UIImage imageNamed:@"vip"];
    [btn addSubview:vipLogo];
    
    if ([model.appVip isEqualToString:@"1"]) {
        vipLogo.hidden = NO;
    } else {
        vipLogo.hidden = YES;
    }
    
    CGSize sizeCount = [model.displayNumbers boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:12]];
    UILabel *showCount = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 1 / 3 - 10 - sizeCount.width, nameLabel.bottom, sizeCount.width, 20)];
    [btn addSubview:showCount];
    showCount.textAlignment = NSTextAlignmentRight;
    showCount.font = [UIFont systemFontOfSize:12];
    showCount.textColor = kCustomColor(33, 151, 216);
    showCount.text = model.displayNumbers;
    
    UIImageView *scanIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
    [btn addSubview:scanIV];
    [scanIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(showCount);
        make.right.equalTo(showCount.mas_left).equalTo(-5);
        make.size.equalTo(CGSizeMake(20, 10));
    }];
    
//    CGSize sizeLabel = [@"展现量" boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:12]];
//    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(BLEJWidth * 1 / 3 - 10 - sizeCount.width - sizeLabel.width - 5, nameLabel.bottom, sizeLabel.width, 20)];
//    [btn addSubview:showLabel];
//    showLabel.textAlignment = NSTextAlignmentRight;
//    showLabel.font = [UIFont systemFontOfSize:12];
//    showLabel.textColor = [UIColor darkGrayColor];
//    showLabel.text = @"展现量";
    
    return btn;
}

#pragma mark - 合作企业点击视图
- (void)didClickCooperate:(UIButton *)btn {
    
    if (self.times && [self.times isEqualToString:@"2"]) {
        return;
    }
    
    ZCHCooperateListModel *model = [self.cooperateArr objectAtIndex:btn.tag];
    if ([model.appVip isEqualToString:@"1"]) {
        //公司的详情
        if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
            CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
            company.companyName = model.companyName;
            company.companyID = model.companyId;
            company.times = @"2";
            company.hidesBottomBarWhenPushed = YES;
            company.origin = self.origin;
            [self.navigationController pushViewController:company animated:YES];
        } else {
            //店铺的详情;
            ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
            shop.shopName = model.companyName;
            shop.shopID = model.companyId;
            model.browse = [NSString stringWithFormat:@"%ld", model.browse.integerValue + 1];
            shop.hidesBottomBarWhenPushed = YES;
            shop.times = @"2";
            shop.origin = self.origin;
            [self.navigationController pushViewController:shop animated:YES];
        }
        
    } else {
        VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
        controller.isEdit = false;
        controller.companyId = model.companyId;
        controller.origin = self.origin;
        [self.navigationController pushViewController:controller animated:true];

    }
}

#pragma  mark - 发送验证码
- (void)sendvertifyAction {
    
    [self.infoView endEditing:YES];
    if (![self.infoView.phoneTF.text ew_justCheckPhone]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"callDecoration/sendPhoneCode.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [param setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [weakSelf timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已喊过装修"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败或操作过于频繁"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)timelessWithSecond:(NSInteger)s button:(UIButton *)btn {
    
    __block int timeout = (int)s; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = kMainThemeColor;
            });
        } else {
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
                btn.backgroundColor = kDisabledColor;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

#pragma mark - 完成
- (void)finishiAction {
    
    if ([self.infoView.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if (![self.infoView.phoneTF.text ew_checkPhoneNumber]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的联系方式"];
        return;
    }
    if (self.infoView.vertifyCodeTF.text.length != 6) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入6位数的验证码"];
        return;
    }
    NSInteger proType = -1;
    if ([self.infoView.itemTF.text isEqualToString:@"量房"]) {
        proType = 0;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"设计"]) {
        proType = 1;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"施工"]) {
        proType = 2;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"维修"]) {
        proType = 3;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"其他"]) {
        proType = 4;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.infoView.vertifyCodeTF.text forKey:@"phoneCode"];
    [dic setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text forKey:@"fullName"];
    [dic setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.companyDic[@"companyType"] forKey:@"companyType"];
    [dic setObject:@(proType) forKey:@"proType"];
    [dic setObject:@"0" forKey:@"agencyId"];
    [dic setObject:@"0" forKey:@"callPage"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
     [dic setObject:self.origin?:@"0" forKey:@"origin"];
    NSString *url = [BASEURL stringByAppendingString:@"callDecoration/v2/save.do"];
    [NetManager  afGetRequest:url parms:dic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        switch ([responseObj[@"code"] integerValue]) {
                //喊装修成功
            case 1000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已提交成功请等待回复"];
                 
                // 睡一秒
                [NSThread sleepForTimeInterval:1];
                
                DecorateCompletionViewController *completionVC = [[DecorateCompletionViewController alloc] init];
                completionVC.dataDic = responseObj[@"data"];
                completionVC.companyType = weakSelf.companyDic[@"companyType"];
                NSString *constructionType = weakSelf.companyDic[@"constructionType"];
                completionVC.constructionType = constructionType;
                [self.navigationController pushViewController:completionVC animated:YES];
                break;
            }
            case 1001:
                break;
                //            本月已喊过装修
            case 1002:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您本月已经预约过了"];
                break;
                //            不在装修区域
            case 1003:
                self.infoView.hidden = YES;
                [self replySubmit:dic];
                break;
                //             该区域暂无接单公司
            case 1004:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该区域暂无接单公司"];
                break;
            case 2000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约修失败，稍后重试"];
                break;
            }
            case 2001:
            {
                self.infoView.hidden = NO;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            }
            default:
                break;
        }
        
    } failed:^(NSString *errorMsg) {
        
        [weakSelf.view hiddleHud];
        self.infoView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark   不在装修区域  是否继续提交
- (void)replySubmit:(NSMutableDictionary *)dic {
    //该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    __weak typeof(self)  weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [dic setObject:@(1) forKey:@"type"];
        
        [weakSelf upDataRequest:dic];
    }];
    
    
    [aler addAction:action];
    [aler addAction:action1];
    [self presentViewController:aler animated:YES completion:nil];
}


#pragma mark - 头部视图
//- (UIView *)topV {
//
//    if (!_topV) {
//
//        _topV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, BLEJWidth-20, 120)];
//        _topV.backgroundColor = White_Color;
//        _topV.layer.borderWidth = 8;
//        _topV.layer.borderColor = kBackgroundColor.CGColor;
//        [_topV addSubview:self.photoImg];
//        [_topV addSubview:self.companyName];
//        [_topV addSubview:self.caseNum];
//        [_topV addSubview:self.caseNumL];
//        [_topV addSubview:self.addressNum];
//        [_topV addSubview:self.addressNumL];
//        [_topV addSubview:self.commentNum];
//        [_topV addSubview:self.commentNumL];
//    }
//    return _topV;
//}
//
//- (UIImageView *)photoImg {
//
//    if (!_photoImg) {
//
//        _photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, self.topV.height-15*2, self.topV.height-15*2)];
//    }
//    return _photoImg;
//}
//
//- (UILabel *)companyName {
//
//    if (!_companyName) {
//        _companyName = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.top, 200, 30)];
//        _companyName.textColor = Black_Color;
//        _companyName.font = [UIFont systemFontOfSize:20];
//        _companyName.textAlignment = NSTextAlignmentLeft;
//        _companyName.text = @"";
//    }
//    return _companyName;
//}
//
//
//- (UILabel *)caseNum {
//
//    if (!_caseNum) {
//        _caseNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.bottom-20, 40, 20)];
//        _caseNum.textColor = Black_Color;
//        _caseNum.font = [UIFont systemFontOfSize:14];
//        _caseNum.textAlignment = NSTextAlignmentLeft;
//        _caseNum.text = @"案例:";
//    }
//    return _caseNum;
//}
//
//- (UILabel *)caseNumL {
//
//    if (!_caseNumL) {
//        _caseNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right+5, self.caseNum.top, 50, 20)];
//        _caseNumL.textColor = [UIColor redColor];
//        _caseNumL.font = [UIFont systemFontOfSize
//                          :14];
//        _caseNumL.textAlignment = NSTextAlignmentLeft;
//        _caseNumL.text = @"";
//    }
//    return _caseNumL;
//}
//
//- (UILabel *)addressNum {
//
//    if (!_addressNum) {
//        _addressNum = [[UILabel alloc]initWithFrame:CGRectMake(self.caseNumL.right, self.caseNumL.top, 40, 20)];
//        _addressNum.textColor = Black_Color;
//        _addressNum.font = [UIFont systemFontOfSize:14];
//        _addressNum.textAlignment = NSTextAlignmentLeft;
//        _addressNum.text = @"工地:";
//    }
//    return _addressNum;
//}
//
//- (UILabel *)addressNumL {
//
//    if (!_addressNumL) {
//        _addressNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.addressNum.right+5, self.addressNum.top, 50, 20)];
//        _addressNumL.textColor = [UIColor redColor];
//        _addressNumL.font = [UIFont systemFontOfSize
//                             :14];
//        _addressNumL.textAlignment = NSTextAlignmentLeft;
//        _addressNumL.text = @"";
//    }
//    return _addressNumL;
//}
//
//- (UILabel *)commentNum {
//
//    if (!_commentNum) {
//        _commentNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.caseNum.top-20-10, 40, 20)];
//        _commentNum.textColor = Black_Color;
//        _commentNum.font = [UIFont systemFontOfSize:14];
//        _commentNum.textAlignment = NSTextAlignmentLeft;
//        _commentNum.text = @"好评:";
//    }
//    return _commentNum;
//}
//
//- (UILabel *)commentNumL {
//
//    if (!_commentNumL) {
//        _commentNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right + 5, self.commentNum.top, 50, 20)];
//        _commentNumL.textColor = [UIColor redColor];
//        _commentNumL.font = [UIFont systemFontOfSize
//                             :14];
//        _commentNumL.textAlignment = NSTextAlignmentLeft;
//        _commentNumL.text = @"";
//    }
//    return _commentNumL;
//}

#pragma mark - topView
- (UIView *)topV {
    if (!_topV) {
        _topV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, BLEJWidth-20, 120)];
        //        _topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth-20, 120)];
        _topV.backgroundColor = [UIColor whiteColor];
        _topV.layer.borderWidth = 8;
        _topV.layer.borderColor = kBackgroundColor.CGColor;
        
        self.photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, self.topV.height-15*2, self.topV.height-15*2)];
        [_topV addSubview:self.photoImg];
        self.companyName = [UILabel new];
        [_topV addSubview:self.companyName];
        [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.equalTo(self.photoImg.mas_top).equalTo(13);
            make.right.equalTo(-10);
        }];
        self.companyName.textColor = Black_Color;
        self.companyName.font = [UIFont systemFontOfSize:20];
        self.companyName.textAlignment = NSTextAlignmentLeft;
        
        
        self.constructionLabel = [UILabel new];
        [_topV addSubview:self.constructionLabel];
        [self.constructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.equalTo(self.companyName.mas_bottom).equalTo(10);
        }];
        self.constructionLabel.textColor = Black_Color;
        self.constructionLabel.font = [UIFont systemFontOfSize:14];
        self.constructionLabel.text = @"案例:";
        
        self.constructionNumLabel = [UILabel new];
        [_topV addSubview:self.constructionNumLabel];
        [self.constructionNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.constructionLabel.mas_right).equalTo(5);
            make.centerY.equalTo(self.constructionLabel);
            make.width.equalTo(60);
        }];
        self.constructionNumLabel.textColor = [UIColor redColor];
        self.constructionNumLabel.font = [UIFont systemFontOfSize:14];
        
        self.displayLabel = [UILabel new];
        [_topV addSubview:self.displayLabel];
        [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.constructionNumLabel.mas_right).equalTo(4);
            make.centerY.equalTo(self.constructionLabel);
        }];
        self.displayLabel.textColor = Black_Color;
        self.displayLabel.font = [UIFont systemFontOfSize:14];
        self.displayLabel.text = @"施工中:";
        
        self.dispalyNumLabel = [UILabel new];
        [_topV addSubview:self.dispalyNumLabel];
        [self.dispalyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.displayLabel.mas_right).equalTo(5);
            make.centerY.equalTo(self.constructionLabel);
        }];
        self.dispalyNumLabel.textColor = [UIColor redColor];
        self.dispalyNumLabel.font = [UIFont systemFontOfSize:14];
        
        // -------
        
        self.label3 = [UILabel new];
        [_topV addSubview:self.label3];
        [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.equalTo(self.dispalyNumLabel.mas_bottom).equalTo(8);
        }];
        self.label3.textColor = Black_Color;
        self.label3.font = [UIFont systemFontOfSize:14];
        self.label3.text = @"商品:";
        
        self.numLabel3 = [UILabel new];
        [_topV addSubview:self.numLabel3];
        [self.numLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label3.mas_right).equalTo(5);
            make.centerY.equalTo(self.label3);
            make.width.equalTo(60);
        }];
        self.numLabel3.textColor = [UIColor redColor];
        self.numLabel3.font = [UIFont systemFontOfSize:14];
        
        self.label4 = [UILabel new];
        [_topV addSubview:self.label4];
        [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numLabel3.mas_right).equalTo(4);
            make.centerY.equalTo(self.label3);
        }];
        self.label4.textColor = Black_Color;
        self.label4.font = [UIFont systemFontOfSize:14];
        self.label4.text = @"展现量:";
        
        self.numLabel4 = [UILabel new];
        [_topV addSubview:self.numLabel4];
        [self.numLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label4.mas_right).equalTo(5);
            make.centerY.equalTo(self.label3);
        }];
        self.numLabel4.textColor = [UIColor redColor];
        self.numLabel4.font = [UIFont systemFontOfSize:14];
    }
    return _topV;
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
