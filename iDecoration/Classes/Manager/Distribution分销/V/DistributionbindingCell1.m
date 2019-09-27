//
//  DistributionbindingCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionbindingCell1.h"

@interface DistributionbindingCell1()<UITextFieldDelegate>


@end

@implementation DistributionbindingCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.contentText];
        [self setuplauout];
        [self setchange];

    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14*WIDTH_SCALE);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(80);
    }];
    [weakSelf.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(20);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
}

#pragma mark - getters


-(Nalabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[Nalabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:13];
    }
    return _leftLab;
}

-(NaText *)contentText
{
    if(!_contentText)
    {
        _contentText = [[NaText alloc] init];
        _contentText.delegate = self;
    }
    return _contentText;
}

-(void)setchange
{
    __weak typeof (self) weakSelf = self;
    self.contentText.valueChanged=^(NSString *str){
        [weakSelf.delegate myTabVClick:weakSelf andtextstr:str];
    };
}

-(void)setdata:(NSString *)tagstr andindex:(NSInteger )index andinfodic:(NSDictionary *)infodic
{
    
   
    
    if ([tagstr isEqualToString:@"0"]) {
        
        if (index==0) {
            self.leftLab.text = @"支付宝账号";
            [self.leftLab setAlightLeftAndRightWithWidth:80];
            self.contentText.text = [infodic objectForKey:@"accountName"];
        }
        if (index==1) {
            self.leftLab.text = @"请再次输入支付宝账号";
            [self.leftLab setAlightLeftAndRightWithWidth:80];
            self.contentText.text = [infodic objectForKey:@"accountName"];
        }
        if (index==2) {
            self.leftLab.text = @"请输入支付宝账号对应的姓名";
             [self.leftLab setAlightLeftAndRightWithWidth:80];
            
            [self.leftLab setHidden:NO];
            [self.contentText setHidden:NO];
        }

    }
    if ([tagstr isEqualToString:@"1"]) {
        
        if (index==0) {
            self.leftLab.text = @"微信账号";
            [self.leftLab setAlightLeftAndRightWithWidth:80];
            self.contentText.text = [infodic objectForKey:@"accountName"];
        }
        if (index==1) {
            self.leftLab.text = @"请再次输入微信账号";
            [self.leftLab setAlightLeftAndRightWithWidth:80];
             self.contentText.text = [infodic objectForKey:@"accountName"];
        }
        if (index==2) {
//            self.leftLab.text = @"确认密码";
//            [self.leftLab setAlightLeftAndRightWithWidth:80];
            [self.leftLab setHidden:YES];
            [self.contentText setHidden:YES];
            self.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    if ([tagstr isEqualToString:@"2"]) {
        
        if (index==0) {
            self.leftLab.text = @"持卡人";
            [self.leftLab setAlightLeftAndRightWithWidth:80];
        }
        if (index==1) {
            self.leftLab.text = @"卡号";
            [self.leftLab setAlightLeftAndRightWithWidth:80];
        }
        if (index==2) {
            self.leftLab.text = @"卡类型";
            [self.leftLab setAlightLeftAndRightWithWidth:80];
            [self.leftLab setHidden:NO];
            [self.contentText setHidden:YES];
        }
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.contentText.valueChanged(self.contentText.text);
}

@end
