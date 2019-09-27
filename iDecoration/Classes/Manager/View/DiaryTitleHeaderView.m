//
//  DiaryTitleHeaderView.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DiaryTitleHeaderView.h"

@implementation DiaryTitleHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = White_Color;
        [self.contentView addSubview:self.logo];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.rowImgV];
        [self.contentView addSubview:self.addBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

-(UIImageView*)logo{
    
    if (!_logo) {
        _logo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        _logo.layer.cornerRadius = 25;
        _logo.userInteractionEnabled = NO;
        _logo.contentMode = UIViewContentModeScaleToFill;
        _logo.backgroundColor = White_Color;
    }
    return _logo;
}

-(UILabel*)title{
    
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 60, 40)];
        _title.font = [UIFont systemFontOfSize:14.0];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.backgroundColor = White_Color;
    }
    return _title;
}

-(UIImageView *)rowImgV{
    if (!_rowImgV) {
        _rowImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.title.right, 25, 10, 10)];
        _rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
    }
    return _rowImgV;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(kSCREEN_WIDTH-80, 15, 80, 30);
        [_addBtn setTitle:@"我来添加" forState:UIControlStateNormal];
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_addBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        _addBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//        _addBtn.layer.masksToBounds = YES;
//        _addBtn.layer.cornerRadius = 5;
                    _addBtn.backgroundColor = White_Color;
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

-(void)addBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(addPointWith:)]) {
        [self.delegate addPointWith:sender.tag];
    }
}

-(void)tapped:(UITapGestureRecognizer*)sender{
    
    if (self.tapBlock) {
        self.tapBlock();
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
