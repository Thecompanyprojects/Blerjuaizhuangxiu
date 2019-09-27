//
//  ZCHCalculatorSelectRoomNumView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCalculatorSelectRoomNumView.h"
#import "JobNameTableViewCell.h"

// JobNameTableViewCellDelegate,UITableViewDelegate, UITableViewDataSource, 
@interface ZCHCalculatorSelectRoomNumView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) BOOL isFirst;
//@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UIView *sepLine;

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel *topTitleView;
@property (strong, nonatomic) UIButton *confirmBtn;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation ZCHCalculatorSelectRoomNumView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadowView:)];
        [self addGestureRecognizer:tap];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        self.topTitleView = [[UILabel alloc] init];
        self.topTitleView.text = @"";
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
    
//    return self.dataArr.count;
    if (self.isFromZero) {

        return self.count + 1;
    } else {

        return self.count;
    }
}

// 自定义pickerView上的视图, 并且赋值
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, BLEJWidth, 30)];
//    ZCHSimpleSettingSupplementModel *model = self.dataArr[row];
//    myView.text = model.supplementName;
    if (self.isFromZero) {

        myView.text = [NSString stringWithFormat:@"%ld", row];
    } else {

        myView.text = [NSString stringWithFormat:@"%ld", row + 1];
    }
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
//    if ([self.delegate respondsToSelector:@selector(didClickPickerViewWithIndex:andSection:)]) {
//        
//        [self.delegate didClickPickerViewWithIndex:index andSection:self.section];
//    }
    
    if (self.isFromZero) {
        
        if ([self.delegate respondsToSelector:@selector(didClickRoomCount:)]) {
            
            [self.delegate didClickRoomCount:index];
        }
    } else {
        
        if ([self.delegate respondsToSelector:@selector(didClickRoomCount:)]) {
            
            [self.delegate didClickRoomCount:index + 1];
        }
    }
}

//- (void)setDataArr:(NSArray *)dataArr {
//    
//    _dataArr = dataArr;
//    [self.pickerView reloadComponent:0];
//}

- (void)setCount:(NSInteger)count {
    
    _count = count;
    [self.pickerView reloadComponent:0];
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.topTitleView.text = title;
}

- (void)setIndex:(NSInteger)index {
    
    _index = index;
    
    if (self.isFromZero) {
        
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    } else {
        
        [self.pickerView selectRow:index - 1 inComponent:0 animated:NO];
    }
}

// 处理弹出动画的
- (void)setHidden:(BOOL)hidden {
    
    if (hidden) {
        
        if (self.isFirst) {
            
            self.isFirst = NO;
            [super setHidden:hidden];
        } else {
            
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





//- (instancetype)initWithFrame:(CGRect)frame {
//    
//    if (self = [super initWithFrame:frame]) {
//        
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShadowView:)];
//        [self addGestureRecognizer:tap];
//        [self setupUI];
//        
//    }
//    return self;
//}
//
//- (void)setupUI {
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, 50)];
//    label.backgroundColor = White_Color;
//    self.titleLabel = label;
//    label.textColor = [UIColor blackColor];
//    [self addSubview:label];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = label.bounds;
//    maskLayer.path = maskPath.CGPath;
//    label.layer.mask = maskLayer;
//    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight + 49, BLEJWidth, 1)];
//    line.backgroundColor = kSepLineColor;
//    self.sepLine = line;
//    [self addSubview:line];
//    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BLEJHeight + 50, BLEJWidth, self.count * 44)];
//    [self.tableView registerNib:[UINib nibWithNibName:@"JobNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobNameTableViewCell"];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.rowHeight = 44;
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 30)];
//    footer.backgroundColor = White_Color;
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];
//    header.backgroundColor = White_Color;
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.tableFooterView = footer;
//    self.tableView.tableHeaderView = header;
//    [self addSubview:self.tableView];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    if (self.isFromZero) {
//        
//        return self.count + 1;
//    } else {
//        
//        return self.count;
//    }
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    JobNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobNameTableViewCell"];
//    cell.delegate = self;
//    cell.indexPath = indexPath;
//    if (self.isFromZero) {
//        
//        cell.titleLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
//    } else {
//        
//        cell.titleLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//    }
//    if ([cell.titleLabel.text integerValue] == self.index && self.count != 0) {
//        
//        cell.selectBtn.selected = YES;
//    } else {
//        
//        cell.selectBtn.selected = NO;
//    }
//    
//    return cell;
//}
//
//- (void)didClickSelectedBtn:(UIButton *)btn withIndexpath:(NSIndexPath *)indexpath {
//    
//    JobNameTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
//    
//    if ([cell.titleLabel.text integerValue] != self.index) {
//        
//        if (self.isFromZero) {
//            
//            JobNameTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.index  inSection:0]];
//            cell.selectBtn.selected = NO;
//        } else {
//            
//            JobNameTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.index - 1 inSection:0]];
//            cell.selectBtn.selected = NO;
//        }
//    }
//    if ([self.delegate respondsToSelector:@selector(didClickRoomCount:)]) {
//        
//        [self.delegate didClickRoomCount:[cell.titleLabel.text integerValue]];
//    }
//    
//    __weak typeof(self) weakSelf = self;;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        weakSelf.hidden = YES;
//    });
//    
//}
//
//// 处理弹出动画的
//- (void)setHidden:(BOOL)hidden {
//    
//    if (hidden) {
//        
//        if (self.isFirst) {
//            
//            self.isFirst = NO;
//            [super setHidden:hidden];
//        } else {
//            
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                self.titleLabel.blej_y = BLEJHeight;
//                self.sepLine.blej_y = BLEJHeight + 49;
//                self.tableView.blej_y = BLEJHeight + 50;
//                self.backgroundColor = [Black_Color colorWithAlphaComponent:0.0];
//            } completion:^(BOOL finished) {
//                [super setHidden:hidden];
//            }];
//        }
//    } else {
//        
//        [super setHidden:hidden];
//        if (self.isFromZero) {
//            
//            self.tableView.frame = CGRectMake(0, BLEJHeight + 50, BLEJWidth, (self.count + 1) * 44 + 50);
//        } else {
//            
//            self.tableView.frame = CGRectMake(0, BLEJHeight + 50, BLEJWidth, self.count * 44 + 50);
//        }
//        [self.tableView reloadData];
//        self.titleLabel.text = self.title;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.backgroundColor = [Black_Color colorWithAlphaComponent:0.2];
//            if (self.isFromZero) {
//                
//                self.titleLabel.blej_y = BLEJHeight - 50 - (self.count + 1) * 44 - 50;
//                self.sepLine.blej_y = BLEJHeight - 1 - (self.count + 1) * 44 - 50;
//                self.tableView.blej_y = BLEJHeight - (self.count + 1) * 44 - 50;
//            } else {
//                
//                self.titleLabel.blej_y = BLEJHeight - 50 - self.count * 44 - 50;
//                self.sepLine.blej_y = BLEJHeight - 1 - self.count * 44 - 50;
//                self.tableView.blej_y = BLEJHeight - self.count * 44 - 50;
//            }
//        }];
//    }
//}

- (void)removeShadowView:(UITapGestureRecognizer *)tap {
    
    self.hidden = YES;
}

@end
