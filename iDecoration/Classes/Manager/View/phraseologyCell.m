//
//  phraseologyCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "phraseologyCell.h"
#import <SDAutoLayout.h>

@interface phraseologyCell()
@property (nonatomic,strong) UILabel *contentlab;
@end

@implementation phraseologyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:self.submitbtn];
        [self.contentView addSubview:self.contentlab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    weakSelf.submitbtn.sd_layout
    .rightSpaceToView(weakSelf.contentView, 30)
    .topSpaceToView(weakSelf.contentView, 20)
    .heightIs(20)
    .widthIs(120);
    
    weakSelf.contentlab
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .rightSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.submitbtn, 10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:weakSelf.submitbtn bottomMargin:20];
}

-(void)setdata:(NSString *)contentstr andtype:(NSString *)type andisshow:(BOOL)show
{
    if ([type isEqualToString:@"0"]) {
        [_submitbtn setTitle:@"公司常用语说明" forState:normal];
        self.contentlab.text = @"公司常用语里包括推送过来的常用语和员工自己创建的常用语。总经理和执行经理推送到该节点的常用语，在该节点有编辑权限的员工可见；公司成员自己在公司常用语里创建的常用语，仅该成员自己可见。总经理/执行经理可以编辑修改推送的常用语；员工没有编辑修改常用语权限";
    }
    else
    {
        [_submitbtn setTitle:@"系统常用语说明" forState:normal];
        self.contentlab.text = @"是管理员给全国公司统一推的一套半成品模板，试用于施工日志各节点中，并针对不同的节点，不同的角色，推送不同的常用语。总经理和执行经理可以根据工地需求，对模板进行编辑完善，之后，再推送到公司常用语中，以供公司员工选择。";
    }
    if (show) {
        [self.contentlab setHidden:NO];
        [self setupAutoHeightWithBottomView:self.contentlab bottomMargin:20];
    }
    else
    {
        [self.contentlab setHidden:YES];
        [self setupAutoHeightWithBottomView:self.submitbtn bottomMargin:20];
    }
}

#pragma mark - getters

-(UIButton *)submitbtn
{
    if(!_submitbtn)
    {
        _submitbtn = [[UIButton alloc] init];
        _submitbtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [_submitbtn setTitleColor:[UIColor redColor] forState:normal];

    }
    return _submitbtn;
}


-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.textColor = [UIColor darkGrayColor];
        _contentlab.font = [UIFont systemFontOfSize:12];
        
    }
    return _contentlab;
}

#pragma mark - 实现方法


@end
