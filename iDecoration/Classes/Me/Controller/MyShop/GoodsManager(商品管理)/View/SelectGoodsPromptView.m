//
//  SelectGoodsPromptView.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SelectGoodsPromptView.h"
#import "UIButton+FillColor.h"

@interface SelectGoodsPromptView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *tmpBtn;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation SelectGoodsPromptView

#pragma mark - lisfeMethod
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [_buyView borderForColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2] borderWidth:1.0 borderType:UIBorderSideTypeTop|UIBorderSideTypeBottom];
}

- (void)setupUI {
    [self bgView];
    [self finishBtn];
    [self closeBtn];
    [self imageView];
    [self priceLabel];
    [self numLabel];
    [self numBottomLabel];
    [self selectLabel];
    [self scrollView];
    [self buyView];
}

#pragma  mark -normalMEthod
- (void)finishAction {
    if (self.finishBlock) {
        self.finishBlock(self);
    }
}

- (void)subAction {
    
    if ([self.delegate respondsToSelector:@selector(selectGoodsPromptView:addBtnActionAtIndex:)]) {
        [self.delegate selectGoodsPromptView:self subBtnActionAtIndex:self.selectedIndex];
    }
}

- (void)addAction {
    if ([self.delegate respondsToSelector:@selector(selectGoodsPromptView:addBtnActionAtIndex:)]) {
        [self.delegate selectGoodsPromptView:self addBtnActionAtIndex:self.selectedIndex];
    }
}

- (void)buttonArrayAction:(UIButton *)sender {
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    
    self.selectedIndex = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedTitleAt:)]) {
        [self.delegate didSelectedTitleAt:sender.tag];
    }
}



- (void)setButtonTitleArray:(NSArray *)buttonTitleArray {
    _buttonTitleArray = buttonTitleArray;
    
    [self.scrollView removeAllSubViews];
    UIButton *lastBtn;
    for (int i = 0; i < buttonTitleArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2] forState:UIControlStateNormal];
        [btn setBackgroundColor:kMainThemeColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonArrayAction:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat margin = 8;
        CGFloat width = [buttonTitleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) withFont:[UIFont systemFontOfSize:14]].width + 16;

        CGFloat y;
        if (i == 0) {
            btn.frame = CGRectMake(0, 0, width, 30);
            btn.selected = YES;
            _tmpBtn = btn;
        } else {
            y = lastBtn.frame.origin.y;
            if ((kSCREEN_WIDTH - 32 - CGRectGetMaxX(lastBtn.frame) - margin * 2) > width) {
                btn.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame) + 2*margin, y, width, 30);
            } else {
                y = 8 + CGRectGetMaxY(lastBtn.frame);
                btn.frame = CGRectMake(0, y, width, 30);
            }
        }
        [self.scrollView addSubview:btn];
        lastBtn = btn;
        
        btn.layer.cornerRadius = 8;
        btn.layer.masksToBounds = YES;
    }
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(lastBtn.frame));
    CGFloat height = self.scrollView.contentSize.height > 38 * 4 ? 38 * 4 + 15 : self.scrollView.contentSize.height;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(self.selectLabel.mas_bottom).equalTo(8);
        make.height.equalTo(height);
    }];
}
#pragma  mark - lazyMethod
- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(0.25 * kSCREEN_HEIGHT - 64);
        }];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_finishBtn];
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(50);
        }];
        _finishBtn.backgroundColor = kMainThemeColor;
        [_finishBtn setTitle:@"知道了" forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _finishBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(4);
            make.right.equalTo(-4);
            make.size.equalTo(CGSizeMake(44, 44));
        }];

        [_closeBtn setImage:[UIImage imageNamed:@"colse"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeBtn;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        [self.bgView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.top.equalTo(-16);
            make.size.equalTo(CGSizeMake(120, 120));
        }];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [UILabel new];
        [self.bgView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).equalTo(10);
            make.top.equalTo(16);
        }];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:22];
        _priceLabel.text = [NSString stringWithFormat:@"￥  "];
    }
    return _priceLabel;
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [UILabel new];
        [self.bgView addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).equalTo(10);
            make.top.equalTo(self.priceLabel.mas_bottom).equalTo(8);
        }];
        _numLabel.font = [UIFont systemFontOfSize:16];
        _numLabel.textColor = [UIColor darkGrayColor];
        _numLabel.text = [NSString stringWithFormat:@"库存 件"];
    }
    return _numLabel;
}

- (UILabel *)numBottomLabel {
    if (!_numBottomLabel) {
        _numBottomLabel = [UILabel new];
        [self.bgView addSubview:_numBottomLabel];
        [_numBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numLabel.mas_bottom).equalTo(8);
            make.left.equalTo(self.imageView.mas_right).equalTo(10);
        }];
        _numBottomLabel.font = [UIFont systemFontOfSize:16];
        _numBottomLabel.textColor = [UIColor darkGrayColor];
        _numBottomLabel.text = @"请选择";
    }
    return _numBottomLabel;
}

- (UILabel *)selectLabel {
    if (_selectLabel == nil) {
        _selectLabel = [UILabel new];
        [self.bgView addSubview:_selectLabel];
        [_selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(self.imageView.mas_bottom).equalTo(32);
        }];
    }
    _selectLabel.font = [UIFont systemFontOfSize:17];
    _selectLabel.textColor = [UIColor darkGrayColor];
    _selectLabel.text = @"选择";
    return _selectLabel;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        [self.bgView addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.top.equalTo(self.selectLabel.mas_bottom).equalTo(8);
            make.height.equalTo(30);
        }];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)buyView {
    if (_buyView == nil) {
        _buyView = [UIView new];
        [self.bgView addSubview:_buyView];
        [_buyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.top.equalTo(self.scrollView.mas_bottom).equalTo(8);
            make.height.equalTo(44);
//            make.bottom.greaterThanOrEqualTo(self.finishBtn.mas_top).greaterThanOrEqualTo(-32);
        }];
       
        
        [self buyNumNameLabel];
        [self addButton];
        [self buyNumLabel];
        [self subButton];
        
    }
    return _buyView;
}

- (UILabel *)buyNumNameLabel {
    if (_buyNumNameLabel == nil) {
        _buyNumNameLabel = [UILabel new];
        [self.buyView addSubview:_buyNumNameLabel];
        [_buyNumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.centerY.equalTo(0);
        }];
    }
    _buyNumNameLabel.font = [UIFont systemFontOfSize:17];
    _buyNumNameLabel.textColor = [UIColor darkGrayColor];
    _buyNumNameLabel.text = @"购买数量";
    return _buyNumNameLabel;
}

- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buyView addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(25, 25));
        }];
        _addButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        _addButton.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
        [_addButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UILabel *)buyNumLabel {
    if (_buyNumLabel== nil) {
        _buyNumLabel = [UILabel new];
        [self.buyView addSubview:_buyNumLabel];
        [_buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.addButton.mas_left).equalTo(0);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(80, 25));
        }];
        _buyNumLabel.textAlignment = NSTextAlignmentCenter;
        _buyNumLabel.textColor = [UIColor blackColor];
        _buyNumLabel.font = [UIFont systemFontOfSize:16];
        _buyNumLabel.text = @"0";
    }
    return _buyNumLabel;
}

- (UIButton *)subButton {
    if (_subButton == nil) {
        _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buyView addSubview:_subButton];
        [_subButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.buyNumLabel.mas_left).equalTo(0);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(25, 25));
        }];
        _subButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        [_subButton setTitle:@"-" forState:UIControlStateNormal];
        _subButton.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
        [_subButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _subButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [_subButton addTarget:self action:@selector(subAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

@end 
