//
//  RegionView.m
//  iDecoration
//
//  Created by RealSeven on 17/3/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"

@implementation RegionView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = White_Color;
        [self getRegionList];
//        [self addSubview:self.line];
        [self addSubview:self.headV];
        [self.headV addSubview:self.sureBtn];
        [self.headV addSubview:self.closeBtn];
        [self addSubview:self.pickerView];
        [self addSubview:self.shadowV];
        self.shadowV.hidden = YES;
        [self addSubview:self.bottomSureBtn];
    }
    return self;
}

-(NSMutableArray*)firstArray{
    
    if (!_firstArray) {
        _firstArray = [NSMutableArray array];
    }
    return _firstArray;
}

-(NSMutableArray*)secondArray{
    
    if (!_secondArray) {
        _secondArray = [NSMutableArray array];
    }
    return _secondArray;
}

-(NSMutableArray*)thirdArray{
    
    if (!_thirdArray) {
        _thirdArray = [NSMutableArray array];
    }
    return _thirdArray;
}

-(NSMutableArray*)selectArray{
    
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    
    return _selectArray;
}

-(UIView*)line{
    
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
        _line.backgroundColor = Bottom_Color;
    }
    return _line;
}

-(UIPickerView*)pickerView{
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.headV.bottom, kSCREEN_WIDTH, self.height-self.headV.height)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = Bottom_Color;
    }
    return _pickerView;
}

-(UIView *)shadowV{
    if (!_shadowV) {
        _shadowV = [[UIView alloc]initWithFrame:CGRectMake(0, self.pickerView.top, kSCREEN_WIDTH/3*2, self.pickerView.height)];
        _shadowV.backgroundColor = Clear_Color;
    }
    return _shadowV;
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
    
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.firstArray.count;
    }else if (component == 1){
        return self.secondArray.count;
    }else{
        return self.thirdArray.count;
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return kSCREEN_WIDTH/3;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/3, 40)];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    
    if (component == 0) {
        PModel *model = [self.firstArray objectAtIndex:row];
        nameLabel.text = model.name;
        }
    
    if (component == 1) {
        CModel *model = [self.secondArray objectAtIndex:row];
        nameLabel.text = model.name;
    }
    
    if (component == 2) {
        DModel *model = [self.thirdArray objectAtIndex:row];
        nameLabel.text = model.name;
    }

    return nameLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
#pragma mark --new
    if (component == 0) {
        
        PModel *pmodel = [self.firstArray objectAtIndex:row];
        
//        清空数据
        [self.selectArray removeAllObjects];
        
        if (![self.selectArray containsObject:pmodel]) {
            [self.selectArray addObject:pmodel];
        }
        
//        获取第二级
        if (self.selectArray.count >0) {
            
            PModel *pmodel = [self.selectArray objectAtIndex:0];
            
//            清空数据
            [self.secondArray removeAllObjects];
            
            for (NSDictionary *dict in pmodel.cities) {
                
                CModel *cmodel = [CModel yy_modelWithJSON:dict];
                
                if (![self.secondArray containsObject:cmodel]) {
                    [self.secondArray addObject:cmodel];
                }
            }
        }else{
            self.secondArray = nil;
        }
        
        if (self.secondArray.count >0) {
        
            CModel *cmodel = [self.secondArray objectAtIndex:0];
            
            [self.thirdArray removeAllObjects];
            
            for (NSDictionary *dict in cmodel.counties) {
                
                DModel *dmodel = [DModel yy_modelWithJSON:dict];
                
                if (![self.thirdArray containsObject:dmodel]) {
                    [self.thirdArray addObject:dmodel];
                }
            }
        }
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    //    滚轮1
    if (component == 1) {
        
        if (self.secondArray.count >0) {
            
            CModel *cmodel = [self.secondArray objectAtIndex:row];
            
            [self.thirdArray removeAllObjects];
            
            for (NSDictionary *dict in cmodel.counties) {
                
                DModel *dmodel = [DModel yy_modelWithJSON:dict];
                
                if (![self.thirdArray containsObject:dmodel]) {
                    [self.thirdArray addObject:dmodel];
                }
            }
        }
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }
}

-(void)scrollPickerViewWith:(NSString*)pid cid:(NSString*)cid{
    NSInteger pidNum = 0;
    NSInteger cidNum = 0;
    
    for (int i = 0; i<self.firstArray.count; i++) {
        PModel *pmodel = self.firstArray[i];
        if ([pmodel.regionId isEqualToString:pid]) {
            pidNum = i;
            break;
        }
    }
    
    
    
    PModel *pmodel = [self.firstArray objectAtIndex:pidNum];
    
    //        清空数据
    [self.selectArray removeAllObjects];
    
    if (![self.selectArray containsObject:pmodel]) {
        [self.selectArray addObject:pmodel];
    }
    
    for (int i = 0; i<pmodel.cities.count; i++) {
        NSDictionary *dict = pmodel.cities[i];
        CModel *cmodel = [CModel yy_modelWithJSON:dict];
        if ([cmodel.regionId isEqualToString:cid]) {
            cidNum = i;
            break;
        }
    }
    
    //        获取第二级
    if (self.selectArray.count >0) {
        
        PModel *pmodel = [self.selectArray objectAtIndex:0];
        
        //            清空数据
        [self.secondArray removeAllObjects];
        
        for (NSDictionary *dict in pmodel.cities) {
            
            CModel *cmodel = [CModel yy_modelWithJSON:dict];
            
            if (![self.secondArray containsObject:cmodel]) {
                [self.secondArray addObject:cmodel];
            }
        }
    }else{
        self.secondArray = nil;
    }
    
    if (self.secondArray.count >0) {
        
        CModel *cmodel = [self.secondArray objectAtIndex:0];
        
        [self.thirdArray removeAllObjects];
        
        for (NSDictionary *dict in cmodel.counties) {
            
            DModel *dmodel = [DModel yy_modelWithJSON:dict];
            
            if (![self.thirdArray containsObject:dmodel]) {
                [self.thirdArray addObject:dmodel];
            }
        }
    }
    
    
    [self.pickerView selectRow:pidNum inComponent:0 animated:YES];
    
    [self.pickerView reloadComponent:1];
    [self.pickerView reloadComponent:2];
    [self.pickerView selectRow:cidNum inComponent:1 animated:YES];
    [self.pickerView selectRow:0 inComponent:2 animated:YES];
    
    YSNLog(@"%ld",pidNum);
    
}

//从json文件得到地址列表
-(void)getRegionList{
    
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_blej_tree" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dict in jsonArr) {
        
        PModel *pmodel = [PModel yy_modelWithJSON:dict];
        if (![self.firstArray containsObject:pmodel]) {
            [self.firstArray addObject:pmodel];
        }
    }
    
    [self getBJList];
}

-(void)getBJList{
    
    PModel *BJModel = [self.firstArray firstObject];
    
    [self.secondArray removeAllObjects];
    for (NSDictionary *dict in BJModel.cities) {
        
        CModel *cmodel = [CModel yy_modelWithJSON:dict];
        
        if (![self.secondArray containsObject:cmodel]) {
            [self.secondArray addObject:cmodel];
        }
    }
    
    [self getBJDistrict];
}

-(void)getBJDistrict{
    
    CModel *cmodel = [self.secondArray firstObject];
    
    [self.thirdArray removeAllObjects];
    
    for (NSDictionary *dict in cmodel.counties) {
        
        DModel *dmodel = [DModel yy_modelWithJSON:dict];
        
        if (![self.thirdArray containsObject:dmodel]) {
            [self.thirdArray addObject:dmodel];
        }
    }
    
    [self.pickerView reloadAllComponents];
}

-(UIView *)headV{
    if (!_headV) {
        _headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
        _headV.backgroundColor = Main_Color;
    }
    return _headV;
}

-(void)sureRegion:(UIButton*)sender{
    
    NSMutableArray *chooseArray = [NSMutableArray array];
    
    NSInteger pIndex = [self.pickerView selectedRowInComponent:0];
    [chooseArray addObject:[self.firstArray objectAtIndex:pIndex]];
    
    NSInteger cIndex = [self.pickerView selectedRowInComponent:1];
    [chooseArray addObject:[self.secondArray objectAtIndex:cIndex]];
    
    NSInteger dIndex = [self.pickerView selectedRowInComponent:2];
    [chooseArray addObject:[self.thirdArray objectAtIndex:dIndex]];
    
    if (self.selectBlock) {
        self.selectBlock(chooseArray);
    }
    
}

-(void)closeBtn:(UIButton*)sender{
    
    self.hidden = YES;
}

- (void)setIsType:(NSString *)isType {
    
    _isType = isType;
    
    if ([isType isEqualToString:@"1"]) {
        _bottomSureBtn.hidden = NO;
        [_bottomSureBtn setTitle:@"添加" forState:UIControlStateNormal];
    }
}

@end
