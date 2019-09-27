//
//  DistributionheadView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionheadView.h"
#import "Timestr.h"
#import "SpreadNewsList.h"
#import "SGAdvertScrollView.h"

@interface DistributionheadView()<SGAdvertScrollViewDelegate>
@property (nonatomic,strong) UIView *bgview0;
@property (nonatomic,strong) UILabel *typelab0;
@property (nonatomic,strong) UILabel *typelab1;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *bgview1;
@property (nonatomic,strong) UIView *bgview3;
@property (nonatomic,strong) UIView *bgview2;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) SpreadNewsList *model;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) SGAdvertScrollView *bobaoLab;
@end

@implementation DistributionheadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.codelab];
        [self addSubview:self.bgview0];
        [self addSubview:self.line];
        [self addSubview:self.typelab0];
        [self addSubview:self.typelab1];
        [self addSubview:self.moneylab0];
        [self addSubview:self.moneylab1];
        [self addSubview:self.isLevelLab];
        [self addSubview:self.img];
        [self addSubview:self.submitbtn];
        [self addSubview:self.bgview3];
        [self addSubview:self.bgview2];
        [self addSubview:self.leftImg];
        [self addSubview:self.line2];
        [self addSubview:self.bobaoLab];
        [self addSubview:self.moreBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(60*WIDTH_SCALE);
        make.height.mas_offset(60*WIDTH_SCALE);
        make.top.equalTo(weakSelf).with.offset(16);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.iconImg.mas_bottom).with.offset(18);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.codelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(5);
        make.left.equalTo(weakSelf.nameLab);
    }];
    [weakSelf.bgview0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.codelab.mas_bottom).with.offset(16);
        make.height.mas_offset(60);
    }];
    
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.bgview0);
        make.height.mas_offset(24);
        make.width.mas_offset(1);
    }];
    
    [weakSelf.typelab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.height.mas_offset(20);
        make.top.equalTo(weakSelf.bgview0).with.offset(12);
        make.right.equalTo(weakSelf.line.mas_left).with.offset(-14);
    }];
    
    [weakSelf.typelab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.line.mas_right).with.offset(14);
        make.height.mas_offset(20);
        make.top.equalTo(weakSelf.bgview0).with.offset(12);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
    
    [weakSelf.moneylab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typelab0);
        make.right.equalTo(weakSelf.typelab0);
        make.bottom.equalTo(weakSelf.bgview0).with.offset(-9);
        make.height.mas_offset(20);
    }];
    
    [weakSelf.moneylab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typelab1);
        make.right.equalTo(weakSelf.typelab1);
        make.bottom.equalTo(weakSelf.bgview0).with.offset(-9);
        make.height.mas_offset(20);
    }];
    
    [weakSelf.isLevelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(60);
        make.height.mas_offset(17);
        make.bottom.equalTo(weakSelf.iconImg.mas_bottom).with.offset(8);
    }];
    
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.isLevelLab).with.offset(-5);
        make.bottom.equalTo(weakSelf.isLevelLab);
        make.height.mas_offset(25);
        make.width.mas_offset(22);
        make.right.equalTo(weakSelf.isLevelLab.mas_left).with.offset(5);
    }];
    
    [weakSelf.bgview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.height.mas_offset(52);
        make.top.equalTo(weakSelf.bgview0.mas_bottom);
    }];
    
    [weakSelf.bgview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.bgview3).with.offset(5);
        make.height.mas_offset(58);
    }];
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(39);
        make.height.mas_offset(39);
        make.left.equalTo(weakSelf).with.offset(12);
        make.centerY.equalTo(weakSelf.bgview2);
    }];
    [weakSelf.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgview2);
        make.height.mas_offset(38);
        make.width.mas_offset(40);
        make.right.equalTo(weakSelf).with.offset(-10);
    }];
    [weakSelf.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(1);
        make.right.equalTo(weakSelf.moreBtn.mas_left);
        make.height.mas_offset(25);
        make.centerY.equalTo(weakSelf.bgview2);
    }];
    [weakSelf.bobaoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.bgview2);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(2);
        make.right.equalTo(weakSelf.line2.mas_left).with.offset(-2);
        make.height.mas_offset(40);
    }];

    [weakSelf.submitbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(35);
        make.left.equalTo(weakSelf.line).with.offset(2);
        make.right.equalTo(weakSelf).with.offset(-2);
        make.top.equalTo(weakSelf.typelab0);
    }];
    
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 30*WIDTH_SCALE;
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:17];
        _nameLab.textColor = [UIColor hexStringToColor:@"FFFFFF"];
        _nameLab.text = @"我名字叫分销员";
    }
    return _nameLab;
}

-(UILabel *)codelab
{
    if(!_codelab)
    {
        _codelab = [[UILabel alloc] init];
        _codelab.textAlignment = NSTextAlignmentCenter;
        _codelab.font = [UIFont systemFontOfSize:15];
        _codelab.textColor = [UIColor hexStringToColor:@"FFFFFF"];
    }
    return _codelab;
}

-(UIView *)bgview0
{
    if(!_bgview0)
    {
        _bgview0 = [[UIView alloc] init];
        _bgview0.backgroundColor = [UIColor hexStringToColor:@"38A165"];
    }
    return _bgview0;
}

-(UILabel *)typelab0
{
    if(!_typelab0)
    {
        _typelab0 = [[UILabel alloc] init];
        _typelab0.textAlignment = NSTextAlignmentCenter;
        _typelab0.font = [UIFont systemFontOfSize:17];
        _typelab0.text = @"未提现：(元）";
        _typelab0.textColor = [UIColor hexStringToColor:@"FFFFFF"];
    }
    return _typelab0;
}

-(UILabel *)typelab1
{
    if(!_typelab1)
    {
        _typelab1 = [[UILabel alloc] init];
        _typelab1.textAlignment = NSTextAlignmentCenter;
        _typelab1.font = [UIFont systemFontOfSize:17];
        _typelab1.text = @"未提现：(元)";
        [_typelab1 setHidden:YES];
        _typelab1.textColor = [UIColor hexStringToColor:@"FFFFFF"];
    }
    return _typelab1;
}

-(UILabel *)moneylab0
{
    if(!_moneylab0)
    {
        _moneylab0 = [[UILabel alloc] init];
        _moneylab0.textAlignment = NSTextAlignmentCenter;
        _moneylab0.font = [UIFont systemFontOfSize:17];
        _moneylab0.text = @"0.00";
        _moneylab0.textColor = [UIColor hexStringToColor:@"FFFFFF"];
    }
    return _moneylab0;
}


-(UILabel *)moneylab1
{
    if(!_moneylab1)
    {
        _moneylab1 = [[UILabel alloc] init];
        _moneylab1.textAlignment = NSTextAlignmentCenter;
        _moneylab1.font = [UIFont systemFontOfSize:17];
        _moneylab1.text = @"0.00";
        [_moneylab1 setHidden:YES];
        
        _moneylab1.textColor = [UIColor hexStringToColor:@"FFFFFF"];
    }
    return _moneylab1;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"钻石222"];
    }
    return _img;
}


-(UILabel *)isLevelLab
{
    if(!_isLevelLab)
    {
        _isLevelLab = [[UILabel alloc] init];
        _isLevelLab.font = [UIFont systemFontOfSize:10];
        _isLevelLab.textColor = [UIColor whiteColor];
        _isLevelLab.backgroundColor = [UIColor hexStringToColor:@"000000"];
        _isLevelLab.layer.masksToBounds = YES;
        _isLevelLab.textAlignment = NSTextAlignmentCenter;
        _isLevelLab.layer.cornerRadius = 17/2;
    }
    return _isLevelLab;
}

-(UIButton *)submitbtn
{
    if(!_submitbtn)
    {
        _submitbtn = [[UIButton alloc] init];
        _submitbtn.backgroundColor = [UIColor clearColor];
        [_submitbtn setTitle:@"提现" forState:normal];
        _submitbtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_submitbtn setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _submitbtn;
}

-(UIView *)bgview2
{
    if(!_bgview2)
    {
        _bgview2 = [[UIView alloc] init];
        _bgview2.backgroundColor = [UIColor whiteColor];

    }
    return _bgview2;
}

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.image = [UIImage imageNamed:@"icon_fenxiaokuai"];
    }
    return _leftImg;
}

-(SGAdvertScrollView *)bobaoLab
{
    if(!_bobaoLab)
    {
        _bobaoLab = [[SGAdvertScrollView alloc] init];
        _bobaoLab.delegate = self;
        _bobaoLab.titleFont = [UIFont systemFontOfSize:14];
    }
    return _bobaoLab;
}

-(UIButton *)moreBtn
{
    if(!_moreBtn)
    {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.titleLabel.numberOfLines = 0;
        _moreBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setTitleColor:[UIColor hexStringToColor:@"4E4E4E"] forState:normal];
    }
    return _moreBtn;
}

-(UIView *)line2
{
    if(!_line2)
    {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor hexStringToColor:@"4E4E4E"];
    }
    return _line2;
}


-(UIView *)bgview3
{
    if(!_bgview3)
    {
        _bgview3 = [[UIView alloc] init];
        _bgview3.backgroundColor = kBackgroundColor;
    }
    return _bgview3;
}

-(void)setdata:(NSMutableArray *)arr
{
    self.dataSource = [NSMutableArray array];
    if (arr.count!=0) {
        for (int i = 0; i<arr.count; i++) {
            SpreadNewsList *model = arr[i];
            NSString *timestr = [Timestr datetime:model.time];
            NSString *cityName = model.cityName;
            NSString *trueName = model.trueName;
            NSString *provinceName = model.provinceName;
            
            NSString *str1 = [NSString new];
            NSString *str2 = [NSString new];
            NSString *str3 = [NSString new];
            
            if (model.incomeType==0) {
                str1 = [NSString stringWithFormat:@"%@%@%@%@%@",timestr,provinceName,cityName,trueName,@"开通会员获得"];
                str2 = [NSString stringWithFormat:@"%@%@",model.price,@"元"];
                str3 = @"现金补贴。";
            }
            else
            {
                float moneyfl = [model.price floatValue];
                NSString *newfl = [NSString stringWithFormat:@"%.2f",moneyfl];
                str1 = [NSString stringWithFormat:@"%@%@%@%@%@",timestr,trueName,@"邀请",model.companyName,@"注册，获得"];
                str2 = [NSString stringWithFormat:@"%@%@",newfl,@"元"];
                str3 = @"红包。";
            }
            
            
            NSString *newStr = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newStr];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"666666"] range:NSMakeRange(0, str1.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"FF9933"] range:NSMakeRange(str1.length, str2.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"666666"] range:NSMakeRange(str1.length+str2.length, str3.length)];
            
            [self.dataSource addObject:AttributedStr];
        }
    }
    else
    {
        NSString *newStr = @"1年开3个会员，则第2年的会员续费还归该分销员所有";
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newStr];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"666666"] range:NSMakeRange(0, newStr.length)];
        [self.dataSource addObject:AttributedStr];
    }
   
    

    self.bobaoLab.titles = self.dataSource;
    self.bobaoLab.titleColor = [UIColor hexStringToColor:@"666666"];

}

- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index
{
    
}

@end
