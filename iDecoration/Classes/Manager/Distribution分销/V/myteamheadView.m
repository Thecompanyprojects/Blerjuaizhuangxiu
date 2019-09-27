//
//  myteamheadView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "myteamheadView.h"

@interface myteamheadView()
@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UILabel *leftlab0;
@property (nonatomic,strong) UILabel *leftlab1;
//@property (nonatomic,strong) UIView *bottombgview;
//@property (nonatomic,strong) UILabel *bottomlabel;
@end

@implementation myteamheadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.infoimg];
        [self addSubview:self.nameLab];
        [self addSubview:self.line0];
        [self addSubview:self.line1];
        [self addSubview:self.leftlab0];
        [self addSubview:self.leftlab1];
//        [self addSubview:self.bottombgview];
//        [self addSubview:self.bottomlabel];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
 
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.height.mas_offset(60);
        make.right.equalTo(weakSelf);
    }];
    [weakSelf.infoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(9);
        make.top.equalTo(weakSelf).with.offset(8);
        make.width.mas_offset(45);
        make.height.mas_offset(45);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.infoimg.mas_right).with.offset(18);
        make.top.equalTo(weakSelf).with.offset(15);
        make.right.equalTo(weakSelf).with.offset(-15);
        make.centerY.equalTo(weakSelf.infoimg);
    }];
    [weakSelf.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf).with.offset(60);
    }];
    [weakSelf.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.line0).with.offset(40);
    }];
    [weakSelf.leftlab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.right.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.line0);
        make.bottom.equalTo(weakSelf.line1.mas_top);
    }];

    [weakSelf.leftlab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.right.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.line1);
        make.height.mas_offset(40);
    }];
//    [weakSelf.bottombgview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf);
//        make.right.equalTo(weakSelf);
//        make.height.mas_offset(60);
//        make.top.equalTo(weakSelf.leftlab1.mas_bottom);
//    }];
//    [weakSelf.bottomlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf).with.offset(14);
//        make.right.equalTo(weakSelf).with.offset(-14);
//        make.centerY.equalTo(weakSelf.bottombgview);
//    }];
}

#pragma mark - getters


-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}



-(UIImageView *)infoimg
{
    if(!_infoimg)
    {
        _infoimg = [[UIImageView alloc] init];
        _infoimg.layer.masksToBounds = YES;
        _infoimg.layer.cornerRadius = 45/2;
        
    }
    return _infoimg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _nameLab.text = @"我的对接人";
    }
    return _nameLab;
}

-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = [UIColor hexStringToColor:@"F5F5F5"];
    }
    return _line0;
}

-(UILabel *)leftlab0
{
    if(!_leftlab0)
    {
        _leftlab0 = [[UILabel alloc] init];
        _leftlab0.font = [UIFont systemFontOfSize:14];
    }
    return _leftlab0;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor hexStringToColor:@"F5F5F5"];
    }
    return _line1;
}

-(UILabel *)leftlab1
{
    if(!_leftlab1)
    {
        _leftlab1 = [[UILabel alloc] init];
        _leftlab1.font = [UIFont systemFontOfSize:14];
    }
    return _leftlab1;
}


//-(UIView *)bottombgview
//{
//    if(!_bottombgview)
//    {
//        _bottombgview = [[UIView alloc] init];
//        _bottombgview.backgroundColor = [UIColor hexStringToColor:@"F3F3F3"];
//    }
//    return _bottombgview;
//}

//-(UILabel *)bottomlabel
//{
//    if(!_bottomlabel)
//    {
//        _bottomlabel = [[UILabel alloc] init];
//        _bottomlabel.text = @"343434";
//        _bottomlabel.font = [UIFont systemFontOfSize:14];
//        _bottomlabel.text = @"我的推广记录";
//
//    }
//    return _bottomlabel;
//}




#pragma mark - 数据方法

-(void)setdata:(NSString *)truename andcreateCode:(NSString *)createCode
{
    NSString *str1 = @"名字:";
    NSString *str2 = truename;
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"3F3F3F"]
                          range:NSMakeRange(0, str1.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"999999"]
                          range:NSMakeRange(str1.length, str2.length)];
    self.leftlab0.attributedText = attributedStr;
    
    NSString *str3 = @"对接人邀请码：";
    NSString *str4 = createCode;
    NSString *newstr = [NSString stringWithFormat:@"%@%@",str3,str4];
    NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc] initWithString:newstr];
    [attributedStr2 addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"3F3F3F"]
                          range:NSMakeRange(0, str3.length)];
    [attributedStr2 addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"999999"]
                          range:NSMakeRange(str3.length, str4.length)];
    self.leftlab1.attributedText = attributedStr2;
    
}

@end
