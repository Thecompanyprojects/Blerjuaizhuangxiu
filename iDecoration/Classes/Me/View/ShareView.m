//
//  ShareView.m
//  iDecoration
//
//  Created by RealSeven on 17/2/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
//        [self addSubview:self.bottomView];
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgView:)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.shareView];
        [self.shareView addSubview:self.titleLabel];
        [self.shareView addSubview:self.CloseBtn];
        [self.shareView addSubview:self.WeChatBtn];
        [self.shareView addSubview:self.TimeLineBtn];
        [self.shareView addSubview:self.QQBtn];
        [self.shareView addSubview:self.QQZoneBtn];
//        [self.shareView addSubview:self.QRCodeBtn];
        
        [self adjustUI];
        
    }
    return self;
}

- (UIView*)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgView:)];
        [_bottomView addGestureRecognizer:tap];
        
    }
    return _bottomView;
}

- (UIView*)shareView {
    
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 130)];
        _shareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _shareView;
}

- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"分享给好友";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
    }
    return _titleLabel;
}

- (UIButton*)WeChatBtn {
    
    if (!_WeChatBtn) {
        _WeChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_WeChatBtn setBackgroundImage:[UIImage imageNamed:@"weixin-share"] forState:UIControlStateNormal];
        [_WeChatBtn addTarget:self action:@selector(wechat:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _WeChatBtn;
}

- (UIButton*)TimeLineBtn {
    
    if (!_TimeLineBtn) {
        _TimeLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_TimeLineBtn setBackgroundImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
        [_TimeLineBtn addTarget:self action:@selector(timeLine:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _TimeLineBtn;
}

- (UIButton*)QQBtn {
    
    if (!_QQBtn) {
        _QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_QQBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_QQBtn addTarget:self action:@selector(qq:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QQBtn;
}

- (UIButton*)QQZoneBtn {
    
    if (!_QQZoneBtn) {
        _QQZoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_QQZoneBtn setBackgroundImage:[UIImage imageNamed:@"qqkongjian"] forState:UIControlStateNormal];
        [_QQZoneBtn addTarget:self action:@selector(qqZone:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QQZoneBtn;
}

//- (UIButton *)QRCodeBtn {
//    if (!_QRCodeBtn) {
//        _QRCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_QRCodeBtn setBackgroundImage:[UIImage imageNamed:@"erweima-0"] forState:UIControlStateNormal];
//        [_QRCodeBtn addTarget:self action:@selector(qrCode:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _QRCodeBtn;
//}

- (UIButton*)CloseBtn {
    
    if (!_CloseBtn) {
        _CloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_CloseBtn setBackgroundImage:[UIImage imageNamed:@"colse"] forState:UIControlStateNormal];
        _CloseBtn.backgroundColor = Clear_Color;
        [_CloseBtn addTarget:self action:@selector(closeWindow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CloseBtn;
}

- (void)adjustUI {
    
    CGFloat marginH = (BLEJWidth - 200) / 5.0;
    CGFloat marginV = 20;
    
    [self.WeChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(marginV);
        make.left.equalTo(self.shareView.mas_left).offset(marginH);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.TimeLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.WeChatBtn);
        make.left.equalTo(self.WeChatBtn.mas_right).offset(marginH);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.WeChatBtn);
        make.left.equalTo(self.TimeLineBtn.mas_right).offset(marginH);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.QQZoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.WeChatBtn);
        make.left.equalTo(self.QQBtn.mas_right).offset(marginH);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
//    [self.QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.WeChatBtn);
//        make.left.equalTo(self.QQZoneBtn.mas_right).offset(marginH);
//        make.width.equalTo(@50);
//        make.height.equalTo(@50);
//    }];
    
//    [self.CloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.shareView.mas_top).offset(20);
//        make.right.equalTo(self.shareView.mas_right).offset(-20);
//        make.width.equalTo(@25);
//        make.height.equalTo(@25);
//        
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.shareView.mas_top).offset(marginV);
        make.centerX.equalTo(self.shareView.mas_centerX);
        make.height.equalTo(@20);
    }];
}

- (void)closeWindow:(UIButton*)sender {
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)wechat:(UIButton*)sender {
    
    if (self.weChatBlock) {
        self.weChatBlock();
    }
}

- (void)timeLine:(UIButton*)sender {
    
    if (self.timeLineBlock) {
        self.timeLineBlock();
    }
}


- (void)qq:(UIButton*)sender {
    
    if (self.QQBlock) {
        self.QQBlock();
    }
}

- (void)qqZone:(UIButton*)sender {
    
    if (self.QQZoneBlock) {
        self.QQZoneBlock();
    }
}

//- (void)qrCode:(UIButton*)sender {
//    if (self.QRCodeBlock) {
//        self.QRCodeBlock();
//    }
//}

- (void)setHidden:(BOOL)hidden {
    
    if (hidden) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.shareView.blej_y = kSCREEN_HEIGHT;
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.shareView.blej_y = kSCREEN_HEIGHT - 130;
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        }];
    }
    
    
}
#pragma mark - 背景视图的点击方法
- (void)didClickBgView:(UITapGestureRecognizer *)tap {
    
    NSLog(@"didClickBgView");
    self.hidden = YES;
}

@end
