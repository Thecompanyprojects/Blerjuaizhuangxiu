//
//  NewCustomParameterItemView.m
//  iDecoration
//
//  Created by zuxi li on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewCustomParameterItemView.h"
@interface NewCustomParameterItemView()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *titleNameArray;
@end

@implementation NewCustomParameterItemView

#pragma mark - lisfeMethod
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat margin = 10;
    CGFloat width = (self.scrollView.width - margin *3)/3.0;
    CGFloat height = 30;
    
    NSMutableArray *titleNameArray = [NSMutableArray array];
    NSMutableArray *seletedNameArray = [NSMutableArray array];
    self.titleNameArray = titleNameArray;
    [titleNameArray addObjectsFromArray:[self.regularArray copy]];
    [self.listArray enumerateObjectsUsingBlock:^(GoodsParamterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.regularArray containsObject:obj.name]) {
            [titleNameArray addObject:obj.name];
        }
        [seletedNameArray addObject:obj.name];
    }];
    
    [self.scrollView removeAllSubViews];
    self.scrollView.userInteractionEnabled = YES;
    for (int i = 0; i < titleNameArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i%3 *(width + margin), i/3 * (height + margin) + margin, width, height);
        [btn setTitle:titleNameArray[i] forState:UIControlStateNormal];
        [btn setTitle:titleNameArray[i] forState:UIControlStateSelected];
        [btn setTitle:titleNameArray[i] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [btn setBackgroundColor:kMainThemeColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnItemSeletedAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([seletedNameArray containsObject:titleNameArray[i]]) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
        [self.scrollView addSubview:btn];
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(CGRectGetMaxX(btn.frame) - 18, CGRectGetMinY(btn.frame) - 12, 30, 30);
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.image = [UIImage imageNamed:@"delete_item"];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [imageView addGestureRecognizer:imageTap];
        
        if (i < self.regularArray.count) {
            if (self.isImplementOrGeneralManager) {
                imageView.hidden = NO;
            } else {
                imageView.hidden = YES;
            }
        }
        
    }
    
    CGFloat contentHeight = (titleNameArray.count/3 + 1) *(height + margin);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, contentHeight > self.scrollView.height ? contentHeight : self.scrollView.height);
    
}


- (void)setupUI {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGR];

    [self bgView];
    
}


- (void)tapAction:(UITapGestureRecognizer *)tapGR {
    if (self.finishBlock) {
        self.finishBlock(self);
    }
}

- (void)bgViewTapAction:(UITapGestureRecognizer *)tapGR {
    
}

- (void)imageTapAction:(UITapGestureRecognizer *)tapGR {
    UIImageView *v = (UIImageView *)tapGR.view;
    if ([self.delegate respondsToSelector:@selector(newParameterItemViewDeleteItemAction:withTitleName:)]) {
        [self.delegate newParameterItemViewDeleteItemAction:self withTitleName:self.titleNameArray[v.tag]];
    }
}

- (void)btnItemSeletedAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 选中
        if ([self.delegate respondsToSelector:@selector(newParameterItemViewAddItemAction:withTitleName:)]) {
            [self.delegate newParameterItemViewAddItemAction:self withTitleName:sender.titleLabel.text];
        }
    } else {
        // 取消选中
        if ([self.delegate respondsToSelector:@selector(newParameterItemViewDeleteItemAction:withTitleName:)]) {
            [self.delegate newParameterItemViewDeleteItemAction:self withTitleName:sender.titleLabel.text];
        }
    }
}

- (void)setListArray:(NSMutableArray<GoodsParamterModel *> *)listArray {
    _listArray = listArray;
}

// 添加
- (void)addItemAction {
    if ([self.delegate respondsToSelector:@selector(newParameterItemViewAddItemAction:withTitleName:)]) {
        [self.delegate newParameterItemViewAddItemAction:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string ew_JudgeTheillegalCharacter:string] && ![string isEqualToString:@""]) {
        [textField resignFirstResponder];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"不支持特殊字符"];
        return NO;
    }
    
    if (range.location + string.length > 8) {
        [textField resignFirstResponder];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"最多输入8个字符"];
    }
    return YES;
}

#pragma mark - LazyMethod
- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [UIView new];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.right.equalTo(-8);
            make.bottom.equalTo(-4);
            make.height.greaterThanOrEqualTo(200);
        }];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tapGRTWO = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapAction:)];
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:tapGRTWO];
        
        [self topLabel];
        [self scrollView];
        [self addBtn];
    }
    return _bgView;
}

- (UILabel *)topLabel {
    if (_topLabel == nil) {
        _topLabel = [UILabel new];
        [self.bgView addSubview:_topLabel];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(32);
            make.height.equalTo(20);
        }];
        _topLabel.text = @"填写项";
        _topLabel.font = [UIFont systemFontOfSize:16];
        _topLabel.textColor = [UIColor darkGrayColor];
    }
    return _topLabel;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        [self.bgView addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.top.equalTo(self.topLabel.mas_bottom).equalTo(6);
            make.height.greaterThanOrEqualTo(130);
        }];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.scrollView.mas_bottom).equalTo(8);
            make.bottom.equalTo(-16);
            make.height.equalTo(40);
        }];
        [_addBtn setTitle:@"+自定义填写项" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
