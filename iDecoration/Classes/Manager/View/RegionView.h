//
//  RegionView.h
//  iDecoration
//
//  Created by RealSeven on 17/3/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic ,strong) UIView *headV;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *shadowV;//禁止选择省市，只能选区（遮挡省市）
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *bottomSureBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableArray *secondArray;
@property (nonatomic, strong) NSMutableArray *thirdArray;
@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, copy) void (^selectBlock)(NSMutableArray *selectArr);

// 表示是从装修区域传进来的(1: 从装修区域)
@property (copy, nonatomic) NSString *isType;

// 传入固定的省市id，自动滚动到相应位置
-(void)scrollPickerViewWith:(NSString*)pid cid:(NSString*)cid;
@end
