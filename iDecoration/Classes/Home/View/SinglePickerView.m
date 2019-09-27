//
//  SinglePickerView.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SinglePickerView.h"

@interface SinglePickerView()
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation SinglePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = White_Color;
        
        [self.headV addSubview:self.sureBtn];
        [self.headV addSubview:self.closeBtn];
        [self addSubview:self.pickerView];
        [self addSubview:self.headV];
        [self addSubview:self.bottomSureBtn];
    }
    return self;
}

-(UIPickerView*)pickerView{
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.height-self.headV.height)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = Bottom_Color;
    }
    return _pickerView;
}

-(UIButton*)sureBtn{
    
    if (!_sureBtn) {
        
         _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(BLEJWidth-80-20, 0, 80,self.headV.height);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:Main_Color];
        [_sureBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.userInteractionEnabled = YES;
        [_sureBtn addTarget:self action:@selector(sureRegion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}



-(UIButton*)closeBtn{
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(20, 0, 80, self.headV.height);
        [_closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_closeBtn setBackgroundColor:Main_Color];
        [_closeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //        _closeBtn.layer.cornerRadius = 5;
        _closeBtn.userInteractionEnabled = YES;
        [_closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIButton*)bottomSureBtn{
    
    if (!_bottomSureBtn) {
        
       _bottomSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomSureBtn.frame = CGRectMake(10, 245, BLEJWidth-20, 40);
        [_bottomSureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_bottomSureBtn setBackgroundColor:Main_Color];
        [_bottomSureBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _bottomSureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _bottomSureBtn.layer.cornerRadius = 5;
        _bottomSureBtn.userInteractionEnabled = YES;
        [_bottomSureBtn addTarget:self action:@selector(sureRegion:) forControlEvents:UIControlEventTouchUpInside];
        _bottomSureBtn.hidden = YES;
    }
    return _bottomSureBtn;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.dataArray.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return kSCREEN_WIDTH;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.text = self.dataArray[row];
    return nameLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectedIndex = row;
}


-(UIView *)headV{
    if (!_headV) {
        _headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
        _headV.backgroundColor = Main_Color;
    }
    return _headV;
}

-(void)sureRegion:(UIButton*)sender{
    
    if (self.selectBlock) {
        self.selectBlock(self.selectedIndex);
    }
    self.hidden = YES;
    
}

-(void)closeBtn:(UIButton*)sender{
    
    self.hidden = YES;
}



@end
