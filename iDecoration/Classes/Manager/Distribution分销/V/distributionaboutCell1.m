//
//  distributionaboutCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionaboutCell1.h"
#import "DistributionaboutModel.h"
#import <UIButton+LXMImagePosition.h>

@interface distributionaboutCell1()
@property (nonatomic,strong) UIImageView *leftimg;
@property (nonatomic,strong) UILabel *titlelab;
@property (nonatomic,strong) UIButton *seebtn;
@end

@implementation distributionaboutCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftimg];
        [self.contentView addSubview:self.titlelab];
        [self.contentView addSubview:self.seebtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(15);
        make.top.equalTo(weakSelf).with.offset(20);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(100);
    }];
    [weakSelf.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftimg);
        make.left.equalTo(weakSelf.leftimg.mas_right).with.offset(15);
        make.right.equalTo(weakSelf).with.offset(-20);
        
    }];
    
    [weakSelf.seebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.leftimg);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(90);
        make.height.mas_offset(20);
    }];
}

#pragma mark - getters


-(UIImageView *)leftimg
{
    if(!_leftimg)
    {
        _leftimg = [[UIImageView alloc] init];
        _leftimg.image = [UIImage imageNamed:@"pic_tututu"];
    }
    return _leftimg;
}

-(UILabel *)titlelab
{
    if(!_titlelab)
    {
        _titlelab = [[UILabel alloc] init];
        _titlelab.font = [UIFont systemFontOfSize:13];
        _titlelab.textColor = [UIColor darkGrayColor];
        _titlelab.numberOfLines = 0;
    }
    return _titlelab;
}

-(UIButton *)seebtn
{
    if(!_seebtn)
    {
        _seebtn = [[UIButton alloc] init];
        [_seebtn setImage:[UIImage imageNamed:@"skimming"] forState:normal];
        _seebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_seebtn setTitleColor:[UIColor hexStringToColor:@"57b1d2"] forState:normal];
        [_seebtn setImagePosition:LXMImagePositionLeft spacing:10];
    }
    return _seebtn;
}

-(void)setdata:(DistributionaboutModel *)model
{
   // [self.leftimg sd_setImageWithURL:[NSURL URLWithString:model.Newtemplate]];
    
    self.titlelab.text = model.designTitle;
    [self.seebtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.readNum] forState:normal];
}

@end
