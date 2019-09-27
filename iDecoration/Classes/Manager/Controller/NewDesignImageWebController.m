//
//  NewDesignImageWebController.m
//  iDecoration
//
//  Created by sty on 2017/9/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NewDesignImageWebController.h"
#import "DesignCaseListController.h"

#import "ConstructionDiaryTwoController.h"
#import "MainMaterialDiaryController.h"
#import "DesignCaseListModel.h"
#import "VoteOptionModel.h"
#import "senceWebViewController.h"

#import "ZCHCashCouponShowController.h"
#import "ZCHProductCouponShowController.h"
#import "ZCHPublicWebViewController.h"

#import "CodeView.h"
#import "NSObject+CompressImage.h"

#import "STYProductCouponDetailController.h"
#import "WSRedPacketView.h"
#import "WSRewardConfig.h"
#import <CoreLocation/CoreLocation.h>
#import "casedesignVC.h"
#import "localVC.h"
#import "localbannerView.h"
#import "BLEJBudgetGuideController.h"
#import "JinQiViewController.h"
#import "SendFlowersViewController.h"

@interface NewDesignImageWebController ()<UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>{
    
    

    NSInteger tempOrder;
    NSInteger templateType;
    NSInteger interimType;//临时的模版type
    
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder *_geocoder;//初始化地理编码器
    
    double myLongitude;//经度
    double myLatitude;//纬度
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIButton *shareBtn;

// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;

// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) CodeView *TwoDimensionCodeView;

@property (nonatomic, strong) UIButton *TemplateBtn;//模版
@property (nonatomic, strong) UIButton *textUpOrDownBtn;//字上图下

@property (nonatomic, strong) UIButton *redLittleBtn;//红包
@property (nonatomic, strong) UIButton *redDeleteLittleBtn;//

@property (nonatomic, strong) UIImageView *redBigImgV;//红包
@property (nonatomic, strong) UIButton *redDeleteBigBtn;//

@property (nonatomic, strong) UIButton *sucessBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *bottomScrView;
@property (nonatomic, strong) UIView *bottomTypeView;

@property (nonatomic, strong) NSMutableArray *templateArray;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) localbannerView *bannerView;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;




@property(nonatomic,strong)UIView *FlipView;
@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)UIImageView *xianHua;
@property(nonatomic,strong)UIImageView *jinQi;
@property(nonatomic,strong)UILabel *xianHuaL;
@property(nonatomic,strong)UILabel *jinQiL;
@end




@implementation NewDesignImageWebController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)orialArray{
    if (!_orialArray) {
        _orialArray = [NSMutableArray array];
    }
    return _orialArray;
}

-(NSMutableArray *)redArray{
    if (!_redArray) {
        _redArray = [NSMutableArray array];
    }
    return _redArray;
}

-(NSMutableArray *)optionList{
    if (!_optionList) {
        _optionList = [NSMutableArray array];
    }
    return _optionList;
}

-(localbannerView *)bannerView
{
    if(!_bannerView)
    {
        _bannerView = [[localbannerView alloc] init];
        _bannerView.frame = CGRectMake(0, kSCREEN_HEIGHT-49, kSCREEN_WIDTH, 49);
        [_bannerView.btn0 addTarget:self action:@selector(headbtn0click) forControlEvents:UIControlEventTouchUpInside];
        [_bannerView.btn1 addTarget:self action:@selector(headbtn1click) forControlEvents:UIControlEventTouchUpInside];
        [_bannerView.btn2 addTarget:self action:@selector(headbtn2click) forControlEvents:UIControlEventTouchUpInside];
        [_bannerView.btn3 addTarget:self action:@selector(headbtn3click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bannerView;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self colseMusic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.fromIndex==1) {
        self.title = @"本案设计";
    }
    else{
        self.title = @"店长手记";
    }
    
    self.templateArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    
    [self setUI];
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"refreshNewDesignWebVc" object:nil];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];

    self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld",BASEURL,(long)self.consID,(long)user.agencyId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    
    
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.editBtn = editBtn;
    [self.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    
    //有编辑权限的不能领红包
    if (self.isPower) {
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        if (self.isComplate) {
            self.editBtn.hidden = YES;
            self.TemplateBtn.hidden = YES;
        }
        else{
            self.editBtn.hidden = NO;
            self.TemplateBtn.hidden = NO;
        }
        self.redLittleBtn.hidden = YES;
        self.redDeleteLittleBtn.hidden = YES;
    }
    else{
        self.editBtn.hidden = NO;
        [self.editBtn setTitle:@"分享" forState:UIControlStateNormal];
        self.TemplateBtn.hidden = YES;
        self.redLittleBtn.hidden = NO;
        self.redDeleteLittleBtn.hidden = NO;
    }
    
    //没有设置红包的，也不显示
    if (!self.redArray.count) {
        self.redLittleBtn.hidden = YES;
        self.redDeleteLittleBtn.hidden = YES;
    }
    
    //先隐藏红包
//    self.redLittleBtn.hidden = NO;
//    self.redDeleteLittleBtn.hidden = NO;
    if (self.isfromlocal) {
        [self.view addSubview:self.bannerView];
    }
   
}

-(void)setUI{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.shareBtn];
    [self addBottomShareView];
    
    [self.view addSubview:self.TemplateBtn];
    [self.view addSubview:self.redLittleBtn];
    [self.view addSubview:self.redDeleteLittleBtn];
    [self.view addSubview:self.redBigImgV];
    [self.view addSubview:self.redDeleteBigBtn];
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

//    [self resetBottomSrcV];
//    [self resetBottomTypeView];
    
    //分享按钮的位置
    if (self.isPower){
        self.shareBtn.hidden = NO;
    }
    else{
        self.shareBtn.hidden = YES;
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
        interimType = tag;
        
        NSDictionary *dict = self.templateArray[interimType];
        NSString *imgStr = [dict objectForKey:@"templateUrl"];
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order,imgStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
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


-(void)refreshData{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    if (!self.templateStr||self.templateStr.length<=5) {
        self.templateStr = @"";
        self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order];
    }
    else{
        self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order,self.templateStr];
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    
    [self requestNewCaseDesign];
}

-(void)refreshDataTwo{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    if (interimType==-1) {
        self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order,@""];
    }
    else{
        NSDictionary *dict = self.templateArray[interimType];
        NSString *imgStr = [dict objectForKey:@"templateUrl"];
        if (!imgStr||imgStr.length<=5) {
            imgStr = @"";
            self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order,imgStr];
        }
        else{
            self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order,imgStr];
        }
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.musicStyle) {
        [self startMusic];
    }
    
    
    [self addTwoDimensionCodeView];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
//    NSString *str = [url scheme];
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



-(void)templateClick:(UIButton *)btn{
    self.TemplateBtn.hidden = YES;
    self.textUpOrDownBtn.hidden = NO;
    self.sucessBtn.hidden = NO;
    self.bottomView.hidden = NO;
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
                //                vc.couponId = dict[@"couponId"];
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

#pragma mark - 领红包
-(void)redBigImgVTouch:(UITapGestureRecognizer *)ges{
//    self.redBigImgV.hidden = YES;
//    self.redDeleteBigBtn.hidden = YES;
//    NSInteger type = [self.couponModel.type integerValue];
//    if (type==0) {
//        //代金券
//        ZCHCashCouponShowController *vc = [[UIStoryboard storyboardWithName:@"ZCHCashCouponShowController" bundle:nil] instantiateInitialViewController];
//        vc.companyId = self.companyId;
//        vc.model = self.couponModel;
//        vc.block = ^{
//            self.redLittleBtn.hidden = YES;
//            self.redDeleteLittleBtn.hidden = YES;
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else{
//        //礼品券
//        ZCHProductCouponShowController *vc = [[UIStoryboard storyboardWithName:@"ZCHProductCouponShowController" bundle:nil] instantiateInitialViewController];
//        vc.companyId = self.companyId;
//        vc.model = self.couponModel;
//        vc.block = ^{
//            self.redLittleBtn.hidden = YES;
//            self.redDeleteLittleBtn.hidden = YES;
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
                               @"designsId":@(self.designId)
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

#pragma mark - 获取本案设计所有模版

-(void)getAllTemplate{
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
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

#pragma mark - 添加二维码
- (void)addTwoDimensionCodeView {
    
    //    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView = [[CodeView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes", (long)self.consID]];
    if (self.fromIndex==2) {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes&type=1", (long)self.consID]];
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyLogo]];
    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:image logoScaleToSuperView:0.3];
        });
    });
    self.TwoDimensionCodeView.typeLabel.text = [NSString stringWithFormat:@"%@",self.coverTitle];
    self.TwoDimensionCodeView.areaLabel.text = @"";
    self.TwoDimensionCodeView.companyNameLabel.text = @"";
    self.TwoDimensionCodeView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.TwoDimensionCodeView.imageView.clipsToBounds = YES;
    [self.TwoDimensionCodeView.imageView sd_setImageWithURL:[NSURL URLWithString:self.coverImgUrl]];
    // 没有图片
    if (self.coverTitle.length == 0) {
        [self.TwoDimensionCodeView.labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-(kSCREEN_HEIGHT - 62-20));
            make.height.equalTo(62);
        }];
        
        [self.TwoDimensionCodeView.QRCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH*0.4, kSCREEN_WIDTH * 0.4));
            make.centerX.equalTo(0);
            make.centerY.equalTo(0);
        }];
        
        [self.TwoDimensionCodeView.visitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.equalTo(0);
            make.top.equalTo(self.TwoDimensionCodeView.labelView.mas_bottom);
            make.bottom.equalTo(self.TwoDimensionCodeView.QRCodeImageView.mas_top);
        }];
    }
    
    self.TwoDimensionCodeView.visitLabel.text = @"邀请您参观本案设计";
    if (self.fromIndex==2) {
        self.TwoDimensionCodeView.visitLabel.text = @"邀请您参观店长手记";
    }
    //    UIView *messageView = [[UIView alloc] init];
    //    [self.TwoDimensionCodeView addSubview:messageView];
    //    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(-kSCREEN_HEIGHT);
    //        make.left.right.equalTo(0);
    //        make.height.equalTo(60);
    //    }];
    //
    //
    //
    //    // 二维码照片
    //    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.3, BLEJHeight * 0.5, BLEJWidth * 0.4, BLEJWidth * 0.4)];
    //    [self.TwoDimensionCodeView addSubview:codeView];
    //    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID]];
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0.1];
    //        });
    //    });
    //
    //    // label
    //    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.top - 80, BLEJWidth, 50)];
    //    centerLabel.text = @"邀请您参观工地";
    //    centerLabel.textAlignment = NSTextAlignmentCenter;
    //    centerLabel.font = [UIFont systemFontOfSize:kSize(40)];
    //    [self.TwoDimensionCodeView addSubview:centerLabel];
    //
    //    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, centerLabel.top - 60, BLEJWidth, 25)];
    //    topLabel.text = self.siteModel.ccBuilder;
    //    topLabel.textAlignment = NSTextAlignmentCenter;
    //    topLabel.font = [UIFont boldSystemFontOfSize:25];
    //    [self.TwoDimensionCodeView addSubview:topLabel];
    //
    //    // 头像图标
    //    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.4, topLabel.top - BLEJWidth * 0.2 - 10, BLEJWidth * 0.2, BLEJWidth * 0.2)];
    //    [iconView sd_setImageWithURL:[NSURL URLWithString:self.siteModel.companyLogo] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    //    [self.TwoDimensionCodeView addSubview:iconView];
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    //    label.text = @"截屏保存到相册:";
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.textColor = [UIColor darkGrayColor];
    //    label.font = [UIFont systemFontOfSize:16];
    //    [self.TwoDimensionCodeView addSubview:label];
    //
    //    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10, BLEJWidth, 30)];
    //    labelBottom.text = @"在微信环境下按住图片识别二维码打开";
    //    labelBottom.textColor = [UIColor darkGrayColor];
    //    labelBottom.textAlignment = NSTextAlignmentCenter;
    //    labelBottom.font = [UIFont systemFontOfSize:16];
    //    [self.TwoDimensionCodeView addSubview:labelBottom];
    //
    
    
    
    
    self.TwoDimensionCodeView.hidden = YES;
}

#pragma mark - 单独的分享

-(void)shareToOther{
    self.shadowView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
    } completion:^(BOOL finished) {
        self.shadowView.hidden = NO;
    }];
}

-(void)shareClick:(UIBarButtonItem*)sender{
    

    self.shadowView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomShareView.blej_y = BLEJHeight - (kSCREEN_WIDTH/2.0 + 70);
    } completion:^(BOOL finished) {
        self.shadowView.hidden = NO;
    }];
    
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


#pragma  mark - 分享
- (void)didClickShareContentBtn:(UIButton *)btn {
    NSString *shareTitle = self.coverTitle;
//    DesignCaseListModel *model = self.dataArray.firstObject;
    NSString *shareDescription = self.coverTitleTwo.length>0?self.coverTitleTwo:@"";
    NSURL *shareImageUrl;
//    if (self.coverImgUrl&&self.coverImgUrl.length>0) {
//        shareImageUrl = [NSURL URLWithString:self.coverImgUrl];
//    }
    shareImageUrl = [NSURL URLWithString:self.coverImgUrl];
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
            if (self.coverImgUrl&&self.coverImgUrl.length>0) {
                [message setThumbImage:img];
            } else {
                UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                [message setThumbImage:image];
            }
            
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes", (long)self.consID]];
            if (self.fromIndex==2) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes&type=1", (long)self.consID]];
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
            if (self.coverImgUrl&&self.coverImgUrl.length>0) {
                [message setThumbImage:img];
            } else {
                [message setThumbImage:[UIImage imageNamed:@"shareDefaultIcon"]];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes", (long)self.consID]];
            
            if (self.fromIndex==2) {
                shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes&type=1", (long)self.consID]];
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
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes", (long)self.consID]];
                if (self.fromIndex==2) {
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes&type=1", (long)self.consID]];
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
                if (self.coverImgUrl&&self.coverImgUrl.length>0) {
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
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes", (long)self.consID]];
                
                if (self.fromIndex==2) {
                    shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/returnDesignHtml.do?constructionId=%ld&isShare=yes&type=1", (long)self.consID]];
                }
                //                NSURL *url = [NSURL URLWithString:shareURL];
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                
                QQApiNewsObject *newObject;
                if (self.coverImgUrl&&self.coverImgUrl.length>0) {
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
        default:
        break;
    }
    
}

#pragma mark - 查询新本案设计的接口

-(void)requestNewCaseDesign{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getByConstructionId.do"];
    
    
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *arr = responseObj[@"data"][@"design"];
                if (arr.count<=0) {
                    
                }
                else{

                    
                    
                    NSDictionary *dict = arr.firstObject;
                    

                    self.isFistr = NO;
                    
                    NSArray *temArray = [dict objectForKey:@"detailsList"];
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:temArray];
                    [self.orialArray removeAllObjects];
                    [self.dataArray removeAllObjects];
                    [self.orialArray addObjectsFromArray:arr];
                    [self.dataArray addObjectsFromArray:arr];
                    self.voteDescribe = [dict objectForKey:@"voteDescribe"];
                    self.voteType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"voteType"]];
                    self.order = [[dict objectForKey:@"order"] integerValue];
//                    self.templateStr = [dict objectForKey:@"template"];
                    
                    self.coverTitle = [dict objectForKey:@"designTitle"];
                    self.coverTitleTwo = [dict objectForKey:@"designSubtitle"];
                    self.musicStyle = [[dict objectForKey:@"musicPlay"]integerValue];
                    self.coverImgUrl = [dict objectForKey:@"coverMap"];
                    self.designId = [[dict objectForKey:@"designId"] integerValue];
                    self.endTime = [dict objectForKey:@"voteEndTime"];
                    self.musicUrl = [dict objectForKey:@"musicUrl"];
                    self.musicName = [dict objectForKey:@"musicName"];
                    
                    self.coverImgStr = [dict objectForKey:@"picUrl"] ;
                    self.nameStr = [dict objectForKey:@"picTitle"];
                    self.linkUrl = [dict objectForKey:@"picHref"] ;
                    
                    
                    NSArray *couponArray =[dict objectForKey:@"coupons"];
                    
                    NSArray *redArray = [NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:couponArray];
                    [self.redArray removeAllObjects];
                    [self.redArray addObjectsFromArray:redArray];
                    
                    
                    NSArray *optionArray = [dict objectForKey:@"optionList"];
                    NSArray *arrTwo = [NSArray yy_modelArrayWithClass:[VoteOptionModel class] json:optionArray];
                    [self.optionList removeAllObjects];
                    [self.optionList addObjectsFromArray:arrTwo];
                    
                }
                
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
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

-(void)back{
    
    if (self.isPower) {
        if (self.isComplate) {
            //完工
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[ConstructionDiaryTwoController class]]||[vc isKindOfClass:[MainMaterialDiaryController class]]||[localVC class]) {
                    
                    [self colseMusic];
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        else{
            //未完工
            
            if (self.TemplateBtn.hidden==YES) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑？"
                                                                    message:@""
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定", nil];
                alertView.tag = 200;
                
                [alertView show];
            }
            else{
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ConstructionDiaryTwoController class]]||[vc isKindOfClass:[MainMaterialDiaryController class]]) {
                        
                        [self colseMusic];
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
            
        }
        
    }
    else{
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ConstructionDiaryTwoController class]]||[vc isKindOfClass:[MainMaterialDiaryController class]]||[vc isKindOfClass:[localVC class]]) {
                
                [self colseMusic];
                [self.navigationController popToViewController:vc animated:YES];
            }
            if ([vc isKindOfClass:[casedesignVC class]]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==200) {
        if (buttonIndex==1) {
            self.TemplateBtn.hidden = NO;
            self.textUpOrDownBtn.hidden = YES;
            self.sucessBtn.hidden = YES;
            self.bottomView.hidden = YES;
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[ConstructionDiaryTwoController class]]||[vc isKindOfClass:[MainMaterialDiaryController class]]) {
                    
                    [self colseMusic];
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    }
}

-(void)editBtnClick:(UIButton *)btn{
    
    [self colseMusic];
    
    
    
    
    if (self.isPower) {
        
        if (!self.order) {
            [self.textUpOrDownBtn setTitle:@"图上字下" forState:UIControlStateNormal];
        }
        else{
            [self.textUpOrDownBtn setTitle:@"字上图下" forState:UIControlStateNormal];
        }
        if (self.TemplateBtn.hidden==YES) {
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            if (!self.templateStr||self.templateStr.length<=5) {
                self.templateStr = @"";
                self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order];
            }
            else{
                self.url = [NSString stringWithFormat:@"%@designs/returnDesignHtml.do?constructionId=%ld&agencysId=%ld&order=%ld&templateUrl=%@",BASEURL,(long)self.consID,(long)user.agencyId,(long)self.order,self.templateStr];
            }
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
            [self.webView loadRequest:request];
            
            self.TemplateBtn.hidden = NO;
            self.textUpOrDownBtn.hidden = YES;
            self.sucessBtn.hidden = YES;
            self.bottomView.hidden = YES;
        }
        
        BOOL isKindEditClass = NO;//是否是从编辑页面进入的
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[DesignCaseListController class]]) {
                isKindEditClass = YES;
                break;
            }
            else{
                isKindEditClass = NO;
            }
        }
        
        if (isKindEditClass) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else{
            
            DesignCaseListController *designVC = [[DesignCaseListController alloc]init];
            
            designVC.fromIndex = self.fromIndex;
            designVC.consID = self.consID;
            designVC.isPower = self.isPower;
            designVC.isFistr = NO;
            
            
            designVC.voteDescribe = self.voteDescribe;
            designVC.voteType = self.voteType;
            designVC.companyId = self.companyId;
//            designVC.couponModel = self.couponModel;
            
            designVC.coverTitle = self.coverTitle;
            designVC.coverTitleTwo = self.coverTitleTwo;
            designVC.musicStyle = self.musicStyle;
            designVC.coverImgUrl = self.coverImgUrl;
            designVC.designId = self.designId;
            designVC.endTime = self.endTime;
            designVC.optionList = self.optionList;
            
            designVC.isComplate = self.isComplate;
            
            designVC.orialArray = self.orialArray;
            designVC.dataArray = self.dataArray;
            designVC.redArray = self.redArray;
            
            designVC.musicName = self.musicName;
            designVC.musicUrl = self.musicUrl;
            designVC.companyLogo = self.companyLogo;
            designVC.companyName = self.companyName;
            
            designVC.coverImgStr = self.coverImgStr;
            
            designVC.nameStr = self.nameStr;
            designVC.linkUrl = self.linkUrl;
            
            //        CATransition *transition = [CATransition animation];
            //        transition.duration = 0.3;
            //        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            //        transition.type = kCATransitionPush;
            //        transition.subtype = kCATransitionFromTop;
            //        [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:designVC animated:YES];
            
        }
    }
    else{
        [self shareToOther];
    }
    
    
    
    
    
    
    
}

#pragma mark - scrollerViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    CGFloat pointX = point.x;
    YSNLog(@"%f",pointX);
    NSInteger tag = 0;
    CGFloat dan = 65;
    if (pointX<=dan) {
        tag=0;
    }
    else{
        NSInteger temTag = (pointX/dan);
        CGFloat temPointX = temTag*dan;
        if (pointX>temPointX) {
            //
            tag = temTag;
        }
        else{
            tag = temTag-1;
        }

    }
    //更新下面类型的状态
    
    [self updateTypeBtnState:tag];
}

-(void)colseMusic{
    NSString *trigger = @"stopMusic()";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}


-(void)startMusic{
    NSString *trigger = @"startMusic()";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

#pragma mark - lazy

-(UIWebView *)webView{
    if (!_webView) {
        //        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
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

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, kSCREEN_HEIGHT-50, kSCREEN_WIDTH, 50);
        [_shareBtn setTitle:@"分    享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        _shareBtn.backgroundColor = Main_Color;
        
        [_shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
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
        _redLittleBtn.frame = CGRectMake(kSCREEN_WIDTH-50-15, kSCREEN_HEIGHT-50-15-50, 50, 50);

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
        //        [_redBtn setTitle:@"模版" forState:UIControlStateNormal];
        //        [_redBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        //        _redBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        _redBtn.backgroundColor = White_Color;
        //        _redBtn.layer.masksToBounds = YES;
        //        _redBtn.layer.cornerRadius = _TemplateBtn.width/2;
        [_redDeleteLittleBtn setImage:[UIImage imageNamed:@"red_envelope_delete"] forState:UIControlStateNormal];
        [_redDeleteLittleBtn addTarget:self action:@selector(redDeleteLittleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redDeleteLittleBtn;
}

-(UIImageView *)redBigImgV{
    if (!_redBigImgV) {
//        _redBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _redBigBtn.frame = CGRectMake(kSCREEN_WIDTH/12, kSCREEN_WIDTH/4, kSCREEN_WIDTH/6*5, kSCREEN_WIDTH/2);
        _redBigImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/12, kSCREEN_HEIGHT/4, kSCREEN_WIDTH/6*5, kSCREEN_HEIGHT/4*2)];
        _redBigImgV.image = [UIImage imageNamed:@"red_envelope_icon"];
        _redBigImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(redBigImgVTouch:)];
        [_redBigImgV addGestureRecognizer:ges];
//        [_redBigImgV addTarget:self action:@selector(redLittleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - 底部菜单栏方法

-(void)headbtn0click
{
    NSMutableArray *phoneArray = [NSMutableArray new];
    if (self.companyLandline.length!=0) {
        [phoneArray addObject:self.companyLandline];
    }
    if (self.companyPhone.length!=0) {
        [phoneArray addObject:self.companyPhone];
    }
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"呼叫" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (phoneArray.count==2) {
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:[phoneArray firstObject] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneArray[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:[phoneArray lastObject] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneArray[1]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [control addAction:action0];
        [control addAction:action1];
        [control addAction:action2];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }
    if (phoneArray.count==1) {
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:[phoneArray firstObject] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneArray[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [control addAction:action0];
        [control addAction:action2];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }
    if (phoneArray.count==0) {
        return;
    }
    
    
}

-(void)headbtn1click{// 收藏(取消)
        
        
        
        self.FlipView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight+ 180)];
        [self.view addSubview:self.FlipView];
        
        self.baseView =[[UIView alloc]initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth,  180)];
        self.baseView.backgroundColor =[UIColor whiteColor];
        [self.FlipView addSubview:self.baseView];
        
        UIButton *BtnGift = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, BLEJWidth/6, 30)];
        
        BtnGift.titleLabel.adjustsFontSizeToFitWidth=YES;
        [BtnGift setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [BtnGift setTitle:@"礼物" forState:UIControlStateNormal];
        
        [self.baseView addSubview:BtnGift];
        UIButton *btnLine=[[UIButton alloc]initWithFrame:CGRectMake(20,BtnGift.bottom+3 , BLEJWidth/6-10, 1)];
        btnLine.backgroundColor=[UIColor redColor];
        [self.baseView addSubview:btnLine];
        
        
    _xianHua=[[UIImageView alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
 //   _xianHuaL=[[UILabel alloc]initWithFrame:CGRectMake(20+_xianHua.right+5, 80+10, 20, 20)];
    _jinQi=[[UIImageView alloc]initWithFrame:CGRectMake(20+60+40,80 , 40, 40)];
 //   _jinQiL=[[UILabel alloc]initWithFrame:CGRectMake(20+60+40+_xianHua.right+5, 80+10, 20, 20)];
    [_jinQi setContentMode:UIViewContentModeScaleAspectFill];
    [_xianHua setContentMode:UIViewContentModeScaleAspectFill];
    _jinQi.image=[UIImage imageNamed:@"Personcard_Flag"];
    _xianHua.image= [UIImage imageNamed:@"Personcard_Flower"] ;
//    NSInteger a=  [[NSUserDefaults standardUserDefaults] integerForKey:@"jinQiCount"];
//    NSInteger b= [[NSUserDefaults standardUserDefaults]integerForKey:@"XinahuaCount"];
//    _jinQiL.text =@(a).stringValue;
//    _xianHuaL.text =@(b).stringValue;
        
        
        _jinQi.userInteractionEnabled=YES;
        _xianHua.userInteractionEnabled =YES;
        UITapGestureRecognizer *Tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToJinQiPurchase)];
        
        UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToXianHuaPurchase)];
        [_jinQi addGestureRecognizer:Tap1];
        [_xianHua addGestureRecognizer:Tap2];
        //     [jinQi addTarget:self action:@selector(ToJinQiPurchase) forControlEvents:UIControlEventTouchUpInside];
        //     [xianHua addTarget:self action:@selector(ToXianHuaPurchase) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:_jinQi];
        [self.baseView addSubview:_xianHua];
        [self.baseView addSubview:_jinQiL];
        [self.baseView addSubview:_xianHuaL];
        
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(hiddenView:)];
        
        [self.FlipView addGestureRecognizer:Tap];
        
        
        
        
        [UIView animateWithDuration:0.5f animations:^{
            
            self.FlipView.mj_y = -180;
            self.FlipView.backgroundColor=    [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            
        }];
    }
    
    
    
- (void)hiddenView:(UITapGestureRecognizer*)tapGesture{
        
        CGPoint selectPoint = [tapGesture locationInView:self.FlipView];
        
        NSLog(@"%@",[NSValue valueWithCGPoint:selectPoint]);
        
        //CGRectContainsPoint(CGRect rect, <#CGPoint point#>)判断某个点是否包含在某个CGRect区域内
        
        if(!CGRectContainsPoint(self.baseView.frame, selectPoint)){
            
            [UIView animateWithDuration:0.3f animations:^{
                
                // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
                self.FlipView.mj_y += 180 ;
            } completion:^(BOOL finished) {
                [self.FlipView removeFromSuperview];
            }];
            
        }
        
        
        
    }
#pragma mark 锦旗的购买事件
    -(void)ToJinQiPurchase{
        
        [UIView animateWithDuration:0.3f animations:^{
            
            // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
            self.FlipView.mj_y += 180 ;
        } completion:^(BOOL finished) {
            [self.FlipView removeFromSuperview];
        }];
        JinQiViewController *view =[[JinQiViewController alloc]init];
        view.companyId = self.companyId;
         view.isSendFromCompany =YES;
        WeakSelf(self)
        view.completionBlock = ^(NSString *count) {
            StrongSelf(weakself)
            if (count) {
                
                //  strongself.jinQiL.text=[NSString stringWithFormat:@"%d",(self.pennantnumber.integerValue +1)];
//                NSUserDefaults *defaultUser= [NSUserDefaults standardUserDefaults];
//                NSInteger totalDisk = [defaultUser integerForKey:@"jinQiCount"];
//                //锦旗的数量加一
//                totalDisk=[count integerValue] +1;
//                [defaultUser setInteger:totalDisk forKey:@"jinQiCount"];
//                [defaultUser synchronize];
//                strongself.jinQiL.text = [NSString stringWithFormat:@"%ld",(long)totalDisk];
//                
            }
        };
        [self.navigationController pushViewController:view animated:YES];
    
}
#pragma mark 鲜花的购买事件

-(void)ToXianHuaPurchase{
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    NSLog(@"++++++++++++++++++");
    SendFlowersViewController *Flowerview =[[SendFlowersViewController alloc]init];
    Flowerview.compamyIDD =self.companyId;
    Flowerview.isCompamyID =YES;
    WeakSelf(self)
    Flowerview.blockIsPay = ^(BOOL isPay) {
        StrongSelf(weakself)
        if (isPay ==YES) {
            
            //鲜花的数量加一
//            NSUserDefaults *defaultUser= [NSUserDefaults standardUserDefaults];
//            NSInteger totalDisk = [defaultUser integerForKey:@"XinahuaCount" ];
//
//            totalDisk=totalDisk +1;
//            [defaultUser setInteger:totalDisk  forKey:@"XinahuaCount"];
//            [defaultUser synchronize];
//            strongself.xianHuaL.text = [NSString stringWithFormat:@"%ld",(long)totalDisk];
            
        }
        
    };
    [self.navigationController pushViewController:Flowerview animated:YES];
}
-(void)headbtn2click
{
    BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
    VC.origin = @"1";
    VC.companyID = [NSString stringWithFormat:@"%ld",(long)self.consID];
    VC.isConVip = @"1";
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)headbtn3click
{
    [self didClickHouseBtn];
}


- (void)didClickHouseBtn {// 量房
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
    
    // 在线预约 后台数据统计
    [NSObject needDecorationStatisticsWithConpanyId:[NSString stringWithFormat:@"%@",self.companyId]];
    
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
    [param setObject:[NSString stringWithFormat:@"%@",self.companyId] forKey:@"companyId"];
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
    //    [dic setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.companyId forKey:@"companyId"];
    //    [dic setObject:self.companyDic[@"companyType"] forKey:@"companyType"];
    [dic setObject:@"" forKey:@"companyType"];
    [dic setObject:@(proType) forKey:@"proType"];
    [dic setObject:@"0" forKey:@"agencyId"];
    [dic setObject:@"0" forKey:@"callPage"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
    [dic setObject:@"0" forKey:@"origin"];
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
                completionVC.companyType = weakSelf.companyType?:@"0";
                NSString *constructionType = weakSelf.constructionType?:@"0";
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

@end
