
//
//  newstousuCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newstousuCell0.h"

@interface newstousuCell0()
@property (nonatomic,strong) UILabel *leftLab;
@end

@implementation newstousuCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.contentLab];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(90);
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(1);
    }];
}

#pragma mark - getters


-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _leftLab.text = @"投诉类型：";
        _leftLab.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"请选择投诉类型";
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab;
}




@end
