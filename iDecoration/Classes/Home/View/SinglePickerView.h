//
//  SinglePickerView.h
//  iDecoration
//
//  Created by zuxi li on 2017/7/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic ,strong) UIView *headV;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *bottomSureBtn;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void (^selectBlock)(NSInteger selectedIndex);


@end
