//
//  DecorateInfoNeedView.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateInfoNeedView.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "SinglePickerView.h"
#import <IQUIView+Hierarchy.h>


@interface DecorateInfoNeedView ()<UITextFieldDelegate>





@property (nonatomic, assign) BOOL keyboardIsVisible;


@property (nonatomic, strong) RegionView *regionView;
@property (nonatomic, strong) PModel *pmodel;
@property (nonatomic, strong) CModel *cmodel;
@property (nonatomic, strong) DModel *dmodel;

@property (nonatomic, strong) SinglePickerView *singlePickerView;

@end
@implementation DecorateInfoNeedView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 12;
    self.contentView.layer.masksToBounds = YES;
    
    self.finishButton.backgroundColor = kMainThemeColor;
    self.finishButton.layer.cornerRadius = 6;
    
    self.sendVertifyBtn.backgroundColor = kMainThemeColor;
    self.sendVertifyBtn.layer.cornerRadius = 4;
    self.sendVertifyBtn.layer.masksToBounds = YES;
    
    self.itemTFHeightCon.constant = kSize(34);
    self.nameTFHeightCon.constant = kSize(34);
    self.phoneTFHeightCon.constant = kSize(34);
    self.tfIVCHeight.constant = kSize(34);
    self.vertifyCodeTFHeightCon.constant = kSize(34);
    self.areaTFHeightCon.constant = kSize(34);
    self.TimeTFHeightCon.constant = kSize(34);
    self.finishBtnHeightCon.constant = kSize(34);
    self.sendVerfifyBtnWidhtCon.constant = kSize(90);
    self.itemTF.font = [UIFont systemFontOfSize:kSize(16)];
    self.nameTF.font = [UIFont systemFontOfSize:kSize(16)];
    self.phoneTF.font = [UIFont systemFontOfSize:kSize(16)];
    self.vertifyCodeTF.font = [UIFont systemFontOfSize:kSize(16)];
    self.areaTF.font = [UIFont systemFontOfSize:kSize(16)];
    self.timeTF.font = [UIFont systemFontOfSize:kSize(16)];
    self.sendVertifyBtn.titleLabel.font = [UIFont systemFontOfSize:kSize(16)];
    self.finishButton.titleLabel.font = [UIFont systemFontOfSize:kSize(16)];
    self.protocolImageTopToPhoneTFCon.constant = kSize(68) + 40;

    self.headImageViewHeightCon.constant = (kSCREEN_WIDTH - 60)/4.0;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGR];
    
    UITapGestureRecognizer *TAPGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentViewAction)];
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:TAPGR2];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
    
    self.itemTF.delegate = self;
    self.nameTF.delegate = self;
    self.phoneTF.delegate = self;
    self.areaTF.delegate = self;
    self.timeTF.delegate = self;
    
    [self regionView];
    [self singlePickerView];
#warning 后台拖后腿 后续版本增加该功能 暂时注释
//    [GetImageVerificationCode setImageVerificationCodeToImageView:self.imageViewImageVerificationCode];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)sendVertifyBtnAction:(id)sender {
    
    if (self.sendVertifyCodeBlock) {
        self.sendVertifyCodeBlock();
    }
    
}



- (void)keyboardDidShow
{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide
{
    _keyboardIsVisible = NO;
}



- (void)hideSelf {
    self.singlePickerView.hidden = YES;
    self.regionView.hidden = YES;
    if (_keyboardIsVisible) {
        [self endEditing:YES];
    } else {
        [self endEditing:YES];
        self.hidden = YES;
    }
}

- (void)tapContentViewAction {
    self.singlePickerView.hidden = YES;
    self.regionView.hidden = YES;
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTF) {
        [textField resignFirstResponder];
        [self.phoneTF becomeFirstResponder];
    }
    if (textField == self.phoneTF) {
        [self endEditing:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.itemTF == textField) {
        //        // IQKeyBoard的坑
        //        if (textField.isAskingCanBecomeFirstResponder == NO) {
        //            [self endEditing:YES];
        //            self.regionView.hidden= YES;
        //            self.singlePickerView.hidden = NO;
        //        }
        [self endEditing:YES];
        self.regionView.hidden= YES;
        self.singlePickerView.hidden = NO;
        return NO;
    } else if (self.areaTF == textField) {
//        // IQKeyBoard的坑
//        if (textField.isAskingCanBecomeFirstResponder == NO) {
//            [self endEditing:YES];
//            self.singlePickerView.hidden = YES;
//            [self getRegion];
//        }
        [self endEditing:YES];
        self.singlePickerView.hidden = YES;
        [self getRegion];
        return NO;
    } else if (self.timeTF == textField) {
//        // IQKeyBoard的坑
//        if (textField.isAskingCanBecomeFirstResponder == NO) {
//            [self endEditing:YES];
//            self.regionView.hidden= YES;
//            self.singlePickerView.hidden = NO;
//        }
        [self endEditing:YES];
        self.regionView.hidden= YES;
        self.singlePickerView.hidden = NO;
        return NO;
    } else {
        self.regionView.hidden = YES;
        self.singlePickerView.hidden = YES;
        return YES;
    }
    
}





#pragma mark 地区的选择

-(RegionView *)regionView{
    
    if (!_regionView) {
        _regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
        _regionView.closeBtn.hidden = NO;
        
        _regionView.hidden = YES;
        
        [self addSubview:_regionView];
    }
    return _regionView;
}

-(void)getRegion{
    
    self.regionView.hidden = NO;
    //    self.bgView.hidden = YES;
    MJWeakSelf;
    
    self.regionView.selectBlock = ^(NSMutableArray *array){
        
        weakSelf.regionView.hidden = YES;
        weakSelf.pmodel = [array objectAtIndex:0];
        weakSelf.cmodel = [array objectAtIndex:1];
        weakSelf.dmodel = [array objectAtIndex:2];
        
        NSString  *addressStr = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.pmodel.name,weakSelf.cmodel.name,weakSelf.dmodel.name];
        weakSelf.areaTF.text = addressStr;
        
        NSInteger regionId = [weakSelf.pmodel.regionId integerValue];
        
        weakSelf.provinceNum = weakSelf.pmodel.regionId;
        weakSelf.cityNum = weakSelf.cmodel.regionId;
        weakSelf.countyNum = weakSelf.dmodel.regionId;
        
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市省传0 
        {
            weakSelf.provinceNum = @"0";
           
        }
         YSNLog(@"城市编号： %@ %@ %@", weakSelf.provinceNum, weakSelf.cityNum, weakSelf.countyNum);
        
        //        //地址最后一级的编号
        //        [weakSelf.dataDic  setObject:weakSelf.dmodel.regionId forKey:@"cityNumber"];
        
        
    };
    
}


#pragma mark - 时间选择  不需要时间了，  预约项目使用这个
- (SinglePickerView *)singlePickerView {
    MJWeakSelf;
    if (!_singlePickerView) {
        _singlePickerView = [[SinglePickerView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305 + 44, kSCREEN_WIDTH, 305)];
        [self addSubview:_singlePickerView];
        NSArray *timeArray = [self chooseItem];
        _singlePickerView.dataArray = timeArray;
        _singlePickerView.closeBtn.hidden = NO;
        _singlePickerView.hidden = YES;
        _singlePickerView.backgroundColor =[UIColor whiteColor]; 
        _singlePickerView.selectBlock = ^(NSInteger index) {
            weakSelf.itemTF.text = timeArray[index];
        };
    }
    
    
    return _singlePickerView;
}

#pragma mark 预约项目
-(NSArray *)chooseItem {
    return @[@"量房", @"设计", @"施工", @"维修", @"其他"];
}

#pragma mark 装修时间的选择
-(NSArray *)chooseTime{
    
    NSMutableArray *arr = [NSMutableArray array];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //获取当前的月份
    [formatter  setDateFormat:@"MM"];
    int mMonth = [[formatter stringFromDate:date] intValue];
    
    //获取当前的日期
    [formatter  setDateFormat:@"dd"];
    NSInteger mDay = [[formatter stringFromDate:date] integerValue];
    
    int num=0;
    int optionnum=0;
    
    NSString *text;
    
    for(int i = mMonth;i <= mMonth+3;i++){
        num=i;
        if (i>12){
            num-=12;
        }
        
        if (num==mMonth){
            if (mDay<=10){
                text = [NSString stringWithFormat:@"%d月中旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
            if (mDay<=20){
                text=[NSString stringWithFormat:@"%d月下旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
        }else{
            if (optionnum<9){
                text=[NSString stringWithFormat:@"%d月上旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
            if (optionnum<9){
                text=[NSString stringWithFormat:@"%d月中旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
            if (optionnum<9){
                text=[NSString stringWithFormat:@"%d月下旬",num];;
                optionnum+=1;
                [arr addObject:text];
            }
        }
    }
    
    
    return arr;
}


@end
