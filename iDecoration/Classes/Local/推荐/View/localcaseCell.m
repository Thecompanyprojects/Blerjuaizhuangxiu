//
//  localcaseCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localcaseCell.h"
#import "localcaseModel.h"

@interface localcaseCell()
@property (nonatomic,strong) UIImageView *caseImg;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *styleLab;
@property (nonatomic,strong) UILabel *areaLab;
@property (nonatomic,strong) UIImageView *starImg;
@property (nonatomic,strong) UILabel *starnumLab;
@property (nonatomic,strong) UILabel *creditLab;
@end

@implementation localcaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.caseImg];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.styleLab];
        [self.contentView addSubview:self.areaLab];
        [self.contentView addSubview:self.starImg];
        [self.contentView addSubview:self.starnumLab];
        [self.contentView addSubview:self.creditLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(localcaseModel *)model withtype:(NSString *)type
{
    [self.caseImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.nameLab.text = model.companyName?:@"";
    self.styleLab.text = model.areaName?:@"";
    self.areaLab.text = [NSString stringWithFormat:@"%@%@",model.ccAcreage,@"²"]?:@"";
    self.starnumLab.text = [NSString stringWithFormat:@"%ld",(long)model.collNum]?:@"";
    
    if ([type isEqualToString:@"0"]) {
        NSString *str1 = @"浏览量:";
        NSString *str2 = [NSString stringWithFormat:@"%ld",(long)model.scanCount];
        NSString *newstr = [NSString stringWithFormat:@"%@%@",str1,str2];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newstr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:Main_Color
         
                              range:NSMakeRange(0, str1.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"999999"]
         
                              range:NSMakeRange(str1.length, str2.length)];
        self.creditLab.attributedText = AttributedStr;
    }
    if ([type isEqualToString:@"1"]) {
        NSString *str1 = @"好评数:";
        NSString *str2 = [NSString stringWithFormat:@"%ld",(long)model.sumGrade];
        NSString *newstr = [NSString stringWithFormat:@"%@%@",str1,str2];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newstr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:Main_Color
         
                              range:NSMakeRange(0, str1.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"999999"]
         
                              range:NSMakeRange(str1.length, str2.length)];
        self.creditLab.attributedText = AttributedStr;
    }
    if ([type isEqualToString:@"2"]) {
        NSString *str1 = @"信用值:";
        NSString *str2 = [NSString stringWithFormat:@"%@",model.bannerNum];
        NSString *newstr = [NSString stringWithFormat:@"%@%@",str1,str2];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newstr];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:Main_Color
         
                              range:NSMakeRange(0, str1.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"999999"]
         
                              range:NSMakeRange(str1.length, str2.length)];
        self.creditLab.attributedText = AttributedStr;
    }
    if ([type isEqualToString:@"4"]) {
        self.creditLab.text = @"";
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.caseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(7);
        make.right.equalTo(weakSelf).with.offset(-7);
        make.top.equalTo(weakSelf).with.offset(10);
        make.height.mas_offset(113);
    }];
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.caseImg);
        make.right.equalTo(weakSelf.caseImg);
        make.height.mas_offset(26);
        make.bottom.equalTo(weakSelf.caseImg);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.bottom.equalTo(weakSelf.bgView);
        make.height.mas_offset(26);
    }];
    [weakSelf.styleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.caseImg);
        make.top.equalTo(weakSelf.bgView.mas_bottom).with.offset(6);
        make.height.mas_offset(12);
        
    }];
    [weakSelf.areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView);
        make.top.equalTo(weakSelf.styleLab);
        make.height.mas_offset(12);
    }];
    [weakSelf.starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(12);
        make.height.mas_offset(12);
        make.top.equalTo(weakSelf.styleLab.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.styleLab);
    }];
    [weakSelf.starnumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.starImg.mas_right).with.offset(6);
        make.top.equalTo(weakSelf.starImg);
        make.height.mas_offset(12);
    }];
    [weakSelf.creditLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView);
        make.top.equalTo(weakSelf.starImg);
        make.height.mas_offset(12);
        make.width.mas_offset(100);
    }];
}

#pragma mark - getters

-(UIImageView *)caseImg
{
    if(!_caseImg)
    {
        _caseImg = [[UIImageView alloc] init];
        _caseImg.contentMode = UIViewContentModeScaleAspectFill;
        _caseImg.layer.masksToBounds = YES;
    }
    return _caseImg;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.alpha = 0.3;
        _bgView.backgroundColor = Black_Color;
    }
    return _bgView;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = White_Color;
        _nameLab.font = [UIFont systemFontOfSize:12];
        //_nameLab.text = @"龙华新区";
    }
    return _nameLab;
}

-(UILabel *)styleLab
{
    if(!_styleLab)
    {
        _styleLab = [[UILabel alloc] init];
        _styleLab.font = [UIFont systemFontOfSize:12];
        //_styleLab.text = @"龙华新区";
        _styleLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _styleLab;
}

-(UILabel *)areaLab
{
    if(!_areaLab)
    {
        _areaLab = [[UILabel alloc] init];
       // _areaLab.text = @"100²";
        _areaLab.font = [UIFont systemFontOfSize:333333];
        _areaLab.font = [UIFont systemFontOfSize:12];
        _areaLab.textAlignment = NSTextAlignmentRight;
    }
    return _areaLab;
}

-(UIImageView *)starImg
{
    if(!_starImg)
    {
        _starImg = [[UIImageView alloc] init];
        _starImg.image = [UIImage imageNamed:@"starSymbol_height"];
    }
    return _starImg;
}

-(UILabel *)starnumLab
{
    if(!_starnumLab)
    {
        _starnumLab = [[UILabel alloc] init];
        _starnumLab.textColor = [UIColor hexStringToColor:@"999999"];
       // _starnumLab.text = @"322";
        _starnumLab.font = [UIFont systemFontOfSize:11];
    }
    return _starnumLab;
}

-(UILabel *)creditLab
{
    if(!_creditLab)
    {
        _creditLab = [[UILabel alloc] init];
        _creditLab.textAlignment = NSTextAlignmentRight;
        _creditLab.font = [UIFont systemFontOfSize:11];
        _creditLab.textColor = [UIColor hexStringToColor:@"999999"];
       // _creditLab.text = @"信用值：600";
    }
    return _creditLab;
}








@end
