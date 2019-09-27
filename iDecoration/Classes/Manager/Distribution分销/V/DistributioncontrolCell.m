//
//  DistributioncontrolCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributioncontrolCell.h"

@interface DistributioncontrolCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *textLab;
@property (nonatomic,strong) UILabel *rightLab;
@end

@implementation DistributioncontrolCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.textLab];
        [self.contentView addSubview:self.rightLab];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(18);
        make.height.mas_offset(18);
    }];
    [weakSelf.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(46);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(120*WIDTH_SCALE);
        make.height.mas_offset(25);
    }];
    [weakSelf.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-44);
        make.width.mas_offset(50);
        make.height.mas_offset(20);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        
    }
    return _leftImg;
}

-(UILabel *)textLab
{
    if(!_textLab)
    {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [UIFont systemFontOfSize:15];
        _textLab.textColor = [UIColor hexStringToColor:@"000000"];
    }
    return _textLab;
}


-(UILabel *)rightLab
{
    if(!_rightLab)
    {
        _rightLab = [[UILabel alloc] init];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.font = [UIFont systemFontOfSize:12];
        _rightLab.textColor = [UIColor hexStringToColor:@"FF3131"];
    }
    return _rightLab;
}



-(void)setdata:(NSInteger )index
{
    switch (index) {
        case 0:
            self.leftImg.image = [UIImage imageNamed:@"icon_qianbao"];
            [self.rightLab setHidden:NO];
            self.textLab.text = @"分销记录及佣金";

            [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(21);
            }];
            
            break;
        case 1:
            self.leftImg.image = [UIImage imageNamed:@"icon_erweima"];
            [self.rightLab setHidden:YES];
            self.textLab.text = @"推广方式";
            break;
        case 2:
            self.leftImg.image = [UIImage imageNamed:@"icon_jilu"];
            [self.rightLab setHidden:YES];
            self.textLab.text = @"邀请记录";
            break;
        default:
            break;
    }
}


@end
