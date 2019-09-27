//
//  NewsActivityShowController.m
//  iDecoration
//
//  Created by sty on 2017/12/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NewsActivityShowController.h"
#import "LoginViewController.h"
#import "DesignCaseListModel.h"
#import "VoteOptionModel.h"
#import "senceWebViewController.h"
#import "ZCHCalculatorPayController.h"
#import "ActivityQRCodeShareView.h"
#import "NSObject+CompressImage.h"
#import "EditNewsActivityController.h"
#import "ZCHNewsActivityController.h"
#import "NewsActivityManageController.h"

#import "ZCHProductCouponShowController.h"
#import "ZCHPublicWebViewController.h"
#import "STYProductCouponDetailController.h"
#import "SSPopup.h"
#import "WSRedPacketView.h"
#import "WSRewardConfig.h"
#import "MyCircleController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MyBeautifulArtShowController.h"
#import <CoreLocation/CoreLocation.h>
#import "VipGroupViewController.h"
#import "ActivitySignUpView.h"
#import "ActivityPayViewController.h"
#import "MyOrderViewController.h"
#import "NewsleavemessageVC.h"
#import "LoginViewController.h"
#import "newscomplaintsVC.h"

@interface NewsActivityShowController ()<UIWebViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,SSPopupDelegate,CLLocationManagerDelegate>{
    
    UIImage *personImg;
    UIImage *companyImg;
    
    NSString *_activityName;
    NSString *_activityAdress;
    NSString *_cost;
    NSString *_costName;
    
    NSInteger tempOrder;
    NSInteger templateType;
    NSInteger interimType;//临时的模版type
    
    NSString *tempStartTime;//临时的活动时间(时间戳)
    
    BOOL isFromYellow;
    NSInteger _tempAgenceId;
    
    
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder *_geocoder;//初始化地理编码器
    
    double myLongitude;//经度
    double myLatitude;//纬度
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *phoneConsultBtn;//咨询按钮
@property (nonatomic, strong) UIButton *signUpBtn;//报名按钮
@property (nonatomic, strong) UIButton *shareBtn;


@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *textFieldImageVerificationCode;//图形验证码
@property (nonatomic, strong) UITextField *codeTextF;//验证码
@property (nonatomic, strong) UIButton *codeBtn;//发送验证码按钮

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *phoneArr;

@property (nonatomic, strong) UIView *shadowV;
@property (nonatomic, strong) UIView *addMuchUseAlertV;

@property (nonatomic, strong) NSMutableArray *customStrArray;
@property (nonatomic, strong) NSMutableArray *customBoolArray;

//模版
@property (nonatomic, strong) UIButton *TemplateBtn;//模版
@property (nonatomic, strong) UIButton *textUpOrDownBtn;//字上图下
@property (nonatomic, strong) UIButton *sucessBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *bottomScrView;
@property (nonatomic, strong) UIView *bottomTypeView;
@property (nonatomic, strong) NSMutableArray *templateArray;
@property (nonatomic, strong) NSMutableArray *typeArray;


@property (nonatomic, strong) UIButton *redLittleBtn;//红包
@property (nonatomic, strong) UIButton *redDeleteLittleBtn;//

@property (nonatomic, strong) UIImageView *redBigImgV;//红包
@property (nonatomic, strong) UIButton *redDeleteBigBtn;//

// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;

// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) ActivityQRCodeShareView *TwoDimensionCodeView;
//bys声明context
@property (strong, nonatomic) JSContext *context;

@property (nonatomic, strong) ActivitySignUpView *signUpView;
@property (nonatomic, strong) UIView *paySuccessBgView;

@property (nonatomic,assign) BOOL isshoucang;
@property (nonatomic,copy) NSString *collectionId;

@end

@implementation NewsActivityShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if (self.activityType==2) {
        self.title = @"美   文";
    }
    else{
        self.title = @"新闻活动";
    }
    
    self.customStrArray = [NSMutableArray array];
    self.customBoolArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.redArray = [NSMutableArray array];
    
    self.templateArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    self.phoneArr = [NSMutableArray array];
    
    NSArray *controllerArray = self.navigationController.childViewControllers;
    NSInteger arrayCount = controllerArray.count;
    
    UIViewController *vc = controllerArray[arrayCount-2];
    
    if ([vc isKindOfClass:[ZCHNewsActivityController class]]||[vc isKindOfClass:[NewsActivityManageController class]]) {
        isFromYellow = NO;
        
    }
    else{
        isFromYellow = YES;
        
    }
    
    templateType = -1; //默认是-1
    interimType = templateType;
    [self requestActivityDetail:self.designsId type:self.activityType];
    
    if (!self.order) {
        [self.textUpOrDownBtn setTitle:@"图上字下" forState:UIControlStateNormal];
    }
    else{
        [self.textUpOrDownBtn setTitle:@"字上图下" forState:UIControlStateNormal];
    }
    
    tempOrder = self.order;
    _tempAgenceId = 0;
    _cost = @"";
    _costName = @"";
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld",BASEURL,(long)self.designsId,(long)user.agencyId,(long)3];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
    [self isshoucangclick];
    
    if (isFromYellow){
        
        // 设置导航栏最右侧的按钮
        UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        moreBtn.frame = CGRectMake(0, 0, 44, 44);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"threemorewithe"]];
        [moreBtn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(25, 25));
        }];
        [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
        
        [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
        
        self.shareBtn.hidden = YES;
    }
    else{

        self.shareBtn.hidden = NO;
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSInteger creatInt = [self.agencysId integerValue];
        //创建人和经理总经理可以编辑
        if (self.activityType==2&&((creatInt==user.agencyId)||self.jobTag==1002||self.jobTag==1003||self.jobTag==1027)) {
            // 设置导航栏最右侧的按钮
            UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            editBtn.frame = CGRectMake(0, 0, 44, 44);
            [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        }

        if(self.activityType==3){
            UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            editBtn.frame = CGRectMake(0, 0, 44, 44);
            [editBtn setTitle:@"分享" forState:UIControlStateNormal];
            [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        }
        
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"refreshNewsActivityList" object:nil];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

#pragma mark - 判断是否收藏

-(void)isshoucangclick
{
    self.collectionId = [NSString new];
    NSString *url = [BASEURL stringByAppendingString:GET_SELECTSHOUCANG];
    NSString *relId = [NSString stringWithFormat:@"%ld",self.designsId];
    NSString *agencysId = @"";
    
    BOOL isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (isLogined) {
        agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    }
    else
    {
        agencysId = @"";
    }

    NSString *type = @"4";
    NSDictionary *para = @{@"relId":relId,@"agencysId":agencysId,@"type":type};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.isshoucang = YES;
            self.collectionId = [responseObj objectForKey:@"collectionId"];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1002) {
            self.isshoucang = NO;
            self.collectionId = [responseObj objectForKey:@"collectionId"];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 三点按钮
- (void)moreBtnClicked:(UIButton *)sender {
    
    // 弹出的自定义视图
    NSArray *array;
    
    if (self.isshoucang) {
        array = @[@"取消收藏",@"分享"];
    }
    else
    {
        array = @[@"收藏", @"分享"];
    }
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(kSCREEN_WIDTH-100, kNaviBottom, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        
        if (index==0) {
            
            if (self.isshoucang) {
                NSDictionary *para = @{@"collectionId":self.collectionId};
                NSString *url = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
                [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                    if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"取消收藏成功" controller:self sleep:1.5];
                        self.isshoucang = NO;
                    }
                } failed:^(NSString *errorMsg) {
                    
                }];
            }
            else
            {
                BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
                if (!isLogin) { // 未登录
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
                    return ;
                }
                else
                {
                    NSString *relId = [NSString stringWithFormat:@"%ld",self.designsId];
                    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
                    NSString *type = @"4";
                    //0:公司 1:店铺 2:商品 3:工地   4:美文  5:名片
                    NSDictionary *para = @{@"relId":relId,@"agencysId":agencysId,@"type":type};
                    NSString *url = [BASEURL stringByAppendingString:POST_ADDSHOUCANG];
                    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                            self.isshoucang = YES;
                            [[PublicTool defaultTool] publicToolsHUDStr:@"收藏成功" controller:self sleep:1.5];
                        }
                    } failed:^(NSString *errorMsg) {
                        
                    }];
                }
            }
        }
        if (index==1) {
            [self shareClick];
        }
        
    } animated:YES];
    
}


#pragma mark - action

-(void)setUI{
    [self.view addSubview:self.webView];
    
    if (self.activityType==3){
        [self.view addSubview:self.bottomV];
        [self.bottomV addSubview:self.phoneConsultBtn];
        [self.bottomV addSubview:self.signUpBtn];
    }
    else{
        [self.view addSubview:self.shareBtn];
        
    }
    
    [self.view addSubview:self.TemplateBtn];
    if (isFromYellow) {
        self.TemplateBtn.hidden = YES;
    }
    else{
        //创建人和经理总经理可以编辑
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSInteger creatInt = [self.agencysId integerValue];
        if ((creatInt==user.agencyId)||self.jobTag==1002||self.jobTag==1003||self.jobTag==1027){
            self.TemplateBtn.hidden = NO;
        }
        else{
            self.TemplateBtn.hidden = YES;
        }
    }
    
    [self.view addSubview:self.redLittleBtn];
    [self.view addSubview:self.redDeleteLittleBtn];
    [self.view addSubview:self.redBigImgV];

    self.redBigImgV.hidden = YES;
    self.redDeleteBigBtn.hidden = YES;
    
    [self.view addSubview:self.textUpOrDownBtn];
    [self.view addSubview:self.sucessBtn];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomScrView];
    [self.bottomView addSubview:self.bottomTypeView];
    
    self.textUpOrDownBtn.hidden = YES;
    self.sucessBtn.hidden = YES;
    self.bottomView.hidden = YES;
    
    
    if (self.TemplateBtn.hidden == YES) {
        self.redLittleBtn.hidden = NO;
        self.redDeleteLittleBtn.hidden = NO;
    }
    else{
        self.redLittleBtn.hidden = YES;
        self.redDeleteLittleBtn.hidden = YES;
    }
    
    //没有设置红包的，也不显示
    if (self.redArray.count<=0) {
        self.redLittleBtn.hidden = YES;
        self.redDeleteLittleBtn.hidden = YES;
    }

}

-(void)back{
    [self colseMusic];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 分享

-(void)shareClick{

    if (isFromYellow) {
        _tempAgenceId = 0;
        
        self.shadowView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = NO;
        }];
    }
    else{
        if (self.activityType==2) {
            //美文，直接分享
            _tempAgenceId = 0;
            
            self.shadowView.hidden = NO;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
            } completion:^(BOOL finished) {
                self.shadowView.hidden = NO;
            }];
            
        }
        else{
            //            1公司和员工都没有开通号码通：
            //            只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值
            //
            //            2公司开通 员工没有开通号码通
            //            有公司分享按钮和员工分享按钮，点击员工分享按钮提示继续分享和充值，继续分享后收到的报名信息是隐藏的，经理总经理查看提示该员工没有开通号码通，员工查看提示没有开通号码通。
            //
            //            3公司没有开通 员工开通号码通
            //            只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值。
            //4.都开通
            //都显示
            
            if (!self.calVipTag&&!self.meCalVipTag) {
                
                //只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有开通企业号码通!" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        // 会员套餐
                        VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                        VC.companyId = self.companyId;
                        __weak typeof(self) weakSelf = self;
                        VC.successBlock = ^() {
                            weakSelf.calVipTag = 1;
                            [weakSelf refreshPreviousVc:1];
                        };
                        [self.navigationController pushViewController:VC animated:YES];
                        
                    }
                    if (buttonIndex == 2) {
                        
                        
                        _tempAgenceId = 0;
                        
                        self.shadowView.hidden = NO;
                        
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                        } completion:^(BOOL finished) {
                            self.shadowView.hidden = NO;
                        }];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通",@"继续分享", nil];
                
                [alertView show];
                
                
            }
            else if(self.calVipTag&&!self.meCalVipTag){
                
                if (self.shadowView.hidden == NO) {
                    [UIView animateWithDuration:0.25 animations:^{
                        self.bottomShareView.blej_y = BLEJHeight;
                    } completion:^(BOOL finished) {
                        self.shadowView.hidden = YES;
                    }];
                }
                
                //有公司分享按钮和员工分享按钮，点击员工分享按钮提示继续分享和充值，继续分享后收到的报名信息是隐藏的，经理总经理查看提示该员工没有开通号码通，员工查看提示没有开通号码通。
                SSPopup* selection=[[SSPopup alloc]init];
                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                
                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                selection.SSPopupDelegate=self;
                [self.view addSubview:selection];
                
                __weak typeof(self) weakSelf = self;
                NSArray *QArray = @[@"公司",@"员工"];
                [selection CreateTableview:QArray withTitle:@"分享类型" setCompletionBlock:^(int tag) {
                    YSNLog(@"%d",tag);
                    if (tag==0) {
                        
                        
                        _tempAgenceId = 0;
                        
                        weakSelf.shadowView.hidden = NO;
                        
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            weakSelf.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                        } completion:^(BOOL finished) {
                            weakSelf.shadowView.hidden = NO;
                        }];
                    }
                    if (tag==1) {
                        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有开个人号码通!" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                            
                            if (buttonIndex == 1) {
                                
                                ZCHCalculatorPayController *payVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
                                payVC.companyId = @"0";
                                payVC.type = @"0";
                                payVC.isNotCompany = YES;
                                __weak typeof(self) weakSelf = self;
                                payVC.refreshBlock = ^() {
                                    weakSelf.meCalVipTag = 1;
                                    //
                                    [weakSelf refreshPreviousVc:2];
                                };
                                [self.navigationController pushViewController:payVC animated:YES];
                            }
                            if (buttonIndex == 2) {
                                
                                UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                                _tempAgenceId = user.agencyId;
                                
                                self.shadowView.hidden = NO;
                                
                                [UIView animateWithDuration:0.25 animations:^{
                                    
                                    self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                                } completion:^(BOOL finished) {
                                    self.shadowView.hidden = NO;
                                }];
                            }
                        } cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通",@"继续分享", nil];
                        
                        [alertView show];
                    }
                    
                }
                 ];
            }
            else if(!self.calVipTag&&self.meCalVipTag){
                //只有公司分享按钮，员工点击公司分享，提示充值公司号码通会员和继续分享。分享后查看收到的报名信息是隐藏的，点击后提示充值。
                
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有开通企业号码通!" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        // 会员套餐
                        VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                        VC.companyId = self.companyId;
                        __weak typeof(self) weakSelf = self;
                        VC.successBlock = ^() {
                            weakSelf.calVipTag = 1;
                            [weakSelf refreshPreviousVc:1];
                        };
                        [self.navigationController pushViewController:VC animated:YES];
                        
                    }
                    if (buttonIndex == 2) {
                        
                        
                        
                        _tempAgenceId = 0;
                        
                        self.shadowView.hidden = NO;
                        
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                        } completion:^(BOOL finished) {
                            self.shadowView.hidden = NO;
                        }];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"立即开通",@"继续分享", nil];
                
                [alertView show];
            }
            else{
                
                if (self.shadowView.hidden == NO) {
                    [UIView animateWithDuration:0.25 animations:^{
                        self.bottomShareView.blej_y = BLEJHeight;
                    } completion:^(BOOL finished) {
                        self.shadowView.hidden = YES;
                    }];
                }
                
                SSPopup* selection=[[SSPopup alloc]init];
                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                
                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                selection.SSPopupDelegate=self;
                [self.view addSubview:selection];
                
                __weak typeof(self) weakSelf = self;
                NSArray *QArray = @[@"公司",@"员工"];
                [selection CreateTableview:QArray withTitle:@"分享类型" setCompletionBlock:^(int tag) {
                    YSNLog(@"%d",tag);
                    if (tag==0) {
                        
                        _tempAgenceId = 0;
                        
                    }
                    if (tag==1) {
                        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                        _tempAgenceId = user.agencyId;
                        
                    }
                    weakSelf.shadowView.hidden = NO;
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        weakSelf.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
                    } completion:^(BOOL finished) {
                        weakSelf.shadowView.hidden = NO;
                    }];
                }
                 ];
            }
        }
    }
    
}

-(void)refreshPreviousVc:(NSInteger)tag{
    if (self.activityShowBlock) {
        self.activityShowBlock(tag);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self colseMusic];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.musicStyle) {
        [self startMusic];
        
    }

}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL * url = [request URL];

    if ([[url scheme] isEqualToString:@"firstclick"]) {
        NSString *urlStr;
        NSArray *params =[url.query componentsSeparatedByString:@"=="];
        urlStr = [params[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        senceWebViewController *vc = [[senceWebViewController alloc]init];
        vc.isFrom = YES;
        vc.webUrl = urlStr;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    if ([[url scheme] isEqualToString:@"alldesign"]) {
        NSString *urlStr = url.query;
        NSArray *params =[urlStr componentsSeparatedByString:@"&"];
        NSArray *arrayOne = [params[0] componentsSeparatedByString:@"="];
        NSArray *arrayTwo = [params[1] componentsSeparatedByString:@"="];
        NSArray *arrayThree = [params[2] componentsSeparatedByString:@"="];
        NSArray *arrayFour = [params[3] componentsSeparatedByString:@"="];
        
        NSString *myCompanyIdStr = arrayOne[1];
        NSString *myAgencysIdStr = arrayTwo[1];
        NSString *myTypeStr = arrayThree[1];
        NSString *myFlagStr = arrayFour[1];

        MyCircleController *myCirCon = [[MyCircleController alloc]init];
        myCirCon.myAgencysId = myAgencysIdStr;
        myCirCon.myCompanyId = myCompanyIdStr;
        myCirCon.myType = myTypeStr;
        myCirCon.myFlag = myFlagStr;
        myCirCon.myDesignsId = [NSString stringWithFormat:@"%ld",self.designsId];
        myCirCon.isCuste = YES;
        [self.navigationController pushViewController:myCirCon animated:YES];
        
        return NO;
    }
    
    if ([[url scheme] isEqualToString:@"recommenddesign"]) {
        NSString *urlStr = url.query;
        NSArray *params =[urlStr componentsSeparatedByString:@"&"];
        NSArray *arrayOne = [params[0] componentsSeparatedByString:@"="];
        NSInteger myDesignStr = [arrayOne[1] integerValue];
        NewsActivityShowController *myCirCon = [[NewsActivityShowController alloc]init];
        myCirCon.designsId = myDesignStr;
        myCirCon.activityId = @"";
        myCirCon.activityType = 2;
        myCirCon.origin = @"2";
        [self.navigationController pushViewController:myCirCon animated:YES];
        return NO;
    }
    
    if ([[url scheme] isEqualToString:@"starttoactivity"]) {
        NSString *urlStr;
        NSArray *params =[url.query componentsSeparatedByString:@"=="];
        urlStr = [params[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (urlStr.length>0) {
            senceWebViewController *vc = [[senceWebViewController alloc]init];
            vc.isFrom = YES;
            vc.webUrl = urlStr;
            vc.titleStr = @"图片链接";
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
        return NO;
    }
    
    //StartToVideo
    if ([[url scheme] isEqualToString:@"starttovideo"]) {
        
        NSString *urlStr;
        NSArray *params =[url.query componentsSeparatedByString:@"=="];
        urlStr = [params[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        ZCHPublicWebViewController *vc = [[ZCHPublicWebViewController alloc]init];
        vc.titleStr = @"视频";
        vc.webUrl = urlStr;
        vc.isAddBaseUrl = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    //留言
    if ([[url scheme] isEqualToString:@"addmessage"])
    {
        
        NSString *newstr = [NSString stringWithFormat:@"%@",url];
        NSArray *params =[newstr componentsSeparatedByString:@"&"];
        NSArray *arrayOne = [params[0] componentsSeparatedByString:@"="];
        
        NSString *designsId = [arrayOne lastObject];
        NSArray *arrayTwo = [newstr componentsSeparatedByString:@"&agencysId="];
        NSString *agencysId = [arrayTwo lastObject];
        
        BOOL isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
        if (isLogined) {
            NewsleavemessageVC *vc = [NewsleavemessageVC new];
            vc.designsId = designsId;
            vc.agencysId = agencysId;
            vc.type = @"0";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    //广告位
    if ([[url scheme] isEqualToString:@"guanggao"])
    {
        NSString *urlStr = @"";
        NSString *newstr = [NSString stringWithFormat:@"%@",url];
        NSArray *array = [newstr componentsSeparatedByString:@"="]; //从字符A中分隔成2个元素的数组
        urlStr = [array lastObject];
        senceWebViewController *vc = [[senceWebViewController alloc]init];
        vc.isFrom = YES;
        vc.webUrl = urlStr;
        vc.isguanggao = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //投诉
    if ([[url scheme] isEqualToString:@"toshupage"]) {
        
        newscomplaintsVC *vc = [newscomplaintsVC new];
        NSString *newstr = [NSString stringWithFormat:@"%@",url];
        NSArray *params =[newstr componentsSeparatedByString:@"&"];
        NSArray *arrayOne = [params[0] componentsSeparatedByString:@"="];
        NSString *designsId = [arrayOne lastObject];
        vc.companyId = designsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //美文留言回复
    if ([[url scheme] isEqualToString:@"tosavehuifu"]) {
        NSString *newstr = [NSString stringWithFormat:@"%@",url];
        NSArray *params =[newstr componentsSeparatedByString:@"&"];
        NSArray *arrayOne = [params[1] componentsSeparatedByString:@"="];
        
        NSString *designsId = [arrayOne lastObject];
        
        NSArray *arrayTwo = [params[4] componentsSeparatedByString:@"="];
        NSString *messageId = [arrayTwo lastObject];
        
        BOOL isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
        if (isLogined) {
            NewsleavemessageVC *vc = [NewsleavemessageVC new];
            vc.designsId = designsId;
            vc.messageId = messageId;
            vc.type = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    return YES;
}

-(void)startMusic{
    NSString *trigger = @"startMusic()";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

-(void)colseMusic{
    NSString *trigger = @"stopMusic()";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

-(void)editBtnClick:(UIButton *)btn{
    if (isFromYellow) {
        [self shareClick];
    }
    else{
        if (self.activityType==2) {
            //美文：进入编辑页面
            [self turnToActivityDetail:self.designsId type:self.activityType];
        }
        else{
            //活动：进入分享页面
            [self shareClick];
        }
    }
    
    
}

-(void)reloadData{
    [self requestActivityDetail:self.designsId type:self.activityType];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld",BASEURL,(long)self.designsId,(long)user.agencyId,(long)3];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

#pragma mark - 初始化定位
-(void)initLocationService{
    
    _locationManager = [[CLLocationManager alloc]init];
    [_locationManager requestWhenInUseAuthorization];
    //    [_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    _locationManager.delegate = self;
    //设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    [_locationManager startUpdatingLocation];
    
    _geocoder = [[CLGeocoder alloc]init];
}

#pragma mark - 定位的代理方法

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    YSNLog(@"%lu",(unsigned long)locations.count);
    CLLocation *location = locations.lastObject;
    //纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    YSNLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",location.coordinate.longitude,location.coordinate.latitude,location.altitude,location.course,location.speed);
    
    self.redLittleBtn.userInteractionEnabled = YES;
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            YSNLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            //位置名
            YSNLog(@"name,%@",placemark.name);
            //街道
            YSNLog(@"thoroughfare,%@",placemark.thoroughfare);
            //子街道
            YSNLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            //市
            YSNLog(@"locality,%@",placemark.location);
            //区
            YSNLog(@"subLocality,%@",placemark.subLocality);
            //国家
            YSNLog(@"county,%@",placemark.country);
            
            myLongitude = longitude;
            myLatitude = latitude;
            
        }
        else if(error==nil&&[placemarks count]==0){
            YSNLog(@"No results were returned.");
//            [[PublicTool defaultTool] publicToolsHUDStr:@"暂未定位到具体地址" controller:self sleep:1.5];
        }
        else if (error==nil){
            YSNLog(@"An error occurred=%@",error);
//            [[PublicTool defaultTool] publicToolsHUDStr:@"定位失败" controller:self sleep:1.5];
        }
        else{
            YSNLog(@"error");
//            [[PublicTool defaultTool] publicToolsHUDStr:@"定位失败" controller:self sleep:1.5];
        }
        
        
        if (myLongitude<=0||myLatitude<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"定位失败" controller:self sleep:1.5];
        }
        else{
            self.redDeleteBigBtn.hidden = NO;
            WSRedPacketView *packetV = [[WSRedPacketView alloc]initRedPacker];
            packetV.longitude = myLongitude;
            packetV.latitude = myLatitude;
            
            __weak typeof(self) weakSelf = self;
            //查看券详情
            packetV.lookBlock = ^(NSDictionary *dict) {
                STYProductCouponDetailController *vc = [[STYProductCouponDetailController alloc]init];
                if (packetV.modifyTag==1) {
                    vc.couponType = 1;
                }
                else{
                    vc.couponType = 2;
                    vc.giftId = dict[@"giftId"];
                }
                vc.couponAddress = dict[@"exchangeAddress"];
                vc.couponCode = dict[@"receiveCode"];
                vc.startTime = dict[@"startDate"];
                vc.endTime = dict[@"endDate"];
                vc.remark = dict[@"remark"];
                vc.companyLogo = weakSelf.companyLogo;
                vc.companyName = weakSelf.companyName;
                
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            
            //检查红包的个数和类型
            if (self.redArray.count==1) {
                ZCHCouponModel *model = self.redArray.firstObject;
                if ([model.type integerValue]==2) {
                    //礼品券
                    packetV.giftCouponId = model.couponId;
                }
                else{
                    packetV.couponId = model.couponId;
                }
                packetV.companyNameStr = model.companyName;
                packetV.companyLogoStr = model.companyLogo;
            }
            if (self.redArray.count==2) {
                for (ZCHCouponModel *model in self.redArray) {
                    if ([model.type integerValue]==2) {
                        //礼品券
                        packetV.giftCouponId = model.couponId;
                    }
                    else{
                        packetV.couponId = model.couponId;
                    }
                    
                    packetV.companyNameStr = model.companyName;
                    packetV.companyLogoStr = model.companyLogo;
                }
                
            }
            
            
        }
        
    }];
    [manager stopUpdatingLocation];//不用的时候关闭更新位置服务
}

#pragma mark - 模版相关

-(void)resetBottomSrcV{
    CGFloat imgLeft = 5.0f;
    NSInteger imgCount=self.templateArray.count;
    for (int i = 0; i<imgCount; i++) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(imgLeft, 0, 60, self.bottomScrView.height)];
        //        imgV.backgroundColor = Red_Color;
        NSDictionary *dict = self.templateArray[i];
        
        NSString *imgStr = [dict objectForKey:@"templateUrl"];
        [imgV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"edit_standard"]];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(srcBtn:)];
        imgV.tag = i;
        
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:ges];
        if (i==templateType) {
            imgV.layer.masksToBounds = YES;
            imgV.layer.borderColor = Yellow_Color.CGColor;
            imgV.layer.borderWidth = 3;
        }
        else{
            imgV.layer.masksToBounds = YES;
            imgV.layer.borderColor = Yellow_Color.CGColor;
            imgV.layer.borderWidth = 0;
        }
        [self.bottomScrView addSubview:imgV];

        imgLeft = imgLeft+60+5;
        
    }
    self.bottomScrView.contentSize = CGSizeMake(imgLeft, self.bottomScrView.height);
}

-(void)srcBtn:(UITapGestureRecognizer *)ges{
    NSInteger tag = ges.view.tag;
    NSInteger count = self.bottomScrView.subviews.count;
    for (int i = 0; i<count; i++) {
        UIImageView *tempBtn = self.bottomScrView.subviews[i];
        if (i==tag) {
            tempBtn.layer.masksToBounds = YES;
            tempBtn.layer.borderColor = Yellow_Color.CGColor;
            tempBtn.layer.borderWidth = 3;
            
        }
        else{
            tempBtn.layer.masksToBounds = YES;
            tempBtn.layer.borderColor = Yellow_Color.CGColor;
            tempBtn.layer.borderWidth = 0;
        }
    }
    if (interimType==tag) {
        
    }
    else{
        interimType = tag;
        
        NSDictionary *dict = self.templateArray[interimType];
        NSString *imgStr = [dict objectForKey:@"templateUrl"];
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)3,(long)tempOrder,imgStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }

}

-(void)resetBottomTypeView{
    
    NSArray *arr = @[@"假期",@"请柬",@"朦胧",@"可爱"];
    CGFloat btnLeft = 30;
    CGFloat btnWidth = 40;
    CGFloat btnTop = self.bottomTypeView.height/2-12.5;
    CGFloat btnSpace = (self.bottomTypeView.width-btnLeft*2-arr.count*btnWidth)/(arr.count-1);
    
    
    for (int i = 0 ; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnLeft, btnTop, btnWidth, 25);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = NB_FONTSEIZ_SMALL;
        btn.tag = i;
        btn.layer.masksToBounds = YES;
 
        btnLeft = btnLeft+btnWidth+btnSpace;
    }
}

-(void)typeBtnClick:(UIButton *)btn{
    
    NSInteger tag = btn.tag;
    NSInteger count = self.bottomTypeView.subviews.count;
    for (int i = 0; i<count; i++) {
        UIButton *tempBtn = self.bottomTypeView.subviews[i];
        if (i==tag) {
            [tempBtn setTitleColor:White_Color forState:UIControlStateNormal];
            tempBtn.backgroundColor = COLOR_BLACK_CLASS_9;
            tempBtn.layer.cornerRadius = 5;
        }
        else{
            [tempBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
            tempBtn.backgroundColor = COLOR_BLACK_CLASS_6;
            tempBtn.layer.cornerRadius = 0;
        }
    }
    
    tag = tag*3;
    
    CGFloat pointX = 0;
    pointX = 65*tag+1;
    
    [self.bottomScrView setContentOffset:CGPointMake(pointX, 0) animated:YES];
    
}

-(void)templateClick:(UIButton *)btn{
    self.TemplateBtn.hidden = YES;
    self.textUpOrDownBtn.hidden = NO;
    self.sucessBtn.hidden = NO;
    self.bottomView.hidden = NO;
}

-(void)textUpOrDownBtnClick:(UIButton *)btn{
    if (!tempOrder) {
        tempOrder = 1;
    }
    else{
        tempOrder = 0;
    }
    if (!tempOrder) {
        [self.textUpOrDownBtn setTitle:@"图上字下" forState:UIControlStateNormal];
    }
    else{
        [self.textUpOrDownBtn setTitle:@"字上图下" forState:UIControlStateNormal];
    }
    [self refreshDataTwo];
}

-(void)refreshDataTwo{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *url;
    
    if (interimType==-1) {
        url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)3,(long)tempOrder,@""];
    }
    else{
        NSDictionary *dict = self.templateArray[interimType];
        NSString *imgStr = [dict objectForKey:@"templateUrl"];
        if (!imgStr||imgStr.length<=5) {
            imgStr = @"";
            
            url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)3,(long)tempOrder,imgStr];
            
        }
        else{
            url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)3,(long)tempOrder,imgStr];
        }
    }
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

-(void)successBtnClick:(UIButton *)btn{
    [self setTemplateInfo];
}

#pragma mark - 报名相关

#pragma mark - 查询是否可以报名
-(void)signUpClick:(UIButton *)btn{
    //判断是否交定金,若交定金则跳登录
   // UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    BOOL isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (!isLogined) {
        LoginViewController *controller = [LoginViewController new];
        [self.navigationController pushViewController:controller animated:true];
        return;
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/isSigUp.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"activityId":self.activityId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已停止报名" controller:self sleep:2.0];
            }else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"超过报名时间" controller:self sleep:2.0];
            }else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"活动没通过审核" controller:self sleep:2.0];
            }else if (statusCode==1005) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"活动已结束" controller:self sleep:2.0];
            }else if (statusCode==1006) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"报名人数已满" controller:self sleep:2.0];
            }else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
//            else if (self.money > 0) {
//                LoginViewController *controller = [LoginViewController new];
//                [self.navigationController pushViewController:controller animated:true];
//                return;
//            }
        else if (statusCode==1000) {
                [self.customStrArray removeAllObjects];
                [self.customBoolArray removeAllObjects];
                [self.dataArray removeAllObjects];
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                NSString *customStr = responseObj[@"custom"];
                _activityAdress = responseObj[@"address"];
                _activityName = responseObj[@"activityName"];
                _cost = [NSString stringWithFormat:@"%.2f", [responseObj[@"money"] doubleValue]];
                _costName = responseObj[@"costName"];
                if (customStr.length<=0) {

                }else{
                    NSData *data = [customStr dataUsingEncoding:NSUTF8StringEncoding];
                    id temID = [self toArrayOrNSDictionary:data];
                    if ([temID isKindOfClass:[NSArray class]]) {
                        NSArray *temArray = temID;
                        if (temArray.count>0) {

                            //                        NSArray *array = @[@"",@""];
                            //                        [self.dataArray addObject:array];
                            for (NSMutableDictionary *dict in temArray) {
                                NSString *strOne = [dict objectForKey:@"customName"];
                                NSString *strTwo = [dict objectForKey:@"isMust"];
                                [self.customStrArray addObject:strOne];
                                [self.customBoolArray addObject:strTwo];
                                [self.dataArray addObject:@""];
                            }
                        }

                    }else{

                    }
                }
                [self showSignUpView];
            }else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

-(void)showSignUpView{
    NSString *costName = _activityName;
    CGFloat length = 14;
    if (IPhone5) {
        length = 10;
    }
    if (IPhone6Plus) {
        length = 18;
    }
//    if (costName.length > length) {
//        costName = [costName substringToIndex:14];
//        costName = [costName stringByAppendingString:@"..."];
//    }
    ActivitySignUpView *signUpView = [[ActivitySignUpView alloc] initWithCustomItem:self.customStrArray costName:costName andPrice:_cost];
    
    if (self.signUpView) {
        [self.signUpView removeFromSuperview];
        self.signUpView = nil;
    }
    self.signUpView = signUpView;
    signUpView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:signUpView];
    // 手机号tag 999 名称888  其他 100， 101， 102 。。。
    self.phoneTextF = [signUpView viewWithTag:999];
    self.nameTextF = [signUpView viewWithTag:888];
    self.codeTextF = [signUpView viewWithTag:777];
    self.textFieldImageVerificationCode = [signUpView viewWithTag:666];
    for (UIView *view in signUpView.subviews[0].subviews) {
        if ([view isKindOfClass:[UITextField class]] && view.tag < 666) {
            ((UITextField *)view).delegate = self;
        }
    }
    
    signUpView.sendCodeBlock = ^(UIButton *btn) {
        [self codeBtnClick:btn];
    };
    
    signUpView.finishBtnBlock = ^(NSInteger flag) {
        [self requestSignUp];
    };
    

    
}
- (void)showPaySuccessView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.paySuccessBgView = bgView;
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickPaySuccessView:)];
    [bgView addGestureRecognizer:tap];
    [self.view addSubview:bgView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(200);
    }];
    UILabel *label = [UILabel new];
    [bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-130);
    }];
    label.font = [UIFont systemFontOfSize:17];
    label.text = @"报名成功";
    label.textColor = [UIColor blackColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(90);
        make.size.equalTo(CGSizeMake(100, 40));
    }];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundColor:kMainThemeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"我的订单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 去订单详情
- (void)goToOrderDetail:(UIButton *)sender {
    [self.paySuccessBgView removeAllSubViews];
    [self.paySuccessBgView removeFromSuperview];

    MyOrderViewController *vc = [MyOrderViewController new];
    vc.agencyId = self.agencysId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickPaySuccessView:(UITapGestureRecognizer *)tap {
    UIView *bgView = tap.view;
    bgView.hidden = YES;
    [bgView removeFromSuperview];
    bgView = nil;
}

-(void)shadowDismiss{
    self.shadowV.hidden = YES;
    self.addMuchUseAlertV.hidden = YES;
    [self.view endEditing:YES];
    [self.addMuchUseAlertV endEditing:YES];
    self.codeTextF.text = @"";
}

-(void)codeBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    [self.addMuchUseAlertV endEditing:YES];
    self.phoneTextF.text = [self.phoneTextF.text ew_removeSpaces];
    if (self.phoneTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号不能为空" controller:self sleep:2.0];
        return;
    }
    if (![self.phoneTextF.text ew_justCheckPhone]||self.phoneTextF.text.length>11) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号格式不正确" controller:self sleep:2.0];
        return;
    }
//    if (!self.textFieldImageVerificationCode.text.length) {
//        SHOWMESSAGE(@"请输入图形验证码")
//        return;
//    }
    NSString *phone = self.phoneTextF.text;
    //UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"sms/getSignUpSms.do"];
    
    
    NSString *temCompanyId = self.companyId;
    if (!temCompanyId||[temCompanyId integerValue]==0) {
        temCompanyId = @"0";
    }
    [[UIApplication sharedApplication].keyWindow hudShow];
#warning textFieldImageVerificationCode.text
    NSDictionary *paramDic = @{@"phone":phone,
                               @"activityName":_activityName,
                               @"address":_activityAdress,
                               @"activityId":self.activityId,
                               @"companyId":temCompanyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码发送成功" controller:self sleep:2.0];
                
                __block int timeout = 120; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(timeout <= 0) { //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            //                            [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                            //                            self.codeBtn.userInteractionEnabled = YES;
                            //                            self.codeBtn.backgroundColor = Main_Color;
                            [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                            btn.userInteractionEnabled = YES;
                            btn.backgroundColor = Main_Color;
                        });
                        
                    } else {
                        
                        int seconds = timeout;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            //NSLog(@"____%@",strTime);
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:1];
                            //                            [self.codeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                            [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                            btn.userInteractionEnabled = NO;
                            btn.backgroundColor = kDisabledColor;
                            [UIView commitAnimations];
                            //                            self.codeBtn.userInteractionEnabled = NO;
                            //                            self.codeBtn.backgroundColor = kDisabledColor;
                        });
                        timeout--;
                    }
                });
                
                dispatch_resume(_timer);
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送失败" controller:self sleep:2.0];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"今天的短信数量已达到最大限制" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:2.0];
            }
            else if (statusCode==2001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"短信模版解释异常，请重新发送" controller:self sleep:2.0];
            } else if(statusCode == 1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您的手机号已经报名成功" controller:self sleep:2.0];
            } else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
    
}

#pragma mark - 报名接口
-(void)requestSignUp{
    [self.view endEditing:YES];
    [self.addMuchUseAlertV endEditing:YES];
    self.nameTextF.text = [self.nameTextF.text ew_removeSpaces];
    if (self.nameTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"姓名不能为空" controller:self sleep:2.0];
        return;
    }
    self.phoneTextF.text = [self.phoneTextF.text ew_removeSpaces];
    if (self.phoneTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号不能为空" controller:self sleep:2.0];
        return;
    }
    if (![self.phoneTextF.text ew_justCheckPhone]||self.phoneTextF.text.length>11) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号格式不正确" controller:self sleep:2.0];
        return;
    }
    if (!self.textFieldImageVerificationCode.text.length) {
        SHOWMESSAGE(@"图形验证码不能为空")
        return;
    }
    self.codeTextF.text = [self.codeTextF.text ew_removeSpaces];
    if (self.codeTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"验证码不能为空" controller:self sleep:2.0];
        return;
    }
    
    if (self.dataArray.count<=0) {
        
    }
    else{
        //便利数组，是否有空项
        NSMutableArray *tagArray = [NSMutableArray array];
        for (int i = 0; i<self.dataArray.count; i++) {
            NSString *str = self.dataArray[i];
            str = [str ew_removeSpaces];
            if (str.length<=0) {
                NSString *temStr = [NSString stringWithFormat:@"%d",i];
                [tagArray addObject:temStr];
            }
        }
        if (tagArray.count>0) {
            //有空项--判断每一个空项是否应该必填
            bool isMust = NO;
            NSInteger mustNum = 0;//必填项名称的tag
            for (NSString *str in tagArray) {
                NSInteger temTag = [str integerValue];
                NSInteger mustTag = [self.customBoolArray[temTag]integerValue];
                if (mustTag==1) {
                    isMust = YES;//必添
                    mustNum = temTag;
                    break;
                }
                else{
                    isMust = NO;
                }
            }
            if (isMust) {
                NSString *str = [NSString stringWithFormat:@"%@必填",self.customStrArray[mustNum]];
                [[PublicTool defaultTool] publicToolsHUDStr:str controller:self sleep:2.0];
                return;
            }
            
        }
        else{
            
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.nameTextF.text forKey:@"userName"];
    [dict setObject:self.phoneTextF.text forKey:@"userPhone"];
    [dict setObject:self.activityId forKey:@"activityId"];
    [dict setObject:self.codeTextF.text forKey:@"code"];
    [dict setObject:self.companyId forKey:@"companyId"];
    
    NSMutableArray *temArray = [NSMutableArray array];
    if (self.customStrArray.count<=0) {
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:self.customStrArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        constructionStr2 = [constructionStr2 ew_removeSpaces];
        constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
        [dict setObject:constructionStr2 forKey:@"customs"];
    }
    else{
        
        for (int i = 0; i<self.customStrArray.count; i++) {
            NSMutableDictionary *temDict = [NSMutableDictionary dictionary];
            [temDict setObject:self.customStrArray[i] forKey:@"customName"];
            [temDict setObject:self.dataArray[i] forKey:@"customValue"];
            [temArray addObject:temDict];
        }
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:temArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        constructionStr2 = [constructionStr2 ew_removeSpaces];
        constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
        [dict setObject:constructionStr2 forKey:@"customs"];
    }
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyID = [NSString stringWithFormat:@"%ld", user.agencyId];
    [dict setObject:agencyID forKey:@"signAgency"];

    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    constructionStr2 = [constructionStr2 ew_removeSpaces];
    constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
    //    {"userName":"姓名","userPhone":"电话","activityId":"活动id","code":"验证码","customs":[{"customName":"自定义项名称","customValue":"自定义值"}]}
    
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signUp/signUp.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];

    NSDictionary *paramDic = @{@"signJson":constructionStr2
                               ,@"origin":@"2"};

    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSInteger flag = [responseObj[@"flag"] integerValue];
                NSInteger signUpId = [responseObj[@"signUpId"] integerValue];
                if (flag == 1) {
                    // 需要付费
                    ActivityPayViewController *payVC = [[ActivityPayViewController alloc] initWithNibName:@"ActivityPayViewController" bundle:nil];
                    payVC.signUpId = signUpId;
                    payVC.activityID = self.activityId;
                    payVC.successBlock = ^{
                        [self.signUpView removeFromSuperview];
                        self.signUpView = nil;
                        [self showPaySuccessView];
                    };
                    [self.navigationController pushViewController:payVC animated:YES];
                    
                } else {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"报名成功" controller:self sleep:2.0];
                    self.signUpView.hidden = YES;
                    [self.signUpView removeFromSuperview];
                    self.signUpView = nil;
                    [self shadowDismiss];
                }
                //刷新页面
                
                UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                NSString *url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld",BASEURL,(long)self.designsId,(long)user.agencyId,(long)3];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                [self.webView loadRequest:request];
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数格式错误" controller:self sleep:2.0];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码错误" controller:self sleep:2.0];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码过期" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"报名失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"报名失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - textFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag - 100;
    NSString *string = textField.text;
    if (string.length) {
        [self.dataArray replaceObjectAtIndex:tag withObject:textField.text];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger tag = textField.tag - 100;
    [self.dataArray replaceObjectAtIndex:tag withObject:textField.text];
    return YES;
}

#pragma mark - 获取本案设计所有模版

-(void)getAllTemplate{
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getAllTempletImg.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
 
    [NetManager afPostRequest:defaultApi parms:nil finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                NSArray *array = responseObj[@"imgList"];
                [self.templateArray removeAllObjects];
                [self.templateArray addObjectsFromArray:array];
                
                if (!self.templateStr||self.templateStr.length<=5) {
                    self.templateStr = @"";
                    templateType = -1;
                }
                else{
                    for (int i = 0; i<self.templateArray.count; i++) {
                        NSDictionary *dict = self.templateArray[i];
                        NSString *imgStr = [dict objectForKey:@"templateUrl"];
                        if ([imgStr isEqualToString:self.templateStr]) {
                            templateType = i;
                            break;
                        }
                    }
                    
                }
                
                interimType = templateType;
                
                [self resetBottomSrcV];
                [self resetBottomTypeView];
                
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 保存模版或和字上图下的接口
-(void)setTemplateInfo{
    
    
    NSString *imgStr;
    if (interimType==-1) {
        imgStr = @"";
    }
    else{
        NSDictionary *dict = self.templateArray[interimType];
        imgStr = [dict objectForKey:@"templateUrl"];
    }
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/setUp.do"];
    
    
    NSDictionary *paramDic = @{@"order":@(tempOrder),
                               @"template":imgStr,
                               @"designsId":@(self.designsId)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                self.order = tempOrder;
                templateType = interimType;
                self.templateStr = imgStr;
                
                self.TemplateBtn.hidden = NO;
                self.textUpOrDownBtn.hidden = YES;
                self.sucessBtn.hidden = YES;
                self.bottomView.hidden = YES;

            }
            else if (statusCode==1001){
                [[PublicTool defaultTool] publicToolsHUDStr:@"id为空" controller:self sleep:1.5];
            }
            else if (statusCode==2000){
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        YSNLog(@"%@",errorMsg);
    }];
    
}

#pragma mark - 编辑前查询美文和新闻详情

-(void)requestActivityDetail:(NSInteger)designsId type:(NSInteger)type{
    //    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignsDetailsByDesignsId.do"];

    NSDictionary *paramDic = @{@"designsId":@(designsId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            //            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                EditMyBeatArtController *vc = [[EditMyBeatArtController alloc]init];
                //                NSArray *arr = responseObj[@"data"][@"design"];
                NSDictionary *dict = responseObj[@"data"][@"design"];
                
                NSArray *temArray = [dict objectForKey:@"detailsList"];
                NSArray *dataArr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:temArray];
                
                //当前页面使用
                self.designTitle = [dict objectForKey:@"designTitle"];

                NSString *subtitle = [dict objectForKey:@"designSubtitle"];
                
                if (self.activityType==2) {
                    //美文
                    if (IsNilString(subtitle)) {
                        self.designSubTitle = [dict objectForKey:@"trueName"];
                    }
                    else
                    {
                        self.designSubTitle = subtitle;
                    }
                }
                else
                {
                    //活动
                    if (IsNilString(subtitle)) {
                        self.designSubTitle = [dict objectForKey:@"trueName"];
                    }
                    else
                    {
                        self.designSubTitle = subtitle;
                    }
                }

                self.coverMap = [dict objectForKey:@"coverMap"];
                self.musicStyle = [[dict objectForKey:@"musicPlay"] integerValue];
                self.order = [[dict objectForKey:@"order"] integerValue];
                self.templateStr = [dict objectForKey:@"template"];
                self.companyName = [dict objectForKey:@"companyName"];
                self.money = [dict[@"money"] integerValue];
                [self.redArray removeAllObjects];
                //获取红包信息
                NSArray *couponArray =[dict objectForKey:@"coupons"];
                
                NSArray *redArray = [NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:couponArray];
                [self.redArray addObjectsFromArray:redArray];
                
                //没有设置红包的，也不显示
                if (self.redArray.count<=0) {
                    self.redLittleBtn.hidden = YES;
                    self.redDeleteLittleBtn.hidden = YES;
                }
                
                
                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                
                
                NSString *activityId = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"activityId"]];
                if (activityId&&activityId.length>0) {
                    self.activityId = activityId;
                }
                else{
                    self.activityId = @"0";
                }
                
                NSString *temStartStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"startTime"]];
                if (temStartStr) {
                    self.activityTime = [self timeWithTimeIntervalString:temStartStr];
                    
                    tempStartTime = temStartStr;
                }
                else{
                    self.activityTime = @"";
                    tempStartTime = @"";
                }
                
                
                
                self.activityAddress = [activityDict objectForKey:@"activityAddress"];
                if (!self.activityAddress||self.activityAddress.length<=0) {
                    self.activityAddress = @"线上活动";
                }
                
                if (self.activityType==2) {
                    self.activityAddress = @"";
                }
                

                
                
                if (type==3) {
                    //活动
                    
                
                }
                if (type==2) {
                    //美文
                }
                
            
                [self setUI];
                
                [self addBottomShareView];
                [self addTwoDimensionCodeView];
                
                [self getAllTemplate];
                [self setQRShareOfPerson];
                [self setQRShareOfCompany];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }

    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 打电话

-(void)consultBtnClick:(UIButton *)btn{
    if (!self.companyLandLine||self.companyLandLine.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"暂无电话" controller:self sleep:2.0];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self.companyLandLine];
    if (self.companyPhone&&self.companyPhone.length>0) {
        [array addObject:self.companyPhone];
    }

    
    NSArray *QArray = [array copy];
    [self.phoneArr removeAllObjects];
    [self.phoneArr addObjectsFromArray:QArray];
    

    
    UIActionSheet *actionSheet;
    if (QArray.count == 1) {
        
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.companyLandLine];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
        }
        if (buttonIndex==2) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.companyPhone];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }
    }
    if (alertView.tag==200) {
        if (buttonIndex==1) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.companyLandLine];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }
    }
}

-(void)redDeleteLittleBtnClick:(UIButton *)btn{
    self.redDeleteLittleBtn.hidden = YES;
    self.redLittleBtn.hidden = YES;
}

-(void)redLittleBtnClick:(UIButton *)btn{
    self.redLittleBtn.userInteractionEnabled = NO;
    //先定位
    [self initLocationService];
}

-(void)redDeleteBigBtnClick:(UIButton *)btn{
    self.redBigImgV.hidden = YES;
    self.redDeleteBigBtn.hidden = YES;
}


#pragma mark - 领红包
-(void)redBigImgVTouch:(UITapGestureRecognizer *)ges{

}

#pragma mark - 进入编辑美文和新闻详情页面

-(void)turnToActivityDetail:(NSInteger)designsId type:(NSInteger)type{
  
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignsDetailsByDesignsId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":@(designsId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                
                EditNewsActivityController *vc = [[EditNewsActivityController alloc]init];
                
                NSDictionary *dict = responseObj[@"data"][@"design"];
                
                NSArray *temArray = [dict objectForKey:@"detailsList"];
                NSArray *dataArr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:temArray];
                vc.designId = designsId;
                [vc.orialArray addObjectsFromArray:dataArr];
                [vc.dataArray addObjectsFromArray:dataArr];
                vc.voteDescribe = [dict objectForKey:@"voteDescribe"];
                vc.voteType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"voteType"]];
                vc.coverTitle = [dict objectForKey:@"designTitle"];
                
                vc.coverTitleTwo = [dict objectForKey:@"designSubtitle"];
                
                vc.musicStyle = [[dict objectForKey:@"musicPlay"]integerValue];
                vc.coverImgUrl = [dict objectForKey:@"coverMap"];
                
                vc.endTime = [dict objectForKey:@"voteEndTime"];
                
                vc.musicName = [dict objectForKey:@"musicName"] ;
                vc.musicUrl = [dict objectForKey:@"musicUrl"];
                
                vc.coverImgStr = [dict objectForKey:@"picUrl"] ;
                vc.nameStr = [dict objectForKey:@"picTitle"];
                vc.linkUrl = [dict objectForKey:@"picHref"];
                vc.isFistr = NO;
                
                //当前页面使用
                self.designTitle = [dict objectForKey:@"picUrl"];
                self.designSubTitle = [dict objectForKey:@"designSubtitle"];
                
                self.coverMap = [dict objectForKey:@"designTitle"];
                self.musicStyle = [[dict objectForKey:@"musicPlay"] integerValue];
                self.order = [[dict objectForKey:@"order"] integerValue];
                self.templateStr = [dict objectForKey:@"template"] ;
                
                NSArray *optionArray = [dict objectForKey:@"optionList"];
                NSArray *arrTwo = [NSArray yy_modelArrayWithClass:[VoteOptionModel class] json:optionArray];
                [vc.optionList addObjectsFromArray:arrTwo];
                
                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                
                
                if (type==3) {
                    //活动
                    
                    NSInteger signUpId = [[activityDict objectForKey:@"activityId"] integerValue];
                    vc.actId = [NSString stringWithFormat:@"%ld",signUpId];
                    
                    NSString *temStartStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"startTime"]];
                    vc.actStartTimeStr = [self timeWithTimeIntervalString:temStartStr];
                    
                    NSString *temEndStr = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"endTime"]];
                    vc.actEndTimeStr = [self timeWithTimeIntervalString:temEndStr];
                    
                    NSInteger signUpNum = [[activityDict objectForKey:@"activityPerson"] integerValue];
                    
                    vc.signUpNumStr = [NSString stringWithFormat:@"%ld",signUpNum];
                    vc.activityPlace = [activityDict objectForKey:@"activityPlace"];
                    vc.activityAddress = [activityDict objectForKey:@"activityAddress"];
                    NSInteger personNum = [[activityDict objectForKey:@"personNum"] integerValue];
                    vc.haveSignUpStr = [NSString stringWithFormat:@"%ld",personNum];
                    NSString *endStr = [activityDict objectForKey:@"activityEnd"];
                    if (!endStr) {
                        endStr = @"1";
                    }
                    vc.activityEnd = endStr;
                }
                if (type==2) {
                    //美文
                }
                
                NSString *customStr =[activityDict objectForKey:@"custom"];
                if (customStr.length<=0) {
                    vc.setDataArray = [NSMutableArray array];
                }
                else{
                    NSData *data = [customStr dataUsingEncoding:NSUTF8StringEncoding];
                    id temID = [self toArrayOrNSDictionary:data];
                    if ([temID isKindOfClass:[NSArray class]]) {
                        NSArray *temArray = temID;
                        vc.setDataArray = [NSMutableArray array];
                        [vc.setDataArray addObjectsFromArray:temArray];
                    }
                    else{
                        vc.setDataArray = [NSMutableArray array];
                    }
                }
                vc.customStr = customStr;
                
                //获取红包信息

                NSArray *couponArray =[dict objectForKey:@"coupons"];
                
                NSArray *redArray = [NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:couponArray];
                [vc.redArray addObjectsFromArray:redArray];
                
                vc.isFistr = NO;
                vc.unionId = 0;
                
                vc.companyName = self.companyName;
                vc.companyLogo = self.companyLogo;
                vc.companyId = [self.companyId integerValue];
                
               
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
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
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 生成个人二维码
- (void)setQRShareOfPerson{
    [self.TwoDimensionCodeView.topImageView sd_setImageWithURL:[NSURL URLWithString:self.coverMap] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.companyName = self.companyName;
    self.TwoDimensionCodeView.activityName = self.designTitle;
    [self.TwoDimensionCodeView.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.activityTime = tempStartTime;
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }

    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",self.designsId, (long)user.agencyId]];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *img = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            personImg = img;
        });
    });
}

#pragma mark - 生成公司二维码
- (void)setQRShareOfCompany{
    [self.TwoDimensionCodeView.topImageView sd_setImageWithURL:[NSURL URLWithString:self.coverMap] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.companyName = self.companyName;
    self.TwoDimensionCodeView.activityName = self.designTitle;
    [self.TwoDimensionCodeView.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.activityTime = tempStartTime;
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }

    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *img = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            companyImg = img;
        });
    });
}


- (void)addBottomShareView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomShareView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/2.0 + 70)];
    self.bottomShareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.shadowView addSubview:self.bottomShareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"分享给好友";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomShareView addSubview:titleLabel];
    
    NSArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0",@"yidongzhi"];
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"二维码",@"移至我的草稿箱"];
    for (int i = 0; i < 6; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%4 * BLEJWidth * 0.25, titleLabel.bottom + 20 + (i/4 * BLEJWidth * 0.25), BLEJWidth * 0.25, BLEJWidth * 0.25)];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickShareContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        [self.bottomShareView addSubview:btn];
    }
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
    
    self.TwoDimensionCodeView.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
}

#pragma mark - 添加二维码
- (void)addTwoDimensionCodeView {
    
    
    self.TwoDimensionCodeView = [[ActivityQRCodeShareView alloc] init];
    self.TwoDimensionCodeView.frame = [UIScreen mainScreen].bounds;
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    self.TwoDimensionCodeView.hidden = YES;
}

- (void)setQRShare {
    [self.TwoDimensionCodeView.topImageView sd_setImageWithURL:[NSURL URLWithString:self.coverMap] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.companyName = self.companyName;
    self.TwoDimensionCodeView.activityName =  self.designTitle;
    [self.TwoDimensionCodeView.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.activityTime = self.activityTime;
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }

    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.TwoDimensionCodeView.QRcodeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
        });
    });
    
    
}

- (void)didClickShareContentBtn:(UIButton *)btn {
    
    NSString *shareTitle = self.designTitle;
    NSString *shareDescription = self.designSubTitle;
    NSURL *shareImageUrl;
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    shareImageUrl = [NSURL URLWithString:self.coverMap];
    
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.coverMap) {
                [message setThumbImage:img];
            } else {
                UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                [message setThumbImage:image];
            }

            WXWebpageObject *webPageObject = [WXWebpageObject object];
  
            if (!user.agencyId) {
                user.agencyId = 0;
            }
//            if (!self.companyId||self.companyId.length<=0) {
//                self.companyId = @"0";
//            }
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm?origin=%@",(long)self.designsId, (long)user.agencyId,self.origin?:@"0"]];
            
            if (!_tempAgenceId) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm?origin=%@",(long)self.designsId, (long)0,self.origin?:@"0"]];
            }
            else{
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm?origin=%@",(long)self.designsId, (long)user.agencyId,self.origin?:@"0"]];
            }
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
               
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.coverMap) {
                [message setThumbImage:img];
            } else {
                [message setThumbImage:[UIImage imageNamed:@"shareDefaultIcon"]];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            if (!user.agencyId) {
                user.agencyId = 0;
            }
//            if (!self.companyId||self.companyId.length<=0) {
//                self.companyId = @"0";
//            }
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
            
            if (!_tempAgenceId) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)0]];
            }
            else{
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
            }
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 2:
        {// QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                if (!user.agencyId) {
                    user.agencyId = 0;
                }
//                if (!self.companyId||self.companyId.length<=0) {
//                    self.companyId = @"0";
//                }
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
                if (!_tempAgenceId) {
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)0]];
                }
                else{
                    [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
                }
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];

                QQApiNewsObject *newObject;
                if (self.coverMap) {
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    //                    NSData *dataOne = UIImagePNGRepresentation(image);
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    //                    [MobClick event:@"ConstructionDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            
            break;
        case 3:
        {// QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                if (!user.agencyId) {
                    user.agencyId = 0;
                }
//                if (!self.companyId||self.companyId.length<=0) {
//                    self.companyId = @"0";
//                }
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
                
                if (!_tempAgenceId) {
                    [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)0]];
                }
                else{
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
                }
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                
                QQApiNewsObject *newObject;
                if (self.coverMap) {
                    //                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageURL:shareImageUrl];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    //                    NSData *data = UIImagePNGRepresentation(image);
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    //                    [MobClick event:@"ConstructionDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            break;
        case 4:
        {// 生成二维码
            
            if (!_tempAgenceId) {
                self.TwoDimensionCodeView.QRcodeView.image = companyImg;
            }
            else{
                self.TwoDimensionCodeView.QRcodeView.image = personImg;
            }
            self.TwoDimensionCodeView.hidden = NO;
            self.navigationController.navigationBar.alpha = 0;
        }
            break;
        case 5:
        {
            //保存到草稿箱
            
            
            NSString *designsId = [NSString stringWithFormat:@"%ld",self.designsId];
            NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
            NSString *draftContent = @"";
            NSString *draftId = @"";
            NSDictionary *para = @{@"designsId":designsId,@"agencysId":agencysId,@"draftContent":draftContent,@"draftId":draftId};
            NSString *url = [BASEURL stringByAppendingString:POST_CAOGAOSAVE];
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"成功保存到草稿箱" controller:self sleep:1.5];
                }
            } failed:^(NSString *errorMsg) {

            }];

            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];

            
        }
            break;
        default:
            break;
    }
    if (self.activityType==3) {
        [self shareNumberCount];
    }
    
}

- (void)shareNumberCount {
    UserInfoModel *userInfo = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyID = [NSString stringWithFormat:@"%ld", (long)userInfo.agencyId];
    NSString *temId = self.activityId;
    
    NSString *urlStr = [NSString stringWithFormat:@"cblejActivity/addShareNumber/%@.do", temId];
    NSString *defaultApi = [BASEURL stringByAppendingString:urlStr];
    NSDictionary *paramDic = @{
                               @"agencyId":agencyID
                               };
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
    }];
}
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

#pragma mark - lazy

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNaviBottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNaviBottom)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

-(UIButton *)shareBtn{
    if(!_shareBtn){
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, kSCREEN_HEIGHT-40, kSCREEN_WIDTH, 40);
        _shareBtn.backgroundColor = Main_Color;
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_shareBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        [_shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _shareBtn;
}

-(UIView *)bottomV{
    if(!_bottomV){
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40, kSCREEN_WIDTH, 40)];
        _bottomV.backgroundColor = White_Color;
    }
    return _bottomV;
}

-(UIButton *)phoneConsultBtn{
    if(!_phoneConsultBtn){
        _phoneConsultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneConsultBtn.frame = CGRectMake(0,0,self.bottomV.width/2,self.bottomV.height);
        _phoneConsultBtn.backgroundColor = White_Color;
        [_phoneConsultBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        _phoneConsultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_phoneConsultBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _phoneConsultBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        [_phoneConsultBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
        [_phoneConsultBtn addTarget:self action:@selector(consultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneConsultBtn;
}

-(UIButton *)signUpBtn{
    if(!_signUpBtn){
        _signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signUpBtn.frame = CGRectMake(self.phoneConsultBtn.right,0,self.bottomV.width/2,self.bottomV.height);
        _signUpBtn.backgroundColor = Main_Color;
        [_signUpBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        _signUpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_signUpBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _signUpBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        [_signUpBtn addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
        //        successBtn.layer.masksToBounds = YES;
        //        successBtn.layer.cornerRadius = 5;
    }
    return _signUpBtn;
}
-(UIButton *)TemplateBtn{
    if (!_TemplateBtn) {
        _TemplateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _TemplateBtn.frame = CGRectMake(kSCREEN_WIDTH-40-15, kSCREEN_HEIGHT-50-15-50, 50, 50);
        [_TemplateBtn setTitle:@"模版" forState:UIControlStateNormal];
        [_TemplateBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _TemplateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _TemplateBtn.backgroundColor = White_Color;
        _TemplateBtn.layer.masksToBounds = YES;
        _TemplateBtn.layer.cornerRadius = _TemplateBtn.width/2;
        
        [_TemplateBtn addTarget:self action:@selector(templateClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _TemplateBtn;
}

-(UIButton *)redLittleBtn{
    if (!_redLittleBtn) {
        _redLittleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redLittleBtn.frame = CGRectMake(kSCREEN_WIDTH-50-15, kSCREEN_HEIGHT-50-15-60, 50, 60);

        UIImage *redImg = [UIImage imageNamed:@"red_rob"];
        [_redLittleBtn setImage:redImg forState:UIControlStateNormal];
        [_redLittleBtn sizeToFit];
        CGFloat ww = kSCREEN_WIDTH/5;

        CGFloat hh = ww*_redLittleBtn.height/_redLittleBtn.width;
        _redLittleBtn.frame = CGRectMake(kSCREEN_WIDTH-ww-15, kSCREEN_HEIGHT-hh-15-60, ww, hh);
        
        
        [_redLittleBtn addTarget:self action:@selector(redLittleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redLittleBtn;
}

-(UIButton *)redDeleteLittleBtn{
    if (!_redDeleteLittleBtn) {
        _redDeleteLittleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redDeleteLittleBtn.frame = CGRectMake(self.redLittleBtn.right, self.redLittleBtn.top-10, 10, 10);
        [_redDeleteLittleBtn setImage:[UIImage imageNamed:@"red_envelope_delete"] forState:UIControlStateNormal];
        [_redDeleteLittleBtn addTarget:self action:@selector(redDeleteLittleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redDeleteLittleBtn;
}

-(UIImageView *)redBigImgV{
    if (!_redBigImgV) {
        _redBigImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/12, kSCREEN_HEIGHT/4, kSCREEN_WIDTH/6*5, kSCREEN_HEIGHT/4*2)];
        _redBigImgV.image = [UIImage imageNamed:@"red_envelope_icon"];
        _redBigImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(redBigImgVTouch:)];
        [_redBigImgV addGestureRecognizer:ges];
    }
    return _redBigImgV;
}

-(UIButton *)redDeleteBigBtn{
    if (!_redDeleteBigBtn) {
        _redDeleteBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redDeleteBigBtn.frame = CGRectMake(self.redBigImgV.right, self.redBigImgV.top-20, 20, 20);
        [_redDeleteBigBtn setImage:[UIImage imageNamed:@"red_envelope_delete"] forState:UIControlStateNormal];
        [_redDeleteBigBtn addTarget:self action:@selector(redDeleteBigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redDeleteBigBtn;
}

-(UIButton *)textUpOrDownBtn{
    if (!_textUpOrDownBtn) {
        _textUpOrDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _textUpOrDownBtn.frame = CGRectMake(7, kSCREEN_HEIGHT-150-7-20, 80, 20);
        _textUpOrDownBtn.frame = CGRectMake(7, kSCREEN_HEIGHT-110-7-20, 80, 20);
        [_textUpOrDownBtn setTitle:@"字上图下" forState:UIControlStateNormal];
        [_textUpOrDownBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _textUpOrDownBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _textUpOrDownBtn.backgroundColor = COLOR_BLACK_CLASS_3;
        _textUpOrDownBtn.layer.masksToBounds = YES;
        _textUpOrDownBtn.layer.cornerRadius = 10;
        
        [_textUpOrDownBtn addTarget:self action:@selector(textUpOrDownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textUpOrDownBtn;
}

-(UIButton *)sucessBtn{
    if (!_sucessBtn) {
        _sucessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sucessBtn.frame = CGRectMake(kSCREEN_WIDTH-60-7, self.textUpOrDownBtn.top, 60, self.textUpOrDownBtn.height);
        [_sucessBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_sucessBtn setTitleColor:RGB(211, 192, 185) forState:UIControlStateNormal];
        //        [_sucessBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [_sucessBtn setImage:[UIImage imageNamed:@"success_dui"] forState:UIControlStateNormal];
        _sucessBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _sucessBtn.backgroundColor = COLOR_BLACK_CLASS_3;
        _sucessBtn.layer.masksToBounds = YES;
        _sucessBtn.layer.cornerRadius = 10;
        
        [_sucessBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sucessBtn;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        //        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-150, kSCREEN_WIDTH, 150)];
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-110, kSCREEN_WIDTH, 110)];
        _bottomView.backgroundColor = COLOR_BLACK_CLASS_3;
    }
    return _bottomView;
}

-(UIScrollView *)bottomScrView{
    if (!_bottomScrView) {
        _bottomScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, 90)];
        _bottomScrView.backgroundColor = COLOR_BLACK_CLASS_3;
        _bottomScrView.showsVerticalScrollIndicator = NO;
        _bottomScrView.showsHorizontalScrollIndicator = NO;
        _bottomScrView.delegate = self;
    }
    return _bottomScrView;
}

-(UIView *)bottomTypeView{
    if (!_bottomTypeView) {
        _bottomTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bottomScrView.bottom, kSCREEN_WIDTH, self.bottomView.height-self.bottomScrView.bottom)];
        _bottomTypeView.backgroundColor = COLOR_BLACK_CLASS_3;
    }
    return _bottomTypeView;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
