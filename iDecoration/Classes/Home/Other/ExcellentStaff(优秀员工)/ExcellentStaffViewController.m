//
//  ExcellentStaffViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ExcellentStaffViewController.h"

#import "ExcellentStaffScrollView.h"
#import <WMPageController/WMPageController.h>
#import "StaffPageViewController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateNeedViewController.h"
#import "BLEJBudgetGuideController.h"
#import "DecorateCompletionViewController.h"


#define kMaxOffsetY  120

@interface ExcellentStaffViewController ()<UIScrollViewDelegate, WMPageControllerDelegate, WMPageControllerDataSource, UIActionSheetDelegate>
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) ExcellentStaffScrollView *containerScrollView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL canLeaveTop;


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


@property(nonatomic,assign)NSInteger  footHeight;
@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@end

@implementation ExcellentStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优秀员工";
    
    self.phoneArr = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
    [self setupView];
    [self getDate];
    [self addBottomView];
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
//     if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1065"] || [self.companyType isEqualToString:@"1064"]) {
//    } else {
//        
//        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth * 0.5, bottomView.height)];
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


- (void)didClickAppointmentBtn:(UIButton *)btn {// 预约
    
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
//          if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
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
    decoration.areaList = self.areaList;
    decoration.companyType = @"1018";
    [self.navigationController pushViewController:decoration animated:YES];
}

#pragma mark 公司预约
- (void)idecoration {
    
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupView {
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
        make.top.equalTo(self.navigationController.navigationBar.bottom);
    }];
    [self.containerScrollView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.containerScrollView);
        make.width.equalTo(self.containerScrollView);
        make.height.mas_equalTo(120);
    }];
    [self.containerScrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.containerScrollView);
        make.width.equalTo(self.containerScrollView);
        make.height.mas_equalTo(kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom);
    }];
    [self.contentView addSubview:self.pageController.view];
    self.pageController.viewFrame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom-120);
}


#pragma mark - notification

-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
        _canLeaveTop = YES;
//        self.containerScrollView.scrollEnabled = YES;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat maxOffsetY = kMaxOffsetY;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>=maxOffsetY) {
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        //NSLog(@"滑动到顶端");
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeGoTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
        _canScroll = NO;
    } else {
        _canScroll = YES;
        //NSLog(@"离开顶端");
        if (!_canScroll && _canLeaveTop) {
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        }
    }
}

// 获取头部数据
- (void)getDate {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASEURL, @"constructionPerson/v2/teamPersonInf.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.companyId forKey:@"companyId"];
    [paramDic setObject:@"1010" forKey:@"teamType"];
    [paramDic setObject:@"1" forKey:@"page"];
    [paramDic setObject:@"999" forKey:@"pageSize"];
    [paramDic setObject:@"1" forKey:@"firstLoad"];
    
    [NetManager afGetRequest:urlString parms:paramDic finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSDictionary * dict = responseObj[@"data"][@"companyinfrom"];
            
            [self.photoImg sd_setImageWithURL:[NSURL URLWithString:dict[@"companyLogo"]]];
            self.companyName.text = dict[@"companyName"];
            
            self.constructionNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"caseTotla"]];
            self.dispalyNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"constructionTotal"]];
            self.numLabel3.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"merchandiesCount"]];
            self.numLabel4.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"displayNumbers"]];
            
        } else {
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - WMPageController
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    StaffPageViewController *guanliVC = [[StaffPageViewController alloc] init];
    guanliVC.companyId = self.companyId;
    guanliVC.teamType = @"-3"; //  -3管理    1010:设计师   -2:业务员  1011：工长    1006：监理;  1025：施工团队,，
    guanliVC.titleStr = @"管理";
    guanliVC.isShop = self.isShop;
    guanliVC.companyId = self.companyId;
    guanliVC.companyType = self.companyType;
    guanliVC.phone = self.phone;
    guanliVC.telPhone = self.telPhone;
    guanliVC.areaList = self.areaList;
    guanliVC.baseItemsArr = self.baseItemsArr;
    guanliVC.suppleListArr = self.suppleListArr;
    guanliVC.calculatorTempletModel = self.calculatorTempletModel;
    guanliVC.constructionCase = self.constructionCase;
    guanliVC.companyId = self.companyId;
    guanliVC.topCalculatorImageArr = self.topCalculatorImageArr;
    guanliVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    guanliVC.companyDic = self.companyDic;
    guanliVC.code = self.code;
    guanliVC.dispalyNum = self.dispalyNum;
    guanliVC.nav = (SNNavigationController *)self.navigationController;
    
    StaffPageViewController *shejishiVC = [[StaffPageViewController alloc] init];
    shejishiVC.companyId = self.companyId;
    shejishiVC.teamType = @"1010";
    shejishiVC.titleStr = @"设计师";
    shejishiVC.isShop = self.isShop;
    shejishiVC.companyId = self.companyId;
    shejishiVC.companyType = self.companyType;
    shejishiVC.phone = self.phone;
    shejishiVC.telPhone = self.telPhone;
    shejishiVC.areaList = self.areaList;
    shejishiVC.baseItemsArr = self.baseItemsArr;
    shejishiVC.suppleListArr = self.suppleListArr;
    shejishiVC.calculatorTempletModel = self.calculatorTempletModel;
    shejishiVC.constructionCase = self.constructionCase;
    shejishiVC.companyId = self.companyId;
    shejishiVC.topCalculatorImageArr = self.topCalculatorImageArr;
    shejishiVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    shejishiVC.companyDic = self.companyDic;
    shejishiVC.code = self.code;
    shejishiVC.dispalyNum = self.dispalyNum;
    shejishiVC.nav = (SNNavigationController *)self.navigationController;
    
    
    StaffPageViewController *yewuyaunVC = [[StaffPageViewController alloc] init];
    yewuyaunVC.companyId = self.companyId;
    yewuyaunVC.teamType = @"-2";
    yewuyaunVC.titleStr = @"业务员";
    yewuyaunVC.isShop = self.isShop;
    yewuyaunVC.companyId = self.companyId;
    yewuyaunVC.companyType = self.companyType;
    yewuyaunVC.phone = self.phone;
    yewuyaunVC.telPhone = self.telPhone;
    yewuyaunVC.areaList = self.areaList;
    yewuyaunVC.baseItemsArr = self.baseItemsArr;
    yewuyaunVC.suppleListArr = self.suppleListArr;
    yewuyaunVC.calculatorTempletModel = self.calculatorTempletModel;
    yewuyaunVC.constructionCase = self.constructionCase;
    yewuyaunVC.companyId = self.companyId;
    yewuyaunVC.topCalculatorImageArr = self.topCalculatorImageArr;
    yewuyaunVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    yewuyaunVC.companyDic = self.companyDic;
    yewuyaunVC.code = self.code;
    yewuyaunVC.dispalyNum = self.dispalyNum;
    yewuyaunVC.nav = (SNNavigationController *)self.navigationController;
    
    StaffPageViewController *gongzhangVC = [[StaffPageViewController alloc] init];
    gongzhangVC.companyId = self.companyId;
    gongzhangVC.teamType = @"1011";
    gongzhangVC.titleStr = @"工长";
    gongzhangVC.isShop = self.isShop;
    gongzhangVC.companyId = self.companyId;
    gongzhangVC.companyType = self.companyType;
    gongzhangVC.phone = self.phone;
    gongzhangVC.telPhone = self.telPhone;
    gongzhangVC.areaList = self.areaList;
    gongzhangVC.baseItemsArr = self.baseItemsArr;
    gongzhangVC.suppleListArr = self.suppleListArr;
    gongzhangVC.calculatorTempletModel = self.calculatorTempletModel;
    gongzhangVC.constructionCase = self.constructionCase;
    gongzhangVC.companyId = self.companyId;
    gongzhangVC.topCalculatorImageArr = self.topCalculatorImageArr;
    gongzhangVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    gongzhangVC.companyDic = self.companyDic;
    gongzhangVC.code = self.code;
    gongzhangVC.dispalyNum = self.dispalyNum;
    gongzhangVC.nav = (SNNavigationController *)self.navigationController;
    
    StaffPageViewController *jianliVC = [[StaffPageViewController alloc] init];
    jianliVC.companyId = self.companyId;
    jianliVC.teamType = @"1006";
    jianliVC.titleStr = @"监理";
    jianliVC.isShop = self.isShop;
    jianliVC.companyId = self.companyId;
    jianliVC.companyType = self.companyType;
    jianliVC.phone = self.phone;
    jianliVC.telPhone = self.telPhone;
    jianliVC.areaList = self.areaList;
    jianliVC.baseItemsArr = self.baseItemsArr;
    jianliVC.suppleListArr = self.suppleListArr;
    jianliVC.calculatorTempletModel = self.calculatorTempletModel;
    jianliVC.constructionCase = self.constructionCase;
    jianliVC.companyId = self.companyId;
    jianliVC.topCalculatorImageArr = self.topCalculatorImageArr;
    jianliVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    jianliVC.companyDic = self.companyDic;
    jianliVC.code = self.code;
    jianliVC.dispalyNum = self.dispalyNum;
    jianliVC.nav = (SNNavigationController *)self.navigationController;
    
    
    StaffPageViewController *gongrenVC = [[StaffPageViewController alloc] init];
    gongrenVC.companyId = self.companyId;
    gongrenVC.teamType = @"1025";
    gongrenVC.titleStr = @"工人";
    gongrenVC.isShop = self.isShop;
    gongrenVC.companyId = self.companyId;
    gongrenVC.companyType = self.companyType;
    gongrenVC.phone = self.phone;
    gongrenVC.telPhone = self.telPhone;
    gongrenVC.areaList = self.areaList;
    gongrenVC.baseItemsArr = self.baseItemsArr;
    gongrenVC.suppleListArr = self.suppleListArr;
    gongrenVC.calculatorTempletModel = self.calculatorTempletModel;
    gongrenVC.constructionCase = self.constructionCase;
    gongrenVC.companyId = self.companyId;
    gongrenVC.topCalculatorImageArr = self.topCalculatorImageArr;
    gongrenVC.bottomCalculatorImageArr = self.bottomCalculatorImageArr;
    gongrenVC.companyDic = self.companyDic;
    gongrenVC.code = self.code;
    gongrenVC.dispalyNum = self.dispalyNum;
    gongrenVC.nav = (SNNavigationController *)self.navigationController;
    
    return @[guanliVC, shejishiVC, yewuyaunVC, gongzhangVC, jianliVC, gongrenVC][index];

    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

#pragma mark - lazyMethod
- (WMPageController *)pageController {
    if (!_pageController) {
        _pageController = [[WMPageController alloc] init];
        _pageController.menuHeight = 40;
        _pageController.menuBGColor = kBackgroundColor;
        _pageController.titleSizeNormal = 16;
        _pageController.titleSizeSelected = 16;
        _pageController.titleColorSelected = kMainThemeColor;
        _pageController.automaticallyCalculatesItemWidths = YES;
//        _pageController.cachePolicy = WMPageControllerCachePolicyDisabled;
        _pageController.selectIndex = 0;
        _pageController.delegate = self;
        _pageController.dataSource = self;
    }
    return _pageController;
}

- (ExcellentStaffScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[ExcellentStaffScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.bounces = YES;
    }
    return _containerScrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}


- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"管理", @"设计师", @"业务员", @"工长", @"监理", @"工人"];
    }
    return _titles;
}


- (UIView *)topView {
    if (!_topView) {
        _topView = [self topV];
    }
    return _topView;
}
#pragma mark - topView
- (UIView *)topV {
    if (!_topV) {
        _topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth-20, 120)];
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
