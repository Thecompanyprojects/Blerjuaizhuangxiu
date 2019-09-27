//
//  WSRedPacketView.m
//  Lottery
//
//  Created by tank on 2017/12/16.
//  Copyright © 2017年 tank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WSRedPacketView.h"
#import "NSString+Extension.h"
#import "UIView+Extension.h"
#import "CodeView.h"
#import "NSObject+CompressImage.h"
#import "DesignImageViewController.h"

//*******************************
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ViewScaleIphone5Value    ([UIScreen mainScreen].bounds.size.width/320.0f)




#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
// CAAnimationDelegate is not available before iOS 10 SDK
@interface WSRedPacketView ()<UIGestureRecognizerDelegate>
#else
@interface WSRedPacketView () <CAAnimationDelegate,UIGestureRecognizerDelegate>{
    NSDictionary *_couponDict;//代金券字典
    NSDictionary *_productDict;//礼品券字典
}
#endif

@property (nonatomic,strong) UIWindow       *alertWindow;

@property (nonatomic,strong) UIImageView    *backgroundImageView;
@property (nonatomic,strong) WSRewardConfig *data;
@property (nonatomic,strong) UIImageView    *avatarImageView;
@property (nonatomic,strong) UILabel        *userNameLabel;


@property (nonatomic,strong) UILabel        *tipsLabel;
@property (nonatomic,strong) UILabel        *messageLabel;

@property (nonatomic, strong) UIButton *QrBtn;//二维码视图或礼品封面图
//@property (nonatomic, strong) UILabel *clickLookDL;//点击查看详情
@property (nonatomic, strong) UIButton *clickLookBtn;//点击查看详情

@property (nonatomic,strong) UIImageView    *squareImgV;//方框
@property (nonatomic, strong) UIButton *reciveBtn;//点击领取按钮
@property (nonatomic, strong) UILabel *priceL;//价格label
@property (nonatomic,strong) UIButton       *openButton;
@property (nonatomic,strong) UIButton       *closeButton;

@property (nonatomic,strong) UIView *modifyV;//手机号验证页面
@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;//验证码
@property (nonatomic, strong) UIButton *sucessBtn;//完成

@property (nonatomic, strong) UIButton *rotateBtn;

@property (nonatomic, strong) UIImage *couponImg;//代金券二维码图片
@property (nonatomic, strong) UIImage *productImg;//礼品券二维码图片
@property (nonatomic, strong) UIImage *faceImg;//礼品券封面图（图片）

@property (nonatomic, strong) UIButton *testBtn;

@property (nonatomic,copy) WSCancelBlock    cancelBlock;
@property (nonatomic,copy) WSFinishBlock    finishBlock;

@end

@implementation WSRedPacketView



- (instancetype)initRedPacker
{
    self = [super init];
    
    if (self) {
        
        
        
        [self.alertWindow addSubview:self.view];
        [self.alertWindow addSubview:self.backgroundImageView];
        
        
        [self.backgroundImageView addSubview:self.openButton];
        [self.backgroundImageView addSubview:self.closeButton];
        
        [self.backgroundImageView addSubview:self.messageLabel];
        
        [self.backgroundImageView addSubview:self.testBtn];
        
        [self.backgroundImageView addSubview:self.tipsLabel];
        [self.backgroundImageView addSubview:self.rotateBtn];
        self.rotateBtn.hidden = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeViewAction)];
        tapGesture.delegate = self;
        [self.view addGestureRecognizer:tapGesture];
        
        [self initData];
        
    }
    return self;
}

#pragma mark -初始化代金券或礼品券（领券）
- (void)showCouponView
{

    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcouponcustomer/save.do"];

    [[UIApplication sharedApplication].keyWindow hudShow];
    
    NSString *uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *longitude = [NSString stringWithFormat:@"%f",self.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",self.latitude];
    NSDictionary *paramDic = @{@"couponId":self.couponId?self.couponId:@"0",
                               @"uuid":uuidStr,
                               @"longitude":longitude,
                               @"latitude":latitude,
                               @"giftCouponId":self.giftCouponId?self.giftCouponId:@"0"
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                
                self.rotateBtn.hidden = YES;
                
                
                NSDictionary *TempCouponDict = responseObj[@"data"][@"coupon"][@"couponInfo"];
                NSDictionary *TempgiftCouponDict = responseObj[@"data"][@"giftCoupon"][@"couponInfo"];
                
                if (TempCouponDict&&[TempCouponDict allValues].count>0&&TempgiftCouponDict&&[TempgiftCouponDict allValues].count>0) {
                    self.couponType = 3;
                }
                if ((TempCouponDict&&[TempCouponDict allValues].count>0)&&(!TempgiftCouponDict||[TempgiftCouponDict allValues].count<=0)) {
                    self.couponType = 1;
                }
                if ((!TempCouponDict||[TempCouponDict allValues].count<=0)&&(TempgiftCouponDict&&[TempgiftCouponDict allValues].count>0)) {
                    self.couponType = 2;
                }
               
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                if (self.couponType==1) {
                    //代金券
                    NSDictionary *couponDict = responseObj[@"data"][@"coupon"];
                    NSDictionary *couponInfo = couponDict[@"couponInfo"];
                    
                    
                    couponDict = couponInfo;
                    self.priceStr = [couponInfo objectForKey:@"money"];
                    self.couponCode = [couponInfo objectForKey:@"receiveCode"];
                    self.couponCcId = [couponInfo objectForKey:@"ccId"];
                    self.couponId = [couponInfo objectForKey:@"couponId"];
                    
                    NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"cblejcouponcustomer/%@.do", self.couponCode]];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.couponImg = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0.3];
                        });
                    });
                    self.modifyTag = 1;
                }
                if (self.couponType==2) {
                    //礼品券
                    NSDictionary *giftCouponDict = responseObj[@"data"][@"giftCoupon"];
                    NSDictionary *giftDict = giftCouponDict[@"gift"];
                    self.couponNameStr = giftDict[@"giftName"];
                    self.faceImgStr = giftDict[@"faceImg"];
                    
                    NSDictionary *productInfoDict = giftCouponDict[@"couponInfo"];
                    _productDict = productInfoDict;
                    
                    self.productCode = [productInfoDict objectForKey:@"receiveCode"];
                    
                    self.productCcId = [NSString stringWithFormat:@"%@",[productInfoDict objectForKey:@"ccId"]];
                    self.giftCouponId = [productInfoDict objectForKey:@"couponId"];
                    
                    NSString *shareURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"cblejcouponcustomer/%@.do", self.productCode]];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.productImg = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0.3];
                        });
                    });
                    
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.faceImgStr]];
                    UIImage *img = [UIImage imageWithData:data];
                    self.faceImg = img;
                    self.modifyTag = 2;
                }
                if (self.couponType==3) {
                    self.rotateBtn.hidden = NO;
                    //代金券
                    NSDictionary *couponDict = responseObj[@"data"][@"coupon"];
                    NSDictionary *couponInfo = couponDict[@"couponInfo"];
                    self.priceStr = [couponInfo objectForKey:@"money"];
                    self.couponCode = [couponInfo objectForKey:@"receiveCode"];
                    self.couponCcId = [couponInfo objectForKey:@"ccId"];
                    self.couponId = [couponInfo objectForKey:@"couponId"];
                    
                    _couponDict = couponInfo;
                    
                    //礼品券
                    NSDictionary *giftCouponDict = responseObj[@"data"][@"giftCoupon"];
                    NSDictionary *giftDict = giftCouponDict[@"gift"];
                    self.couponNameStr = giftDict[@"giftName"];
                    self.faceImgStr = giftDict[@"faceImg"];
                    
                    NSDictionary *productInfoDict = giftCouponDict[@"couponInfo"];
                    self.productCode = [productInfoDict objectForKey:@"receiveCode"];
                    self.productCcId = [productInfoDict objectForKey:@"ccId"];
                    self.giftCouponId = [productInfoDict objectForKey:@"couponId"];
                    _productDict = productInfoDict;
                    
                    
                    NSString *shareOneURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"cblejcouponcustomer/%@.do", self.couponCode]];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.couponImg = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareOneURL logoImageName:nil logoScaleToSuperView:0.3];
                        });
                    });
                    
                    NSString *shareTwoURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"cblejcouponcustomer/%@.do", self.productCode]];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.productImg = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareTwoURL logoImageName:nil logoScaleToSuperView:0.3];
                        });
                    });
                    
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.faceImgStr]];
                    UIImage *img = [UIImage imageWithData:data];
                    self.faceImg = img;
                    
                }
                
                self.openButton.hidden = YES;
                self.isHaveOpen = YES;
                
                
                NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"恭喜您获得\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30], NSForegroundColorAttributeName: Yellow_Color} ];
                
                NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:self.companyNameStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: White_Color} ];
                [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
                NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"发放的红包\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Yellow_Color} ];
                [tempAttrStringOne appendAttributedString:tempAttrStringThree];
                
                
                _messageLabel.attributedText = tempAttrStringOne;
                NSString *str = @"*此红包每个手机号只能领取一次\n*需要到发放红包的商家使用";
                _tipsLabel.text = str;
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
                
                CGSize retSize = [str boundingRectWithSize:CGSizeMake(_backgroundImageView.frame.size.width - 80, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                _tipsLabel.frame = CGRectMake(40, _backgroundImageView.frame.size.height-retSize.height-60, _backgroundImageView.frame.size.width - 80, retSize.height);
            
                
                [self resetSquareV];
                
                if (self.couponType==2){
                    [self transToProductView];
                }
                
                self.backgroundImageView.image = [UIImage imageNamed:@"redpacket_bg_Two"];
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"卷已不存在" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"超出领取范围" controller:self sleep:1.5];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已领取完" controller:self sleep:1.5];
            }
            else if (statusCode==1005) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已过期" controller:self sleep:1.5];
            }else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"领取出错" controller:self sleep:1.5];
            }
            else if (statusCode==2001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"领取失败请重试" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
    
    
    
}


-(void)resetSquareV{
    if (!_reciveBtn) {
        UIButton *reciveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reciveBtn.frame = CGRectMake(self.squareImgV.frame.origin.x+(self.squareImgV.frame.size.width)-17-(_squareImgV.frame.size.height-40), _squareImgV.frame.origin.y+21, _squareImgV.frame.size.height-40, _squareImgV.frame.size.height-40);
        [reciveBtn setImage:[UIImage imageNamed:@"red_receive"] forState:UIControlStateNormal];
        self.reciveBtn = reciveBtn;
        [self.backgroundImageView addSubview:self.reciveBtn];
    }
    

    
    if (!_priceL) {
        UILabel *priceL = [[UILabel alloc]initWithFrame:CGRectMake(self.backgroundImageView.frame.origin.x+17,self.reciveBtn.frame.origin.y,120,self.reciveBtn.frame.size.height)];
        priceL.textColor = [UIColor colorWithRed:245.0/255.0 green:193.0/255.0 blue:150.0/255.0 alpha:1];
        priceL.font = [UIFont systemFontOfSize:23];;
        //        priceL.text = @"10元代金券";
        priceL.numberOfLines = 0;
        priceL.textAlignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:self.priceStr?self.priceStr:@"0" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30], NSForegroundColorAttributeName: [UIColor blackColor]} ];
        
        NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:@"元代金券" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor blackColor]} ];
        [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
        priceL.attributedText = tempAttrStringOne;
        
        self.priceL = priceL;
        [self.backgroundImageView addSubview:self.priceL];
    }
}

-(void)initData{
    

    
}



- (UIWindow *)alertWindow
{
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.windowLevel = UIWindowLevelAlert;
        _alertWindow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [_alertWindow makeKeyAndVisible];
        _alertWindow.rootViewController = self;
    }
    return _alertWindow;
}


- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        
        UIImage *image =  [UIImage imageNamed:@"redpacket_bg"];
        
        CGFloat width = ScreenWidth - 50 * ViewScaleIphone5Value;
        CGFloat height = width * (image.size.height / image.size.width);
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25 * ViewScaleIphone5Value, ScreenHeight / 2 - height / 2, width, height)];
        _backgroundImageView.image = image;

        self.backgroundImageView.transform = CGAffineTransformMakeScale(0.05, 0.05);
        
        [UIView animateWithDuration:.15
                         animations:^{
                             self.backgroundImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                         }completion:^(BOOL finish){
                             [UIView animateWithDuration:.15
                                              animations:^{
                                                  self.backgroundImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                              }completion:^(BOOL finish){
                                                  [UIView animateWithDuration:.15
                                                                   animations:^{
                                                                       self.backgroundImageView.transform = CGAffineTransformMakeScale(1, 1);
                                                                   }];
                                              }];
                         }];
    }
    return _backgroundImageView;
}

- (UIButton *)openButton
{
    if (!_openButton) {

        CGFloat widthOrHeight = 100 * ViewScaleIphone5Value;
        
        _openButton = [[UIButton alloc]initWithFrame:CGRectMake(_backgroundImageView.frame.size.width/2 - widthOrHeight/2, _backgroundImageView.frame.size.height/4 , widthOrHeight,widthOrHeight)];
        [_openButton setImage:[UIImage imageNamed:@"redpacket_open_btn"] forState:UIControlStateNormal];
        
    }
    return _openButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundImageView.right-40-18, -13, 40, 40)];
        [_closeButton setImage:[UIImage imageNamed:@"red_envelope_delete"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_backgroundImageView.frame.size.width/2 - 24, 35, 48, 48)];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 3;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_avatarImageView setImage:_data.avatarImage];
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _avatarImageView.frame.size.height + _avatarImageView.frame.origin.y + 10, _backgroundImageView.frame.size.width - 40, 20)];
        _userNameLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:226.0/255.0 blue:177.0/255.0 alpha:1];
        _userNameLabel.font = [UIFont systemFontOfSize:17];
        _userNameLabel.text = _data.userName;
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLabel;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {

        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, _backgroundImageView.frame.size.height-60-20, _backgroundImageView.frame.size.width - 80, 80)];
        _tipsLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:193.0/255.0 blue:150.0/255.0 alpha:1];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        NSString *str = @"*此红包每个手机号只能领取一次\n*需要到发放红包的商家使用";
        _tipsLabel.text = str;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        
        CGSize retSize = [str boundingRectWithSize:CGSizeMake(_backgroundImageView.frame.size.width - 80, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _tipsLabel.frame = CGRectMake(40, _backgroundImageView.frame.size.height-retSize.height-60, _backgroundImageView.frame.size.width - 80, retSize.height);
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tipsLabel;
}

-(UIButton *)rotateBtn{
    if (!_rotateBtn) {
        _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rotateBtn.frame = CGRectMake(self.backgroundImageView.right-35-50,self.tipsLabel.bottom-10,35,35);
        [_rotateBtn setImage:[UIImage imageNamed:@"red_rotateToProduct"] forState:UIControlStateNormal];
    }
    return _rotateBtn;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
//        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _tipsLabel.frame.size.height + _tipsLabel.frame.origin.y + 10 * ViewScaleIphone5Value, _backgroundImageView.frame.size.width - 40, 27 * ViewScaleIphone5Value)];
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, _backgroundImageView.frame.size.width - 80, 100)];
        _messageLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:193.0/255.0 blue:150.0/255.0 alpha:1];
        _messageLabel.font = [UIFont systemFontOfSize:23];;
//        _messageLabel.text = @"恭喜你获得\n xxx发放的";
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
//        [self.backgroundImageView addSubview:_messageLabel];
    }
    return _messageLabel;
}

-(UIButton *)QrBtn{
    if (!_QrBtn) {
        _QrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *image = [UIImage imageNamed:DefaultManPic];
        _QrBtn.frame = CGRectMake(self.backgroundImageView.width/2-120/2, self.messageLabel.bottom+10, 120, 120);
//        _QrBtn.frame = CGRectMake(self.messageLabel.left, self.messageLabel.bottom, 20, 20);
//        [_QrBtn setImage:image forState:UIControlStateNormal];
//        _QrBtn.backgroundColor = Blue_Color;
        [self.backgroundImageView addSubview:_QrBtn];
    }
    return _QrBtn;
}


//-(UILabel *)clickLookDL{
//    if (!_clickLookDL) {
//        _clickLookDL = [[UILabel alloc]initWithFrame:CGRectMake(self.backgroundImageView.width/2-100/2, self.QrBtn.bottom+5, 100, 20)];
//        _clickLookDL.textColor = COLOR_BLACK_CLASS_3;
//        _clickLookDL.font = NB_FONTSEIZ_NOR;
//        _clickLookDL.textAlignment = NSTextAlignmentCenter;
//
//        NSString *textStr = @"点击查看详情"; // 下划线
//        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic]; //赋值
//        _clickLookDL.attributedText = attribtStr;
//    return _clickLookDL;
//}

-(UIButton *)clickLookBtn{
    if (!_clickLookBtn) {
        _clickLookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickLookBtn.frame = CGRectMake(self.backgroundImageView.width/2-100/2, self.QrBtn.bottom+5, 100, 20);
        _clickLookBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_clickLookBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _clickLookBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        
        NSString *textStr = @"点击查看详情"; // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic]; //赋值
        [_clickLookBtn setAttributedTitle:attribtStr forState:UIControlStateNormal];
        [self.backgroundImageView addSubview:_clickLookBtn];
    }
        return _clickLookBtn;
}

-(UIImageView *)squareImgV{
    if (!_squareImgV) {
        _squareImgV = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.messageLabel.frame.origin.y+self.messageLabel.frame.size.height+10, self.backgroundImageView.frame.size.width-40, 20)];
        UIImage *image =  [UIImage imageNamed:@"red_square"];
        
        CGFloat width = self.backgroundImageView.frame.size.width-40;
        CGFloat height = width * (image.size.height / image.size.width);
        _squareImgV.frame = CGRectMake(20, self.messageLabel.frame.origin.y+self.messageLabel.frame.size.height+10, width, height);
        _squareImgV.image = image;
        
        [self.backgroundImageView addSubview:_squareImgV];
        
    }
    return _squareImgV;
}


-(UIButton *)testBtn
{
    if(!_testBtn)
    {
        _testBtn = [[UIButton alloc] init];
        _testBtn.backgroundColor = COLOR_BLACK_CLASS_Y;
        [_testBtn setTitle:@"点击图片领取" forState:normal];
        [_testBtn setTitleColor:COLOR_BLACK_CLASS_O forState:normal];
        _testBtn.layer.masksToBounds = YES;
        _testBtn.layer.cornerRadius = 10;
        //  _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, _backgroundImageView.frame.size.width - 80, 100)];
        
        
    }
    return _testBtn;
}


- (void)closeViewAction{

    [UIView animateWithDuration:.2 animations:^{
        self.backgroundImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.08
                         animations:^{
                             self.backgroundImageView.transform = CGAffineTransformMakeScale(0.25, 0.25);
                         }completion:^(BOOL finish){
                             [self.alertWindow removeFromSuperview];
                             self.alertWindow.rootViewController = nil;
                             self.alertWindow = nil;
                             
                             if (self.cancelBlock) {
                                 self.cancelBlock();
                             }
                             
                         }];
    }];

}

- (void)openRedPacketAction
{
    [_openButton.layer addAnimation:[self confirmViewRotateInfo] forKey:@"transform"];
}
-(void)backGroundRotateAction{
    if (self.tag==0) {
        self.tag = 1;
    }
    else{
        if (self.tag==1) {
            self.tag=2;
        }
        else{
            self.tag=1;
        }
    }
    
//    self.tag = 1;
    [self.backgroundImageView.layer addAnimation:[self confirmViewRotateInfoTwo] forKey:@"transform"];
}


- (CAKeyframeAnimation *)confirmViewRotateInfo
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.28, 0, 0.5, 0)],
                           nil];
    
    
    theAnimation.cumulative = YES;
    theAnimation.duration = .4;
    theAnimation.repeatCount = 1;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = self;
    
    
    [theAnimation setValue:@"three" forKey:@"type"];
    
    
    
    
    
    return theAnimation;
}

- (CAKeyframeAnimation *)confirmViewRotateInfoTwo
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.28, 0, 0.5, 0)],
                           nil];
    
    
    theAnimation.cumulative = YES;
    theAnimation.duration = .4;
    theAnimation.repeatCount = 1;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = self;
    
    if (self.tag==0) {
        self.tag = 1;
    }
    if (self.tag==1) {
        //        self.tag=2;
        
        [theAnimation setValue:@"one" forKey:@"type"];
    }
    if (self.tag==2) {
        //        self.tag=1;
        [theAnimation setValue:@"two" forKey:@"type"];
    }
    
    return theAnimation;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {

    if ([_openButton pointInside:[touch locationInView:_openButton] withEvent:nil]) {
        
        [self openRedPacketAction];
        
        return NO;
    }

    if ([_closeButton pointInside:[touch locationInView:_closeButton] withEvent:nil]) {
        
        [self closeViewAction];
        
        return NO;
    }
    
    if ([_reciveBtn pointInside:[touch locationInView:_reciveBtn] withEvent:nil]) {
        self.modifyTag = 1;
        [self showVi];
        
        return NO;
    }
    
    if ([_QrBtn pointInside:[touch locationInView:_QrBtn] withEvent:nil]) {
        self.modifyTag = 2;
        [self showVi];
        
        return NO;
    }
    
    if ([_clickLookBtn pointInside:[touch locationInView:_clickLookBtn] withEvent:nil]) {
        if (self.lookBlock&&self.isHaveModify) {
            [self closeViewAction];
            if (self.modifyTag==1) {
                self.lookBlock(_couponDict);
            }
            if (self.modifyTag==2) {
                self.lookBlock(_productDict);
            }
        }
        
        return NO;
    }
    
    if ([_rotateBtn pointInside:[touch locationInView:_rotateBtn] withEvent:nil]&&self.couponType==3) {
        [self backGroundRotateAction];
        return NO;
    }
    
    return (![_backgroundImageView pointInside:[touch locationInView:_backgroundImageView] withEvent:nil]);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    
    if ([[anim valueForKey:@"type"] isEqualToString:@"one"]&&self.couponType==3) {
        [self transToProductView];
    }
    
    if ([[anim valueForKey:@"type"] isEqualToString:@"two"]&&self.couponType==3) {
        [self transToCouponView];
    }
    
    if ([[anim valueForKey:@"type"] isEqualToString:@"three"]&&!self.isHaveOpen) {//代金券
        [self showCouponView];
    }
}


#pragma mark - 验证码页面

-(void)showVi{
//    NSLog(@"232");
    if (!_modifyV) {
//        _modifyV =[[UIView alloc]initWithFrame:CGRectMake(self.backgroundImageView.frame.origin.x+10, (kSCREEN_HEIGHT-225)/2, self.backgroundImageView.frame.size.width-20, 225)];
        _modifyV =[[UIView alloc]initWithFrame:CGRectMake(0, self.backgroundImageView.height/2-225/2, self.backgroundImageView.frame.size.width, 265)];

        _modifyV.backgroundColor = [UIColor whiteColor];
        _modifyV.layer.masksToBounds = YES;
        _modifyV.layer.cornerRadius = 10;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, self.modifyV.frame.size.width-50, 40)];
        
        lab.text = @"请输入您的姓名，手机号，\n方便商家兑换时使用";
        lab.numberOfLines = 0;
        lab.textColor = [UIColor hexStringToColor:@"5D5E5F"];
        lab.font = [UIFont systemFontOfSize:15];
        [_modifyV addSubview:lab];
        [self.backgroundImageView addSubview:_modifyV];
        self.backgroundImageView.userInteractionEnabled = YES;
        CGFloat textFTop = 15;
        for (int i = 0; i<3; i++) {
            
            
//            UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(25,lab.bottom+10,self.modifyV.frame.size.width-50,40)];
            UITextField *textF = [[UITextField alloc]init];
            textF.textColor = COLOR_BLACK_CLASS_3;
            textF.font = [UIFont systemFontOfSize:16];
            [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
            [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
            textF.layer.masksToBounds = YES;
            textF.layer.cornerRadius = 5;
            textF.layer.borderWidth = 1.0;
            textF.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
            textF.text = @"";
//            [self.modifyV addSubview:textF];

            if (i==0) {
                textF.frame = CGRectMake(25, lab.bottom+10, self.modifyV.frame.size.width-50, 40);
                textF.placeholder = @"请输入你的姓名";
                //                textF.tag = 1000;
                //                textF.delegate = self;
                if (!_nameTextF) {
                    self.nameTextF = textF;
                }
                [self.modifyV addSubview:self.nameTextF];
            }
            else if (i==1) {
                textF.frame = CGRectMake(25, lab.bottom+10+50, self.modifyV.frame.size.width-50, 40);
                textF.placeholder = @"请输入你的手机号";
                //                textF.tag = 1001;
                //                textF.delegate = self;
                if (!_phoneTextF) {
                    self.phoneTextF = textF;
                }
                [self.modifyV addSubview:self.phoneTextF];
            }
            else{
                textF.frame = CGRectMake(25, lab.bottom+10+100, self.modifyV.frame.size.width-50, 40);
               textF.placeholder = @"验证码";
                if (!_codeTextF) {
                    self.codeTextF = textF;
                }
                [self.modifyV addSubview:self.codeTextF];
                
                UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                sendBtn.frame = CGRectMake(textF.right-textF.width/5*2,textF.top,textF.width/5*2,textF.height);
                sendBtn.backgroundColor = Main_Color;
                [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [sendBtn setTitleColor:White_Color forState:UIControlStateNormal];
                sendBtn.titleLabel.font = NB_FONTSEIZ_BIG;
                //        self.codeBtn = successBtn;
                [sendBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        sendBtn.layer.masksToBounds = YES;
                        sendBtn.layer.cornerRadius = 5;
                [self.modifyV addSubview:sendBtn];
            }

            textFTop = textFTop+50;

            
        }
        
        UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        successBtn.frame = CGRectMake(40,textFTop+50,self.modifyV.frame.size.width-80,40);
        successBtn.backgroundColor = Main_Color;
        [successBtn setTitle:@"完  成" forState:UIControlStateNormal];
        successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [successBtn setTitleColor:White_Color forState:UIControlStateNormal];
        successBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        successBtn.layer.masksToBounds = YES;
        successBtn.layer.cornerRadius = 5;
        [successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (!_sucessBtn) {
            self.sucessBtn = successBtn;
        }
        [self.modifyV addSubview:self.sucessBtn];
    }
    
    self.backgroundImageView.userInteractionEnabled = YES;
    self.modifyV.hidden = NO;
    [self.backgroundImageView bringSubviewToFront:self.modifyV];
}

#pragma mark - 验证手机验证码
-(void)successBtnClick:(UIButton *)btn{

    
    
    [self.alertWindow endEditing:YES];
    
    self.nameTextF.text = [self.nameTextF.text ew_removeSpaces];
    if (self.nameTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"姓名不能为空" controller:self sleep:1.5];
        return;
    }
    
    self.phoneTextF.text = [self.phoneTextF.text ew_removeSpaces];
    if (self.phoneTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号不能为空" controller:self sleep:1.5];
        return;
    }
    if (![self.phoneTextF.text ew_justCheckPhone]||self.phoneTextF.text.length>11) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号格式不正确" controller:self sleep:1.5];
        return;
    }
    
    self.codeTextF.text = [self.codeTextF.text ew_removeSpaces];
    if (self.codeTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"验证码不能为空" controller:self sleep:1.5];
        return;
    }
    
    NSString *phone = self.phoneTextF.text;
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcouponcustomer/checkPhoneCode.do"];
    
    NSString *couponIdStr;
    NSString *receiveCodeStr;
    NSString *ccidStr;
    
    if (self.modifyTag==1) {
        couponIdStr = self.couponId;
        receiveCodeStr = self.couponCode;
        ccidStr = self.couponCcId;
    }
    if (self.modifyTag==2) {
        couponIdStr = self.giftCouponId;
        receiveCodeStr = self.productCode;
        ccidStr = self.productCcId;
    }
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"phone":phone,
                               @"couponId":couponIdStr?couponIdStr:@"0",
                               @"code":self.codeTextF.text,
                               @"ccId":ccidStr?ccidStr:@"0",
                               @"receiveCode":receiveCodeStr?receiveCodeStr:@"0",
                               @"customerName":self.nameTextF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [self showSucessView];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码已过期" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码错误" controller:self sleep:1.5];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已经领取过" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
            [self.alertWindow endEditing:NO];
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
    
    
    self.backgroundImageView.userInteractionEnabled = NO;
}

-(void)codeBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    [self.alertWindow endEditing:YES];
    
    self.nameTextF.text = [self.nameTextF.text ew_removeSpaces];
    if (self.nameTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"姓名不能为空" controller:self sleep:1.5];
        return;
    }
    
    self.phoneTextF.text = [self.phoneTextF.text ew_removeSpaces];
    if (self.phoneTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号不能为空" controller:self sleep:1.5];
        return;
    }
    if (![self.phoneTextF.text ew_justCheckPhone]||self.phoneTextF.text.length>11) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号格式不正确" controller:self sleep:1.5];
        return;
    }
    NSString *phone = self.phoneTextF.text;
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"sms/getByCouponIdAndPhone.do"];
    
    NSString *couponId;
    if (self.modifyTag==1) {
        couponId = self.couponId;
    }
    if (self.modifyTag==2) {
        couponId = self.giftCouponId;
    }
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"phone":phone,
                               @"couponId":couponId?couponId:@"0"
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码发送成功" controller:self sleep:1.5];
                
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
                [[PublicTool defaultTool] publicToolsHUDStr:@"卷已不存在" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已到期" controller:self sleep:1.5];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"已领完" controller:self sleep:1.5];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"代金券还没生效" controller:self sleep:1.5];
            } else if(statusCode == 1005) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"手机号错误" controller:self sleep:1.5];
            }
            else if(statusCode == 1006) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"此手机已经领取过" controller:self sleep:1.5];
            }
            else if(statusCode == 1007) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送失败" controller:self sleep:1.5];
            }
            else if(statusCode == 2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:1.5];
            }else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 领取成功显示页面
-(void)showSucessView{
    self.modifyV.hidden = YES;
    self.backgroundImageView.userInteractionEnabled = NO;
    self.isHaveModify = YES;
    
    NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"恭喜您获得\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30], NSForegroundColorAttributeName: Yellow_Color} ];
    
    NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:self.companyNameStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: White_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
    NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"发放的红包\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Yellow_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringThree];
    
    NSString *strOne = @"兑换码：";
    if (self.modifyTag == 1) {
        strOne = [strOne stringByAppendingString:self.couponCode];
    }
    if (self.modifyTag == 2) {
        strOne = [strOne stringByAppendingString:self.productCode];
    }
    NSMutableAttributedString *tempAttrStringFour = [[NSMutableAttributedString alloc] initWithString:strOne attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:White_Color } ];
    [tempAttrStringOne appendAttributedString:tempAttrStringFour];
    
    _messageLabel.attributedText = tempAttrStringOne;
    self.QrBtn.hidden = NO;
    
    if (self.modifyTag == 1) {
        [self.QrBtn setImage:self.couponImg forState:UIControlStateNormal];
    }
    if (self.modifyTag == 2) {
        [self.QrBtn setImage:self.productImg forState:UIControlStateNormal];
    }
    
    [self.backgroundImageView addSubview:self.clickLookBtn];
    self.squareImgV.hidden = YES;
    self.reciveBtn.hidden = YES;
    self.priceL.hidden = YES;
    self.clickLookBtn.hidden = NO;
    NSString *str = @"请保存整张图片 \n有效期内内到商家使用 \n商家输入兑换码或扫二维码兑换";
    self.tipsLabel.text = str;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [str boundingRectWithSize:CGSizeMake(_backgroundImageView.frame.size.width - 80, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _tipsLabel.frame = CGRectMake(40, _backgroundImageView.frame.size.height-retSize.height-60, _backgroundImageView.frame.size.width - 80, retSize.height);
}

#pragma mark - 旋转到礼品券
-(void)transToProductView{
    
    self.modifyTag = 2;
    self.modifyV.hidden = YES;
    
    NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"恭喜您获得\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30], NSForegroundColorAttributeName: Yellow_Color} ];
    
    NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:self.companyNameStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: White_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
    NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"发放的红包\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Yellow_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringThree];
    
    NSString *str = [NSString stringWithFormat:@"小礼品：%@",self.couponNameStr];
    NSMutableAttributedString *tempAttrStringFour = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: Yellow_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringFour];
    
    _messageLabel.attributedText = tempAttrStringOne;
    
    [_rotateBtn setImage:[UIImage imageNamed:@"red_rotateToCou"] forState:UIControlStateNormal];
    
    self.QrBtn.hidden = NO;
    
    [self.QrBtn setImage:self.faceImg forState:UIControlStateNormal];
    self.squareImgV.hidden = YES;
    self.reciveBtn.hidden = YES;
    
    self.priceL.hidden = YES;

    self.clickLookBtn.hidden = YES;
    
    
    self.testBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.testBtn.frame = CGRectMake(kSCREEN_WIDTH/2-40-24, self.tipsLabel.top-40, 80, 30);
    

    NSString *strTwo = @"* 此礼品券每人只能使用一次\n* 需要发放礼品券的商家使用";
    
    self.tipsLabel.text = strTwo;
    _tipsLabel.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - 旋转到代金券
-(void)transToCouponView{
    self.modifyTag = 1;
    self.modifyV.hidden = YES;
    
    
    NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"恭喜您获得\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30], NSForegroundColorAttributeName: Yellow_Color} ];
    
    NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:self.companyNameStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: White_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
    NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"发放的红包\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Yellow_Color} ];
    [tempAttrStringOne appendAttributedString:tempAttrStringThree];
    
    
    _messageLabel.attributedText = tempAttrStringOne;
    [_rotateBtn setImage:[UIImage imageNamed:@"red_rotateToProduct"] forState:UIControlStateNormal];
    
    self.QrBtn.hidden = YES;
    self.squareImgV.hidden = NO;
    self.reciveBtn.hidden = NO;
    self.priceL.hidden = NO;
    //    self.priceL.text = @"jrfgjsdf;g";
    //    self.tipsLabel
    self.clickLookBtn.hidden = YES;
    NSString *str = @"* :此代金券每人只能使用一次\n*:需要发放代金券的商家使用";
    
    self.tipsLabel.text = str;
    _tipsLabel.textAlignment = NSTextAlignmentLeft;

}



- (void)dealloc
{
    NSLog(@"dealloc");
}


@end
