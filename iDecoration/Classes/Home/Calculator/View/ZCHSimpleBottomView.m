//
//  ZCHSimpleBottomView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSimpleBottomView.h"
#import "ZCHSimpleSettingSupplementModel.h"

@interface ZCHSimpleBottomView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *topTitleView;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (strong, nonatomic) UIPickerView *pickerView;

@property (assign, nonatomic) BOOL isFirst;
@end

@implementation ZCHSimpleBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadowView:)];
        [self addGestureRecognizer:tap];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        self.topTitleView = [[UILabel alloc] init];
        self.topTitleView.text = @"添加模板";
        self.topTitleView.textAlignment = NSTextAlignmentCenter;
        self.topTitleView.textColor = [UIColor whiteColor];
        self.topTitleView.backgroundColor = [UIColor blackColor];
        [self.bgView addSubview:self.topTitleView];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.bgView addSubview:self.pickerView];
        
        self.confirmBtn = [[UIButton alloc] init];
        self.confirmBtn.layer.cornerRadius = 5;
        self.confirmBtn.layer.masksToBounds = YES;
        [self.confirmBtn setTitle:@"确  定" forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(didClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.confirmBtn.backgroundColor = kMainThemeColor;
        [self.bgView addSubview:self.confirmBtn];
        self.isFirst = YES;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(0, BLEJHeight, BLEJWidth, 220);
    self.topTitleView.frame = CGRectMake(0, 0, BLEJWidth, 40);
    self.pickerView.frame = CGRectMake(0, 40, BLEJWidth, 132);
    self.confirmBtn.frame = CGRectMake(20, 172, BLEJWidth - 40, 40);
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.dataArr.count;
}

// 自定义pickerView上的视图, 并且赋值
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, BLEJWidth, 30)];
    ZCHSimpleSettingSupplementModel *model = self.dataArr[row];
    myView.text = model.supplementName;
    myView.textColor = [UIColor blackColor];
    //用label来设置字体大小
    myView.font = [UIFont systemFontOfSize:15];
    myView.backgroundColor = [UIColor clearColor];
    myView.textAlignment = NSTextAlignmentCenter;
    
    return myView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // 选中了某一个的回调
    NSLog(@"2222");
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 44.0;
}

- (void)didClickConfirmBtn:(UIButton *)btn {
    
    NSInteger index = [self.pickerView selectedRowInComponent:0];
//    BLEJCalculatorBaseAndSuppleListModel *model = self.dataArr[index];
    if ([self.delegate respondsToSelector:@selector(didClickPickerViewWithIndex:andSection:)]) {
        
        [self.delegate didClickPickerViewWithIndex:index andSection:self.section];
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    
    _dataArr = dataArr;
    [self.pickerView reloadComponent:0];
}

// 处理弹出动画的
- (void)setHidden:(BOOL)hidden {
    
    if (hidden) {
        
        if (self.isFirst) {
            
            self.isFirst = NO;
            [super setHidden:hidden];
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changTableViewFrame" object:nil];
            [UIView animateWithDuration:0.25 animations:^{
                self.bgView.blej_y = BLEJHeight;
                self.backgroundColor = [Black_Color colorWithAlphaComponent:0.0];
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        }
    } else {
        
        [super setHidden:hidden];
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundColor = [Black_Color colorWithAlphaComponent:0.2];
            self.bgView.blej_y = BLEJHeight - 220;
        }];
    }
}




- (void)removeShadowView:(UITapGestureRecognizer *)tap {
    
    self.hidden = YES;
}




@end
