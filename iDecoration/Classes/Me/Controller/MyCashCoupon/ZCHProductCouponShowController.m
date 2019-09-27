//
//  ZCHProductCouponShowController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHProductCouponShowController.h"
#import "ZCHCouponGettingRecordModel.h"
#import "ZCHAloneGetRecordCouponController.h"
#import "ShareView.h"

@interface ZCHProductCouponShowController ()

@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productLogo;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) ZCHCouponModel *detailModel;
@property (strong, nonatomic) NSDictionary *companyDic;
@property (strong, nonatomic) NSMutableArray *getRecordList;

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UITextField *phoneTF;
@property (strong, nonatomic) UITextField *codeTF;
@property (strong, nonatomic) UIButton *getCodeBtn;

@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) UserInfoModel *userModel;

@end

@implementation ZCHProductCouponShowController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"促销礼品券";
    self.getRecordList = [NSMutableArray array];
    if (self.isMy) {
        [self.getBtn setBackgroundColor:kCOLOR(204)];
        [self.getBtn setTitle:@"已经领取" forState:UIControlStateNormal];
        self.getBtn.titleLabel.textColor = White_Color;
    } else {
        
        if (self.isFromCompany) {
            [self.getBtn setTitle:@"查看领取人" forState:UIControlStateNormal];
            [self.getBtn setTitleColor:White_Color forState:UIControlStateNormal];
        } else {
            [self.getBtn setTitle:@"马上领取" forState:UIControlStateNormal];
            [self.getBtn setTitleColor:kCustomColor(216, 65, 50) forState:UIControlStateNormal];
        }
    }
    
    if (!self.isMy) {
        // 设置导航栏最右侧的按钮
        UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        
        [shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        shareBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [shareBtn addTarget:self action:@selector(didClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    }
    [self getData];
}

#pragma mark - 分享按钮的点击事件
- (void)didClickShareBtn:(UIButton *)btn {
    
    self.shareView.hidden = NO;
}

- (IBAction)didClickGetBtn:(UIButton *)sender {
    
    if ([self.getBtn.titleLabel.text isEqualToString:@"查看领取人"]) {
        
        if (self.getRecordList.count == 0) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还没有人领取哦"];
        } else {
            ZCHAloneGetRecordCouponController *VC = [[ZCHAloneGetRecordCouponController alloc] init];
            VC.dataArray = self.getRecordList;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    if ([self.getBtn.titleLabel.text isEqualToString:@"马上领取"]) {
        
        self.bgView.hidden = NO;
    }
}

#pragma mark - 获取数据
- (void)getData {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcoupon/getById.do"];
    NSDictionary *param = @{
                            @"companyId" : self.companyId,
                            @"couponId" : self.model.couponId,
                            @"agencyId" : @(agencyid)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            self.detailModel = [ZCHCouponModel yy_modelWithJSON:responseObj[@"data"][@"model"]];
            self.companyDic = responseObj[@"data"][@"company"];
            self.getRecordList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCouponGettingRecordModel class] json:responseObj[@"data"][@"list"]]];
            self.titleLabel.text = [NSString stringWithFormat:@"%@给您发代金券了!", self.companyDic[@"companyName"]];
            [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
            [self.productLogo sd_setImageWithURL:[NSURL URLWithString:self.detailModel.merchandPhoto] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
            self.addressLabel.text = self.detailModel.exchangeAddress;
            NSString *beginTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:self.detailModel.startDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            NSString *endTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:self.detailModel.endDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",beginTime, endTime];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < self.getRecordList.count; i ++) {
                ZCHCouponGettingRecordModel *model = self.getRecordList[i];
                [arr addObject:model.agencyId];
            }
            if ([arr containsObject:[NSString stringWithFormat:@"%ld", agencyid]] && !self.isFromCompany) {
                
                [self.getBtn setBackgroundColor:kCOLOR(204)];
                [self.getBtn setTitle:@"已经领取" forState:UIControlStateNormal];
                self.getBtn.titleLabel.textColor = White_Color;
            }
            
        } else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"获取信息失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        if (BLEJHeight < 667) {
            
            return BLEJHeight - self.navigationController.navigationBar.bottom - 305;
        } else {
            
            return BLEJHeight - self.navigationController.navigationBar.bottom - 355;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }
    return [super tableView:tableView heightForFooterInSection:section];
}

- (UIView *)bgView {
    
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _bgView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgView:)];
        [_bgView addGestureRecognizer:tap];
        [self.view addSubview:_bgView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, BLEJHeight * 0.5 - 180, BLEJWidth - 40, 300)];
        bottomView.backgroundColor = White_Color;
        bottomView.layer.cornerRadius = 5;
        [_bgView addSubview:bottomView];
        
        UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, bottomView.width - 40, 44)];
        nameTF.placeholder = @"请输入您的姓名";
        nameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
        nameTF.font = [UIFont systemFontOfSize:14];
        nameTF.layer.cornerRadius = 5;
        nameTF.layer.borderWidth = 1;
        nameTF.layer.borderColor = kBackgroundColor.CGColor;
        nameTF.leftViewMode = UITextFieldViewModeAlways;
        self.nameTF = nameTF;
        [bottomView addSubview:nameTF];
        
        UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(nameTF.left, nameTF.bottom + 20, nameTF.width, nameTF.height)];
        phoneTF.placeholder = @"请输入您的手机号";
        phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
        phoneTF.font = [UIFont systemFontOfSize:14];
        phoneTF.layer.cornerRadius = 5;
        phoneTF.layer.borderWidth = 1;
        phoneTF.layer.borderColor = kBackgroundColor.CGColor;
        phoneTF.leftViewMode = UITextFieldViewModeAlways;
        self.phoneTF = phoneTF;
        [bottomView addSubview:phoneTF];
        
        UITextField *codeTF = [[UITextField alloc] initWithFrame:CGRectMake(nameTF.left, phoneTF.bottom + 20, nameTF.width, nameTF.height)];
        codeTF.placeholder = @"请输入验证码";
        codeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
        codeTF.font = [UIFont systemFontOfSize:14];
        codeTF.layer.cornerRadius = 5;
        codeTF.layer.borderWidth = 1;
        codeTF.layer.borderColor = kBackgroundColor.CGColor;
        codeTF.leftViewMode = UITextFieldViewModeAlways;
        self.codeTF = codeTF;
        [bottomView addSubview:codeTF];
        
        UIButton *getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(codeTF.width - 80, 0, 80, codeTF.height)];
        getCodeBtn.layer.cornerRadius = 5;
        getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCodeBtn setBackgroundColor:kMainThemeColor];
        [getCodeBtn addTarget:self action:@selector(didClickGetCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.getCodeBtn = getCodeBtn;
        [codeTF addSubview:getCodeBtn];
        
        UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(nameTF.left, codeTF.bottom + 20, nameTF.width, nameTF.height)];
        finishBtn.layer.cornerRadius = 5;
        [finishBtn setTitle:@"完 成" forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [finishBtn setBackgroundColor:kMainThemeColor];
        [finishBtn addTarget:self action:@selector(didClickFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:finishBtn];
    }
    
    return _bgView;
}

- (void)didClickBgView:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
    self.bgView.hidden = YES;
}


#pragma mark - 完成按钮的点击事件(领取代金券)
- (void)didClickFinishBtn:(UIButton *)btn {
    
    if ([self.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if ([self.phoneTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的手机号"];
        return;
    }
    if ([self.codeTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入验证码"];
        return;
    }
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcouponcustomer/save.do"];
    NSDictionary *param = @{
                            @"phone" : self.phoneTF.text,
                            @"code" : self.codeTF.text,
                            @"customerName" : self.nameTF.text,
                            @"couponId" : self.detailModel.couponId,
                            @"companyId" : self.companyId,
                            @"couponNo" : self.detailModel.couponNo,
                            @"agencyId" : @(agencyid)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj) {
            switch ([responseObj[@"code"] integerValue]) {
                case 1000:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"领取成功"];
                    self.bgView.hidden = YES;
                    [self.getBtn setBackgroundColor:kCOLOR(204)];
                    [self.getBtn setTitle:@"已经领取" forState:UIControlStateNormal];
                    self.getBtn.titleLabel.textColor = White_Color;
                    if (self.block) {
                        self.block();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
                case 1001:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                    break;
                case 1002:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"券已领取完"];
                    break;
                case 1003:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"公司未开通VIP"];
                    break;
                case 1004:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"券已到期"];
                    break;
                case 1005:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"此手机号已领取过"];
                    break;
                    
                default:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"领取失败"];
                    break;
            }
            
            
        } else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"领取失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

#pragma mark - 获取验证码
- (void)didClickGetCodeBtn:(UIButton *)btn {
    
    [self.view endEditing:YES];
    if (![self.phoneTF.text ew_justCheckPhone]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"sms/getByCouponIdAndPhone.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.phoneTF.text forKey:@"phone"];
    [param setObject:self.detailModel.couponId forKey:@"couponId"];
    [param setObject:self.detailModel.couponNo forKey:@"couponNo"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [weakSelf timelessWithSecond:120 button:weakSelf.getCodeBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"券已不存在"];
                break;
            case 1002:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"券已到期"];
                break;
            case 1003:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"券已领完"];
                break;
            case 1004:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"代金券编号错误"];
                break;
            case 1005:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"手机号错误"];
                break;
            case 1006:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"此手机号已经领取过"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"发送验证码失败"];
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

- (ShareView *)shareView {
    
    if (!_shareView) {
        _shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        
        //        关闭
        _shareView.closeBlock = ^(){
            
            weakSelf.shareView.hidden = YES;
        };
        
        //        微信
        _shareView.weChatBlock = ^(){
            [weakSelf shareToWXSession];
        };
        
        //        朋友圈
        _shareView.timeLineBlock = ^(){
            [weakSelf shareToTimeLine];
        };
        
        //        QQ
        _shareView.QQBlock = ^(){
            [weakSelf shareToQQSession];
        };
        
        //        空间
        _shareView.QQZoneBlock = ^(){
            [weakSelf shareToQQZone];
        };
    }
    
    return _shareView;
}

//分享到好友
- (void)shareToWXSession {
    
    NSString *shareTitle = self.detailModel.couponName;
    NSString *shareDescription = self.companyDic[@"companyName"];
    if (shareTitle.length > 30) {
        shareTitle = [shareTitle substringToIndex:28];
    }
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.companyLogo.image == nil) {
        [[UIApplication sharedApplication].keyWindow hudShow];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]]]];
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
    } else {
        shareImage = self.companyLogo.image;
        
        NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
        if (data.length > 32) {
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
            
        }
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = shareTitle;
    message.description = shareDescription;
    [message setThumbImage:shareImage];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.detailModel.couponId]];
    
    webPageObject.webpageUrl = shareURL;
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];  // 返回YES 跳转成功
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.shareView.hidden = YES;
    });
}

//分享到朋友圈
- (void)shareToTimeLine {
    
    NSString *shareTitle = self.detailModel.couponName;
    NSString *shareDescription = self.companyDic[@"companyName"];
    if (shareTitle.length > 30) {
        shareTitle = [shareTitle substringToIndex:28];
    }
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.companyLogo.image == nil) {
        [[UIApplication sharedApplication].keyWindow hudShow];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]]]];
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
    } else {
        shareImage = self.companyLogo.image;
        
        NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
        if (data.length > 32) {
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
            
        }
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = shareTitle;
    message.description = shareDescription;
    [message setThumbImage:shareImage];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.detailModel.couponId]];
    webPageObject.webpageUrl = shareURL;
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.shareView.hidden = YES;
    });
}

//分享到QQ
- (void)shareToQQSession {
    
    NSString *shareTitle = self.detailModel.couponName;
    NSString *shareDescription = self.companyDic[@"companyName"];
    if (shareTitle.length > 30) {
        shareTitle = [shareTitle substringToIndex:28];
    }
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.companyLogo.image == nil) {
        [[UIApplication sharedApplication].keyWindow hudShow];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]]]];
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
    } else {
        shareImage = self.companyLogo.image;
        
        NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
        if (data.length > 32) {
            
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
        }
    }
    
    if ([TencentOAuth iphoneQQInstalled]) {
        
        //声明一个新闻类对象
        self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
        //从contentObj中传入数据，生成一个QQReq
        NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.detailModel.couponId]];
        
        NSURL *url = [NSURL URLWithString:shareURL];
        QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
        //向QQ发送消息，查看是否可以发送
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
        QQApiSendResultCode code = [QQApiInterface sendReq:req];
        NSLog(@"%d",code);
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到AppStore下载最新版本手机QQ" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.shareView.hidden = YES;
    });
}

//分享到QQ空间
- (void)shareToQQZone {
    
    NSString *shareTitle = self.detailModel.couponName;
    NSString *shareDescription = self.companyDic[@"companyName"];
    if (shareTitle.length > 30) {
        shareTitle = [shareTitle substringToIndex:28];
    }
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.companyLogo.image == nil) {
        [[UIApplication sharedApplication].keyWindow hudShow];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]]]];
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
    } else {
        shareImage = self.companyLogo.image;
        
        NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
        if (data.length > 32) {
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
            
        }
    }
    
    if ([TencentOAuth iphoneQQInstalled]){
        
        //声明一个新闻类对象
        self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
        //从contentObj中传入数据，生成一个QQReq
        NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/cblejcoupon/%@.htm", self.detailModel.couponId]];
        NSURL *url = [NSURL URLWithString:shareURL];
        QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
        //向QQ发送消息，查看是否可以发送
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
        QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
        NSLog(@"%d",code);
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到AppStore下载最新版本手机QQ" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.shareView.hidden = YES;
    });
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
