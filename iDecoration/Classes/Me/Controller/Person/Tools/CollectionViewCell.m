//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionCategoryModel.h"
#import "CollectionViewCell.h"

@interface CollectionViewCell ()

//@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, self.frame.size.width, 30)];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.numberOfLines = 1;
        [self.contentView addSubview:self.name];
        self.name.layer.borderColor = [UIColor hexStringToColor:@"f2f2f2"].CGColor;
        self.name.layer.borderWidth = 1.0f;
        self.name.layer.cornerRadius = 4.0f;
        self.name.layer.masksToBounds = true;
        [self.name setTextColor:[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.name.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    }else
        self.name.backgroundColor = [UIColor clearColor];
}

//- (void)setModel:(SubCategoryModel *)model
//{
//    self.name.text = model.name;
//}

@end
