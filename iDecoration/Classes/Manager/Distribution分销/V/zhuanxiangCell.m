//
//  zhuanxiangCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "zhuanxiangCell.h"

@interface zhuanxiangCell()
@property (nonatomic,strong) UIImageView *img;

@end

@implementation zhuanxiangCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.submitBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
    }];
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(40);
        make.top.equalTo(weakSelf).with.offset(134);
        make.width.mas_offset(167);
        make.height.mas_offset(52);
    }];
}

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"分销员专享"];
    }
    return _img;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"立即开通" forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.layer.borderWidth = 1;
        [_submitBtn setTitleColor:[UIColor hexStringToColor:@"CF8638"] forState:normal];
        _submitBtn.layer.borderColor = [UIColor hexStringToColor:@"CF8638"].CGColor;
    }
    return _submitBtn;
}



@end
