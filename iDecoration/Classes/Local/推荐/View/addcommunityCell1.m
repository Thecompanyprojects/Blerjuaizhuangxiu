//
//  addcommunityCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "addcommunityCell1.h"

@interface addcommunityCell1()

@end

@implementation addcommunityCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.commnuityText];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(80);
        make.centerY.equalTo(weakSelf);
        //make.top.equalTo(weakSelf).with.offset(12);
    }];
    [weakSelf.commnuityText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-12);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(4);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textColor = [UIColor hexStringToColor:@"333333"];
        _leftLab.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab;
}

-(UITextField *)commnuityText
{
    if(!_commnuityText)
    {
        _commnuityText = [[UITextField alloc] init];
        
    }
    return _commnuityText;
}


@end
