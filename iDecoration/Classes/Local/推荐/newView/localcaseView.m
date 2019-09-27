//
//  localcaseView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localcaseView.h"

@implementation localcaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.caseImg];
        [self addSubview:self.styleLab];
        [self addSubview:self.areaLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.caseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(104);
    }];
    [weakSelf.styleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.caseImg.mas_bottom).with.offset(11);
        make.left.equalTo(weakSelf).with.offset(6);
    }];
    [weakSelf.areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.styleLab);
        make.right.equalTo(weakSelf).with.offset(-5);
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

-(UILabel *)styleLab
{
    if(!_styleLab)
    {
        _styleLab = [[UILabel alloc] init];
        _styleLab.font = [UIFont systemFontOfSize:13];
        _styleLab.textColor = [UIColor hexStringToColor:@"444444"];
        _styleLab.text = @"现代风格三居";
    }
    return _styleLab;
}

-(UILabel *)areaLab
{
    if(!_areaLab)
    {
        _areaLab = [[UILabel alloc] init];
        _areaLab.textColor = [UIColor hexStringToColor:@"777777"];
        _areaLab.font = [UIFont systemFontOfSize:13];
        _areaLab.text = @"100";
    }
    return _areaLab;
}




@end
