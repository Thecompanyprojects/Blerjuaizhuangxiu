//
//  personalitytestCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "personalitytestCell.h"

@interface personalitytestCell()
@property (nonatomic,strong) UIImageView *img;

@end

@implementation personalitytestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.leftBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    [weakSelf.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(28);
        make.height.mas_offset(28);
        make.left.equalTo(weakSelf).with.offset(20);
        make.top.equalTo(weakSelf).with.offset(20);
    }];
}

#pragma mark - getters

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"styletest"];
        _img.userInteractionEnabled = YES;
    }
    return _img;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.userInteractionEnabled = YES;
        [_leftBtn setImage:[UIImage imageNamed:@"leftbacl2"] forState:normal];
     
    }
    return _leftBtn;
}

-(void)btnclick
{

}

@end
