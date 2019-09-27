//
//  LeftTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "LeftTableViewCell.h"

#define defaultColor rgba(253, 212, 49, 1)

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.name = [UILabel new];
        self.name.font = [UIFont systemFontOfSize:15];
        self.viewLine = [UIView new];
        [self.viewLine setBackgroundColor:[UIColor colorWithRed:0.98 green:0.50 blue:0.20 alpha:1.00]];
        self.viewLine.frame = CGRectMake(0, 0, 2, 70);
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.viewLine];
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(padding.top); //with is an optional semantic filler
            make.left.equalTo(self.mas_left).with.offset(padding.left);
            make.bottom.equalTo(self.mas_bottom).with.offset(-padding.bottom);
            make.right.equalTo(self.mas_right).with.offset(-padding.right);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
    self.viewLine.hidden = !selected;
    if (selected) {
        [self.name setTextColor:[UIColor blackColor]];
    }else{
        [self.name setTextColor:[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00]];
    }
}

@end
