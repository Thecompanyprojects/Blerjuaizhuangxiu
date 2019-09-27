//
//  changeuserinfoCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "changeuserinfoCell1.h"

@interface changeuserinfoCell1()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *xinxin;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UITextField *nameText;
@end

@implementation changeuserinfoCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.xinxin];
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.nameText];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.xinxin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(15);
        make.height.mas_offset(15);
    }];
    
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.xinxin.mas_right).with.offset(10);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(60);
    }];
    [weakSelf.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
    
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:15];
        _leftLab.text = @"昵称";
        _leftLab.textColor = [UIColor hexStringToColor:@"292929"];
    }
    return _leftLab;
}


-(UITextField *)nameText
{
    if(!_nameText)
    {
        _nameText = [[UITextField alloc] init];
        _nameText.delegate = self;
        _nameText.placeholder = @"请输入昵称";
    }
    return _nameText;
}


-(UIImageView *)xinxin
{
    if(!_xinxin)
    {
        _xinxin = [[UIImageView alloc] init];
        _xinxin.image = [UIImage imageNamed:@"xinxin0"];
    }
    return _xinxin;
}




@end
