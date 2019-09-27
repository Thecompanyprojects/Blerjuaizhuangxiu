//
//  VoteSetController.m
//  iDecoration
//
//  Created by sty on 2017/8/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "VoteSetController.h"
#import "PlaceHolderTextView.h"
#import "WSDatePickerView.h"
#import "VoteOptionModel.h"

#import "WWPickerView.h"


@interface VoteSetController ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    NSString *_voteTypeStr;//投票类型
    
    NSInteger selectTag;//选中几项的标志
    
    BOOL isFirstVote;//是否是第一次投票
}
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scroview;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *endTimeBtn;
@property (nonatomic, strong) UIButton *voteTypeBtn;
@property (nonatomic, strong) UIButton *successBtn;


@end

@implementation VoteSetController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投票设置";
    selectTag = [self.voteType integerValue];
    if (self.voteTheme.length<=0) {
        isFirstVote = YES;
        //没有投票
        [self.dateArray removeAllObjects];
        for (int i = 0; i<2; i++) {
            VoteOptionModel *model = [[VoteOptionModel alloc]init];
            model.voteId = 0;
            model.voteOption = @"";
            [self.dateArray addObject:model];
        }
        
        selectTag = 0 ;
//        _voteTypeStr = @"单选，默认";
    }
    else{
        isFirstVote = NO;
        selectTag = [self.voteType integerValue];
        if (selectTag == 0) {
            selectTag = 1;
        }
        
        else if (selectTag==1) {
            selectTag = 0;
        }
        
        else{
        
        }
        
        NSInteger count = self.dateArray.count;
        NSArray *array = @[@"单选",@"多选，无限制"];
        NSMutableArray *typeArray = [[NSMutableArray alloc]initWithArray:array];
        for (int i = 0; i<count-2; i++) {
            NSString *str = [NSString stringWithFormat:@"多选，最多选%d项",i+2];
            [typeArray addObject:str];
        }
        _voteTypeStr = typeArray[selectTag];
    }
    
    [self.view addSubview:self.scroview];
    [self.scroview addSubview:self.headView];
    [self.scroview addSubview:self.bottomView];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.successBtn = editBtn;
    [self.successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self createNoDataUI];
}



-(void)createNoDataUI{
    [self.headView removeAllSubViews];
    UILabel *voteL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 40)];
    voteL.text = @"投票描述";
    voteL.textColor = COLOR_BLACK_CLASS_3;
    voteL.font = NB_FONTSEIZ_BIG;
    
    UITextField *voteT = [[UITextField alloc]initWithFrame:CGRectMake(voteL.right, voteL.top, self.headView.width-voteL.right, voteL.height)];
    voteT.delegate = self;
    voteT.tag = 1000;
    voteT.text = _voteTheme;
    
    voteT.textColor = COLOR_BLACK_CLASS_3;
    voteT.font = NB_FONTSEIZ_NOR;
    voteT.placeholder = @"输入投票描述";
    [voteT setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
    [voteT setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
    
    [self.headView addSubview:voteL];
    [self.headView addSubview:voteT];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(voteL.left, voteL.bottom, self.headView.width-voteL.left, 1)];
    lineV.backgroundColor = COLOR_BLACK_CLASS_0;
    [self.headView addSubview:lineV];
    
    CGFloat bottomH = lineV.bottom;
    NSInteger count = self.dateArray.count;
    for (int i = 0; i<count; i++) {
        UIView *optionV = [[UIView alloc]initWithFrame:CGRectMake(lineV.left, bottomH, lineV.width, 45)];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, optionV.height/2-10, 20, 20)];
        imgV.image = [UIImage imageNamed:@"setting_head_bg.png"];
        
        NSString *temPlaceHolder = [NSString stringWithFormat:@"选项%d",i+1];
        PlaceHolderTextView *companyNameTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(imgV.right+10,6,optionV.width-imgV.right-10-30,optionV.height-12)];
        companyNameTextView.placeHolder = temPlaceHolder;
        companyNameTextView.placeHolderColor = COLOR_BLACK_CLASS_9;
        //                companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
//        companyNameTextView.textContainerInset
//        companyNameTextView.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
        companyNameTextView.font = NB_FONTSEIZ_NOR;
        companyNameTextView.textColor = COLOR_BLACK_CLASS_3;
        companyNameTextView.tag = i;
        companyNameTextView.delegate = self;
        VoteOptionModel *model = self.dateArray[i];
        companyNameTextView.text = model.voteOption;
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(optionV.width-15-10, optionV.height/2-7.5, 15, 15);
        [deleteBtn setImage:[UIImage imageNamed:@"promo_cancel"] forState:UIControlStateNormal];
        deleteBtn.tag = i;
        [deleteBtn addTarget:self action:@selector(deleteOption:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0||i==1) {
            deleteBtn.hidden = YES;
        }
        else{
            deleteBtn.hidden = NO;
        }
        [self.headView addSubview:optionV];
        [optionV addSubview:imgV];
        [optionV addSubview:companyNameTextView];
        [optionV addSubview:deleteBtn];
        
        UIView *temLineV = [[UIView alloc]initWithFrame:CGRectMake(imgV.left, 44, optionV.width, 1)];
        temLineV.backgroundColor = COLOR_BLACK_CLASS_0;
        [optionV addSubview:temLineV];
        
        bottomH = bottomH+45;
    }
    
    UIView *addOptionV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-50, bottomH, 100, 50)];
    
    addOptionV.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addOption:)];
    [addOptionV addGestureRecognizer:ges];
    UIImageView *addImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, addOptionV.height/2-15/2, 15, 15)];
//    addImg.backgroundColor = Red_Color;
    addImg.image = [UIImage imageNamed:@"vote_add"];
    
    UILabel *addL = [[UILabel alloc]initWithFrame:CGRectMake(addImg.right, 0, 80, addOptionV.height)];
    addL.text = @"添加选项";
    addL.textColor = Main_Color;
    addL.font = NB_FONTSEIZ_BIG;
    
    [addOptionV addSubview:addImg];
    [addOptionV addSubview:addL];
    [self.headView addSubview:addOptionV];
    
    self.headView.frame = CGRectMake(10, 10, kSCREEN_WIDTH-20, addOptionV.bottom);
    self.bottomView.frame = CGRectMake(self.headView.left, self.headView.bottom+10, self.headView.width, 40);
    [self.bottomView removeAllSubViews];
    
//    //截止日期
//    UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 39.5)];
//    timeL.text = @"截止日期";
//    timeL.textColor = COLOR_BLACK_CLASS_3;
//    timeL.font = NB_FONTSEIZ_NOR;
//
//
//    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    timeBtn.frame = CGRectMake(timeL.right,0,self.bottomView.width-timeL.right,timeL.height);
//    timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    timeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//    if (!_timeStr||_timeStr.length<=0) {
//        [timeBtn setTitle:@"无截止日期" forState:UIControlStateNormal];
//        [timeBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
//
//    }
//    else{
//        [timeBtn setTitle:_timeStr forState:UIControlStateNormal];
//        [timeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
//    }
//    self.endTimeBtn = timeBtn;
//    [self.endTimeBtn addTarget:self action:@selector(endTimeClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.bottomView addSubview:timeL];
//    [self.bottomView addSubview:timeBtn];
//
//    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(timeL.left, timeL.bottom, self.bottomView.width-timeL.left, 1)];
//    bottomLine.backgroundColor = COLOR_BLACK_CLASS_0;
//    [self.bottomView addSubview:bottomLine];
    
    //投票类型
    UILabel *typeL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 39.5)];
    typeL.text = @"投票类型";
    typeL.textColor = COLOR_BLACK_CLASS_3;
    typeL.font = NB_FONTSEIZ_NOR;
    
    
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = CGRectMake(typeL.right,typeL.top,self.bottomView.width-typeL.right,typeL.height);
    typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    typeBtn.titleLabel.font = NB_FONTSEIZ_NOR;
    if (!_voteTypeStr||_voteTypeStr.length<=0) {
        [typeBtn setTitle:@"单选，默认" forState:UIControlStateNormal];
        [typeBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
        
    }
    else{
        [typeBtn setTitle:_voteTypeStr forState:UIControlStateNormal];
        [typeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
    }
    self.voteTypeBtn = typeBtn;
    [self.voteTypeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:typeL];
    [self.bottomView addSubview:typeBtn];
    
    
    CGFloat bottomViewH = self.bottomView.bottom;
    if (bottomViewH<=(kSCREEN_HEIGHT-64)) {
        bottomViewH = kSCREEN_HEIGHT-64;
    }
    
    self.scroview.contentSize = CGSizeMake(self.scroview.width, bottomViewH+30);
    

}

#pragma mark - alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - action


-(void)back{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)successBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    _voteTheme = [_voteTheme stringByReplacingOccurrencesOfString:@" " withString:@""];
    _voteTheme = [_voteTheme ew_removeSpacesAndLineBreaks];
    _voteTheme = [_voteTheme ew_removeSpaces];
    if (_voteTheme.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入投票描述" controller:self sleep:1.5];
        return;
    }
    BOOL isHaveSuccess = NO;
    NSInteger count = self.dateArray.count;
    for (int i = 0; i<count; i++) {
        VoteOptionModel *model = self.dateArray[i];
        model.voteOption = [model.voteOption stringByReplacingOccurrencesOfString:@" " withString:@""];
        model.voteOption = [model.voteOption ew_removeSpaces];
        if (model.voteOption.length<=0) {
            isHaveSuccess = NO;
            break;
        }
        else{
            isHaveSuccess = YES;
        }
    }
    if (!isHaveSuccess) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入选项" controller:self sleep:1.5];
        return;
    }
    if (selectTag == 0) {
        selectTag = 1;
    }
    else if (selectTag==1) {
        selectTag = 0;
    }
    else{
        
    }
    
//    if () {
//        <#statements#>
//    }
    
    
    
    if (self.isFistr) {
        //第一次设置，需要校验投票截止时间 -- 大于当前时间
        if (self.timeStr.length>0) {
            //1:前一个的时间早。-1:前一个的时间晚。0:一样
            NSString *currentStr = [self getCurrentTimes];
            NSInteger a = [self compareDate:self.timeStr withDate:currentStr];
            if (a!=-1) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"投票截止时间必须大于当前时间" controller:self sleep:2.0];
                return;
            }
        }
        
    }
    if (self.voteBlock) {
        self.voteBlock(_voteTheme, self.dateArray, self.timeStr, selectTag);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addOption:(UITapGestureRecognizer *)ges{
    [self.view endEditing:YES];
    VoteOptionModel *model = [[VoteOptionModel alloc]init];
    model.voteId = 0;
    model.voteOption = @"";
    NSArray *arr = @[model];
    [self.dateArray addObjectsFromArray:arr];
    [self createNoDataUI];
}

-(void)deleteOption:(UIButton *)btn{
    

    NSInteger count = self.dateArray.count-1;

    if ((selectTag==count)&&(btn.tag==selectTag)) {
        if (btn.tag==2) {
            selectTag = selectTag-1;
            NSString *str = @"多选，无限制";
            _voteTypeStr = str;
            [self.voteTypeBtn setTitle:_voteTypeStr forState:UIControlStateNormal];
            [self.voteTypeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        }else{
            selectTag = selectTag-1;
            NSString *str = [NSString stringWithFormat:@"多选，最多选%ld项",(long)selectTag];
            _voteTypeStr = str;
            [self.voteTypeBtn setTitle:_voteTypeStr forState:UIControlStateNormal];
            [self.voteTypeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        }
        
    }
    [self.dateArray removeObjectAtIndex:btn.tag];
    [self createNoDataUI];
}

-(void)endTimeClick:(UIButton *)btn{
    [self.view endEditing:YES];
    if (_timeStr&&_timeStr.length>0) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *scrollToDate = [minDateFormater dateFromString:_timeStr];
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"投票截止时间" scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            NSLog(@"选择的日期：%@",date);
            _timeStr = date;
            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
        //    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        //    datepicker.doneButtonColor = RGB(65, 188, 241);//确定按钮的颜色
        //    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
        [datepicker show];
    }
    else{
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"投票截止时间" CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            NSLog(@"选择的日期：%@",date);
            _timeStr = date;
            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
//        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
//        datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
        [datepicker show];
    }
    
}

-(void)typeBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    NSInteger count = self.dateArray.count;
    BOOL isFinish = NO;
    for (int i=0; i<count; i++) {
        VoteOptionModel *model = self.dateArray[i];
        model.voteOption = [model.voteOption stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (model.voteOption.length<=0) {
            isFinish = NO;
            break;
        }
        else{
            isFinish = YES;
        }
    }
    if (!isFinish) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填满选项" controller:self sleep:1.5];
        return;
    }
    
    WWPickerView *pickerView = [[WWPickerView alloc] init];
    NSArray *array = @[@"单选",@"多选，无限制"];
    NSMutableArray *typeArray = [[NSMutableArray alloc]initWithArray:array];
    for (int i = 0; i<count-2; i++) {
        NSString *str = [NSString stringWithFormat:@"多选，最多选%d项",i+2];
        [typeArray addObject:str];
    }
    pickerView.isNeedRow = YES;
    [pickerView setDataViewWithItem:typeArray title:@"投票类型"];
    
    [pickerView showPickView:self];
    
    //block回调
    __weak typeof (self) wself = self;
    pickerView.blockTwo = ^(NSString *selectedStr, NSInteger row) {
        _voteTypeStr = selectedStr;
        selectTag = row;
        [wself.voteTypeBtn setTitle:_voteTypeStr forState:UIControlStateNormal];
        [wself.voteTypeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
    };
}

#pragma mark - textfieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _voteTheme = textField.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _voteTheme= textField.text;
    return YES;
}

#pragma mark - textviewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    NSInteger tag = textView.tag;
    VoteOptionModel *model = self.dateArray[tag];
    model.voteOption = textView.text;
    [self.dateArray replaceObjectAtIndex:tag withObject:model];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSInteger tag = textView.tag;
    VoteOptionModel *model = self.dateArray[tag];
    model.voteOption = textView.text;
    [self.dateArray replaceObjectAtIndex:tag withObject:model];
}

//获取当前的时间

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    YSNLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case(NSOrderedAscending): ci=1;break;
            //date02比date01小
        case(NSOrderedDescending): ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: YSNLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}

#pragma mark - lazy

-(UIScrollView *)scroview{
    if (!_scroview) {
        _scroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
        _scroview.backgroundColor = RGB(241, 242, 245);
    }
    return _scroview;
}

-(UIView *)headView{
    if (!_headView) {
        
        _headView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-20, 210)];
        _headView.layer.masksToBounds = YES;
        _headView.backgroundColor = White_Color;
        _headView.layer.cornerRadius = 5;
    }
    return _headView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(self.headView.left, self.headView.bottom+10, self.headView.width, 40)];
        _bottomView.layer.masksToBounds = YES;
        _bottomView.backgroundColor = White_Color;
        _bottomView.layer.cornerRadius = 5;
    }
    return _bottomView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
