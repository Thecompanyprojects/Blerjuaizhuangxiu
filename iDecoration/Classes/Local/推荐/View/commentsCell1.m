//
//  commentsCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "commentsCell1.h"
#import <SDAutoLayout.h>

@interface commentsCell1()
@property (nonatomic,strong) UIView *leftLine;
@property (nonatomic,strong) UIView *rightLine;
@end

@implementation commentsCell1


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.numberLab];
        [self.contentView addSubview:self.leftLine];
        [self.contentView addSubview:self.rightLine];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    weakSelf.numberLab.sd_layout
    .leftSpaceToView(weakSelf.contentView, 20)
    .rightSpaceToView(weakSelf.contentView, 20)
    .topSpaceToView(weakSelf.contentView, 10)
    .heightIs(18);
    
    
    
    [weakSelf.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(20);
        make.height.mas_offset(1);
        make.width.mas_offset(kSCREEN_WIDTH/2-60);
    }];
    
    [weakSelf.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.numberLab);
        make.right.equalTo(weakSelf).with.offset(-20);
        make.height.mas_offset(1);
        make.width.mas_offset(kSCREEN_WIDTH/2-60);
    }];
    [weakSelf setupAutoHeightWithBottomView:weakSelf.numberLab bottomMargin:10];
}

#pragma mark - getters

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.textColor = [UIColor lightGrayColor];
        _numberLab.font = [UIFont systemFontOfSize:13];
    }
    return _numberLab;
}


-(UIView *)leftLine
{
    if(!_leftLine)
    {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = [UIColor hexStringToColor:@"C7C7CD"];
    }
    return _leftLine;
}


-(UIView *)rightLine
{
    if(!_rightLine)
    {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = [UIColor hexStringToColor:@"C7C7CD"];
    }
    return _rightLine;
}



@end
