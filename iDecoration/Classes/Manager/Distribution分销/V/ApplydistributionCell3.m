//
//  ApplydistributionCell3.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ApplydistributionCell3.h"

@interface ApplydistributionCell3()
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *rightLab;



@end

@implementation ApplydistributionCell3

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.rightLab];
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.rightImg];
        [self.contentView addSubview:self.img0];
        [self.contentView addSubview:self.img1];
        [self.contentView addSubview:self.imgBtn0];
        [self.contentView addSubview:self.imgBtn1];
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(26);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-kSCREEN_WIDTH/2);
    }];
    [weakSelf.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab);
        make.left.equalTo(weakSelf).with.offset(kSCREEN_WIDTH/2);
        make.right.equalTo(weakSelf);
    }];
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab.mas_bottom).with.offset(10);
        make.width.mas_offset(131);
        make.height.mas_offset(87);
        make.centerX.equalTo(weakSelf.leftLab);
    }];
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab.mas_bottom).with.offset(10);
        make.width.mas_offset(131);
        make.height.mas_offset(87);
        make.centerX.equalTo(weakSelf.rightLab);
    }];
    
    [weakSelf.img0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(46);
        make.height.mas_offset(43);
        make.centerX.equalTo(weakSelf.leftImg);
        make.top.equalTo(weakSelf.leftImg).with.offset(10);
    }];
    
    [weakSelf.img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(46);
        make.height.mas_offset(43);
        make.centerX.equalTo(weakSelf.rightImg);
        make.top.equalTo(weakSelf.img0);
    }];
    
    [weakSelf.imgBtn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.img0.mas_bottom).with.offset(6);
        make.left.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf.leftImg);
    }];
    
    [weakSelf.imgBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imgBtn0);
        make.left.equalTo(weakSelf.rightImg);
        make.right.equalTo(weakSelf.rightImg);
    }];

    [weakSelf.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-kSCREEN_WIDTH/2);
        make.top.equalTo(weakSelf.leftImg.mas_bottom).with.offset(10);
    }];
    [weakSelf.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(kSCREEN_WIDTH/2);
        make.top.equalTo(weakSelf.leftImg.mas_bottom).with.offset(10);
    }];
    
 
}

#pragma mark - getters


-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textAlignment = NSTextAlignmentCenter;
        _leftLab.text = @"证件正面照片";
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.textColor = [UIColor hexStringToColor:@"373737"];
    }
    return _leftLab;
}

-(UILabel *)rightLab
{
    if(!_rightLab)
    {
        _rightLab = [[UILabel alloc] init];
        _rightLab.textAlignment = NSTextAlignmentCenter;
        _rightLab.font = [UIFont systemFontOfSize:14];
        _rightLab.textColor = [UIColor hexStringToColor:@"373737"];
        _rightLab.text = @"证件背面照片";
    }
    return _rightLab;
}

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.backgroundColor = [UIColor hexStringToColor:@"D4EDFF"];
    }
    return _leftImg;
}

-(UIImageView *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIImageView alloc] init];
        _rightImg.backgroundColor = [UIColor hexStringToColor:@"D4EDFF"];
    }
    return _rightImg;
}


-(UIButton *)imgBtn0
{
    if(!_imgBtn0)
    {
        _imgBtn0 = [[UIButton alloc] init];
        [_imgBtn0 setTitle:@"点击上传" forState:normal];
        [_imgBtn0 setTitleColor:[UIColor hexStringToColor:@"8B8B8B"] forState:normal];
        _imgBtn0.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _imgBtn0;
}


-(UIButton *)imgBtn1
{
    if(!_imgBtn1)
    {
        _imgBtn1 = [[UIButton alloc] init];
        [_imgBtn1 setTitle:@"点击上传" forState:normal];
        [_imgBtn1 setTitleColor:[UIColor hexStringToColor:@"8B8B8B"] forState:normal];
        _imgBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _imgBtn1;
}


-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"重新上传" forState:normal];
        [_leftBtn setTitleColor:[UIColor hexStringToColor:@"91C7FF"] forState:normal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"重新上传" forState:normal];
        [_rightBtn setTitleColor:[UIColor hexStringToColor:@"91C7FF"] forState:normal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    return _rightBtn;
}


-(UIImageView *)img0
{
    if(!_img0)
    {
        _img0 = [[UIImageView alloc] init];
        _img0.image = [UIImage imageNamed:@"上传转账凭证拷贝"];
    }
    return _img0;
}


-(UIImageView *)img1
{
    if(!_img1)
    {
        _img1 = [[UIImageView alloc] init];
        _img1.image = [UIImage imageNamed:@"上传转账凭证拷贝"];
    }
    return _img1;
}

#pragma mark - 实现方法



@end
