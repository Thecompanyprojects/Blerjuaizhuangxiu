//
//  newstousuCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newstousuCell2.h"

@interface newstousuCell2()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *topLab;

@end

@implementation newstousuCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:self.topLab];
        [self.contentView addSubview:self.contentText];
        [self.contentView addSubview:self.submitBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(12);
        make.height.mas_offset(16);
    }];
    [weakSelf.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf.topLab.mas_left);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(12);
        make.height.mas_offset(142);
    }];
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentText.mas_bottom).with.offset(42);
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(40);
        make.height.mas_offset(40);
    }];
    
}

#pragma mark - getters


-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textColor = [UIColor hexStringToColor:@"3f3f3f"];
        _topLab.font = [UIFont systemFontOfSize:14];
        _topLab.text = @"投诉描述";
    }
    return _topLab;
}


-(WJGtextView *)contentText
{
    if(!_contentText)
    {
        _contentText = [[WJGtextView alloc] init];
        _contentText.delegate = self;
        _contentText.customPlaceholder = @"请输入描述内容";
        _contentText.backgroundColor = [UIColor whiteColor];
    }
    return _contentText;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = Main_Color;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 3;
        [_submitBtn setTitle:@"提交" forState:normal];
    }
    return _submitBtn;
}



@end
