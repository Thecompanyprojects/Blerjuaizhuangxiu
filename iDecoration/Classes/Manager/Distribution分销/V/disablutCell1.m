//
//  disablutCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "disablutCell1.h"


@interface disablutCell1()
@property (nonatomic,strong) UIImageView *scroll;
@end

@implementation disablutCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.scroll];
        [self setuplauout];
    }
    return self;
}


-(void)setdatafrom:(NSString *)imgname
{
    self.scroll.image = [UIImage imageNamed:imgname];
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - getters


-(UIImageView *)scroll
{
    if(!_scroll)
    {
        _scroll = [[UIImageView alloc] init];
        
    }
    return _scroll;
}


@end

