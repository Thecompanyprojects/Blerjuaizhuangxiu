//
//  dockingchooseCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "dockingchooseCell.h"
#import "dockingModel.h"

@interface dockingchooseCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIButton *chooseBtn;
@end

@implementation dockingchooseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.chooseBtn];
        [self.contentView addSubview:self.nameLab];
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(dockingModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.nameLab.text = model.trueName;
    if (model.ischoose) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"椭圆3拷贝"] forState:normal];
    }
    else
    {
        [self.chooseBtn setImage:[UIImage imageNamed:@"kongxin"] forState:normal];
    }
}

-(void)setuplauout
{

    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(45);
        make.height.mas_offset(45);
        make.left.equalTo(weakSelf).with.offset(35);
    }];
    [weakSelf.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(13);
        make.width.mas_offset(13);
        make.right.equalTo(weakSelf).with.offset(-35);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(20);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(20);
        make.right.equalTo(weakSelf.chooseBtn.mas_left).with.offset(-10);
    }];
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 45/2;
        
    }
    return _iconImg;
}


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _nameLab.text = @"我的对接人1号";
    }
    return _nameLab;
}


-(UIButton *)chooseBtn
{
    if(!_chooseBtn)
    {
        _chooseBtn = [[UIButton alloc] init];
        [_chooseBtn addTarget:self action:@selector(choosebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}


-(void)choosebtnclick
{
    [self.delegate myTabVchooseClick:self];
}


@end
