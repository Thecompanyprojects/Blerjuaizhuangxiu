//
//  ActivityQRCodeShareView.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivityQRCodeShareView.h"

#define  textColot RGB(70, 172, 200)

@interface ActivityQRCodeShareView()


@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UILabel *activityNameLabel;
@property (nonatomic, strong) UILabel *activityTimeLabel;
@property (nonatomic, strong) UILabel *activityAddressLabel;
@property (nonatomic, strong) UIImageView *lineImageView1;
@property (nonatomic, strong) UIImageView *lineImageView2;
@property (nonatomic, strong) UIImageView *lineImageView3;
@property (nonatomic, strong) UILabel *codeBottomLabel;

@end


@implementation ActivityQRCodeShareView


- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self  topImageView];
        [self companyNameLabel];
        [self companyIcon];
        [self lineImageView1];
        [self activityNameLabel];
        [self lineImageView2];
        [self activityTimeLabel];
        [self lineImageView3];
        [self activityAddressLabel];
        [self QRcodeView];
        [self codeBottomLabel];
        
    }
    return self;
}



- (void)setCompanyName:(NSString *)companyName {
    _companyName = companyName;
    self.companyNameLabel.text = companyName;
    CGSize maximumLabelSize = CGSizeMake(kSCREEN_WIDTH - 88, 40);
    CGSize expectSize = [self.companyNameLabel sizeThatFits:maximumLabelSize];
    [self.companyNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(24);
        make.top.equalTo(self.topImageView.mas_bottom).equalTo(30);
        make.right.lessThanOrEqualTo(-20);
        make.left.greaterThanOrEqualTo(68);
        make.height.equalTo(expectSize.height + 4);
    }];
}

- (void)setActivityName:(NSString *)activityName {
    _activityName = activityName;
    self.activityNameLabel.text = activityName;
    CGSize maximumLabelSize = CGSizeMake(kSCREEN_WIDTH - 40, 50);
    CGSize expectSize = [self.activityNameLabel sizeThatFits:maximumLabelSize];
    [self.activityNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineImageView1.mas_bottom).equalTo(4);
        make.right.equalTo(-20);
        make.left.equalTo(20);
        make.height.equalTo(expectSize.height + 4);
    }];
}

- (void)setActivityTime:(NSString *)activityTime {
    _activityTime = activityTime;
    NSString *temStr = @"-";
    if ([activityTime isKindOfClass:[NSString class]]) {
        if ([activityTime rangeOfString:temStr].length>0) {
            //是时间，不是时间戳
            self.activityTimeLabel.text = activityTime;
        }
    }
    else{
        NSInteger temTime = [activityTime integerValue];
        if (temTime==0) {
            self.activityTimeLabel.text = @"";
        }
        else{
            self.activityTimeLabel.text = [self stringFromDouble:activityTime.integerValue];
        }
    }
    
    
    
}

- (NSString *)stringFromDouble:(double)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

- (void)setActivityAddress:(NSString *)activityAddress {
    _activityAddress = activityAddress;
    self.activityAddressLabel.text = activityAddress;
    CGSize maximumLabelSize = CGSizeMake(kSCREEN_WIDTH - 40, 40);
    CGSize expectSize = [self.activityNameLabel sizeThatFits:maximumLabelSize];
    [self.activityAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.lineImageView3.mas_bottom).equalTo(4);
        make.right.equalTo(-20);
        make.left.equalTo(20);
        make.height.equalTo(expectSize.height);
//        make.height.equalTo(30);
    }];
}

- (UIImageView *)topImageView {
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] init];
        [self addSubview:_topImageView];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(40);
            make.left.equalTo(20);
            make.right.equalTo(-20);
            make.height.equalTo(kSize(200));
        }];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.layer.masksToBounds = YES;
    }
    return _topImageView;
}


- (UILabel *)companyNameLabel {
    if (_companyNameLabel == nil) {
        _companyNameLabel = [UILabel new];
        [self addSubview:_companyNameLabel];
        _companyNameLabel.preferredMaxLayoutWidth = kSCREEN_WIDTH - 88;
        [_companyNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _companyNameLabel.numberOfLines = 2;
        [_companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(24);
            make.top.equalTo(self.topImageView.mas_bottom).equalTo(30);
            make.right.equalTo(-20);
            make.left.equalTo(88);
            make.height.greaterThanOrEqualTo(20);
        }];
        _companyNameLabel.textColor = textColot;
        _companyNameLabel.font = [UIFont systemFontOfSize:kSize(16)];
        _companyNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _companyNameLabel;
}
- (UIImageView *)companyIcon {
    if (_companyIcon == nil) {
        _companyIcon = [[UIImageView alloc] init];
        [self addSubview:_companyIcon];
        [_companyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(40, 40));
            make.centerY.equalTo(self.companyNameLabel);
            make.right.equalTo(self.companyNameLabel.mas_left).equalTo(-8);
        }];
        _companyIcon.layer.cornerRadius = 20;
        _companyIcon.layer.masksToBounds = YES;
        _companyIcon.contentMode = UIViewContentModeScaleAspectFill;
        _companyIcon.backgroundColor = [UIColor lightGrayColor];
    }
    return _companyIcon;
}



- (UIImageView *)lineImageView1 {
    if (_lineImageView1 == nil) {
        _lineImageView1 = [[UIImageView alloc] init];
        [self addSubview:_lineImageView1];
        [_lineImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(20);
            make.width.equalTo(kSCREEN_WIDTH/2.0);
            make.top.equalTo(self.companyIcon.mas_bottom).equalTo(4);
        }];
        _lineImageView1.image = [UIImage imageNamed:@"activityQRshare_line"];
    }
    return _lineImageView1;
}

#pragma mark - 活动名称
- (UILabel *)activityNameLabel {
    if (_activityNameLabel == nil) {
        _activityNameLabel = [UILabel new];
        [self addSubview:_activityNameLabel];
        _activityNameLabel.preferredMaxLayoutWidth = kSCREEN_WIDTH - 40;
        [_activityNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _activityNameLabel.numberOfLines = 2;
        [_activityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineImageView1.mas_bottom).equalTo(4);
            make.right.equalTo(-20);
            make.left.equalTo(20);
            make.height.greaterThanOrEqualTo(20);
        }];
        _activityNameLabel.textColor = textColot;
        _activityNameLabel.font = [UIFont systemFontOfSize:kSize(20)];
        _activityNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _activityNameLabel;
}

- (UIImageView *)lineImageView2 {
    if (_lineImageView2 == nil) {
        _lineImageView2 = [[UIImageView alloc] init];
        [self addSubview:_lineImageView2];
        [_lineImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(20);
            make.width.equalTo(kSCREEN_WIDTH/2.0);
            make.top.equalTo(self.activityNameLabel.mas_bottom).equalTo(4);
        }];
        _lineImageView2.image = [UIImage imageNamed:@"activityQRshare_line"];
    }
    return _lineImageView2;
}

- (UILabel *)activityTimeLabel {
    if (_activityTimeLabel == nil) {
        _activityTimeLabel = [UILabel new];
        [self addSubview:_activityTimeLabel];
        [_activityTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.lineImageView2.mas_bottom).equalTo(4);
            make.right.equalTo(-20);
            make.left.equalTo(20);
            make.height.equalTo(20);
        }];
        _activityTimeLabel.textColor = textColot;
        _activityTimeLabel.font = [UIFont systemFontOfSize:kSize(16)];
        _activityTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _activityTimeLabel;
}

- (UIImageView *)lineImageView3 {
    if (_lineImageView3 == nil) {
        _lineImageView3 = [[UIImageView alloc] init];
        [self addSubview:_lineImageView3];
        [_lineImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(20);
            make.width.equalTo(kSCREEN_WIDTH/2.0);
            make.top.equalTo(self.activityTimeLabel.mas_bottom).equalTo(4);
        }];
        _lineImageView3.image = [UIImage imageNamed:@"activityQRshare_line"];
    }
    return _lineImageView3;
}

- (UILabel *)activityAddressLabel {
    if (_activityAddressLabel == nil) {
        _activityAddressLabel = [UILabel new];
        [self addSubview:_activityAddressLabel];
        _activityAddressLabel.preferredMaxLayoutWidth = kSCREEN_WIDTH - 40;
        [_activityAddressLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _activityAddressLabel.numberOfLines = 2;
        [_activityAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.lineImageView3.mas_bottom).equalTo(4);
            make.right.equalTo(-20);
            make.left.equalTo(20);
            make.height.greaterThanOrEqualTo(20);
        }];
        
        _activityAddressLabel.textColor = textColot;
        _activityAddressLabel.font = [UIFont systemFontOfSize:kSize(16)];
        _activityAddressLabel.textAlignment = NSTextAlignmentCenter;
        [_activityAddressLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _activityAddressLabel;
}

- (UIImageView *)QRcodeView {
    if (_QRcodeView == nil) {
        _QRcodeView = [UIImageView new];
        [self addSubview:_QRcodeView];
        [_QRcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.activityAddressLabel.mas_bottom).equalTo(20);
            make.bottom.equalTo(-40);
            make.width.equalTo(_QRcodeView.mas_height);
        }];
    }
    return _QRcodeView;
}

- (UILabel *)codeBottomLabel  {
    if (_codeBottomLabel == nil) {
        _codeBottomLabel = [UILabel new];
        [self addSubview:_codeBottomLabel];
        [_codeBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.QRcodeView.mas_bottom).equalTo(4);
        }];
        _codeBottomLabel.font = [UIFont systemFontOfSize:kSize(14)];
        _codeBottomLabel.text = @"长按或扫一扫报名";
        _codeBottomLabel.textColor = textColot;
    }
    return _codeBottomLabel;
}

@end
