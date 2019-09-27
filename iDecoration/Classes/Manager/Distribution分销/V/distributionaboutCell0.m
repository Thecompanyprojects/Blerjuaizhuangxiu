//
//  distributionaboutCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionaboutCell0.h"

@interface distributionaboutCell0()
@property (nonatomic,strong) UIImageView *img;
@end

@implementation distributionaboutCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.img];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"fenxiaowm"];
    }
    return _img;
}

@end
