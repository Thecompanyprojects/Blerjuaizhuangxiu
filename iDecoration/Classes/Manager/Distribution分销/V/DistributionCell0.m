//
//  DistributionCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionCell0.h"

@interface DistributionCell0()
@property (nonatomic,strong) UIImageView *bgimg;
@end

@implementation DistributionCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.bgimg];
        [self setuplauout];
    }
    return self;
}


-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - getters


-(UIImageView *)bgimg
{
    if(!_bgimg)
    {
        _bgimg = [[UIImageView alloc] init];
        _bgimg.image = [UIImage imageNamed:@"bg_jiaruwomen"];
    }
    return _bgimg;
}



@end
