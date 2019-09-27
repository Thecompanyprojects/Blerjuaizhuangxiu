//
//  ZCHBottomLocationPickerView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/8/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHBottomLocationPickerView.h"

@interface ZCHBottomLocationPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPickerView *provincePickerView;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) NSArray *provinceDataArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSDictionary *selectedDic;

@end

@implementation ZCHBottomLocationPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0001];
        [self setUpUI];
        [self preparePickerViewData];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgView:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgView:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipe];
        UISwipeGestureRecognizer *swipeTwo = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgView:)];
        swipeTwo.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeTwo];
    }
    return self;
}

- (void)setUpUI {
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, 280)];
    mainView.backgroundColor = White_Color;
    self.mainView = mainView;
    [self addSubview:mainView];
    
    self.provincePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 80, BLEJWidth, 200)];
    self.provincePickerView.backgroundColor = [UIColor whiteColor];
    self.provincePickerView.delegate = self;
    self.provincePickerView.dataSource = self;
    
    [mainView addSubview:self.provincePickerView];
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
    topView.backgroundColor = Main_Color;
    [mainView addSubview:topView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelBtn.frame = CGRectMake(20, 0, 40, 44);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(BLEJWidth-40-20, 0, 40, 44);
    confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmCityAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:confirmBtn];
    
    UIButton *autoLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [autoLocationBtn setTitle:@"自动定位" forState:UIControlStateNormal];
    autoLocationBtn.frame = CGRectMake(20, 44, 80, 36);
    autoLocationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    autoLocationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [autoLocationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [autoLocationBtn addTarget:self action:@selector(didClickAutoLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:autoLocationBtn];
}

- (void)preparePickerViewData {
    
    //加载省份数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_blej_tree" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _provinceDataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _cityArray = [_provinceDataArray objectAtIndex:0][@"cities"];
    _townArray = [_cityArray objectAtIndex:0][@"counties"];
    
}

#pragma mark - pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return _provinceDataArray.count;
    } else if (component == 1) {
        
        return  _cityArray.count;
    } else
        
        return _townArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [_provinceDataArray objectAtIndex:row][@"name"];
    }else if (component == 1){
        return [_cityArray objectAtIndex:row][@"name"];
    }else return [_townArray objectAtIndex:row][@"name"];
    
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
////    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_label.text];
////    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(mainRange.location, mainRange.length)];
////    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(mainRange.location, mainRange.length)];
////    if (leftRange.length>0) {
////        NSDictionary *dict = @{
////                               NSForegroundColorAttributeName:kMainThemeColor,
////                               NSFontAttributeName:[UIFont systemFontOfSize:20]
////                               };
////        [attributedString addAttributes:dict range:leftRange];
////    }
////    _label.attributedText = attributedString;
//    
//    if (component == 0) {
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[_provinceDataArray objectAtIndex:row][@"name"]];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:Black_Color range:NSMakeRange(0, attributedString.length)];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
//        
//        
//        return attributedString;
//    } else if (component == 1) {
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[_cityArray objectAtIndex:row][@"name"]];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:Black_Color range:NSMakeRange(0, attributedString.length)];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
//        
//        
//        return attributedString;
////        return [_cityArray objectAtIndex:row][@"name"];
//    } else {
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[_townArray objectAtIndex:row][@"name"]];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:Black_Color range:NSMakeRange(0, attributedString.length)];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
//        
//        
//        return attributedString;
////        return [_townArray objectAtIndex:row][@"name"];
//    }
//    
//}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        
        pickerLabel = [[UILabel alloc] init];
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        _cityArray = [_provinceDataArray objectAtIndex:row][@"cities"];
        if (_cityArray.count) {
            _townArray = [_cityArray objectAtIndex:0][@"counties"];
        }
        if (_townArray.count) {
            
            _selectedDic = [_townArray objectAtIndex:0];
        }
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1){
        _townArray = [_cityArray objectAtIndex:row][@"counties"];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        if (_townArray.count) {
            
            _selectedDic = [_townArray objectAtIndex:0];
        }
    }
    
    if (component == 2) {
        if (_townArray.count) {
            
            _selectedDic = [_townArray objectAtIndex:row];
        }
    }
    [self.provincePickerView reloadComponent:2];
}

#pragma mark - 城市选择按钮点击事件
// 取消
- (void)cancelAction {
    
    self.hidden = YES;
}

// 确定
- (void)confirmCityAction {
    
    if (_selectedDic) {
        
    } else {
        
        [self pickerView:self.provincePickerView didSelectRow:0 inComponent:0];
        [self pickerView:self.provincePickerView didSelectRow:0 inComponent:1];
        [self pickerView:self.provincePickerView didSelectRow:0 inComponent:2];
    }
    
    if (self.confirmBlock) {
        
        self.confirmBlock(self.selectedDic);
    }
}

#pragma mark - 自动定位按钮的点击事件
- (void)didClickAutoLocationBtn:(UIButton *)btn {
    
    if (self.locationBlock) {
        
        self.locationBlock();
    }
}

- (void)locationAction {
    
}

- (void)setHidden:(BOOL)hidden {
    
    if (hidden) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.mainView.blej_y = BLEJHeight;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.mainView.blej_y = BLEJHeight - 280;
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
}

- (void)didClickBgView:(UIGestureRecognizer *)ges {
    
    self.hidden = YES;
}


@end
