//
//  BLEJCalculatorBottomShadowView.m
//  Calculator
//
//  Created by 赵春浩 on 17/5/4.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJCalculatorBottomShadowView.h"
#import "BLEJTCalculatorBottomView.h"
#import "ZCHCalculatorBaseTemplateBottomView.h"
//#import "BLEJCalculatorBaseAndSuppleListModel.h"
//#import "BLEJCalculatorBudgetPriceCellModel.h"
#import "BLEJCalculatorBottomOneView.h"
#import "BLEJCalculatorBottomTwoView.h"
#import "BLEJFloorBrickView.h"

@interface BLEJCalculatorBottomShadowView ()<UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *BaseBottomView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *topTitleView;
@property (strong, nonatomic) UIView *bottomOneView;
@property (strong, nonatomic) UIView *bottomTwoView;
@property (strong, nonatomic) UIView *FloorBrickAndWoodView;
@property (strong, nonatomic) UIButton *confirmBtn;

@property (strong, nonatomic) BLEJTCalculatorBottomView *bottomViewCell;//添加新报价
@property (strong, nonatomic) ZCHCalculatorBaseTemplateBottomView *baseBottomViewCell;

@property (strong, nonatomic) BLEJCalculatorBottomOneView *oneView;

@property (strong, nonatomic) BLEJCalculatorBottomTwoView *twoView;//单位+面积+名称


@end


@implementation BLEJCalculatorBottomShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadowView:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationMes:) name:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationMes:) name:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationMes:) name:@"didClickCalculatorBaseBottomViewConfirmBtnReplace" object:nil];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        self.topTitleView = [[UILabel alloc] init];
        self.topTitleView.text = @"补充报价选项";
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
        
        
        self.bottomViewCell = [BLEJTCalculatorBottomView blej_viewFromXib];
        self.bottomViewCell.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, 300)];
        [self.bottomView addSubview:self.bottomViewCell];
        [self addSubview:self.bottomView];
        
        self.oneView = [BLEJCalculatorBottomOneView blej_viewFromXib];
        self.oneView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.bottomOneView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, 280)];
        [self.bottomOneView addSubview:self.oneView];
        [self addSubview:self.bottomOneView];
        
        self.twoView = [BLEJCalculatorBottomTwoView blej_viewFromXib];
        self.twoView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.bottomTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, 260)];
        [self.bottomTwoView addSubview:self.twoView];
        [self addSubview:self.bottomTwoView];
    
        self.baseBottomViewCell = [ZCHCalculatorBaseTemplateBottomView blej_viewFromXib];
        self.baseBottomViewCell.frame=CGRectMake(0, BLEJHeight, BLEJWidth, 230);
//         self.baseBottomViewCellCell.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//         self.baseBottomViewCell = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, 230)];
     //   [ self.baseBottomViewCell addSubview: self.baseBottomViewCellCell];
        [self addSubview: self.baseBottomViewCell];
        
        
     
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
    
    UILabel *myView = nil;
//    BLEJCalculatorBaseAndSuppleListModel *model = self.dataArr[row];
    BLRJCalculatortempletModelAllCalculatorTypes *model = self.dataArr[row];
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, BLEJWidth, 30)];
    myView.text = model.supplementName;

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
    BLRJCalculatortempletModelAllCalculatorTypes *model = self.dataArr[index];
    self.bgView.hidden = YES;
    self.bgView.blej_y = BLEJHeight;
    self.bottomView.hidden = NO;
    self.edittingType = @"1";
    self.bottomViewCell.isNeedNumKeyboard = YES;
    self.viewType = 4;
    self.bottomViewCell.itemModel = model;
    self.bottomViewCell.techTextView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomView.blej_y = BLEJHeight - 300;
        
    }];

}



- (void)removeShadowView:(UITapGestureRecognizer *)tap {
    

    self.hidden = YES;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

// 1 弹出pickView  2  弹出自定义视图(带面积)  3 不带面积  4 新项目报价  5 新项目编辑
- (void)setViewType:(int)viewType {
    
    if (_viewType != viewType) {
        _viewType = viewType;
    }
    if (viewType == 1) {
        
         self.baseBottomViewCell.hidden = YES;
        self.bottomView.hidden = YES;
        self.bottomOneView.hidden = YES;
        self.bgView.hidden = NO;
        self.bottomTwoView.hidden = YES;
    }
    if (viewType == 2) {
        
        self.bottomOneView.hidden = NO;
         self.baseBottomViewCell.hidden = YES;
        self.bgView.hidden = YES;
        self.bottomView.hidden = YES;
        self.bottomTwoView.hidden = YES;
    }
    if (viewType == 3) {
        
        self.bottomOneView.hidden = YES;
         self.baseBottomViewCell.hidden = NO;
        self.bgView.hidden = YES;
        self.bottomView.hidden = YES;
        self.bottomTwoView.hidden = YES;
    }
    
    if (viewType == 4) {
        
         self.baseBottomViewCell.hidden = YES;
        self.bottomView.hidden = NO;
        self.bottomViewCell.itemModel = nil;
        self.bottomOneView.hidden = YES;
        self.bgView.hidden = YES;
        self.bottomTwoView.hidden = YES;
    }
    
    if (viewType == 5) {
        
         self.baseBottomViewCell.hidden = YES;
        self.bottomView.hidden = YES;
        self.bottomOneView.hidden = YES;
        self.bgView.hidden = YES;
        self.bottomTwoView.hidden = NO;
    }
    if (viewType ==6) {
         self.baseBottomViewCell.hidden = YES;
        self.bottomView.hidden = YES;
        self.bottomOneView.hidden = YES;
        self.bgView.hidden = YES;
        self.bottomTwoView.hidden = YES;
        
    }
}



-(void)setAllcalModel:(BLRJCalculatortempletModelAllCalculatorTypes *)allcalModel{
    
    _allcalModel=allcalModel;
    if (allcalModel ==nil) {
        self.bottomViewCell.nameTF.text = @"";
        self.bottomViewCell.areaTF.text = @"";
        self.bottomViewCell.unitPriceTF.text = @"";
        self.bottomViewCell.techTextView.text = @"";
        
        self.oneView.nameTF.text = @"";
        self.oneView.areaTF.text = @"";
        self.oneView.unitPriceTF.text = @"";
        self.oneView.techTextView.text = @"";
        
        self.twoView.nameTF.text = @"";
        self.twoView.areaTF.text = @"";
        self.twoView.unitPriceTF.text = @"";
        self.twoView.techTextView.text = @"";
        return;
    }
    self.oneView.nameTF.text =  [NSString stringWithFormat:@"%@",allcalModel.supplementName];
   
   self.oneView.areaTF.text  =  [NSString stringWithFormat:@"%.2f", [[NSNumber numberWithInteger:allcalModel.number ] doubleValue]];
    
    self.oneView.unitPriceTF.text =   [NSString stringWithFormat:@"%.2ld", (long)[allcalModel.supplementPrice  integerValue]];
    self.oneView.techTextView.text = [NSString stringWithFormat:@"%@",allcalModel.supplementTech];

    self.twoView.nameTF.text =  [NSString stringWithFormat:@"%@",allcalModel.supplementName];
    self.twoView.areaTF.text =  [NSString stringWithFormat:@"%.2f", [[NSNumber numberWithInteger:allcalModel.number ] doubleValue]];
    self.twoView.unitPriceTF.text =  [NSString stringWithFormat:@"%.2ld", (long)[allcalModel.supplementPrice  integerValue]];
    self.twoView.techTextView.text = [NSString stringWithFormat:@"%@",allcalModel.supplementTech];

    
    self.baseBottomViewCell.nameTF.text =  [NSString stringWithFormat:@"%@",allcalModel.supplementName];
    self.baseBottomViewCell.unitPriceTF.text = [NSString stringWithFormat:@"%.2ld", (long)[allcalModel.supplementPrice  integerValue]];
    self.baseBottomViewCell.techTextView.text = [NSString stringWithFormat:@"%@",allcalModel.supplementTech];
    
    
    if (self.oneView.techTextView.text.length > 0) {
        
        self.oneView.phLabel.hidden = YES;
    } else {
        
        self.oneView.phLabel.hidden = NO;
    }
    
    if (self.twoView.techTextView.text.length > 0) {
        
        self.twoView.phLabel.hidden = YES;
    } else {
        
        self.twoView.phLabel.hidden = NO;
    }
   
    self.twoView.calcaulatorTypeModel = allcalModel;
    self.baseBottomViewCell.model = allcalModel;
    self.oneView.modelItem = allcalModel;

   
}


// 处理弹出动画的
- (void)setHidden:(BOOL)hidden {
    
    if (hidden) {
        if (self.viewType == 1) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bgView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        } else if (self.viewType == 2) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomOneView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        } else if (self.viewType == 3) {
            
            [UIView animateWithDuration:0.25 animations:^{
                 self.baseBottomViewCell.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        } else if (self.viewType == 4) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        } else if (self.viewType == 5) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomTwoView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
            }];
        }else {
            [super setHidden:hidden];
        }
        
    } else {
        
        [super setHidden:hidden];
        if (self.viewType == 1) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bgView.blej_y = BLEJHeight - 220;
            }];
        } else if (self.viewType == 2) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomOneView.blej_y = BLEJHeight - 280;
                self.oneView.techTextView.userInteractionEnabled = YES;
            }];
        } else if (self.viewType == 3) {
            
            [UIView animateWithDuration:0.25 animations:^{
                 self.baseBottomViewCell.blej_y = BLEJHeight - 230;
            }];
        } else if (self.viewType == 4) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.blej_y = BLEJHeight - 300;
            }];
        } else if (self.viewType == 5) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomTwoView.blej_y = BLEJHeight - 260;
            }];
        }
    }
}

- (void)setEdittingType:(NSString *)edittingType {
    
    // 这个用于弹出视图2的时候那些可以进行编辑(0: 什么都可以编辑  1: 只可以编辑面积 2: 可以编辑单价和工艺 3: 什么都不可以编辑)
    if (_edittingType != edittingType) {
        
        _edittingType = edittingType;
    }
    
    if ([edittingType isEqualToString:@"0"]) {
        
        self.bottomViewCell.nameTF.userInteractionEnabled = YES;
        self.bottomViewCell.areaTF.userInteractionEnabled = YES;
        self.bottomViewCell.unitPriceTF.userInteractionEnabled = YES;
        self.bottomViewCell.techTextView.userInteractionEnabled = YES;
        
        self.baseBottomViewCell.nameTF.userInteractionEnabled = YES;
        self.baseBottomViewCell.unitPriceTF.userInteractionEnabled = YES;
        self.baseBottomViewCell.techTextView.userInteractionEnabled = YES;
        
        self.twoView.nameTF.userInteractionEnabled = YES;
        self.twoView.areaTF.userInteractionEnabled = YES;
        self.twoView.unitPriceTF.userInteractionEnabled = YES;
        self.twoView.techTextView.userInteractionEnabled = YES;
    }
    
    if ([edittingType isEqualToString:@"1"]) {
        
        self.oneView.nameTF.userInteractionEnabled = NO;
        self.oneView.areaTF.userInteractionEnabled = YES;
        self.oneView.unitPriceTF.userInteractionEnabled = NO;
        self.oneView.techTextView.userInteractionEnabled = NO;
        
        self.bottomViewCell.nameTF.userInteractionEnabled = NO;
        self.bottomViewCell.areaTF.userInteractionEnabled = YES;
        self.bottomViewCell.unitPriceTF.userInteractionEnabled = NO;
        self.bottomViewCell.techTextView.userInteractionEnabled = NO;
        
        self.baseBottomViewCell.nameTF.userInteractionEnabled = NO;
        self.baseBottomViewCell.unitPriceTF.userInteractionEnabled = NO;
        self.baseBottomViewCell.techTextView.userInteractionEnabled = NO;
    }
    
    if ([edittingType isEqualToString:@"2"]) {
        
        self.oneView.nameTF.userInteractionEnabled = NO;
        self.oneView.areaTF.userInteractionEnabled = NO;
        self.oneView.unitPriceTF.userInteractionEnabled = YES;
        self.oneView.techTextView.userInteractionEnabled = YES;
        
        self.baseBottomViewCell.nameTF.userInteractionEnabled = NO;
        self.baseBottomViewCell.unitPriceTF.userInteractionEnabled = YES;
        self.baseBottomViewCell.techTextView.userInteractionEnabled = YES;
    }
    
    if ([edittingType isEqualToString:@"3"]) {
        
        self.oneView.nameTF.userInteractionEnabled = NO;
        self.oneView.areaTF.userInteractionEnabled = NO;
        self.oneView.unitPriceTF.userInteractionEnabled = NO;
        self.oneView.techTextView.userInteractionEnabled = NO;
        
        self.bottomViewCell.nameTF.userInteractionEnabled = NO;
        self.bottomViewCell.areaTF.userInteractionEnabled = NO;
        self.bottomViewCell.unitPriceTF.userInteractionEnabled = NO;
        self.bottomViewCell.techTextView.userInteractionEnabled = NO;
        
        self.baseBottomViewCell.nameTF.userInteractionEnabled = NO;
        self.baseBottomViewCell.unitPriceTF.userInteractionEnabled = NO;
        self.baseBottomViewCell.techTextView.userInteractionEnabled = NO;
    }
}

- (void)setShowType:(NSString *)showType {
    
    // 这个是用来设置显示的文字 (0 : 面积 平米 单价 元  1: 面积 平米 单价 %  2: 数量 自定义单位 单价 元  3: 单位 空 单价 元)
    if (_showType != showType) {
        
        _showType = showType;
    }
    self.bottomViewCell.isNeedNumKeyboard = YES;
//    self.oneView.isNeedNumKeyboard = YES;
    
    if ([showType isEqualToString:@"0"]) {
        
        self.baseBottomViewCell.isShowPercentage = NO;
        self.baseBottomViewCell.priceLabel.text = @"元";
        
        self.oneView.areaFirstLabel.text = @"面积";
        self.oneView.areaLabel.text = @"平米";
        self.oneView.priceLabel.text = @"元";
    }
    
    if ([showType isEqualToString:@"1"]) {
        
        self.baseBottomViewCell.isShowPercentage = YES;
        self.baseBottomViewCell.priceLabel.text = @"%";
        
        self.oneView.areaFirstLabel.text = @"面积";
        self.oneView.areaLabel.text = @"平米";
        self.oneView.priceLabel.text = @"%";
    }
    
    if ([showType isEqualToString:@"2"]) {
        
        self.baseBottomViewCell.isShowPercentage = NO;
        self.baseBottomViewCell.priceLabel.text = @"元";
        
        self.bottomViewCell.areaFirstLabel.text = @"数量";
//        self.bottomViewCell.areaLabel.text = self.model.unitName;
        self.bottomViewCell.areaLabel.text = self.allcalModel.supplementUnit;
        self.bottomViewCell.priceLabel.text = @"元";
        
        self.oneView.areaFirstLabel.text = @"数量";
//        self.oneView.areaLabel.text = self.model.unitName;
       
        self.oneView.areaLabel.text = self.allcalModel.supplementUnit;
        self.oneView.priceLabel.text = @"元";
    }
    
    if ([showType isEqualToString:@"3"]) {
        
        self.baseBottomViewCell.isShowPercentage = NO;
        self.baseBottomViewCell.priceLabel.text = @"元";
        
        
        self.twoView.areaFirstLabel.text = @"单位";
        self.bottomViewCell.areaFirstLabel.text = @"单位";
        
//        if (self.baseAndSuppleListModel) {
//            self.bottomViewCell.areaTF.text = self.baseAndSuppleListModel.supplementUnit;
//            self.twoView.areaTF.text = self.baseAndSuppleListModel.supplementUnit;
//        } else {
//            self.bottomViewCell.areaTF.text = @"";
//            self.twoView.areaTF.text = @"";
//        }
        if (self.allcalModel) {
            self.bottomViewCell.areaTF.text = self.allcalModel.supplementUnit;
            self.twoView.areaTF.text = self.allcalModel.supplementUnit;
        } else {
            self.bottomViewCell.areaTF.text = @"";
            self.twoView.areaTF.text = @"";
        }
        
        self.twoView.areaLabel.text = @"";
        self.twoView.priceLabel.text = @"元";
        self.twoView.isNeedNumKeyboard = NO;
        
        
        self.bottomViewCell.areaLabel.text = @"";
        self.bottomViewCell.priceLabel.text = @"元";
        self.bottomViewCell.isNeedNumKeyboard = NO;
        
//        if (self.baseAndSuppleListModel) {
//            self.oneView.areaTF.text = self.baseAndSuppleListModel.supplementUnit;
//        } else {
//            self.oneView.areaTF.text = @"";
//        }
        if (self.allcalModel) {
            self.oneView.areaTF.text = self.allcalModel.supplementUnit;
        } else {
            self.oneView.areaTF.text = @"";
        }
        self.oneView.areaLabel.text = @"";
        self.oneView.priceLabel.text = @"元";
//        self.oneView.isNeedNumKeyboard = NO;
    }
    
    if ([showType isEqualToString:@"4"]) {
        
    }
}


// 通知处理
- (void)notificationMes:(NSNotification *)noc {
    
    self.hidden = YES;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

 //解决手势冲突问题(点击上层视图  底下的视图添加的手势响应方法)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ([touch.view isDescendantOfView:self.bottomViewCell]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.oneView]) {
        return NO;
    }
    if ([touch.view isDescendantOfView: self.baseBottomViewCell]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.twoView]) {
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didClickCalculatorBaseBottomViewConfirmBtnReplace" object:nil];
}


@end
