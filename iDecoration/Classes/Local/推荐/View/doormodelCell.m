//
//  doormodelCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/28.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "doormodelCell.h"
#import "newdoorModel.h"

@interface doormodelCell()
@property (nonatomic ,strong) UIImageView *doorImg;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UILabel *styleLab;
@property (nonatomic ,strong) UILabel *priceLab;
@end

@implementation doormodelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.doorImg];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.styleLab];
        [self.contentView addSubview:self.priceLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(newdoorModel *)model
{
    [self.doorImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.styleLab.text = model.style?:@"";
    self.priceLab.text = [NSString stringWithFormat:@"%@%@",model.ccAcreage,@"㎡"];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.doorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.height.mas_offset(103);
    }];
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.doorImg.mas_bottom);
        make.height.mas_offset(20);
    }];
    [weakSelf.styleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf.bgView);
        make.bottom.equalTo(weakSelf.bgView);
        make.width.mas_offset(80);
    }];
    [weakSelf.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.bgView);
        make.bottom.equalTo(weakSelf.bgView);
        make.width.mas_offset(80);
    }];
}

#pragma mark - getters

-(UIImageView *)doorImg
{
    if(!_doorImg)
    {
        _doorImg = [[UIImageView alloc] init];
        
    }
    return _doorImg;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    }
    return _bgView;
}

-(UILabel *)styleLab
{
    if(!_styleLab)
    {
        _styleLab = [[UILabel alloc] init];
        _styleLab.textColor = [UIColor hexStringToColor:@"003333"];
        _styleLab.font = [UIFont systemFontOfSize:11];
    }
    return _styleLab;
}

-(UILabel *)priceLab
{
    if(!_priceLab)
    {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textColor = [UIColor hexStringToColor:@"003333"];
        _priceLab.textAlignment = NSTextAlignmentRight;
        _priceLab.font = [UIFont systemFontOfSize:11];
    }
    return _priceLab;
}





@end

