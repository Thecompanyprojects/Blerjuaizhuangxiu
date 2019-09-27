//
//  ZYCShareView.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ZYCShareView.h"

@implementation ZYCShareView

+ (instancetype)sharedInstance {
    static ZYCShareView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZYCShareView new];
    });
    return instance;
}

//- (void)setURL:(NSString *)URL {
//    NSString *s = @"?";
//    if ([URL containsString:@"?"]) {
//        s = @"&";
//    }
//    //_URL = [NSString stringWithFormat:@"%@%@agencyId=%@",URL,s,GETAgencyId];
//
//}

- (void)makeShareView {
    [self.shareView removeAllSubViews];
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    self.shadowView.userInteractionEnabled = true;
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/2.0 + 70)];
    self.shareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.shadowView addSubview:self.shareView];
    self.shareView.userInteractionEnabled = true;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"分享给好友";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.shareView addSubview:titleLabel];

    NSMutableArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0",@"erweima-0"].mutableCopy;
    NSMutableArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"公司二维码", @"员工二维码"].mutableCopy;
    if (self.shareViewType == ZYCShareViewTypeCompanyOnly) {
        [imageNames removeLastObject];
        [names removeObject:@"员工二维码"];
    }else if (self.shareViewType == ZYCShareViewTypeEmployeesOnly) {
        [imageNames removeLastObject];
        [names removeObject:@"公司二维码"];
    }else if (self.shareViewType == ZYCShareViewTypeNone) {
        [imageNames removeObject:@"erweima-0"];
        [names removeObject:@"公司二维码"];
        [names removeObject:@"员工二维码"];
    }
    for (int i = 0; i < imageNames.count; i ++) {
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
        [self.shareView addSubview:btn];
    }
}

- (void)setShareViewType:(ZYCShareViewType)shareViewType {
    _shareViewType = shareViewType;
    [self makeShareView];
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    [self dismissShareView];
}

- (void)showShareView {
    [self makeShareView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.shadowView];
    [UIView animateWithDuration:.2 animations:^{
        self.shareView.alpha = 1;
        self.shareView.frame = CGRectMake(0, BLEJHeight - (kSCREEN_WIDTH/2.0 + 70), BLEJWidth, kSCREEN_WIDTH/2.0 + 70);
    } completion:^(BOOL finished) {
        [self.shareView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *view = obj;
            if ([view isKindOfClass:[UIButton class]]) {
                [UIView animateWithDuration:.2 animations:^{
                    view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    view.transform = CGAffineTransformMakeScale(0.7, 0.7);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        view.transform = CGAffineTransformIdentity;
                        view.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }];
}

- (void)didClickShareContentBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [OpenShare shareToWeixinSession:self.message Success:^(OSMessage *message) {} Fail:^(OSMessage *message, NSError *error) {}];
            break;
        case 1:
            [OpenShare shareToWeixinTimeline:self.message Success:^(OSMessage *message) {} Fail:^(OSMessage *message, NSError *error) {}];
            break;
        case 2:
            [OpenShare shareToQQFriends:self.message Success:^(OSMessage *message) {} Fail:^(OSMessage *message, NSError *error) {}];
            break;
        case 3:
            [OpenShare shareToQQZone:self.message Success:^(OSMessage *message) {} Fail:^(OSMessage *message, NSError *error) {}];
            break;
        case 4:
            if (self.blockQRCode1st) {
                self.blockQRCode1st();
            }
            break;
        case 5:
            if (self.blockQRCode2nd) {
                self.blockQRCode2nd();
            }
            break;

        default:
            break;
    }
    [self dismissShareView];
}

- (void)dismissShareView {
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.frame = CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/2.0 + 70);
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
    }];
}

- (void)makeQRCodeView {
    UIView *QRCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    QRCodeView.backgroundColor = White_Color;
    [[UIApplication sharedApplication].keyWindow addSubview:QRCodeView];
    QRCodeView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchQRCodeView:)];
    [QRCodeView addGestureRecognizer:tap];
    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = QRCodeView.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [QRCodeView addSubview:codeView];
    NSString *shareURL = [NSString stringWithFormat:@"%@",self.URL];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *shareImage;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
        if (image) {
            shareImage = image;
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }else{
            shareImage = [UIImage imageNamed:@"shareDefaultIcon"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];
        });
    });
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    label.text = @"截屏保存到相册:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    [QRCodeView addSubview:label];
    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10, BLEJWidth, 30)];
    labelBottom.text = @"在微信环境下按住图片识别二维码打开";
    labelBottom.textColor = [UIColor darkGrayColor];
    labelBottom.textAlignment = NSTextAlignmentCenter;
    labelBottom.font = [UIFont systemFontOfSize:16];
    [QRCodeView addSubview:labelBottom];
    UILabel *titleLabel = [[UILabel alloc] init];
    [QRCodeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeView.mas_top).equalTo(-20);
        make.left.right.equalTo(0);
    }];
    titleLabel.text = @"企业";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    UILabel *companyNameLabel = [[UILabel alloc] init];
    [QRCodeView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top).equalTo(-10);
        make.left.equalTo(codeView).equalTo(6);
        make.right.equalTo(codeView).equalTo(-6);
    }];
    companyNameLabel.text = self.companyName;
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.font = [UIFont systemFontOfSize:20];
    companyNameLabel.textColor = [UIColor blackColor];
}

- (void)didTouchQRCodeView:(UIView *)view {
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 0;
    }completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)share {
    [self showShareView];
    OSMessage *msg = [[OSMessage alloc] init];
    self.message = msg;
    msg.title = self.shareTitle;
    msg.link = self.URL;
    NSString *shareDescription = self.shareCompanyIntroduction;
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    msg.desc = shareDescription;
    NSData *shareData;
    if (self.shareCompanyLogoImage) {
        msg.image = [NSData imageData:self.shareCompanyLogoImage];
    }else{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareCompanyLogo]]];
        if (image) {
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [image drawInRect:CGRectMake(0,0,300,300)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *data=UIImageJPEGRepresentation(image, 1.0);
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(image, scale);
        } else {
            image = [UIImage imageNamed:@"shareDefaultIcon"];
            shareData = UIImagePNGRepresentation(image);
        }
        msg.image = shareData;
    }
}

@end
