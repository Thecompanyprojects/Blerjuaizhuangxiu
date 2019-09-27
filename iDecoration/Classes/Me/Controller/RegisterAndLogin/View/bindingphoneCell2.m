//
//  bindingphoneCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "bindingphoneCell2.h"
 
@interface bindingphoneCell2()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIImageView *codeimg;
@end

@implementation bindingphoneCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.codeimg];
        [self.contentView addSubview:self.codeText];
        [self.contentView addSubview:self.line];
        [self refreshimg];
        [self setuplauout];
    }
    return self;
}


-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(10);
        make.left.equalTo(weakSelf).with.offset(15);
        make.width.mas_offset(60);
    }];
    [weakSelf.codeimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf.leftLab);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(80);
        
    }];
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset(1);
        make.right.equalTo(weakSelf.codeimg.mas_left).with.offset(-14);
    }];
    [weakSelf.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf.leftLab);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(10);
        make.right.equalTo(weakSelf.line.mas_left).with.offset(10);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.textColor = [UIColor hexStringToColor:@"000000"];
        _leftLab.text = @"验证码";
    }
    return _leftLab;
}


-(UIImageView *)codeimg
{
    if(!_codeimg)
    {
        _codeimg = [[UIImageView alloc] init];
        _codeimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [_codeimg addGestureRecognizer:singleTap];
    }
    return _codeimg;
}


-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"BFBFBF"];
    }
    return _line;
}

-(UITextField *)codeText
{
    if(!_codeText)
    {
        _codeText = [[UITextField alloc] init];
        _codeText.delegate = self;
        _codeText.placeholder = @"请输入您的验证码";
        [_codeText addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _codeText;
}


-(void)refreshimg
{
    NSString *url = [BASEURL stringByAppendingString:tupianyanzhengma];
    NSString *str = [self getuuid];
    NSString *imgurl = [NSString stringWithFormat:@"%@%@%@",url,@"?v=",str];
    [_codeimg sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:SDWebImageRefreshCached];
}

//获取uuid

-(NSString *)getuuid
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSUUID *UUID = [device identifierForVendor];
    NSString *deviceID = @"";
    deviceID = [UUID UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@",deviceID);
    return deviceID;
}

- (void)textFieldDidChanged:(UITextField *)sender {
    if (self.block) {
        self.block(sender.text);
    }
}

//点击刷新

-(void)handleSingleTap
{
    [self refreshimg];
}

@end
