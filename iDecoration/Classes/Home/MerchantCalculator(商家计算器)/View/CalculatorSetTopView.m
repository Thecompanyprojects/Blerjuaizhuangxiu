//
//  CalculatorSetTopView.m
//  iDecoration
//
//  Created by zuxi li on 2018/3/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CalculatorSetTopView.h"

@implementation CalculatorSetTopView

- (void)buildView {
    [super buildView];
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 330);
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 80)];
    topBgView.backgroundColor = White_Color;
    [self addSubview:topBgView];
    
    _companyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _companyIcon.backgroundColor = [UIColor lightGrayColor];
    [topBgView addSubview:_companyIcon];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_companyIcon.right + 10, _companyIcon.top, BLEJWidth - 160, 20)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = Black_Color;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.text= @"公司名称公司名称公司名称公司名称公司名称公司名称";
    [topBgView addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, BLEJWidth - 90, 60 - _nameLabel.height)];
    _addressLabel.numberOfLines = 2;
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.textColor = [UIColor grayColor];
    _addressLabel.font = [UIFont systemFontOfSize:12];
    _addressLabel.text = @"公司地址公司地址公司地址公司地址公司地址公司地址公司地址";
    [topBgView addSubview:_addressLabel];
    
    
    _collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 70, _companyIcon.top, 60, 20)];
    _collectionBtn.layer.borderColor = [UIColor redColor].CGColor;
    _collectionBtn.layer.borderWidth = 1;
    _collectionBtn.layer.cornerRadius = 3;
    _collectionBtn.layer.masksToBounds = YES;
    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_collectionBtn setTitle:@"收集号码" forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [topBgView addSubview:_collectionBtn];
    
    _simpleSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 90, (BLEJWidth - 70) * 0.5, 40)];
    [_simpleSetBtn setBackgroundColor:kMainThemeColor];
    _simpleSetBtn.layer.cornerRadius = 3;
    _simpleSetBtn.layer.masksToBounds = YES;
    [_simpleSetBtn setTitle:@"简装报价设置" forState:UIControlStateNormal];
    _simpleSetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_simpleSetBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [self addSubview:_simpleSetBtn];

    
    _hardcoverSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 + 15, 90, (BLEJWidth - 70) * 0.5, 40)];
    [_hardcoverSetBtn setBackgroundColor:kMainThemeColor];
    _hardcoverSetBtn.layer.cornerRadius = 3;
    _hardcoverSetBtn.layer.masksToBounds = YES;
    [_hardcoverSetBtn setTitle:@"精装报价设置" forState:UIControlStateNormal];
    _hardcoverSetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_hardcoverSetBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [self addSubview:_hardcoverSetBtn];
    
    UIView *budgetExplain = [[UIView alloc] init];
    budgetExplain.frame = CGRectMake(0, 140, BLEJWidth, 190);
    budgetExplain.backgroundColor = White_Color;
    [self addSubview:budgetExplain];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, BLEJWidth - 20, 40)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = Black_Color;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"预算说明";
    [budgetExplain addSubview:titleLabel];
    
    _remindTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, BLEJWidth - 20, 140)];
    _remindTV.font = [UIFont systemFontOfSize:14];
    _remindTV.textColor = Black_Color;
    _remindTV.backgroundColor = kBackgroundColor;
    _remindTV.layer.cornerRadius = 5;
    _remindTV.layer.masksToBounds = YES;
    [budgetExplain addSubview:_remindTV];
    _remindTV.text = @"温馨提示：尊敬的业主您好，您现在看到的是我公司的预算报价总计，稍后我们公司将有客服人员与您联系，并将详细报价清单发送给您，如有打扰敬请谅解！";
    
}


@end
