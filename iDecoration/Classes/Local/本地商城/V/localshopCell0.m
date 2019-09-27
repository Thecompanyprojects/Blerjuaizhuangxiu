//
//  localshopCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localshopCell0.h"

@interface localshopCell0()
@property (nonatomic,strong) UIImageView *img;
@end

@implementation localshopCell0

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
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - getters


-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.userInteractionEnabled = true;
        //_img.image = [UIImage imageNamed:@"img_jiazhuangbaike"];
        _img.image = [UIImage imageNamed:@"bendishagncheng"];
    }
    return _img;
}

@end
