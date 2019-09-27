//
//  localcaseHeaderView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localcaseHeaderView.h"
#import <UIButton+LXMImagePosition.h>

@implementation localcaseHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.search];
        [self addSubview:self.submitBtn];
        [self addSubview:self.chooseBtn0];
        [self addSubview:self.chooseBtn1];
        [self addSubview:self.chooseBtn2];
        [self addSubview:self.chooseBtn3];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(0);
        make.right.equalTo(weakSelf).with.offset(-43);
        make.top.equalTo(weakSelf).with.offset(14);
        make.height.mas_offset(28);
    }];
    
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.search);
        make.bottom.equalTo(weakSelf.search);
        make.right.equalTo(weakSelf).with.offset(-5);
        make.left.equalTo(weakSelf.search.mas_right).with.offset(5);
    }];
    [weakSelf.chooseBtn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.search.mas_bottom).with.offset(14);
        make.left.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset((kSCREEN_WIDTH-20)/4);
        make.height.mas_offset(16);
    }];
    [weakSelf.chooseBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseBtn0);
        make.left.equalTo(weakSelf.chooseBtn0.mas_right);
        make.width.mas_offset((kSCREEN_WIDTH-20)/4);
        make.height.mas_offset(16);
    }];
    [weakSelf.chooseBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseBtn0);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.width.mas_offset((kSCREEN_WIDTH-20)/4);
        make.height.mas_offset(16);
    }];
    [weakSelf.chooseBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseBtn0);
        make.right.equalTo(weakSelf.chooseBtn3.mas_left);
        make.width.mas_offset((kSCREEN_WIDTH-20)/4);
        make.height.mas_offset(16);
    }];
}

#pragma mark - getters

-(UISearchBar *)search
{
    if(!_search)
    {
        _search = [[UISearchBar alloc] init];
        _search.placeholder = @"搜索";
        _search.backgroundImage = [UIImage new];
        _search.backgroundColor = [UIColor clearColor];
        UIImage* searchBarBg = [self GetImageWithColor:kBackgroundColor andHeight:32.0f];
        [_search setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
        UITextField *searchField = [_search valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        
    }
    return _search;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"确定" forState:normal];
        [_submitBtn setTitleColor:[UIColor hexStringToColor:@"25B764"] forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _submitBtn;
}

-(UIButton *)chooseBtn0
{
    if(!_chooseBtn0)
    {
        _chooseBtn0 = [[UIButton alloc] init];
        [_chooseBtn0 setTitle:@"浏览量" forState:normal];
        [_chooseBtn0 setTitleColor:[UIColor hexStringToColor:@"25B764"] forState:normal];
        _chooseBtn0.titleLabel.font = [UIFont systemFontOfSize:15];
        [_chooseBtn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn0;
}

-(UIButton *)chooseBtn1
{
    if(!_chooseBtn1)
    {
        _chooseBtn1 = [[UIButton alloc] init];
        [_chooseBtn1 setTitle:@"好评" forState:normal];
        [_chooseBtn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _chooseBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [_chooseBtn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn1;
}

-(UIButton *)chooseBtn2
{
    if(!_chooseBtn2)
    {
        _chooseBtn2 = [[UIButton alloc] init];
        [_chooseBtn2 setTitle:@"信用" forState:normal];
        _chooseBtn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [_chooseBtn2 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        [_chooseBtn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn2;
}

-(UIButton *)chooseBtn3
{
    if(!_chooseBtn3)
    {
        _chooseBtn3 = [[UIButton alloc] init];
        [_chooseBtn3 setTitle:@"综合排序" forState:normal];
        _chooseBtn3.titleLabel.font = [UIFont systemFontOfSize:15];
        [_chooseBtn3 setImage:[UIImage imageNamed:@"icon_xia"] forState:normal];
        [_chooseBtn3 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        [_chooseBtn3 setImagePosition:LXMImagePositionRight spacing:4];
    }
    return _chooseBtn3;
}

-(void)btn0click
{
    [_chooseBtn0 setTitleColor:[UIColor hexStringToColor:@"25B764"] forState:normal];
    [_chooseBtn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [_chooseBtn2 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
}

-(void)btn1click
{
    [_chooseBtn0 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [_chooseBtn1 setTitleColor:[UIColor hexStringToColor:@"25B764"] forState:normal];
    [_chooseBtn2 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
}

-(void)btn2click
{
    [_chooseBtn0 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [_chooseBtn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [_chooseBtn2 setTitleColor:[UIColor hexStringToColor:@"25B764"] forState:normal];
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
