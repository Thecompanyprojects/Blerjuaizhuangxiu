//
//  communitymanagerCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "communitymanagerCell.h"
#import "communitymanagerModel.h"
#import "communitymanagerModel2.h"

@interface communitymanagerCell()
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation communitymanagerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.height.mas_offset(102);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(6);
    }];
}
-(void)setdata2:(communitymanagerModel2 *)model
{
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.contentLab.text = [NSString stringWithFormat:@"%@%@%@%@",model.sharTitle,@"   ",model.ccAcreage,@"㎡"];
}
-(void)setdata:(communitymanagerModel *)model
{
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
    NSString *contentstr = [NSString stringWithFormat:@"%ld%@%ld%@%ld%@%ld%@%@%@%@",model.room,@"室",model.darawindRoom,@"厅",model.kitchen,@"厨",model.toilet,@"卫",@"/",model.mobelAcreage,@"㎡"];
    self.contentLab.text = contentstr;
}

#pragma mark - getters

-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        
    }
    return _topImg;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = [UIColor hexStringToColor:@"003333"];
    }
    return _contentLab;
}



@end
