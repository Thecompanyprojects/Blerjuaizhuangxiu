//
//  STYProductCouponDetailController.m
//  iDecoration
//
//  Created by sty on 2018/3/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "STYProductCouponDetailController.h"
#import "ProdcutDetailInfoController.h"

@interface STYProductCouponDetailController ()
@property (nonatomic, strong) UIImageView *backGroundImgV;
@property (nonatomic, strong) UILabel *contentL;

@property (nonatomic, strong) UIImageView *companyLogoV;
@property (nonatomic, strong) UILabel *companyNameL;

@property (nonatomic, strong) UIButton *lookDetailBtn;

@end

@implementation STYProductCouponDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self setUI];
    [self setData];
}

-(void)setUI{
    [self.view addSubview:self.backGroundImgV];
    [self.view addSubview:self.contentL];
    [self.view addSubview:self.companyLogoV];
    [self.view addSubview:self.companyNameL];
    
    if (self.couponType==2) {
        [self.view addSubview:self.lookDetailBtn];
    }
}

-(void)setData{
    
    if (!self.isChangeTime) {
        self.startTime = [self getDateFormatStrFromTimeStamp:self.startTime];
        self.endTime = [self getDateFormatStrFromTimeStamp:self.endTime];
    }
    
    NSString *contentStr = [NSString stringWithFormat:@"领取地点：%@\n兑换码：%@\n有效日期：%@～%@\n备注：\n%@ ",self.couponAddress,self.couponCode,self.startTime,self.endTime,self.remark];
    self.contentL.text = contentStr;
    [self.companyLogoV sd_setImageWithURL:[NSURL URLWithString:self.companyLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
    self.companyNameL.text = self.companyName;
}

#pragma mark - lazy

-(UIImageView *)backGroundImgV{
    if (!_backGroundImgV) {
        _backGroundImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom)];
        
        _backGroundImgV.image = [UIImage imageNamed:@"red_backGround"];
        [_backGroundImgV sizeToFit];
        CGFloat height = kSCREEN_WIDTH*_backGroundImgV.height/_backGroundImgV.width;
        _backGroundImgV.frame = CGRectMake(0, (kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom-height)/2, kSCREEN_WIDTH, height);
    }
    return _backGroundImgV;
}

-(UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]initWithFrame:CGRectMake(self.backGroundImgV.left+40, self.backGroundImgV.top+25, kSCREEN_WIDTH-(self.backGroundImgV.left+40)*2, 100)];
//        LogoName.text = @"联盟LOGO";
        _contentL.textColor = Red_Color;
        _contentL.font = NB_FONTSEIZ_SMALL;
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

-(UIImageView *)companyLogoV{
    if (!_companyLogoV) {
        CGFloat width = 110;
        _companyLogoV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-width/2, self.backGroundImgV.height/2-width/2, width, width)];
        _companyLogoV.centerY = self.backGroundImgV.centerY;
        _companyLogoV.centerX = self.backGroundImgV.centerX;
        _companyLogoV.image = [UIImage imageNamed:DefaultIcon];
        _companyLogoV.contentMode = UIViewContentModeScaleAspectFill;
        _companyLogoV.userInteractionEnabled = YES;
        _companyLogoV.layer.masksToBounds = YES;
        _companyLogoV.layer.cornerRadius =_companyLogoV.width/2;
    }
    return _companyLogoV;
}

-(UILabel *)companyNameL{
    if (!_companyNameL) {
        _companyNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, self.companyLogoV.bottom, kSCREEN_WIDTH, 40)];
//        LogoName.text = @"联盟LOGO";
        _companyNameL.textColor = White_Color;
        _companyNameL.font = NB_FONTSEIZ_NOR;
        _companyNameL.textAlignment = NSTextAlignmentCenter;
    }
    return _companyNameL;
}

-(UIButton *)lookDetailBtn{
    if (!_lookDetailBtn) {
        _lookDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookDetailBtn.frame = CGRectMake(self.companyNameL.left,self.companyNameL.bottom,self.companyNameL.width,self.companyNameL.height);
        _lookDetailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [_lookDetailBtn setTitleColor:Yellow_Color forState:UIControlStateNormal];
        _lookDetailBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        
        NSString *textStr = @"点击查看详情"; // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName: Yellow_Color};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic]; //赋值
        [_lookDetailBtn setAttributedTitle:attribtStr forState:UIControlStateNormal];
        [_lookDetailBtn addTarget:self action:@selector(lookDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookDetailBtn;
}

#pragma mark - action

-(void)lookDetailBtnClick:(UIButton *)btn{
    ProdcutDetailInfoController *vc = [[ProdcutDetailInfoController alloc]init];
    vc.giftId = self.giftId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
