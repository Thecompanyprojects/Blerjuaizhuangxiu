//
//  DesignTitleHeaderView.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DesignTitleHeaderView.h"

@implementation DesignTitleHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = White_Color;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

-(UILabel*)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 29)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor = White_Color;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIView*)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, kSCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
