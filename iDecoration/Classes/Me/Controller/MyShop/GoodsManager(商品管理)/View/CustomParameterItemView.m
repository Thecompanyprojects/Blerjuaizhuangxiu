//
//  CustomParameterItemView.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CustomParameterItemView.h"


@interface CustomParameterItemView()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *bgView;

@end

@implementation CustomParameterItemView

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
    if (_isfromPrice) {
        [self.priceArray enumerateObjectsUsingBlock:^(GoodsPriceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleNameArray addObject:obj.name];
        }];
    } else {
        [self.listArray enumerateObjectsUsingBlock:^(GoodsParamterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleNameArray addObject:obj.name];
        }];
    }
    
    [self.scrollView removeAllSubViews];
    self.scrollView.userInteractionEnabled = YES;
    for (int i = 0; i < titleNameArray.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i%3 *(width + margin), i/3 * (height + margin) + margin, width, height)];
        label.text = titleNameArray[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.layer.cornerRadius = 4;
//        label.layer.masksToBounds = YES;
        label.layer.borderColor = [UIColor darkGrayColor].CGColor;
        label.layer.borderWidth = 1.0;
        [self.scrollView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(CGRectGetMaxX(label.frame) - 18, CGRectGetMinY(label.frame) - 12, 30, 30);
        label.userInteractionEnabled = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.image = [UIImage imageNamed:@"delete_item"];
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [imageView addGestureRecognizer:imageTap];

    }

    CGFloat contentHeight = (titleNameArray.count/3 + 1) *(height + margin);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, contentHeight > self.scrollView.height ? contentHeight : self.scrollView.height);
    
    if (_isfromPrice) {
        
    }
}


- (void)setupUI {
    _isfromPrice = NO;
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
    if ([self.delegate respondsToSelector:@selector(parameterItemViewDeleteItemAction:atIndex:)]) {
        [self.delegate parameterItemViewDeleteItemAction:self atIndex:v.tag];
    }
}


- (void)setListArray:(NSMutableArray<GoodsParamterModel *> *)listArray {
    _listArray = listArray;
}

- (void)setPriceArray:(NSMutableArray<GoodsPriceModel *> *)priceArray {
    _priceArray = priceArray;
}

- (void)addItemAction {

    if ([self.delegate respondsToSelector:@selector(parameterItemViewAddItemAction:)]) {
        [self.delegate parameterItemViewAddItemAction:self];
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
