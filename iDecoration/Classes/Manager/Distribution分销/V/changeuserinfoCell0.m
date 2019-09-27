//
//  changeuserinfoCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "changeuserinfoCell0.h"

@interface changeuserinfoCell0()
@property (nonatomic,strong) UIImageView *xinxinimg;
@property (nonatomic,strong) UILabel *typelab;
@end


@implementation changeuserinfoCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconBtn];
        [self.contentView addSubview:self.typelab];
        [self.contentView addSubview:self.xinxinimg];
        [self.contentView addSubview:self.submitBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(50);
        make.height.mas_offset(50);
        make.top.equalTo(weakSelf).with.offset(30);
    }];
    [weakSelf.typelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconBtn.mas_bottom).with.offset(15);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(20);
    }];
    [weakSelf.xinxinimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.typelab);
        make.right.equalTo(weakSelf.typelab.mas_left).with.offset(-5);
        make.width.mas_offset(15);
        make.height.mas_offset(15);
    }];
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(48);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(42);
        make.top.equalTo(weakSelf.typelab.mas_bottom).with.offset(20);
    }];
}

#pragma mark - getters


-(UIButton *)iconBtn
{
    if(!_iconBtn)
    {
        _iconBtn = [[UIButton alloc] init];
        [_iconBtn setImage:[UIImage imageNamed:@"touxiang"] forState:normal];
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.layer.cornerRadius = 25;
    }
    return _iconBtn;
}


-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        [_submitBtn setTitle:@"上传图像" forState:normal];
        _submitBtn.backgroundColor = [UIColor hexStringToColor:@"24B764"];
    }
    return _submitBtn;
}

-(UILabel *)typelab
{
    if(!_typelab)
    {
        _typelab = [[UILabel alloc] init];
        _typelab.textAlignment = NSTextAlignmentCenter;
        _typelab.text = @"注：推荐头像尺寸100*100";
        _typelab.font = [UIFont systemFontOfSize:12];
        _typelab.textColor = [UIColor hexStringToColor:@"868686"];
    }
    return _typelab;
}

-(UIImageView *)xinxinimg
{
    if(!_xinxinimg)
    {
        _xinxinimg = [[UIImageView alloc] init];
        _xinxinimg.image = [UIImage imageNamed:@"xinxin0"];
    }
    return _xinxinimg;
}





@end
