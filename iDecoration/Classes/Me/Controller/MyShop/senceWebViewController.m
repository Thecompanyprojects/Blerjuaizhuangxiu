
//
//  senceWebViewController.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "senceWebViewController.h"
#import <WebKit/WebKit.h>
#import "SenceQRShareView.h"
#import "ZYCShareView.h"
#import "localbannerView.h"
#import "BLEJBudgetGuideController.h"
#import "JinQiViewController.h"
#import "SendFlowersViewController.h"

@interface senceWebViewController ()<WKUIDelegate>
@property (strong, nonatomic) ZYCShareView *shareView;
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 分享的遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 是否是定制会员
@property (nonatomic, assign) BOOL isVIP;
// 二维码
@property (strong, nonatomic) SenceQRShareView *TwoDimensionCodeView;

@property (nonatomic, strong) CAShapeLayer *border;
@property (nonatomic, strong) localbannerView *bannerView;

@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@property(nonatomic,strong)UIView *FlipView;
@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)UIImageView *xianHua;
@property(nonatomic,strong)UIImageView *jinQi;
@property(nonatomic,strong)UILabel *xianHuaL;
@property(nonatomic,strong)UILabel *jinQiL;
@end

@implementation senceWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"全景图";
    
    if (!self.titleStr||self.titleStr.length<=0) {
        self.title = @"全景图";
    }else{
        self.title = self.titleStr;
    }
    
    if (self.isguanggao) {
        self.title = @"广告位";
    }
    
    if (!self.isFrom) {
        
//        if (![self.model.picHref ew_isUrlString]) {
//             [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
//            return;
//        }
        
        NSURL *url = [NSURL URLWithString:self.model.picHref];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        WKWebView  *web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        web.UIDelegate = self;
        [web loadRequest:request];
        
        [self.view addSubview:web];
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        
        // 分享视图
        [self addBottomShareView];
        [self TwoDimensionCodeView];
        
       
        
    }
    
    else{
        
        if (![self.webUrl ew_isUrlString]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
            return;
        }
        
        NSURL *url = [NSURL URLWithString:self.webUrl];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        WKWebView  *web = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        web.UIDelegate = self;
        [web loadRequest:request];
        
        [self.view addSubview:web];
       
    }
    if (self.isfromlocal) {
        [self.view addSubview:self.bannerView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}

-(void)share{

    [self.shareView share];

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

#pragma  mark - 分享 ↓
- (void)addBottomShareView {


    self.shareView = [ZYCShareView sharedInstance];
    [self makeShareView];

}

- (void)makeShareView {
    WeakSelf(self);
    self.shareView.URL = self.model.picHref;
    self.shareView.imageURL = self.model.picUrl;
    self.shareView.shareTitle = self.model.picTitle;
    self.shareView.shareCompanyIntroduction = @"爱装修";
    self.shareView.shareCompanyLogo = self.model.picUrl;
    self.shareView.shareViewType = ZYCShareViewTypeCompanyOnly;
    [self.shareView share];
    weakself.shareView.blockQRCode1st = ^{
        [MobClick event:@"ShopYellowPageShare"];
        weakself.TwoDimensionCodeView.hidden = NO;
        weakself.shadowView.hidden = YES;
        weakself.bottomShareView.blej_y = BLEJHeight;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.TwoDimensionCodeView.alpha = 1.0;
            weakself.navigationController.navigationBar.alpha = 0;
        }];
    };
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
}

- (void)didClickShareContentBtn:(UIButton *)btn {

    
    NSString *shareTitle = self.model.picTitle;
    NSString *shareDescription = @"爱装修";

    NSURL *shareImageUrl = [NSURL URLWithString:self.model.picUrl];
    UIImage *shareImage;
    NSData *shareData;
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
    [[UIApplication sharedApplication].keyWindow hiddleHud];
    if (image) {
        shareImage = image;
        
        UIGraphicsBeginImageContext(CGSizeMake(300, 300));
        [shareImage drawInRect:CGRectMake(0,0,300,300)];
        shareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
        CGFloat scale = 32.0 / data.length;
        shareData  = UIImageJPEGRepresentation(shareImage, scale);
        
    } else {
        shareImage = [UIImage imageNamed:@"shareDefaultIcon"];
        shareData = UIImagePNGRepresentation(shareImage);
        
    }
    
    
    NSString *shareURL = self.model.picHref;
    
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            //            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.shopID]];
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopYellowPageShare"];
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
            [message setThumbImage:shareImage];
            //            [message setThumbImage:[UIImage imageNamed:@"top_default"]];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            //            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.shopID]];
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopYellowPageShare"];
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
                
                //                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.shopID]];
                NSURL *url = [NSURL URLWithString:shareURL];
                // title = 分享标题
                // description = 施工单位 小区名称
                
                
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopYellowPageShare"];
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
                
                //                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.shopID]];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopYellowPageShare"];
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
        {// 二维码
            [MobClick event:@"ShopYellowPageShare"];
            self.TwoDimensionCodeView.hidden = NO;
            self.shadowView.hidden = YES;
            self.bottomShareView.blej_y = BLEJHeight;
            [UIView animateWithDuration:0.25 animations:^{
                
                self.TwoDimensionCodeView.alpha = 1.0;
                self.navigationController.navigationBar.alpha = 0;
            }];
        }
            break;
        default:
            break;
    }
    
}


- (void)didClickTwoDimensionCodeView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}

- (SenceQRShareView *)TwoDimensionCodeView {
    if (_TwoDimensionCodeView == nil) {
        _TwoDimensionCodeView = [[SenceQRShareView alloc] init];
        _TwoDimensionCodeView.frame = self.view.frame;
        [self.view addSubview:_TwoDimensionCodeView];
        
        _TwoDimensionCodeView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
        [_TwoDimensionCodeView addGestureRecognizer:tap];
        
        
        NSString *shareURL = self.model.picHref;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow hudShow];
            });
            
            UIImage *shareImage;
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:self.companyLogo]]];
            if (image) {
                shareImage = image;
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            } else {
                shareImage = [UIImage imageNamed:@"shareDefaultIcon"];
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow hiddleHud];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_TwoDimensionCodeView.goodsCoverImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl] placeholderImage:nil options:SDWebImageRetryFailed];
            
                _TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.2];
                
            });
        });
        
        _TwoDimensionCodeView.goodsNameLabel.text = self.model.picTitle;
        
        _TwoDimensionCodeView.hidden = YES;
        
    }
    return _TwoDimensionCodeView;
}

#pragma mark  分享 ↑
-(void)headbtn1click{
    
//}
//- (void)didClickCollectionBtn:(UIButton *)btn {// 收藏(取消)
    
    
    
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
   // _xianHuaL=[[UILabel alloc]initWithFrame:CGRectMake(20+_xianHua.right+5, 80+10, 20, 20)];
    _jinQi=[[UIImageView alloc]initWithFrame:CGRectMake(20+60+40,80 , 40, 40)];
 //  _jinQiL=[[UILabel alloc]initWithFrame:CGRectMake(20+60+40+_xianHua.right+5, 80+10, 20, 20)];
    [_jinQi setContentMode:UIViewContentModeScaleAspectFill];
    [_xianHua setContentMode:UIViewContentModeScaleAspectFill];
    _jinQi.image=[UIImage imageNamed:@"Personcard_Flag"];
    _xianHua.image= [UIImage imageNamed:@"Personcard_Flower"] ;
    NSInteger a=  [[NSUserDefaults standardUserDefaults] integerForKey:@"jinQiCount"];
    NSInteger b= [[NSUserDefaults standardUserDefaults]integerForKey:@"XinahuaCount"];
    _jinQiL.text =@(a).stringValue;
    _xianHuaL.text =@(b).stringValue;
    
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
//    [self.baseView addSubview:_jinQiL];
//    [self.baseView addSubview:_xianHuaL];
    
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
     view.isSendFromCompany =YES;
    view.companyId = self.companyId;
    WeakSelf(self)
    view.completionBlock = ^(NSString *count) {
        StrongSelf(weakself)
        if (count) {
         
            strongself.jinQiL.text=[NSString stringWithFormat:@"%d",(self.pennantnumber.integerValue +1)];

        }
    };
    [self.navigationController pushViewController:view animated:YES];
    
}
#pragma mark 鲜花的购买事件

-(void)ToXianHuaPurchase{
    NSLog(@"++++++++++++++++++");
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    SendFlowersViewController *Flowerview =[[SendFlowersViewController alloc]init];
    Flowerview.compamyIDD =self.companyId;
    Flowerview.isCompamyID =YES;
    WeakSelf(self)
    Flowerview.blockIsPay = ^(BOOL isPay) {
        StrongSelf(weakself)
        if (isPay ==YES) {
            //鲜花的数量加一
              strongself.xianHuaL.text =[NSString stringWithFormat:@"%d",(self.flowerNumber.integerValue +1)];
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



-(void)headbtn2click
{
    BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
    VC.origin = @"1";
    VC.companyID = self.companyId;
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

