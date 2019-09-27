//
//  casedesignCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "casedesignCell2.h"
#import <UIButton+LXMImagePosition.h>
#import "newdesignModel.h"

@interface casedesignCell2()
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *commentsBtn;
@property (nonatomic,strong) UIButton *praiseBtn;
@end

@implementation casedesignCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.shareBtn];
        [self.contentView addSubview:self.commentsBtn];
        [self.contentView addSubview:self.praiseBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(newdesignModel *)model
{
//    if ([model.liked isEqualToString:@"0"]) {
//        [_praiseBtn setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
//        [_praiseBtn setImage:[UIImage imageNamed:@"赞"] forState:normal];
//    }
//    else
//    {
//        [_praiseBtn setTitleColor:[UIColor hexStringToColor:@"FFA204"] forState:normal];
//        [_praiseBtn setImage:[UIImage imageNamed:@"赞2"] forState:normal];
//    }
    
    NSString *likedstr = [NSString stringWithFormat:@"%ld",model.likeNumbers];
    NSString *readNumstr = [NSString stringWithFormat:@"%ld",model.readNum];
    NSString *shareNumstr = [NSString stringWithFormat:@"%ld",model.share];
    
    [self.praiseBtn setTitle:likedstr forState:normal];
    [self.shareBtn setTitle:shareNumstr forState:normal];
    [self.commentsBtn setTitle:readNumstr forState:normal];
    
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(50);
        make.height.mas_offset(28);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(50);
        make.height.mas_offset(28);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(44);
    }];
    [weakSelf.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(50);
        make.height.mas_offset(28);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-44);
    }];
}

#pragma mark - getters


-(UIButton *)shareBtn
{
    if(!_shareBtn)
    {
        _shareBtn = [[UIButton alloc] init];
        [_shareBtn setImage:[UIImage imageNamed:@"转发"] forState:normal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_shareBtn setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_shareBtn setImagePosition:LXMImagePositionLeft spacing:10];
        [_shareBtn addTarget:self action:@selector(sharebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

-(UIButton *)commentsBtn
{
    if(!_commentsBtn)
    {
        _commentsBtn = [[UIButton alloc] init];
        [_commentsBtn setImage:[UIImage imageNamed:@"评论(2)"] forState:normal];
        [_commentsBtn setTitle:@"22" forState:normal];
        _commentsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_commentsBtn setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_commentsBtn setImagePosition:LXMImagePositionLeft spacing:10];
        [_commentsBtn addTarget:self action:@selector(commentsbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentsBtn;
}

-(UIButton *)praiseBtn
{
    if(!_praiseBtn)
    {
        _praiseBtn = [[UIButton alloc] init];
        [_praiseBtn setImage:[UIImage imageNamed:@"赞"] forState:normal];
        [_praiseBtn setTitle:@"31" forState:normal];
        _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_praiseBtn setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_praiseBtn setImagePosition:LXMImagePositionLeft spacing:10];
        [_praiseBtn addTarget:self action:@selector(praisbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseBtn;
}


-(void)sharebtnclick
{
    [self.delegate shareTabVClick0:self];
}

-(void)commentsbtnclick
{
    [self.delegate commentsTabVClick1:self];
}

-(void)praisbtnclick
{
    [self.delegate zanTabVClick2:self];
}

@end
