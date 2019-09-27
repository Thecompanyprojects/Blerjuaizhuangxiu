//
//  MyBeautifulArtShowController.m
//  iDecoration
//
//  Created by sty on 2017/11/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MyBeautifulArtShowController.h"
#import "DesignCaseListModel.h"
#import "VoteOptionModel.h"
#import "senceWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AllPersonBeautilArtController.h"
#import "ActivityQRCodeShareView.h"
#import "NSObject+CompressImage.h"
#import "EditMyBeatArtController.h"
#import "BeautifulArtManageController.h"
#import "ZCHCalculatorPayController.h"
#import "ZCHPublicWebViewController.h"

#import "MyBeautifulArtController.h"
#import "BeautifulArtManageController.h"

#import "SSPopup.h"
#import "MyCircleController.h"

#import "NewsleavemessageVC.h"
#import "LoginViewController.h"

@interface MyBeautifulArtShowController ()<UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,SSPopupDelegate>{
    
    NSString *_activityName;
    NSString *_activityAdress;
    
    NSInteger tempOrder;
    NSInteger templateType;
    NSInteger interimType;//临时的模版type
    
    BOOL isFromMyArt;//是否是从我的美文进入 （是：有编辑权限，否：没有）
    
    
}

@property (nonatomic, strong) UIButton *phoneConsultBtn;//咨询按钮
@property (nonatomic, strong) UIButton *signUpBtn;//报名按钮

@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;//验证码
@property (nonatomic, strong) UIButton *codeBtn;//发送验证码按钮

@property (nonatomic, strong) NSMutableArray *dataArray;



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



// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) ActivityQRCodeShareView *TwoDimensionCodeView;
//bys声明context
@property (strong, nonatomic) JSContext *context;

@end

@implementation MyBeautifulArtShowController

-(void)qwerrttaoid:(NSString *)qq{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美   文";
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    self.url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld",BASEURL,(long)self.designsId,(long)user.agencyId,(long)2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self make];
}

- (void)make {
    self.customStrArray = [NSMutableArray array];
    self.customBoolArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.templateArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    NSArray *controllerArray = self.navigationController.childViewControllers;
    NSInteger arrayCount = controllerArray.count;
    UIViewController *vc = controllerArray[arrayCount-2];
    if ([vc isKindOfClass:[MyBeautifulArtController class]]||[vc isKindOfClass:[BeautifulArtManageController class]]) {
        isFromMyArt = YES;
    }else{
        isFromMyArt = NO;
    }
    templateType = -1; //默认是-1
    interimType = templateType;
    [self requestActivityDetail:self.designsId type:self.activityType];
    if (!self.order) {
        [self.textUpOrDownBtn setTitle:@"图上字下" forState:UIControlStateNormal];
    }else{
        [self.textUpOrDownBtn setTitle:@"字上图下" forState:UIControlStateNormal];
    }
    tempOrder = self.order;
    [self setUI];
    [self addBottomShareView];
    [self addTwoDimensionCodeView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    if (self.activityType==2&&isFromMyArt) {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"refreshBeatAteList" object:nil];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}


#pragma mark - action

-(void)setUI{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.phoneConsultBtn];

    [self.view addSubview:self.TemplateBtn];
    if (isFromMyArt) {
        self.TemplateBtn.hidden = NO;
    }
    else{
        self.TemplateBtn.hidden = YES;
    }
    [self.view addSubview:self.textUpOrDownBtn];
    [self.view addSubview:self.sucessBtn];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomScrView];
    [self.bottomView addSubview:self.bottomTypeView];
    
    self.textUpOrDownBtn.hidden = YES;
    self.sucessBtn.hidden = YES;
    self.bottomView.hidden = YES;
    
}

-(void)back{
    [self colseMusic];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 分享

-(void)shareClick{
    if (self.activityType==2) {
        
        self.shadowView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = NO;
        }];
    }
    if (self.activityType==3){
        //活动，提示开通个人vip
        if (self.meCalVipTag==1) {
          //已开通
            self.shadowView.hidden = NO;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
            } completion:^(BOOL finished) {
                self.shadowView.hidden = NO;
            }];
        }
        else{
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
                        [weakSelf refreshPreviousVc];
                    };
                    [self.navigationController pushViewController:payVC animated:YES];
                }
                if (buttonIndex == 2) {
                    
                    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                    
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
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self colseMusic];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.musicStyle) {
        [self startMusic];
    }
    

}
    

//bys
//13522249020 123456
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    
    
    //NSString *schemeStr = [url scheme];
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
    
    // dxp 修改
    if ([[url scheme] isEqualToString:@"recommenddesign"]) {
        NSString *urlStr = url.query;
        NSArray *params =[urlStr componentsSeparatedByString:@"&"];
        
        NSArray *arrayOne = [params[0] componentsSeparatedByString:@"="];
        
        NSInteger myDesignStr = [arrayOne[1] integerValue];

        
        MyBeautifulArtShowController *myCirCon = [[MyBeautifulArtShowController alloc]init];
        myCirCon.designsId = myDesignStr;
        myCirCon.activityId = @"";
        myCirCon.activityType = 2;
        
        [self.navigationController pushViewController:myCirCon animated:YES];
        
        return NO;
    }
   
    
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
        //        if (urlStr.length>0) {
        ZCHPublicWebViewController *vc = [[ZCHPublicWebViewController alloc]init];
        vc.titleStr = @"视频";
        vc.webUrl = urlStr;
        vc.isAddBaseUrl = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
        //        }
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
    [self turnToActivityDetail:self.designsId type:self.activityType];
}

-(void)reloadData{
    [self requestActivityDetail:self.designsId type:self.activityType];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld",BASEURL,(long)self.designsId,(long)user.agencyId,(long)2];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
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
        
        //        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgLeft, 30, 60, 30)];
        //        label.textColor = Black_Color;
        //        label.text = [NSString stringWithFormat:@"%d",i];
        //        [self.bottomScrView addSubview:label];
        
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
        NSString *url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)2,(long)tempOrder,imgStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
    
    
    //    [self updateTypeBtnState:tag];
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
        url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)2,(long)tempOrder,@""];
    }
    else{
        NSDictionary *dict = self.templateArray[interimType];
        NSString *imgStr = [dict objectForKey:@"templateUrl"];
        if (!imgStr||imgStr.length<=5) {
            imgStr = @"";
            
            url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)2,(long)tempOrder,imgStr];
            
        }
        else{
            url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=%ld&type=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.designsId,(long)user.agencyId,(long)2,(long)tempOrder,imgStr];
        }
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}


#pragma mark - 开通会员后，刷新上个页面数据
-(void)refreshPreviousVc{
    if (self.BeautifulArtShowBlock) {
        self.BeautifulArtShowBlock();
    }
}

-(void)successBtnClick:(UIButton *)btn{
    [self setTemplateInfo];
}

#pragma mark - 获取本案设计所有模版

-(void)getAllTemplate{
    //UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
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
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshActivityList" object:nil];
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
    
//    [[UIApplication sharedApplication].keyWindow hudShow];
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
                

                
                //当前页面使用
                self.designTitle = [dict objectForKey:@"designTitle"];
                self.designSubTitle = [dict objectForKey:@"designSubtitle"];
                
                self.coverMap = [dict objectForKey:@"coverMap"];
                self.musicStyle = [[dict objectForKey:@"musicPlay"] integerValue];
                self.order = [[dict objectForKey:@"order"] integerValue];
                self.templateStr = [dict objectForKey:@"template"] ;

                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                NSString *activityId = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"activityId"]];
                if (activityId&&activityId.length>0) {
                    self.activityId = activityId;
                }
                else{
                    self.activityId = @"0";
                }
                
                if (type==3) {

                    self.activityAddress = [activityDict objectForKey:@"activityAddress"];
                    self.activityTime = [NSString stringWithFormat:@"%@",[activityDict objectForKey:@"startTime"]];

                }
                if (type==2) {
                    //美文
                }
                
                [self getAllTemplate];
                [self setQRShare];
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
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 进入编辑美文和新闻详情页面

-(void)turnToActivityDetail:(NSInteger)designsId type:(NSInteger)type{
    //    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignsDetailsByDesignsId.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":@(designsId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                EditMyBeatArtController *vc = [[EditMyBeatArtController alloc]init];
                //                NSArray *arr = responseObj[@"data"][@"design"];
                NSDictionary *dict = responseObj[@"data"][@"design"];
                vc.isHaveMusicButton = YES;
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
                
                self.coverMap = [dict objectForKey:@"coverMap"];
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

                vc.isFistr = NO;
                vc.unionId = 0;
                vc.companyName = @"";
                vc.companyLogo = @"";
             
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

    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
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
    self.TwoDimensionCodeView.companyName = @"";
    self.TwoDimensionCodeView.activityName =  self.designTitle;
    self.TwoDimensionCodeView.companyIcon.hidden = YES;
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
            
            if (!user.agencyId) {
                user.agencyId = 0;
            }
            if (!self.companyId||self.companyId.length<=0) {
                self.companyId = @"0";
            }
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
            
            
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
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];

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
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
                
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
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%ld/%ld.htm",(long)self.designsId, (long)user.agencyId]];
                
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
        YSNLog(@"%@",responseObj);
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
        _phoneConsultBtn.frame = CGRectMake(0,0,self.bottomV.width,self.bottomV.height);
        _phoneConsultBtn.backgroundColor = Main_Color;
        [_phoneConsultBtn setTitle:@"分享" forState:UIControlStateNormal];
        _phoneConsultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_phoneConsultBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _phoneConsultBtn.titleLabel.font = NB_FONTSEIZ_BIG;

        [_phoneConsultBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];

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
//        [_signUpBtn addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
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


@end
