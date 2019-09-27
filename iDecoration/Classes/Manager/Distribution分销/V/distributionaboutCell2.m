//
//  distributionaboutCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/5.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionaboutCell2.h"

@interface distributionaboutCell2()
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation distributionaboutCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.contentLab];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(12);
        make.width.mas_offset(2);
        make.height.mas_offset(15);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.line.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.height.mas_offset(20);
    }];
}

#pragma mark - getters


-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"24B764"];
    }
    return _line;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"爱装修优秀团队";
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor hexStringToColor:@"010101"];
    }
    return _contentLab;
}


@end
