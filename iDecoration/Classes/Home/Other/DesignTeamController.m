//
//  DesignTeamController.m
//  iDecoration
//  设计团队／优秀工长／优秀监理／施工团队
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DesignTeamController.h"
#import "DesignTeamModel.h"
#import "DesignTeamDetailController.h"
#import "ZCHTapGestureRecognizer.h"

#import "bottomView.h"

#import "decorationViewController.h"

#import "DecorateNeedViewController.h"
#import "BLEJBudgetGuideController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"

@interface DesignTeamController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *commentNum;
@property (nonatomic, strong) UILabel *commentNumL;
@property (nonatomic, strong) UILabel *caseNum;
@property (nonatomic, strong) UILabel *caseNumL;
@property (nonatomic, strong) UILabel *addressNum;
@property (nonatomic, strong) UILabel *addressNumL;

@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UILabel *titleL;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (strong, nonatomic) UITableView *tableView;
// 记录行高的
@property (assign, nonatomic) CGFloat rowHeight;

@property(nonatomic,assign)CGFloat  footHeight;
@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@end

@implementation DesignTeamController


//- (void)loadView {
//
//    [super loadView];
//
//    //店铺不需要喊装修
//    if (self.isShop == NO) {
//        
//        self.footHeight = 44.0;
//        [self creatFootView];
//        
//    }else{
//        
//        self.footHeight = 0.0;
//        
//    }
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = self.titleStr;
    self.phoneArr = [NSMutableArray array];
    self.dataArray  = [NSMutableArray array];
    [self setUI];
    [self requestData];
}

- (void)setScanFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
    [footerView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(20, 10));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    [footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV);
        make.left.equalTo(imageV.mas_right).equalTo(5);
    }];
    label.text = self.dispalyNum;
}
#pragma mark - action

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [self addBottomView];
    self.tableView.tableHeaderView = self.topV;
//    [self setScanFooterView];
}
    

- (void)requestData {
    
    [self.dataArray removeAllObjects];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/teamPersonInf.do"];
    NSDictionary *paramDic = @{@"companyId":self.companyId,
                               @"teamType":@(self.teamType),
                               @"page":@(1),
                               @"pageSize":@(99),
                               @"firstLoad":@(1)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = responseObj[@"data"];
                        NSDictionary *dict = [dic objectForKey:@"companyinfrom"];
                        
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[DesignTeamModel class] json:[dic objectForKey:@"agencysList"]];
                        [self.dataArray addObjectsFromArray:arr];
                        //刷新数据
                        [self reloadDataWithDic:dict];
                        
                    };
                    break;
                default:
                    break;
            }
        }
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell.contentView addSubview:self.bottomV];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.rowHeight;
}

- (void)reloadDataWithDic:(NSDictionary *)dict {
    
    self.companyName.text = [dict objectForKey:@"companyName"];
    self.commentNumL.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praiseTotal"]];
    self.caseNumL.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"caseTotla"]];
    self.addressNumL.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"constructionTotal"]];
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    
    [self bottomVsetData];
}

- (void)bottomVsetData {
    NSInteger count = self.dataArray.count;
//    NSInteger count = 7;
    CGFloat spacing = kSCREEN_WIDTH/20;
    CGFloat w = kSCREEN_WIDTH/5*4/3;
    CGFloat h = self.titleL.bottom + 10;
    CGFloat bottomVH=0;
    for (int i = 0; i<count; i++) {
        DesignTeamModel *model = self.dataArray[i];
        NSInteger x = i/3;
        NSInteger y = i%3;
        UIImageView *photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(spacing+(spacing+w)*y, h+(w + 20 + 5 + 15 + 25 + 10)*x, w, w)];
        photoImg.layer.cornerRadius = 5;
        photoImg.layer.masksToBounds = YES;
//        photoImg.tag = i;
//        photoImg.backgroundColor = Red_Color;
        [photoImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
        
        ZCHTapGestureRecognizer *ges = [[ZCHTapGestureRecognizer alloc]initWithTarget:self action:@selector(gesTap:)];
        ges.index = i;
        photoImg.userInteractionEnabled = YES;
        [photoImg addGestureRecognizer:ges];
        
        //传值
//        _agencyId = [model.agencyId integerValue];
//        _photo = model.photo;
//        _name = model.trueName;
//        _school = model.agencySchool;
//        _job = model.companyJob;
//        _comment = model.comment;
        
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(photoImg.left, photoImg.bottom, w, 20)];
        nameL.textColor = COLOR_BLACK_CLASS_6;
        nameL.font = [UIFont systemFontOfSize:12];
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.text = model.trueName;
        
        UILabel *companyJob = [[UILabel alloc]initWithFrame:CGRectMake(photoImg.left, nameL.bottom+5, w, 15)];
        companyJob.textColor = COLOR_BLACK_CLASS_3;
        companyJob.font = [UIFont systemFontOfSize
                      :10];
//        companyJob.backgroundColor = Red_Color;
        companyJob.textAlignment = NSTextAlignmentLeft;
        if (model.companyJob && ![model.companyJob isEqual: [NSNull null]]) {
            
            companyJob.text = [NSString stringWithFormat:@"公司职位：%@",model.companyJob];
        } else {
            
            companyJob.text = [NSString stringWithFormat:@"公司职位：%@",@""];
        }
        
        UILabel *comment = [[UILabel alloc]initWithFrame:CGRectMake(photoImg.left, companyJob.bottom, w, 25)];
        comment.textColor = COLOR_BLACK_CLASS_3;
        comment.font = [UIFont systemFontOfSize:10];
        comment.numberOfLines = 2;
//        comment.backgroundColor = Black_Color;
        comment.textAlignment = NSTextAlignmentLeft;
        
        if (model.comment && ![model.comment isEqual: [NSNull null]]) {
            
            comment.text = [NSString stringWithFormat:@"职业格言：%@",model.comment];
        } else {
            
            comment.text = [NSString stringWithFormat:@"职业格言：%@",@""];;
        }
        bottomVH = self.titleL.height+(w + 20 + 5 + 20 + 25 + 10)*(x+1)+10;
        [self.bottomV addSubview:photoImg];
        [self.bottomV addSubview:nameL];
        [self.bottomV addSubview:companyJob];
        [self.bottomV addSubview:comment];
    }
    self.bottomV.frame = CGRectMake(0, 10, kSCREEN_WIDTH, bottomVH);
    self.rowHeight = bottomVH;
}



- (void)gesTap:(ZCHTapGestureRecognizer *)tap {
    
    DesignTeamDetailController *vc = [[DesignTeamDetailController alloc]init];
    vc.titleStr = self.titleL.text;
    vc.model = self.dataArray[tap.index];
    vc.isShop = self.isShop;
    vc.companyId = self.companyId;
    vc.companyType = self.companyType;
    vc.phone = self.phone;
    vc.telPhone = self.telPhone;
    vc.areaList = self.areaList;
    vc.baseItemsArr = self.baseItemsArr;
    vc.suppleListArr = self.suppleListArr;
    vc.calculatorTempletModel = self.calculatorTempletModel;
    vc.constructionCase = self.constructionCase;
    vc.companyId = self.companyId;
    vc.topCalculatorImageArr = self.topCalculatorImageArr;
    vc.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    vc.companyDic = self.companyDic;
    vc.code = self.code;
    vc.teamType = [NSString stringWithFormat:@"%ld",(long)self.teamType];
    vc.dispalyNum = self.dispalyNum;
    vc.origin = self.origin;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter

- (UIView *)topV {
    if (!_topV) {
        _topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth-20, 120)];
        _topV.backgroundColor = White_Color;
        _topV.layer.borderWidth = 8;
        _topV.layer.borderColor = kBackgroundColor.CGColor;
        
        [_topV addSubview:self.photoImg];
        [_topV addSubview:self.companyName];
        [_topV addSubview:self.caseNum];
        [_topV addSubview:self.caseNumL];
        [_topV addSubview:self.addressNum];
        [_topV addSubview:self.addressNumL];
        [_topV addSubview:self.commentNum];
        [_topV addSubview:self.commentNumL];
    }
    return _topV;
}

- (UIImageView *)photoImg {
    
    if (!_photoImg) {
        
        _photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, self.topV.height-15*2, self.topV.height-15*2)];
    }
    return _photoImg;
}

- (UILabel *)companyName {
    if (!_companyName) {
        _companyName = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.top, 200, 30)];
        _companyName.textColor = Black_Color;
        _companyName.font = [UIFont systemFontOfSize:20];
        _companyName.textAlignment = NSTextAlignmentLeft;
        _companyName.text = @"";
    }
    return _companyName;
}


- (UILabel *)caseNum {
    if (!_caseNum) {
        _caseNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.bottom-20, 40, 20)];
        _caseNum.textColor = Black_Color;
        _caseNum.font = [UIFont systemFontOfSize:14];
        _caseNum.textAlignment = NSTextAlignmentLeft;
        _caseNum.text = @"案例:";
    }
    return _caseNum;
}

- (UILabel *)caseNumL {
    if (!_caseNumL) {
        _caseNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right+5, self.caseNum.top, 50, 20)];
        _caseNumL.textColor = [UIColor redColor];
        _caseNumL.font = [UIFont systemFontOfSize
                          :14];
        _caseNumL.textAlignment = NSTextAlignmentLeft;
        _caseNumL.text = @"";
    }
    return _caseNumL;
}

- (UILabel *)addressNum {
    if (!_addressNum) {
        _addressNum = [[UILabel alloc]initWithFrame:CGRectMake(self.caseNumL.right, self.caseNumL.top, 40, 20)];
        _addressNum.textColor = Black_Color;
        _addressNum.font = [UIFont systemFontOfSize:14];
        _addressNum.textAlignment = NSTextAlignmentLeft;
        _addressNum.text = @"工地:";
    }
    return _addressNum;
}

- (UILabel *)addressNumL {
    if (!_addressNumL) {
        _addressNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.addressNum.right+5, self.addressNum.top, 50, 20)];
        _addressNumL.textColor = [UIColor redColor];
        _addressNumL.font = [UIFont systemFontOfSize
                             :14];
        _addressNumL.textAlignment = NSTextAlignmentLeft;
        _addressNumL.text = @"";
    }
    return _addressNumL;
}

- (UILabel *)commentNum {
    if (!_commentNum) {
        _commentNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.caseNum.top-20-10, 40, 20)];
        _commentNum.textColor = Black_Color;
        _commentNum.font = [UIFont systemFontOfSize:14];
        _commentNum.textAlignment = NSTextAlignmentLeft;
        _commentNum.text = @"好评:";
    }
    return _commentNum;
}

- (UILabel *)commentNumL {
    if (!_commentNumL) {
        _commentNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right + 5, self.commentNum.top, 50, 20)];
        _commentNumL.textColor = [UIColor redColor];
        _commentNumL.font = [UIFont systemFontOfSize
                             :14];
        _commentNumL.textAlignment = NSTextAlignmentLeft;
        _commentNumL.text = @"";
    }
    return _commentNumL;
}

- (UIView *)bottomV {
    
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, BLEJHeight-self.topV.bottom)];
        _bottomV.backgroundColor = White_Color;
        [_bottomV addSubview:self.titleL];
    }
    return _bottomV;
}

- (UILabel *)titleL {
    
    if (!_titleL) {
        
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH,30)];
        _titleL.textColor = COLOR_BLACK_CLASS_9;
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textAlignment = NSTextAlignmentCenter;
        
        NSString *str;
        if (self.teamType == 1010) {
            
            str = @"设计师简介";
        } else if (self.teamType == 1011) {
            
            str = @"工长简介";
        } else if (self.teamType == 1006) {
            
            str = @"监理简介";
        } else {
            
            str = @"工人简介";
        }
        _titleL.text = str;
    }
    
    return _titleL;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH,kSCREEN_HEIGHT - 64 - _footHeight - 5) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH,kSCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];

        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


#pragma mark 底部打电话预约和喊装修
- (void)creatFootView {
    
    bottomView *bootomView  = [[bottomView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 44, kSCREEN_WIDTH, self.footHeight)];
    //预约
    [bootomView.idecorationButton setTitle:@"我要预约" forState:UIControlStateNormal];
    [bootomView.idecorationButton addTarget:self action:@selector(idecoration) forControlEvents:UIControlEventTouchUpInside];
    //咨询
    [bootomView.callButton setTitle:@"电话咨询" forState:UIControlStateNormal];
    [bootomView.callButton addTarget:self action:@selector(callOthers) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bootomView];
    
}

#pragma mark - 添加底部视图
- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
    if (self.isShop == NO) {
        
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
        
    } else {
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, bottomView.height)];
        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:phoneBtn];
        
        UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, BLEJWidth - phoneBtn.right, bottomView.height)];
        appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        appointmentBtn.backgroundColor = kMainThemeColor;
        [appointmentBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [appointmentBtn setTitle:@"在线预约" forState:UIControlStateNormal];
        [appointmentBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:appointmentBtn];
    }
}

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    [self.phoneArr removeAllObjects];
    
    if (!(!self.companyDic || self.companyDic[@"companyLandline"] == nil || [self.companyDic[@"companyLandline"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyLandline"]];
    }
    
    if (!(!self.companyDic || self.companyDic[@"companyPhone"] == nil || [self.companyDic[@"companyPhone"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyPhone"]];
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


#pragma mark - 店铺预约
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
            VC.baseItemsArr = self.baseItemsArr;
            VC.origin = self.origin;
            VC.suppleListArr = self.suppleListArr;
            VC.calculatorModel = self.calculatorTempletModel;
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
    decoration.areaList = self.areaList;
    decoration.companyType = @"1018";
    [self.navigationController pushViewController:decoration animated:YES];
}

#pragma mark 公司预约
- (void)idecoration {

//    decorationViewController *decoration = [[decorationViewController alloc]init];
//    decoration.companyID = self.companyId;
//    decoration.areaList = self.areaList;
//    [self.navigationController pushViewController:decoration animated:YES];
    
    DecorateNeedViewController *decoration = [[DecorateNeedViewController alloc]init];
    decoration.companyID = self.companyId;
    decoration.areaList = self.areaList;
    decoration.companyType = @"1018";
    [self.navigationController pushViewController:decoration animated:YES];
    

}

#pragma mark 在线咨询
- (void)callOthers {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
     UIAlertAction *action2 = [UIAlertAction actionWithTitle:self.phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self callPhone:self.phone];
     }];
     UIAlertAction *action3 = [UIAlertAction actionWithTitle:self.telPhone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self callPhone:self.telPhone];
     }];
    
    [alert addAction:action1];
    
    [alert addAction:action2];
    
    if (self.telPhone.length > 0) {
       [alert addAction:action3];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)callPhone:(NSString *)phone {

    NSString *string = [NSString stringWithFormat:@"tel:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
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

@end
