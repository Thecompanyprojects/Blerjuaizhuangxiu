//
//  ApplydistributionCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ApplydistributionCell.h"

@interface ApplydistributionCell()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *img;


@end

@implementation ApplydistributionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.applyText];
        [self.contentView addSubview:self.contentLab];
        [self setuplauout];
        [self setchange];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(12);
        make.height.mas_offset(12);
    }];
    
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.img.mas_right).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(80*WIDTH_SCALE);
        make.height.mas_offset(20);
    }];
    
    [weakSelf.applyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(20);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(20);;
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(4);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _leftLab;
}

-(NaText *)applyText
{
    if(!_applyText)
    {
        _applyText = [[NaText alloc] init];
        _applyText.delegate = self;
        _applyText.textAlignment = NSTextAlignmentRight;
    }
    return _applyText;
}


-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"xinxin0"];
    }
    return _img;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.text = @"(请上传你的身份证证件正反面照片)";
        [_contentLab setHidden:YES];
        _contentLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab;
}

-(void)setdata:(NSInteger )index
{
    switch (index) {
        case 0:
            self.leftLab.text = @"真实姓名";
            
            break;
        case 1:
            self.leftLab.text = @"身份证号码";
            
            break;
        case 2:
            self.leftLab.text = @"微信号";
            self.applyText.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        default:
            break;
    }
}

-(void)setchange
{
    __weak typeof (self) weakSelf = self;
    self.applyText.valueChanged=^(NSString *str){
        [weakSelf.delegate myTabVClick:weakSelf andtextstr:str];
    };
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.applyText.valueChanged(self.applyText.text);
}

@end
