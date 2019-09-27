//
//  HCGDatePickerAppearance.m
//  HcgDatePicker-master
//
//  Created by 黄成钢 on 14/12/2016.
//  Copyright © 2016 chedaoshanqian. All rights reserved.
//

#import "HCGDatePickerAppearance.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define DATE_PICKER_HEIGHT 216.0f
#define TOOLVIEW_HEIGHT 40.0f
#define BACK_HEIGHT TOOLVIEW_HEIGHT + DATE_PICKER_HEIGHT

typedef void(^dateBlock)(NSDate *);

@interface HCGDatePickerAppearance ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) DatePickerMode dataPickerMode;

@property (nonatomic, copy) dateBlock dateBlock;

@end

@implementation HCGDatePickerAppearance

- (instancetype)initWithDatePickerMode:(DatePickerMode)dataPickerMode completeBlock:(void (^)(NSDate *date))completeBlock {
    self = [super init];
    if (self) {
        _dataPickerMode = dataPickerMode;
        [self setupUI];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _dateBlock = completeBlock;
    }
    return self;
}

- (void)setupUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, BACK_HEIGHT)];
    _backView.backgroundColor = [UIColor whiteColor];
    NSDate *minDate = [[NSDate alloc] initWithTimeIntervalSince1970:-473414400];
    
    _datePicker = [[HCGDatePicker alloc]initWithDatePickerMode:_dataPickerMode MinDate:minDate MaxDate:nil];
    _datePicker.frame = CGRectMake(0, TOOLVIEW_HEIGHT, kScreenWidth, DATE_PICKER_HEIGHT);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 45)];
    [self.backView addSubview:view];
    view.backgroundColor = kMainThemeColor;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 80, 8, 80, 40)];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    btn.centerY = view.centerY;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 8, 80, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    cancelBtn.centerY = view.centerY;
    
    [self.backView addSubview:_datePicker];
    [self addSubview:self.backView];
}

- (void)cancelAction {
    [self hide];
}
- (void)done {
    if (_dateBlock) {
        _dateBlock(_datePicker.date);
    }
    
    [self hide];

}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.25 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight - (BACK_HEIGHT), kScreenWidth, BACK_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}

-(void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, BACK_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
