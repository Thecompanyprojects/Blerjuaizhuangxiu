//
//  productListViewController.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "productListViewController.h"
#import "goodsModel.h"
#import "goodsCollectionViewCell.h"
#import "ZCHGoodsDetailViewController.h"
#import "DecorateNeedViewController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "BLEJBudgetGuideController.h"

@interface productListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UIActionSheetDelegate>
@property(nonatomic,strong)UICollectionView *collection;

@property(nonatomic,strong)NSMutableArray *goodListArray;
@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (strong, nonatomic) DecorateInfoNeedView *infoView;


@property (nonatomic, assign) BOOL hasSupport; // 是否点赞
@property (nonatomic, strong) UIButton *supportButton;
@property (strong, nonatomic) UILabel *goodCountLabel; // 底部点赞数量

@end

@implementation productListViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"商品列表";
    self.phoneArr = [NSMutableArray array];
    [self creatCollectionView];
    [self addBottomView];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasSupport = NO;
    if (self.supportButton) {
        [self.supportButton setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
    }
}

// 设置浏览量视图
- (UIView *)setScanFooterView {
    
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
    [footView addSubview:displayCount];
    displayCount.textAlignment = NSTextAlignmentRight;
    displayCount.font = [UIFont systemFontOfSize:16];
    displayCount.textColor = [UIColor darkGrayColor];
    displayCount.text = @"9999";
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
    goodCount.text = @"9999";
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
    
    return footView;
}
#pragma mark - 点赞按钮的点击事件
- (void)didClickGoodBtn:(UIButton *)btn {
    
    if (!_hasSupport) {
        _hasSupport = YES;
        
        [btn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        self.goodCountLabel.text = [NSString stringWithFormat:@"%ld", [self.goodCountLabel.text integerValue] + 1];
        [self.goodCountLabel sizeToFit];
        
        //        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        //        NSString *apiStr = [BASEURL stringByAppendingString:@"company/like.do"];
        //        NSDictionary *param = @{
        //                                @"agencyId" : @(user.agencyId),
        //                                @"companyId" : self.companyID
        //                                };
        //        [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        //        } failed:^(NSString *errorMsg) {
        //        }];
    }
    
}
#pragma mark - 投诉按钮的点击事件
- (void)didClickComplainBtn:(UIButton *)btn {
    
    //    ComplainViewController *ComplainVC = [UIStoryboard storyboardWithName:@"ComplainViewController" bundle:nil].instantiateInitialViewController;
    //    ComplainVC.companyID = self.companyID.integerValue;
    //    [self.navigationController pushViewController:ComplainVC animated:YES];
}


- (void)creatCollectionView {

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
//    flow.itemSize = CGSizeMake((kSCREEN_WIDTH - 30)/3 , (kSCREEN_WIDTH/4) * 2);
    flow.itemSize = CGSizeMake((kSCREEN_WIDTH - 30)/3 , (kSCREEN_WIDTH - 30)/3 * 1.4);
    
    flow.footerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 100);
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 50) collectionViewLayout:flow];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.alwaysBounceVertical = YES;
    

    [self.view addSubview:self.collection];
    
    self.collection.backgroundColor = [UIColor whiteColor];
    //cell 注册
    [self.collection  registerNib:[UINib nibWithNibName:@"goodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"good"];
    [self.collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.goodListArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    goodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"good" forIndexPath:indexPath];
    cell.model = self.goodListArray[indexPath.row];
    return cell;
}


- ( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
//    {top, left, bottom, right}
    return UIEdgeInsetsMake (10 ,5, 50, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"forIndexPath:indexPath];
//    [footerView addSubview:[self setScanFooterView]];
    
    return footerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 100);
}

- (void)requestData {
    
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    NSInteger agencId;
    if (isLogin) {
        UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        agencId = model.agencyId;
    } else {
        agencId = 0;
    }
    
    NSString *requestString = [BASEURL stringByAppendingString:@"merchandies/list.do"];
    NSDictionary *param = @{@"merchantId": @(self.shopid.integerValue),
                            @"agencysId": @(agencId),
                            @"type": @(1)
                            };
    
    self.goodListArray = [NSMutableArray array];
    
    [NetManager afPostRequest:requestString parms:param finished:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1000) {
           
            for (NSDictionary *dic in responseObj[@"list"]) {
                
                goodsModel *model = [[goodsModel alloc]init];
                [model yy_modelSetWithJSON:dic];
                [self.goodListArray addObject:model];
            }
        }
        
        if (self.goodListArray.count == 0) {
            
         [[UIApplication sharedApplication].keyWindow hudShowWithText:@"暂无商品"];
        }
        
        [self.collection reloadData];
    } failed:^(NSString *errorMsg) {

        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHGoodsDetailViewController *VC = [[ZCHGoodsDetailViewController alloc] init];
    VC.goodModel = self.goodListArray[indexPath.row];
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 添加底部视图
- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
    if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1065"] || [self.companyType isEqualToString:@"1064"]) {
        
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
        [houseBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - 预约
- (void)didClickAppointmentBtn:(UIButton *)btn {// 预约
    
    // 在线预约浏览量
    [NSObject needDecorationStatisticsWithConpanyId:self.shopid];
    
//    DecorateNeedViewController *vc = [[DecorateNeedViewController alloc] init];
//    vc.companyType = self.dataDic[@"companyType"];
//    vc.companyID = self.shopid;
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
}

- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    
    // 装修报价
    if (self.code == 1000) {
        
       
            
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.baseItemsArr = self.baseItemsArr;
            VC.origin = @"0";
            VC.suppleListArr = self.suppleListArr;
            VC.calculatorModel = self.calculatorTempletModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.shopid;
            VC.topImageArr = self.topCalculatorImageArr;
            VC.bottomImageArr = self.bottomCalculatorImageArr;
            VC.isConVip = self.companyDic[@"conVip"];
            [self.navigationController pushViewController:VC animated:YES];
//         if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
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
    decoration.companyID = self.shopid;
    decoration.areaList = self.areaList;
    decoration.companyType = self.companyType;
    [self.navigationController pushViewController:decoration animated:YES];
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
    [param setObject:self.dataDic[@"companyId"] forKey:@"companyId"];
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.infoView.vertifyCodeTF.text forKey:@"phoneCode"];
    [dic setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text forKey:@"fullName"];
    [dic setObject:self.dataDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.dataDic[@"companyType"] forKey:@"companyType"];
    [dic setObject:@"0" forKey:@"province"];
    [dic setObject:@"0" forKey:@"county"];
    [dic setObject:@"0" forKey:@"city"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
    NSString *url = [BASEURL stringByAppendingString:@"callDecoration/save.do"];
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
                completionVC.companyType = weakSelf.dataDic[@"companyType"];
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

@end
