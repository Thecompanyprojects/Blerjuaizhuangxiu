//
//  ActivityShowController.m
//  iDecoration
//  活动展示页面
//  Created by sty on 2017/10/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivityShowController.h"
#import "DesignCaseListModel.h"
#import "VoteOptionModel.h"
#import "senceWebViewController.h"
//#import "JudgeIsRegistedApi.h"
#import "VIPExperienceShowViewController.h"
#import "ActivityQRCodeShareView.h"
#import "NSObject+CompressImage.h"
#import "ShopDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "ActivitySignUpTwoController.h"
#import "ZCHCalculatorPayController.h"
#import "ZCHPublicWebViewController.h"
#import "ActivityManageController.h"

#import "SSPopup.h"
#import "VipGroupViewController.h"
#import "ActivitySignUpView.h"
#import "ActivityPayViewController.h"
#import "LoginViewController.h"


@interface ActivityShowController ()<UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,SSPopupDelegate,UIActionSheetDelegate>{
    NSString *_activityName;
    NSString *_activityAdress;
    NSString *_cost;
    NSString *_costName;
    
    NSInteger tempOrder;
    NSInteger templateType;
    NSInteger interimType;//临时的模版type
    
    BOOL isFromYellow;//是否从企业或历史活动进入
    
    NSInteger _tempAgenceId;//临时的人员id
    
    UIImage *personImg;
    UIImage *companyImg;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *phoneConsultBtn;//咨询按钮
@property (nonatomic, strong) UIButton *signUpBtn;//报名按钮

@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *phoneTextF;
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

// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;

// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) ActivityQRCodeShareView *TwoDimensionCodeView;

@property (nonatomic, strong) ActivitySignUpView *signUpView;

@end
@implementation ActivityShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动";
    self.customStrArray = [NSMutableArray array];
    self.customBoolArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.phoneArr = [NSMutableArray array];
    
    self.templateArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    _tempAgenceId = 0;
    _cost = @"";
    _costName = @"";
    NSArray *controllerArray = self.navigationController.childViewControllers;
    NSInteger count = controllerArray.count;
    UIViewController *vc = controllerArray[count-2];
    if ([vc isKindOfClass:[ActivityManageController class]]) {
        isFromYellow = NO;
        //只有活动的创建人可以编辑
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSInteger creatInt = [self.agencysId integerValue];
        if (creatInt==user.agencyId) {
            self.TemplateBtn.hidden = NO;
        }
        else{
            self.TemplateBtn.hidden = YES;
        }
        
    }
    else{
        isFromYellow = YES;
        self.TemplateBtn.hidden = YES;
    }
    
    
    if (!self.order) {
        [self.textUpOrDownBtn setTitle:@"图上字下" forState:UIControlStateNormal];
    }
    else{
        [self.textUpOrDownBtn setTitle:@"字上图下" forState:UIControlStateNormal];
    }
    tempOrder = self.order;
    
    templateType = -1; //默认是-1
    interimType = templateType;
    [self getAllTemplate];
    
//    self.navigationController.root
    [self setUI];
    [self addBottomShareView];
    [self addTwoDimensionCodeView];
//    [self setQRShare];
    
    [self setQRShareOfPerson];
    [self setQRShareOfCompany];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *url = [NSString stringWithFormat:@"%@cblejActivity/returnHtml.do?designsId=%@&agencysId=%ld&companyId=%@",BASEURL,self.designsId,(long)user.agencyId,self.companyId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"分享" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

-(void)shareBtnClick:(UIButton *)btn{
    
    
    if (isFromYellow) {
        //从企业网进入啥都不判断，直接分享
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
                    
//                    ZCHCalculatorPayController *payVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
//                    payVC.companyId = self.companyId;
//                    payVC.type = @"0";
//                    __weak typeof(self) weakSelf = self;
//                    payVC.refreshBlock = ^() {
//                        weakSelf.calVipTag = 1;
//                        //
//                        [weakSelf refreshPreviousVc:1];
//                    };
//                    [self.navigationController pushViewController:payVC animated:YES];
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
            
            
//            self.shadowView.hidden = YES;
            
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
                            payVC.companyId = self.companyId;
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
                    
//                    ZCHCalculatorPayController *payVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
//                    payVC.companyId = self.companyId;
//                    payVC.type = @"0";
//                    __weak typeof(self) weakSelf = self;
//                    payVC.refreshBlock = ^() {
//                        weakSelf.calVipTag = 1;
//                        //
//                        [weakSelf refreshPreviousVc:1];
//                    };
//                    [self.navigationController pushViewController:payVC animated:YES];
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
        
        //        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgLeft, 30, 60, 30)];
        //        label.textColor = Black_Color;
        //        label.text = [NSString stringWithFormat:@"%d",i];
        //        [self.bottomScrView addSubview:label];
        
        imgLeft = imgLeft+60+5;
        
    }
    self.bottomScrView.contentSize = CGSizeMake(imgLeft, self.bottomScrView.height);
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
        //        [btn setTitleColor:White_Color forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = NB_FONTSEIZ_SMALL;
        btn.tag = i;
        btn.layer.masksToBounds = YES;
        
        //        [self.bottomTypeView addSubview:btn];
        btnLeft = btnLeft+btnWidth+btnSpace;
    }
}

//-(void)

#pragma mark - action

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
        NSString *url;
        interimType = tag;
        if (interimType==-1) {
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            url = [NSString stringWithFormat:@"%@cblejActivity/returnHtml.do?designsId=%@&agencysId=%ld&companyId=%@&order=%ld&templateUrl=%@",BASEURL,self.designsId,(long)user.agencyId,self.companyId,(long)self.order,@""];
        }
        else{
            NSDictionary *dict = self.templateArray[interimType];
            NSString *imgStr = [dict objectForKey:@"templateUrl"];
            
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            url = [NSString stringWithFormat:@"%@cblejActivity/returnHtml.do?designsId=%@&agencysId=%ld&companyId=%@&order=%ld&templateUrl=%@",BASEURL,self.designsId,(long)user.agencyId,self.companyId,(long)self.order,imgStr];
        }
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
    
    
    //    [self updateTypeBtnState:tag];
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

-(void)updateTypeBtnState:(NSInteger)tag{
    
    NSInteger count = self.bottomTypeView.subviews.count;
    
    if (tag<=2) {
        tag=0;
    }else if(tag<=5){
        tag=1;
    }
    else if(tag<=8){
        tag=2;
    }
    else if(tag<=11){
        tag=3;
    }
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
    
    
}


-(void)refreshPreviousVc:(NSInteger)tag{
    if (self.activityShowBlock) {
        self.activityShowBlock(tag);
    }
}

-(void)back{
    [self colseMusic];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    // 这里统一设置键盘处理
//    //    manager.toolbarDoneBarButtonItemText = @"完成";
//    //    manager.toolbarTintColor = kMainThemeColor;
//    manager.enable = NO;
//    manager.shouldToolbarUsesTextFieldTintColor = NO;
//    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
//    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self colseMusic];
    
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    // 这里统一设置键盘处理
//    manager.toolbarDoneBarButtonItemText = @"完成";
//    manager.toolbarTintColor = kMainThemeColor;
//    manager.enable = YES;
//    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
//    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.musicStyle) {
        [self startMusic];
    }
}

-(void)startMusic{
    NSString *trigger = @"startMusic()";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

-(void)colseMusic{
    NSString *trigger = @"stopMusic()";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
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
    
    if ([[url scheme] isEqualToString:@"twoclick"]) {
        NSString *urlStr = url.query;
        
        NSArray *params =[urlStr componentsSeparatedByString:@"&"];
        NSArray *arrayOne = [params[0] componentsSeparatedByString:@"="];
        NSArray *arrayTwo = [params[1] componentsSeparatedByString:@"="];
        NSArray *arrayThree = [params[2] componentsSeparatedByString:@"="];
        
        NSString *companyType = arrayOne[1];
        NSString *companyId = arrayTwo[1];
        NSString *companyVip = arrayThree[1];
        
        
        if ([companyVip isEqualToString:@"1"]) {
            
            //公司的详情
            if ([companyType isEqualToString:@"1018"] || [companyType isEqualToString:@"1064"] || [companyType isEqualToString:@"1065"]) {
                CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
//                company.companyName = model.companyName;
                company.companyID = companyId;
                company.hidesBottomBarWhenPushed = YES;
                company.origin = @"0";
                [self.navigationController pushViewController:company animated:YES];
            } else {
                //店铺的详情;
                ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
//                shop.shopName = model.companyName;
                shop.shopID = companyId;
                shop.hidesBottomBarWhenPushed = YES;
                shop.origin = @"0";
                [self.navigationController pushViewController:shop animated:YES];
            }
        } else {
            VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
            controller.isEdit = false;
            controller.companyId = companyId;
            controller.origin = @"0";
            [self.navigationController pushViewController:controller animated:true];
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司未开通企业网会员"];
        }
        
        return NO;
    }
    
    if ([[url scheme] isEqualToString:@"starttoactivity"]) {
        NSString *urlStr;
        NSArray *params =[url.query componentsSeparatedByString:@"=="];
        urlStr = [params[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
            senceWebViewController *vc = [[senceWebViewController alloc]init];
            vc.isFrom = YES;
            vc.webUrl = urlStr;
            vc.titleStr = @"图片链接";
            [self.navigationController pushViewController:vc animated:YES];
            return NO;

    }
    
    //StartToVideo
    if ([[url scheme] isEqualToString:@"starttovideo"]) {
        
        NSString *urlStr;
        NSArray *params =[url.query componentsSeparatedByString:@"=="];
        urlStr = [params[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        if (urlStr.length>0) {
        ZCHPublicWebViewController *vc = [[ZCHPublicWebViewController alloc]init];
        vc.titleStr = @"视频";
        vc.webUrl = urlStr;
        vc.isAddBaseUrl = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
        //        }
    }
    
    return YES;
}

#pragma mark - action

-(void)setUI{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.phoneConsultBtn];
    [self.bottomV addSubview:self.signUpBtn];
    
//    [self.view addSubview:self.shareBtn];
//    [self addBottomShareView];
//
    [self.view addSubview:self.TemplateBtn];
    [self.view addSubview:self.textUpOrDownBtn];
    [self.view addSubview:self.sucessBtn];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomScrView];
    [self.bottomView addSubview:self.bottomTypeView];

    self.textUpOrDownBtn.hidden = YES;
    self.sucessBtn.hidden = YES;
    self.bottomView.hidden = YES;
}

#pragma mark - 查询是否可以报名
-(void)signUpClick:(UIButton *)btn{
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (!isLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.tag = 300;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/isSigUp.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"activityId":self.activityId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                [self.customStrArray removeAllObjects];
                [self.customBoolArray removeAllObjects];
                [self.dataArray removeAllObjects];
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                NSString *customStr = responseObj[@"custom"];
                _activityAdress = responseObj[@"address"];
                _activityName = responseObj[@"activityName"];
//                _cost = [NSString stringWithFormat:@"%.2f", [responseObj[@"money"] doubleValue]];
//                _costName = responseObj[@"costName"];
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
                        
                    }
                    else{
                        
                    }
                }
                
                [self showSignUpView];
                
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已停止报名" controller:self sleep:2.0];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"超过报名时间" controller:self sleep:2.0];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"活动没通过审核" controller:self sleep:2.0];
            }
            else if (statusCode==1005) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"活动已结束" controller:self sleep:2.0];
            }
            else if (statusCode==1006) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"报名人数已满" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma  mark - 报名弹框
-(void)showSignUpView{
    
    ActivitySignUpView *signUpView = [[ActivitySignUpView alloc] initWithCustomItem:self.customStrArray costName:_costName andPrice:_cost];
    
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
    
    for (UIView *view in signUpView.subviews[0].subviews) {
        if ([view isKindOfClass:[UITextField class]] && view.tag < 777) {
            ((UITextField *)view).delegate = self;
        }
    }
    
    signUpView.sendCodeBlock = ^(UIButton *btn) {
        [self codeBtnClick:btn];
    };
    
    signUpView.finishBtnBlock = ^(NSInteger flag) {
        [self requestSignUp];
        
//        if (flag == 2) { // 报名
//            [self requestSignUp];
//        }
//        if (flag == 1) { // 支付
//            ActivityPayViewController *payVC = [[ActivityPayViewController alloc] initWithNibName:@"ActivityPayViewController" bundle:nil];
//            payVC.successBlock = ^{
//                [self.signUpView removeFromSuperview];
//                self.signUpView = nil;
//                [self showPaySuccessView];
//            };
//            [self.navigationController pushViewController:payVC animated:YES];
//        }
    };
    
}

- (void)showPaySuccessView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
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
    [btn setTitle:@"订单详情" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToOrderDetail) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 去订单详情
- (void)goToOrderDetail {
    YSNLog(@"-----");
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
    NSString *phone = self.phoneTextF.text;
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"sms/getSignUpSms.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *temCompanyId = self.companyId;
    if (!temCompanyId||[temCompanyId integerValue]==0) {
        temCompanyId = @"0";
    }
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
    
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
//    NSString *agencyID = [NSString stringWithFormat:@"%ld", user.agencyId];
//    [dict setObject:agencyID forKey:@"signAgency"];
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    constructionStr2 = [constructionStr2 ew_removeSpaces];
    constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
//    {"userName":"姓名","userPhone":"电话","activityId":"活动id","code":"验证码","customs":[{"customName":"自定义项名称","customValue":"自定义值"}]}
    
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
                NSString *url = [NSString stringWithFormat:@"%@cblejActivity/returnHtml.do?designsId=%@&agencysId=%ld&companyId=%@",BASEURL,self.designsId,(long)user.agencyId,self.companyId];
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
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - textFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag - 100;
    [self.dataArray replaceObjectAtIndex:tag withObject:textField.text];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger tag = textField.tag - 100;
    [self.dataArray replaceObjectAtIndex:tag withObject:textField.text];
    return YES;
}

#pragma mark - 模版相关

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
        url = [NSString stringWithFormat:@"%@cblejActivity/returnHtml.do?designsId=%@&agencysId=%ld&companyId=%@&order=%ld&templateUrl=%@",BASEURL,self.designsId,(long)user.agencyId,self.companyId,(long)tempOrder,@""];
    }
    else{
        NSDictionary *dict = self.templateArray[interimType];
        NSString *imgStr = [dict objectForKey:@"templateUrl"];
        if (!imgStr||imgStr.length<=5) {
            imgStr = @"";
            
            url = [NSString stringWithFormat:@"%@cblejActivity/returnHtml.do?designsId=%@&agencysId=%ld&companyId=%@&order=%ld&templateUrl=%@",BASEURL,self.designsId,(long)user.agencyId,self.companyId,(long)tempOrder,imgStr];
        }
        else{
            url = [NSString stringWithFormat:@"%@cblejActivity/returnHtml.do?designsId=%@&agencysId=%ld&companyId=%@&order=%ld&templateUrl=%@",BASEURL,self.designsId,(long)user.agencyId,self.companyId,(long)tempOrder,imgStr];
        }
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

-(void)successBtnClick:(UIButton *)btn{
    [self setTemplateInfo];
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
                               @"designsId":self.designsId
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
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshActivityList" object:nil];
            }
            else if (statusCode==1001){
                [[PublicTool defaultTool] publicToolsHUDStr:@"本案设计id为空" controller:self sleep:1.5];
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

#pragma mark - 分享相关
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
    
    NSArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0"];
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"二维码"];
    for (int i = 0; i < 5; i ++) {
        
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

    
    
//    SSPopup* selection=[[SSPopup alloc]init];
//    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
//
//    selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
//    selection.SSPopupDelegate=self;
//    [self.view addSubview:selection];


    NSArray *QArray = [array copy];
    [self.phoneArr removeAllObjects];
    [self.phoneArr addObjectsFromArray:QArray];

//    [selection CreateTableview:QArray withTitle:@"" setCompletionBlock:^(int tag) {
//        YSNLog(@"%d",tag);
//
//        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",array[tag]];
//        UIWebView *callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
//
//    }
//     ];
    
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

#pragma mark - 获取本案设计所有模版

-(void)getAllTemplate{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getAllTempletImg.do"];
    
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

#pragma mark - 生成个人二维码
- (void)setQRShareOfPerson{
    [self.TwoDimensionCodeView.topImageView sd_setImageWithURL:[NSURL URLWithString:self.coverMap] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.companyName = self.companyName;
    self.TwoDimensionCodeView.activityName = self.designTitle;
    [self.TwoDimensionCodeView.companyIcon sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:nil options:SDWebImageRetryFailed];
    self.TwoDimensionCodeView.activityTime = self.activityTime;
    if (!self.activityAddress||self.activityAddress.length<=0) {
        self.activityAddress = @"线上活动";
    }
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }
    NSString *companyStr = self.companyId;
    //    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,companyStr, (long)user.agencyId]];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,companyStr, (long)user.agencyId]];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverMap]];
    //    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.TwoDimensionCodeView.QRcodeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
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
    self.TwoDimensionCodeView.activityTime = self.activityTime;
    
    if (!self.activityAddress||self.activityAddress.length<=0) {
        self.activityAddress = @"线上活动";
    }
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }
    NSString *companyStr = self.companyId;
    //    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,companyStr, (long)user.agencyId]];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,companyStr, (long)0]];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverMap]];
    //    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.TwoDimensionCodeView.QRcodeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            UIImage *img = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0];
            companyImg = img;
        });
    });
}

//-(void)callPhoneWith:(NSString *)phoneStr{
//
//}
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
    if (!self.activityAddress||self.activityAddress.length<=0) {
        self.activityAddress = @"线上活动";
    }
    self.TwoDimensionCodeView.activityAddress = self.activityAddress;
    
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (!user.agencyId) {
        user.agencyId = 0;
    }
    NSString *companyStr = self.companyId;
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,companyStr, (long)user.agencyId]];
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverMap]];
    //    UIImage *image = [UIImage imageWithData:data];
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
//    if (self.coverMap) {
        shareImageUrl = [NSURL URLWithString:self.coverMap];
//    }
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
            //            NSString *shareURL = WebPageUrl;
            //resources/html/shigongrizhi1.jsp?constructionId=%ld
            if (!user.agencyId) {
                user.agencyId = 0;
            }
            if (!self.companyId||self.companyId.length<=0) {
                self.companyId = @"0";
            }
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
            
            if (!_tempAgenceId) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)0]];
            }
            else{
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
            }
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
//                [MobClick event:@"ConstructionDiaryShare"];
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
            if (!self.companyId||self.companyId.length<=0) {
                self.companyId = @"0";
            }
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
            
            if (!_tempAgenceId) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)0]];
            }
            else{
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
            }
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
//                [MobClick event:@"ConstructionDiaryShare"];
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
                //                NSString *shareURL = WebPageUrl;
                //                NSString *shareURL = @"https://www.baidu.com";
                
                if (!user.agencyId) {
                    user.agencyId = 0;
                }
                if (!self.companyId||self.companyId.length<=0) {
                    self.companyId = @"0";
                }
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
                if (!_tempAgenceId) {
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)0]];
                }
                else{
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
                }
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                //                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:[NSString stringWithFormat:@"爱装修--%@", self.model.companyName] description:[NSString stringWithFormat:@"爱装修--%@", self.model.companyName] previewImageData:data];
                
                
                
                //                NSURL *url = [NSURL URLWithString:shareURL];
                // title = 分享标题
                // description = 施工单位 小区名称
                
                
                QQApiNewsObject *newObject;
                if (self.coverMap) {
                    //                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageURL:shareImageUrl];
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
                if (!self.companyId||self.companyId.length<=0) {
                    self.companyId = @"0";
                }
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
                
                if (!_tempAgenceId) {
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)0]];
                }
                else{
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejActivity/%@/%@/%ld.htm",self.activityId,self.companyId, (long)user.agencyId]];
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
//            [MobClick event:@"ConstructionDiaryShare"];
            
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
        default:
            break;
    }
    [self shareNumberCount];
}

- (void)shareNumberCount {
    UserInfoModel *userInfo = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyID = [NSString stringWithFormat:@"%ld", (long)userInfo.agencyId];
    NSString *urlStr = [NSString stringWithFormat:@"cblejActivity/addShareNumber/%@.do", self.activityId];
    NSString *defaultApi = [BASEURL stringByAppendingString:urlStr];
    NSDictionary *paramDic = @{
                               @"agencyId":agencyID
                               };
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
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
        //        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-40)];
        _webView.delegate = self;
        //            _webView.inputAccessoryView = YES;
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        //        [_webView setKeyboardDisplayRequiresUserAction:NO];
    }
    return _webView;
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
//        successBtn.layer.masksToBounds = YES;
//        successBtn.layer.cornerRadius = 5;
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
