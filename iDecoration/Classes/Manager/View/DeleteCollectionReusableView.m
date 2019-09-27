//
//  DeleteCollectionReusableView.m
//  iDecoration
//
//  Created by RealSeven on 17/3/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DeleteCollectionReusableView.h"

@implementation DeleteCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = White_Color;
        [self addSubview:self.deleteBtn];
    }
    return self;
}

-(UIButton*)deleteBtn{
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setFrame:CGRectMake(kSCREEN_WIDTH/2-50, 0, 100, 40)];
        [_deleteBtn setTitle:@"全部删除" forState:UIControlStateNormal];
        [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_deleteBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = White_Color;
        _deleteBtn.layer.cornerRadius = 5;
        _deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _deleteBtn.layer.borderWidth = 0.8;

    }
    return _deleteBtn;
}

@end
