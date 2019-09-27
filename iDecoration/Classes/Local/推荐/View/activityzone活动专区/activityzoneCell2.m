//
//  activityzoneCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "activityzoneCell2.h"
#import <UIButton+LXMImagePosition.h>
#import "activityzoneModel.h"

@interface activityzoneCell2()
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@end

@implementation activityzoneCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.btn0];
        [self.contentView addSubview:self.btn1];
        [self.contentView addSubview:self.btn2];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(activityzoneModel *)model
{
    NSString *likedstr = [NSString stringWithFormat:@"%ld",model.likeCount];
    [self.btn2 setTitle:likedstr forState:normal];
    NSString *sharestr = [NSString stringWithFormat:@"%ld",model.shareCount];
    [self.btn0 setTitle:sharestr forState:normal];
    NSString *commenstr = [NSString stringWithFormat:@"%ld",model.commentCount];
    [self.btn1 setTitle:commenstr forState:normal];
    
    if (model.isliked) {
        [self.btn2 setImage:[UIImage imageNamed:@"赞2"] forState:normal];
        [self.btn2 setTitleColor:[UIColor hexStringToColor:@"FFA204"] forState:normal];
    }
    else
    {
        [self.btn2 setImage:[UIImage imageNamed:@"赞"] forState:normal];
        [self.btn2 setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(50);
        make.height.mas_offset(28);
    }];
    [weakSelf.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(44);
        make.width.mas_offset(50);
        make.height.mas_offset(28);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(50);
        make.height.mas_offset(28);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-44);
    }];
    

}

#pragma mark - getters

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        [_btn0 setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn0 setImage:[UIImage imageNamed:@"转发"] forState:normal];
        [_btn0 setImagePosition:LXMImagePositionLeft spacing:10];
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn1 setImage:[UIImage imageNamed:@"评论(2)"] forState:normal];
        [_btn1 setImagePosition:LXMImagePositionLeft spacing:10];
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn2 setImage:[UIImage imageNamed:@"赞"] forState:normal];
        [_btn2 setImagePosition:LXMImagePositionLeft spacing:10];
        [_btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}

#pragma mark - 实现方法

-(void)btn0click
{
    [self.delegate myTabVClick0:self];
}

-(void)btn1click
{
    [self.delegate myTabVClick1:self];
}

-(void)btn2click
{
    [self.delegate myTabVClick2:self];
}

@end
