//
//  CompanyIntroductController.m
//  iDecoration
//  公司简介
//  Created by Apple on 2017/5/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyIntroductController.h"
#import "Tyview.h"
#import "MapViewController.h"
#import "BLEJBudgetGuideController.h"
#import "DecorateNeedViewController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "ComplainViewController.h"

@interface CompanyIntroductController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    
    BOOL isGetData;
}


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


@property (nonatomic, strong) UIView *midV;

@property (nonatomic, strong) Tyview *tyV;
@property (nonatomic, strong) UIView *bottomV;

@property (strong, nonatomic) UITableView *tableView;

// 记录公司简介需要的高度
@property (assign, nonatomic) CGFloat introductHeight;
// 公司数据
@property (nonatomic, strong) NSDictionary *dataDic;
// 定位按钮
@property (nonatomic, strong) UIButton *navButton;
@property (strong, nonatomic) NSMutableArray *phoneArr;

@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@property (nonatomic, assign) BOOL hasSupport; // 是否点赞
@property (nonatomic, strong) UIButton *supportButton;
@property (strong, nonatomic) UILabel *goodCountLabel; // 底部点赞数量
@property (nonatomic, strong) UILabel *scanCountLabel;

@end

@implementation CompanyIntroductController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.iscompany == NO) {
        
        self.title = @"店铺简介";
    }else{
    
        self.title = @"公司简介";
    }
    self.phoneArr = [NSMutableArray array];
    self.view.backgroundColor = kBackgroundColor;
    [self setUI];
    [self addBottomView];
    [self requestCompanyInfo];
    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }
}

#pragma mark - action
- (void)setUI {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64 - 50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.topV;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
    self.tableView.tableFooterView = view;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self setScanFooterView];
    
    [self.view addSubview:self.tableView];
}

// 设置浏览量视图
- (void)setScanFooterView {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];
    
//    UIImageView *scanIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
//    scanIV.frame = CGRectMake(16, 15, 30, 15);
//    [footView addSubview:scanIV];

    UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 0, 50)];
    [footView addSubview:scanLabel];
    scanLabel.font = [UIFont systemFontOfSize:16];
    scanLabel.textColor = [UIColor darkGrayColor];
    scanLabel.text = @"浏览量";
    [scanLabel sizeToFit];
    
    UILabel *displayCount = [[UILabel alloc] initWithFrame:CGRectMake(scanLabel.right + 10, 0, 0, 50)];
    self.scanCountLabel = displayCount;
    [footView addSubview:displayCount];
    displayCount.textAlignment = NSTextAlignmentRight;
    displayCount.font = [UIFont systemFontOfSize:16];
    displayCount.textColor = [UIColor darkGrayColor];
    displayCount.text = @"0";
    [displayCount sizeToFit];
    
    UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(displayCount.right + 10, 0, 44, 44)];
    self.supportButton = goodBtn;
    [goodBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    [goodBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateHighlighted];
    [goodBtn addTarget:self action:@selector(didClickGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:goodBtn];
    
    UILabel *goodCount = [[UILabel alloc] initWithFrame:CGRectMake(goodBtn.right, 0, 0, 50)];
    self.goodCountLabel = goodCount;
    [footView addSubview:goodCount];
    goodCount.textAlignment = NSTextAlignmentRight;
    goodCount.font = [UIFont systemFontOfSize:16];
    goodCount.textColor = [UIColor darkGrayColor];
    goodCount.text = @"0";
    [goodCount sizeToFit];
    
    
    UIButton *complainBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 50, 0, 50, 50)];
    [complainBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [complainBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    complainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [complainBtn addTarget:self action:@selector(didClickComplainBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:complainBtn];
    goodCount.centerY = complainBtn.centerY;
    goodBtn.centerY = goodCount.centerY;
    displayCount.centerY = goodBtn.centerY;
    scanLabel.centerY = displayCount.centerY;
    
    self.tableView.tableFooterView = footView;
}
#pragma mark - 点赞按钮的点击事件
- (void)didClickGoodBtn:(UIButton *)btn {
    
    if (!_hasSupport) {
        _hasSupport = YES;
        
        [btn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        self.goodCountLabel.text = [NSString stringWithFormat:@"%ld", [self.goodCountLabel.text integerValue] + 1];
        [self.goodCountLabel sizeToFit];

        NSString *apiStr = [BASEURL stringByAppendingString:@"company/introductionLike.do"];
        NSDictionary *param = @{
                                @"companyId" : self.companyId
                                };
        [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        } failed:^(NSString *errorMsg) {
        }];
    }
    
}
#pragma mark - 投诉按钮的点击事件
- (void)didClickComplainBtn:(UIButton *)btn {
    
    ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
    ComplainVC.companyID = self.companyId.integerValue;
    ComplainVC.complainFrom = 2;
    [self.navigationController pushViewController:ComplainVC animated:YES];
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
        [houseBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:houseBtn];
 //    if (self.iscompany) {
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

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    if (!isGetData) {
        
        return;
    } else {
        
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
//    vc.companyType = self.companyType;
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
            VC.origin = self.origin;
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
        VC.calculatorModel = self.calculatorModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.companyId;
            VC.topImageArr = self.topCalculatorImageArr;
            VC.bottomImageArr = self.bottomCalculatorImageArr;
            VC.isConVip = self.companyDic[@"conVip"];
            [self.navigationController pushViewController:VC animated:YES];
    
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
    decoration.companyType = @"1018";
    [self.navigationController pushViewController:decoration animated:YES];
}


#pragma mark - action
- (void)requestCompanyInfo {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"company/getCompanyIntroductions.do"];
    NSDictionary *paramDic = @{
                               @"companyId" : self.companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    isGetData = YES;
                    break;
                case 2000:
                    isGetData = NO;
                    break;
                default:
                    break;
            }
            
            
            if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObj[@"data"];
                NSMutableDictionary *dict = [[dic objectForKey:@"companyModel"] mutableCopy];
                // 去掉地址中的回车 换行
                NSString *compayaddress = dict[@"companyAddress"];
                compayaddress = [compayaddress stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                compayaddress = [compayaddress stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                [dict setObject:compayaddress forKey:@"companyAddress"];
                self.dataDic = [NSDictionary dictionary];
                self.dataDic = [dict copy];
                //刷新数据
                [self reloadDataWithDic:dict];
            };
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.midV];
    }
    
    if (indexPath.row == 1) {
        [cell.contentView addSubview:self.bottomV];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 120;
    }
    if (indexPath.row == 1) {
        
        return self.introductHeight + 10;
    }
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


// dict为返回的公司信息数据
- (void)reloadDataWithDic:(NSDictionary *)dict {
    
    if (!isGetData) {
        self.companyName.text = @"";
        self.constructionNumLabel.text = @"";
        self.dispalyNumLabel.text = @"";
        self.numLabel3.text = @"";
        self.numLabel4.text = @"";
    }else{
        self.companyName.text = [dict objectForKey:@"companyName"];
        self.constructionNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"caseTotla"]];
        self.dispalyNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"constructionTotal"]];
        self.numLabel3.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"merchandiesCount"]];
        self.numLabel4.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"displayNumbers"]];
        
        
        
        self.goodCountLabel.text = dict[@"introductionLikeNumbers"];
        [self.goodCountLabel sizeToFit];
        self.scanCountLabel.text = dict[@"introductionBrowse"];
        [self.scanCountLabel sizeToFit];

    }
    
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    
    [self midVsetData:dict];
    [self bottomVsetData:dict];
}

#pragma 底部视图设置
- (void)bottomVsetData:(NSDictionary *)dict {
    
    NSArray *leftArray = nil;
    if (self.iscompany == YES) {
      
        leftArray = @[@"座机",@"业务经理电话",@"邮箱",@"网址",@"地址"];
        
    }else{
    
        leftArray = @[@"类别",@"座机",@"业务经理电话",@"邮箱",@"网址",@"地址"];
    
    }
    
    NSArray *rightArray;
    if (!isGetData) {
        if (self.iscompany == YES) {
          rightArray = @[@"",@"",@"",@"",@""];
        }else{
         
            rightArray = @[@"",@"",@"",@"",@"",@""];
            
        }
    }
    else{
        NSString *landLine = [dict objectForKey:@"companyLandline"];
        if (!landLine||[landLine isKindOfClass:[NSNull class]]) {
            landLine = @"";
        }
        NSString *phone = [dict objectForKey:@"companyPhone"];
        if (!phone||[phone isKindOfClass:[NSNull class]]) {
            phone = @"";
        }
        NSString *companyEmail = [dict objectForKey:@"companyEmail"];
        if (!companyEmail||[companyEmail isKindOfClass:[NSNull class]]) {
            companyEmail = @"";
        }
        NSString *companyUrl = [dict objectForKey:@"companyUrl"];
        if (!companyUrl||[companyUrl isKindOfClass:[NSNull class]]) {
            companyUrl = @"";
        }
        
        
    
        NSString *address = [dict objectForKey:@"companyAddress"];
        if (!address||[address isKindOfClass:[NSNull class]]) {
            address = @"";
        }
        
        
        NSString *kind = [dict objectForKey:@"typeName"];
        if (!kind||[kind isKindOfClass:[NSNull class]]) {
            kind = @"";
        }
        
        if (self.iscompany == YES) {
            rightArray = @[landLine,phone,companyEmail,companyUrl,address];
        }else{
        
            rightArray = @[kind,landLine,phone,companyEmail,companyUrl,address];
        }
        
    }
    
    CGFloat h = 0;
    for (int i = 0; i < rightArray.count; i ++) {
        UIView *temV = [[UIView alloc]initWithFrame:CGRectMake(0, h, kSCREEN_WIDTH, 44)];
        temV.backgroundColor = White_Color;
        
        UILabel *temL = [[UILabel alloc] init];
        if ((self.iscompany && i == 1) || (!self.iscompany && i == 2)) {
            temL.frame = CGRectMake(10, 0, 100, temV.height);
        } else {
            temL.frame = CGRectMake(10, 0, 50, temV.height);
        }
        temL.text = leftArray[i];
        temL.textAlignment = NSTextAlignmentLeft;
        if (IPhone4) {
            temL.font = [UIFont systemFontOfSize:12];
        } else if (IPhone5) {
            temL.font = [UIFont systemFontOfSize:14];
        } else {
            temL.font = [UIFont systemFontOfSize:15];
        }
        temL.textColor = COLOR_BLACK_CLASS_3;
        
        UILabel *temB = [[UILabel alloc] init];
        // 重新设置  地址的宽度
        if (i == leftArray.count - 1) {
            temB.frame = CGRectMake(temL.right+10, temL.top, kSCREEN_WIDTH-temL.right-20 - 40, temL.height);
        } else {
            temB.frame = CGRectMake(temL.right+10, temL.top, kSCREEN_WIDTH-temL.right-20 , temL.height);
        }
        if (IPhone4) {
            temB.font = [UIFont systemFontOfSize:12];
        } else if (IPhone5) {
            temB.font = [UIFont systemFontOfSize:14];
        } else {
            temB.font = [UIFont systemFontOfSize:15];
        }
        
        temB.text = rightArray[i];
        temB.numberOfLines = 0;
        temB.textColor = COLOR_BLACK_CLASS_6;
        temB.textAlignment = NSTextAlignmentLeft;
        
        CGSize size = [temB.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-temL.right-20 - 40, MAXFLOAT) withFont:temB.font];
        if (size.height > 44) {
             if (i == leftArray.count - 1) {
                 temB.size = CGSizeMake(kSCREEN_WIDTH-temL.right-20 - 40, size.height + 10);
             } else {
                 temB.size = CGSizeMake(kSCREEN_WIDTH-temL.right-20, size.height + 10);
             }
            
            temL.centerY = temB.centerY;
            temV.size = CGSizeMake(kSCREEN_WIDTH, size.height + 10);
        }
        
        
        UIView *temLine = [[UIView alloc]initWithFrame:CGRectMake(0, h + temB.size.height - 0.5, kSCREEN_WIDTH, 0.5)];
        h = h + temB.size.height;
    
        temLine.backgroundColor = self.tableView.separatorColor;
        
        [temV addSubview:temL];
        [temV addSubview:temB];
        // 定位按钮
        if (i == leftArray.count - 1) {
            self.navButton = [[UIButton alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH - 40, temL.top * i + 5,  30, 30)];
            self.navButton.frame = CGRectMake(kSCREEN_WIDTH - 40, temL.top * i + 5,  30, 30);
            self.navButton.centerY = temB.centerY;
            self.navButton.contentMode = UIViewContentModeScaleAspectFit;
            [self.navButton  addTarget:self action:@selector(localionAddress) forControlEvents:UIControlEventTouchUpInside];
            [self.navButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
            [temV addSubview:self.navButton];
            
//            temV.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(localionAddress)];
//            [temV addGestureRecognizer:tapGR];
        }
        
        [self.bottomV addSubview:temV];
        [self.bottomV addSubview:temLine];
    
        
    }
    
    
    h = h + 10;
    UILabel *company = [[UILabel alloc]initWithFrame:CGRectMake(0, h, kSCREEN_WIDTH, 20)];
    company.text = @"公司简介";
    company.textAlignment = NSTextAlignmentCenter;
    if (IPhone4) {
        company.font = [UIFont systemFontOfSize:12];
    } else if (IPhone5) {
        company.font = [UIFont systemFontOfSize:14];
    } else {
        company.font = [UIFont systemFontOfSize:15];
    }
    company.textColor = COLOR_BLACK_CLASS_3;
    [self.bottomV addSubview:company];
    h = h + 30;
    
    UIView *temLine = [[UIView alloc]initWithFrame:CGRectMake(0, h, kSCREEN_WIDTH, 0.5)];
    temLine.backgroundColor = self.tableView.separatorColor;
    [self.bottomV addSubview:temLine];
    
    
    NSString *intro;
    if (!isGetData) {
        intro = @"";
    } else {
        intro = [dict objectForKey:@"companyIntroduction"];
        if (!intro || [intro isKindOfClass:[NSNull class]]) {
            intro = @"";
        }
    }
    
    UILabel *companyIntroduct = [[UILabel alloc] initWithFrame:CGRectMake(10, temLine.bottom + 10, kSCREEN_WIDTH-20, 20)];
    companyIntroduct.numberOfLines = 0;
    companyIntroduct.text = [NSString stringWithFormat:@"%@",intro];
    companyIntroduct.textAlignment = NSTextAlignmentLeft;
    if (IPhone4) {
        companyIntroduct.font = [UIFont systemFontOfSize:12];
    } else if (IPhone5) {
        companyIntroduct.font = [UIFont systemFontOfSize:14];
    } else {
        companyIntroduct.font = [UIFont systemFontOfSize:15];
    }
    [companyIntroduct sizeToFit];

    self.introductHeight = CGRectGetMaxY(companyIntroduct.frame);
    companyIntroduct.textColor = COLOR_BLACK_CLASS_3;
    [self.bottomV addSubview:companyIntroduct];
    
    if (intro.length <= 0) {
        
        companyIntroduct.hidden = YES;
    }
}

#pragma 综合评价部分
- (void)midVsetData:(NSDictionary *)dict {
    
    NSArray *leftArray = @[@"服务",@"价格",@"设计",@"施工",@"工期"];
    NSArray *rightArray;
    NSString *totalStr;
    if (!isGetData) {
        rightArray = @[@(0),@(0),@(0),@(0),@(0)];
        totalStr = @"0.0";
    } else {
        
        totalStr = [dict objectForKey:@"sumGrade"] == nil ? @"0": [dict objectForKey:@"sumGrade"] ;
        NSString *serviceGrade = [dict objectForKey:@"serviceGrade"] == nil ? @"0": [dict objectForKey:@"serviceGrade"] ;
        NSString *priceGrade = [dict objectForKey:@"priceGrade"] == nil ? @"0": [dict objectForKey:@"priceGrade"];
        NSString *designGrade = [dict objectForKey:@"designGrade"] == nil ? @"0": [dict objectForKey:@"designGrade"];
        
        NSString *qualityGrade = [dict objectForKey:@"qualityGrade"] == nil ? @"0": [dict objectForKey:@"qualityGrade"];
        NSString *speedGrade = [dict objectForKey:@"speedGrade"] == nil ? @"0": [dict objectForKey:@"speedGrade"];
        rightArray = @[serviceGrade,priceGrade,designGrade,qualityGrade,speedGrade];
        
    }
    UILabel *commentL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.midV.height/2+10,self.midV.height,30)];
    commentL.text = @"综合评价";
    commentL.textAlignment = NSTextAlignmentCenter;
    commentL.font = [UIFont systemFontOfSize:14];
    commentL.textColor = COLOR_BLACK_CLASS_3;
    [self.midV addSubview:commentL];
    
    UILabel *commentCount = [[UILabel alloc]initWithFrame:CGRectMake(0, commentL.top-30,commentL.width,30)];
    commentCount.text =[NSString stringWithFormat:@"%@",totalStr];
    commentCount.textAlignment = NSTextAlignmentCenter;
    commentCount.font = [UIFont systemFontOfSize:20];
    commentCount.textColor = Green_Color;
    [self.midV addSubview:commentCount];
    
    CGFloat h = 10;
    for (int i = 0; i<5; i++) {
        
        UILabel *rightL = [[UILabel alloc]initWithFrame:CGRectMake(self.midV.width - 60, h,20,20)];
        rightL.text = [NSString stringWithFormat:@"%@",rightArray[i]];
        rightL.textAlignment = NSTextAlignmentLeft;
        rightL.font = [UIFont systemFontOfSize:12];
        rightL.textColor = COLOR_BLACK_CLASS_6;
        [self.midV addSubview:rightL];
        
        Tyview *view = [[Tyview alloc]initWithFrame:CGRectMake(rightL.left-100, h+5, 100, 10)];
        CGFloat ff = [rightArray[i] floatValue];
        [view configView:5.0f score:ff bottomColor:COLOR_BLACK_CLASS_0 topColor:Green_Color cornerRadius:5.0];
        [self.midV addSubview:view];
        
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(view.left-30, h,30,20)];
        leftL.text = leftArray[i];
        leftL.textAlignment = NSTextAlignmentLeft;
        leftL.font = [UIFont systemFontOfSize:12];
        leftL.textColor = COLOR_BLACK_CLASS_6;
        [self.midV addSubview:leftL];
        h = h+20;
    }
}

#pragma mark - 头部视图


- (UIView *)midV {
    
    if (!_midV) {
        _midV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 120)];
        _midV.backgroundColor = [UIColor whiteColor];
    }
    return _midV;
}

- (Tyview *)tyV {
    if (!_tyV) {
        _tyV = [[Tyview alloc]initWithFrame:CGRectMake(10, 10, 100, 10)];
        [_tyV configView:5.0f score:4.3f bottomColor:COLOR_BLACK_CLASS_0 topColor:Green_Color cornerRadius:5];
    }
    return _tyV;
}

- (UIView *)bottomV{
    if (!_bottomV) {
        
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, BLEJHeight - 230)];
        _bottomV.backgroundColor = [UIColor whiteColor];
    }
    return _bottomV;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


#pragma mark 定位
- (void)localionAddress{

    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.latitude = [self.dataDic[@"latitude"] doubleValue];
    mapVC.longitude = [self.dataDic[@"longitude"] doubleValue];
    //self.dataDic[@"companyAddress"];  // 北京市-北京市-昌平区- 详细地址哦哦哦哦
    mapVC.companyAddress = [self.dataDic[@"companyAddress"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mapVC.companyName = self.dataDic[@"companyName"];
    [self.navigationController pushViewController: mapVC animated:YES];
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
    [param setObject:self.companyId forKey:@"companyId"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [weakSelf timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已预约过"];
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
    [dic setObject:self.companyId forKey:@"companyId"];
    [dic setObject:self.companyType forKey:@"companyType"];
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
                completionVC.companyType = weakSelf.companyType;
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
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败，稍后重试"];
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


@end
