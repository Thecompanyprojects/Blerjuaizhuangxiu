//
//  CompanyDetailTableViewCell.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyDetailTableViewCell.h"

#define kDetailTag 9999
@implementation CompanyDetailTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self configureUI];
    }
    return self;
}


- (void)configureUI {
    
    CGFloat imageHeight = 0;
    
//    _topImage = [[UIImageView alloc] init];
//    _topImage.frame = CGRectMake(0, 0, self.size.width, imageHeight);
//    _topImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTopImage:)];
//    [_topImage addGestureRecognizer:tap];
//    [self.contentView addSubview:_topImage];
    
    
    CGFloat space = 0;
    CGFloat viewWidth = (kSCREEN_WIDTH - 3*space) / 4;
    CGFloat viewHeight = viewWidth;
    CGFloat sep = (viewHeight - 43 - 12) / 3;
    
    NSArray *imageArr = @[@"brief",@"constructionCase",@"xuanzeyangbanjian",@"news",@"yuangong",@"productshow",@"quanjing",@"case"];
    NSArray *titleArr = @[@"公司简介",@"案例展示",@"小区管家",@"新闻资讯",@"优秀员工",@"商品展示",@"全景展示",@"合作企业"];
    // news
    for (NSInteger i = 0; i<titleArr.count; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(((space+viewWidth) * (i % 4)) , (space+viewHeight) * (i / 4) + imageHeight, viewWidth, viewHeight)];
        backView.backgroundColor = White_Color;
        backView.tag = i + kDetailTag;
        [self.contentView addSubview:backView];
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:imageArr[i]];
        [backView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backView);
            make.size.mas_equalTo(CGSizeMake(43, 43));
            make.top.mas_equalTo(backView).offset(sep);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor darkGrayColor];
        [backView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(backView);
            make.top.mas_equalTo(image.mas_bottom).offset(sep);
            make.height.mas_equalTo(12);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [backView addGestureRecognizer:tap];
        
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    NSInteger selectedTag = tap.view.tag - kDetailTag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDetailActionWithTag:)]) {
        
        [self.delegate didSelectDetailActionWithTag:selectedTag];
    }
}


- (void)didClickTopImage:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(didClickTopImage)]) {
        [self.delegate didClickTopImage];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
