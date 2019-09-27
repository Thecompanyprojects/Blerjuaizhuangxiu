//
//  GoodsEditSectionView.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsEditSectionView.h"

@interface GoodsEditSectionView ()



//@property (nonatomic, strong) UIButton *addButton;
//
//@property (nonatomic, strong) UIButton *addTextBtn;
//@property (nonatomic, strong) UIButton *addImageBtn;
//@property (nonatomic, strong) UIButton *addVideoBtn;

@end

@implementation GoodsEditSectionView
// 图片有 namen 130X72   120X72   130X72

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, 380/2.0, 72/2.0 + 16);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"GoodsEditSectionView 初始化请使用 initWithFrame");
    return self;
}

- (void)setupUI {
    [self backView];
    
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.top.equalTo(8);
            make.bottom.equalTo(-8);
            make.size.equalTo(CGSizeMake(380/2.0, 72/2.0));
//            make.size.equalTo(CGSizeMake(27, 15));
        }];
        [self addButton];
        [self addTextBtn];
        [self addImageBtn];
        [self addVideoBtn];
        
    }
    return _backView;
}

- (void)addAction {
    if ([self.delegate respondsToSelector:@selector(editSectionView:addActionWithIndexPath:)]) {
        self.addButton.hidden = YES;
        self.addVideoBtn.hidden = NO;
        self.addImageBtn.hidden = NO;
        self.addTextBtn.hidden = NO;

        [self.delegate editSectionView:self addActionWithIndexPath:self.section];
    }
}

- (void)addTextAction {
    if ([self.delegate respondsToSelector:@selector(editSectionView:addTextActionWithIndexPath:)]) {
        self.addButton.hidden = NO;
        self.addVideoBtn.hidden = YES;
        self.addImageBtn.hidden = YES;
        self.addTextBtn.hidden = YES;
        [self.delegate editSectionView:self addTextActionWithIndexPath:self.section];
    }
}

- (void)addImageAction {
    if ([self.delegate respondsToSelector:@selector(editSectionView:addImageActionWithIndexPath:)]) {
        self.addButton.hidden = NO;
        self.addVideoBtn.hidden = YES;
        self.addImageBtn.hidden = YES;
        self.addTextBtn.hidden = YES;
        [self.delegate editSectionView:self addImageActionWithIndexPath:self.section];
    }
}

- (void)addVideoAction {
    if ([self.delegate respondsToSelector:@selector(editSectionView:addVideoActionWithIndexPath:)]) {
        self.addButton.hidden = NO;
        self.addVideoBtn.hidden = YES;
        self.addImageBtn.hidden = YES;
        self.addTextBtn.hidden = YES;
        [self.delegate editSectionView:self addVideoActionWithIndexPath:self.section];
    }
}




- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backView addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake(27, 15));
        }];
        [_addButton setImage:[UIImage imageNamed:@"edit_insert_normal"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        _addButton.hidden = NO;
    }
    return _addButton;
}
- (UIButton *)addTextBtn {
    if (!_addTextBtn) {
        _addTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backView addSubview:_addTextBtn];
        _addTextBtn.frame = CGRectMake(0, 0, 130/2.0, 72/2.0);
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_normal"] forState:UIControlStateNormal];
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_pressed"] forState:UIControlStateHighlighted];
        [_addTextBtn addTarget:self action:@selector(addTextAction) forControlEvents:UIControlEventTouchUpInside];
        _addTextBtn.hidden = YES;
    }
    return _addTextBtn;
}

- (UIButton *)addImageBtn {
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backView addSubview:_addImageBtn];
        _addImageBtn.frame = CGRectMake(130/2.0, 0, 120/2.0, 72/2.0);
        [_addImageBtn setImage:[UIImage imageNamed:@"edit_add_image_normal"] forState:UIControlStateNormal];
        [_addImageBtn setImage:[UIImage imageNamed:@"edit_add_image_pressed"] forState:UIControlStateHighlighted];
        [_addImageBtn addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
        _addImageBtn.hidden = YES;
    }
    return _addImageBtn;
}

- (UIButton *)addVideoBtn {
    if (!_addVideoBtn) {
        _addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backView addSubview:_addVideoBtn];
        _addVideoBtn.frame = CGRectMake(250/2.0, 0, 130/2.0, 72/2.0);
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_video_normal"] forState:UIControlStateNormal];
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_video_pressed"] forState:UIControlStateHighlighted];
        [_addVideoBtn addTarget:self action:@selector(addVideoAction) forControlEvents:UIControlEventTouchUpInside];
        _addVideoBtn.hidden = YES;
    }
    return _addVideoBtn;
}



@end
