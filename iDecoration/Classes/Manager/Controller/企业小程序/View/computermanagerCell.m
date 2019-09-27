//
//  computermanagerCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "computermanagerCell.h"

@interface computermanagerCell()
@property (nonatomic,strong) UIImageView *bigImg;
@end

@implementation computermanagerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.bigImg];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bigImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIImageView *)bigImg
{
    if(!_bigImg)
    {
        _bigImg = [[UIImageView alloc] init];
        _bigImg.image = [UIImage imageNamed:@"qiyexiaochengxu"];
    }
    return _bigImg;
}


@end
