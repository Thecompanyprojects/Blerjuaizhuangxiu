//
//  EditShopInfoTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditShopInfoTableViewCell.h"

@implementation EditShopInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _isSelected = NO;
    
//    self.quiryLabel = [[UILabel alloc]init];
//    self.quiryLabel.text = @"114可查";
//    self.quiryLabel.font = [UIFont systemFontOfSize:14];
//    self.quiryLabel.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:self.quiryLabel];
//
//    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.selectBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//    [self.selectBtn setBackgroundColor:Clear_Color];
//    [self.selectBtn addTarget:self action:@selector(selectOn:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.contentView addSubview:self.selectBtn];
//
//
//    [self.quiryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.selectBtn.mas_left).offset(-3);
//        make.top.equalTo(self.contentView.mas_top).offset(12);
//        make.height.equalTo(@20);
//        make.width.equalTo(@60);
//    }];
//
//    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right).offset(-10);
//        make.top.equalTo(self.contentView.mas_top).offset(15);
//        make.width.equalTo(@14);
//        make.height.equalTo(@14);
//    }];
}

//-(void)selectOn:(UIButton*)sender{
//    
//    if (_isSelected == NO) {
//        _isSelected = YES;
//        self.seeFlag = 1;
//        [self.selectBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//    }else{
//        _isSelected = NO;
//        self.seeFlag = 0;
//        [self.selectBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//    }
//    
//    if (self.selectBlock) {
//        self.selectBlock(self.seeFlag);
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
