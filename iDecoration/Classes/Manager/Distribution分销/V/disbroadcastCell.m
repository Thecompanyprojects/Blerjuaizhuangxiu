//
//  disbroadcastCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "disbroadcastCell.h"
#import "SpreadNewsList.h"
#import "Timestr.h"

@interface disbroadcastCell()
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *rightBtn;
@end

@implementation disbroadcastCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.rightBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(SpreadNewsList *)model
{
    NSString *timestr = [Timestr datetime:model.time];
    NSString *provinceName = model.provinceName;
    NSString *cityName = model.cityName;
    NSString *trueName = model.trueName;
   
    NSString *str1 = [NSString new];
    NSString *str2 = [NSString new];
    NSString *str3 = [NSString new];
    
    if ([model.price intValue]<1) {
        if (model.incomeType==0) {
            str1 = [NSString stringWithFormat:@"%@%@%@%@%@",timestr,provinceName,cityName,trueName,@"开通会员"];
            str2 = @"";
            str3 = @"";
            [self.rightBtn setHidden:NO];
        }
        else
        {
            //float moneyfl = [model.price floatValue];
           // NSString *newfl = [NSString stringWithFormat:@"%.2f",moneyfl];
            str1 = [NSString stringWithFormat:@"%@%@%@%@%@",timestr,trueName,@"邀请",model.companyName,@"注册"];
            str2 = @"";
            str3 = @"";
            [self.rightBtn setHidden:YES];
        }
    }
    else
    {
        if (model.incomeType==0) {
            str1 = [NSString stringWithFormat:@"%@%@%@%@%@",timestr,provinceName,cityName,trueName,@"开通会员获得"];
            str2 = [NSString stringWithFormat:@"%@%@",model.price,@"元"];
            str3 = @"现金补贴。";
            [self.rightBtn setHidden:NO];
        }
        else
        {
            float moneyfl = [model.price floatValue];
            NSString *newfl = [NSString stringWithFormat:@"%.2f",moneyfl];
            str1 = [NSString stringWithFormat:@"%@%@%@%@%@",timestr,trueName,@"邀请",model.companyName,@"注册，获得"];
            str2 = [NSString stringWithFormat:@"%@%@",newfl,@"元"];
            str3 = @"红包。";
            [self.rightBtn setHidden:YES];
        }
    }
    

    
    NSString *newStr = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newStr];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"666666"] range:NSMakeRange(0, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"FF9933"] range:NSMakeRange(str1.length, str2.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"666666"] range:NSMakeRange(str1.length+str2.length, str3.length)];
    
    self.contentLab.attributedText = AttributedStr;
    
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.time];
    
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(12);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.contentLab);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-12);
        make.top.equalTo(weakSelf.timeLab);
        make.height.mas_offset(14);
        make.width.mas_offset(100);
    }];
}

#pragma mark - getters

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _timeLab;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rightBtn setTitle:@"团队报单卡>" forState:normal];
        [_rightBtn setTitleColor:Main_Color forState:normal];
        [_rightBtn addTarget:self action:@selector(rightbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    }
    return _rightBtn;
}

#pragma mark - 点击事件

-(void)rightbtnclick
{
    [self.delegate myTabVClick:self];
}

@end
