//
//  CompanyQRShareView.m
//  iDecoration
//
//  Created by zuxi li on 2018/5/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CompanyQRShareView.h"

@implementation CompanyQRShareView

- (instancetype)initViewWithShareURLStr:(NSString *)shareURLStr shareImage:(UIImage *)companyLogo shareImageURLStr:(NSString *)imageURLStr companyName:(NSString *)companyName {
    self = [super init];
    if (self) {
        [self buildViewWithShareURLStr:shareURLStr shareImage:companyLogo shareImageURLStr:imageURLStr companyName:companyName];
    }
    return self;
}

// 点击二维码图片后生成的分享页面
- (void)buildViewWithShareURLStr:(NSString *)shareURLStr shareImage:(UIImage*)companyLogo shareImageURLStr:(NSString *)imageURLStr companyName:(NSString *)companyName {
    
    self.frame = CGRectMake(0, 0, BLEJWidth, BLEJHeight);
    self.backgroundColor = White_Color;
    self.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self addGestureRecognizer:tap];
    
    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:codeView];
    
//    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.companyID]];
    NSString *shareURL = shareURLStr;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hudShow];
        });
        
        UIImage *shareImage;
        if (companyLogo == nil) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]]];
            if (image) {
                shareImage = image;
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            } else {
                shareImage = [UIImage imageNamed:@"shareDefaultIcon"];
                
            }
        } else {
            shareImage = companyLogo;
            NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
            if (data.length > 32) {
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hiddleHud];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];
            
        });
    });
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    label.text = @"截屏保存到相册:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    [self addSubview:label];
    
    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10, BLEJWidth, 30)];
    labelBottom.text = @"在微信环境下按住图片识别二维码打开";
    labelBottom.textColor = [UIColor darkGrayColor];
    labelBottom.textAlignment = NSTextAlignmentCenter;
    labelBottom.font = [UIFont systemFontOfSize:16];
    [self addSubview:labelBottom];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeView.mas_top).equalTo(-20);
        make.left.right.equalTo(0);
    }];
    titleLabel.text = @"企业";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    
    UILabel *companyNameLabel = [[UILabel alloc] init];
    [self addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top).equalTo(-10);
        make.left.equalTo(codeView).equalTo(6);
        make.right.equalTo(codeView).equalTo(-6);
    }];
    companyNameLabel.text = companyName;
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.font = [UIFont systemFontOfSize:20];
    companyNameLabel.textColor = [UIColor blackColor];
    
    self.hidden = YES;
}

- (void)didClickTwoDimensionCodeView:(UITapGestureRecognizer *)tap {
    if (self.hiddenBlock) {
        self.hiddenBlock(self);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
//        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

@end
