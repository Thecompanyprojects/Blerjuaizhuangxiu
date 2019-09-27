//
//  localbroadcastCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localbroadcastCell.h"
#import "localbroadcastModel.h"

@interface localbroadcastCell()
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@end

@implementation localbroadcastCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.timeLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(12);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.contentLab);
        make.centerX.equalTo(weakSelf);
    }];
}

-(void)setdata:(localbroadcastModel *)model
{
    self.contentLab.text = [NSString stringWithFormat:@"%@%@%@%@%@",@"手机尾号",model.companyNumber,@"的用户注册成为",model.companyName,@"商家"];
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithMin:[NSString stringWithFormat:@"%ld",model.createTime]];
}

#pragma mark - getters

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor hexStringToColor:@"666666"];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
        
    }
    return _contentLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor hexStringToColor:@"666666"];
        _timeLab.font = [UIFont systemFontOfSize:13];
    }
    return _timeLab;
}



@end
