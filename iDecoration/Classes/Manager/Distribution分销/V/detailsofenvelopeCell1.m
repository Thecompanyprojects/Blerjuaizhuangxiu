//
//  detailsofenvelopeCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "detailsofenvelopeCell1.h"

@interface detailsofenvelopeCell1()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation detailsofenvelopeCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(19);
        make.width.mas_offset(16);
        make.height.mas_offset(17);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(10);
        make.width.mas_offset(150);
    }];
}


#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.image = [UIImage imageNamed:@"hongbaojianglixiq"];
    }
    return _leftImg;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"";
        _contentLab.textColor = [UIColor hexStringToColor:@"333333"];
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    return _contentLab;
}



@end
