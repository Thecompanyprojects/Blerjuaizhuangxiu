
//
//  localexeCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localexeCell.h"
#import <UIButton+LXMImagePosition.h>
#import "localexeModel.h"

@interface localexeCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *readBtn;
@end

@implementation localexeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.readBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(localexeModel *)model
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
    self.titleLab.text = model.caseTitle?:@"";
    self.contentLab.text = model.designSubtitle?:@"";
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld",(long)model.addTime]];
    [self.readBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.readNum] forState:normal];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.top.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset(104);
        make.height.mas_offset(69);
    }];
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-10);
    }];
    
    // _contentLab.text = @"在我们生活中，大家一定接触到保温材料吧，今天小编就给大家详细讲解一下生活中的保温材料有…";
    _contentLab.preferredMaxLayoutWidth = (kSCREEN_WIDTH - 10.0 * 2-104);
    [_contentLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.right.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(7);
        make.height.mas_offset(29);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(7);
    }];
    [weakSelf.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLab);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.height.mas_offset(11);
        make.width.mas_offset(60);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        //_leftImg.backgroundColor = [UIColor greenColor];
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
        _leftImg.layer.masksToBounds = YES;
    }
    return _leftImg;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _titleLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = [UIColor hexStringToColor:@"777777"];
        _contentLab.numberOfLines = 2;
    }
    return _contentLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor hexStringToColor:@"777777"];
    }
    return _timeLab;
}

-(UIButton *)readBtn
{
    if(!_readBtn)
    {
        _readBtn = [[UIButton alloc] init];
        _readBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_readBtn setTitleColor:[UIColor hexStringToColor:@"777777"] forState:normal];
        [_readBtn setImagePosition:LXMImagePositionLeft spacing:4];
        [_readBtn setImage:[UIImage imageNamed:@"skimming"] forState:normal];
    }
    return _readBtn;
}
@end
