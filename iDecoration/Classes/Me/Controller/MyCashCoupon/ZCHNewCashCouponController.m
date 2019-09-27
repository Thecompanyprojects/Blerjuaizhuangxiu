//
//  ZCHNewCashCouponController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHNewCashCouponController.h"
#import "WSDatePickerView.h"

@interface ZCHNewCashCouponController ()<UITextFieldDelegate, WSDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cashCouponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UITextField *cashCouponTF;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *beginTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIView *beginView;
@property (weak, nonatomic) IBOutlet UIView *endView;

@end

@implementation ZCHNewCashCouponController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"代金券";
    self.cashCouponTF.delegate = self;
    self.countTF.delegate = self;
    self.priceTF.delegate = self;
    self.beginTimeTF.delegate = self;
    self.endTimeTF.delegate = self;
    self.addressTF.delegate = self;
    
    self.beginTimeTF.userInteractionEnabled = NO;
    self.beginView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBeginView:)];
    [self.beginView addGestureRecognizer:tap];
    
    self.endTimeTF.userInteractionEnabled = NO;
    self.endView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapEnd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickEndView:)];
    [self.endView addGestureRecognizer:tapEnd];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    
}

- (void)didClickBeginView:(UITapGestureRecognizer *)tap {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.tableView.height = BLEJHeight - weakSelf.navigationController.navigationBar.bottom - 300;
    }];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
//    CGRect rect = [cell convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
//    NSLog(@"%@", NSStringFromCGRect(rect));
    
    [self showTimeWithTF:self.beginTimeTF];
    self.endTimeTF.text = @"";
    self.timeLabel.text = [NSString stringWithFormat:@"%@", self.beginTimeTF.text];
}

- (void)didClickEndView:(UITapGestureRecognizer *)tap {
    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    if ([self.beginTimeTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先设置生效时间"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.tableView.height = BLEJHeight - weakSelf.navigationController.navigationBar.bottom - 300;
    }];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self showTimeWithTF:self.endTimeTF];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
//    if (textField == self.beginTimeTF) {
//        [textField endEditing:YES];
//        [self showTimeWithTF:textField];
//        return NO;
//    }
//    if (textField == self.endTimeTF) {
//        [textField endEditing:YES];
//        [self showTimeWithTF:textField];
//        return NO;
//    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.cashCouponTF) {
        self.cashCouponNameLabel.text = textField.text;
    }
    
    if (textField == self.priceTF) {
        self.priceLabel.text = textField.text;
    }
    
    return YES;
}


- (IBAction)didClickFinishBtn:(UIButton *)sender {
    
    if ([self.cashCouponTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入代金券名称"];
        return;
    }
    if ([self.countTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入发行数量"];
        return;
    }
    if ([self.priceTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入面值"];
        return;
    }
    if ([self.beginTimeTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请设置生效时间"];
        return;
    }
    if ([self.endTimeTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请设置过期时间"];
        return;
    }
    if ([self.addressTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入兑换地址"];
        return;
    }
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *apiStr = [BASEURL stringByAppendingString:@"cblejcoupon/add.do"];
    NSDictionary *param = @{
                            @"couponName" : self.cashCouponTF.text,
                            @"startDate" : self.beginTimeTF.text,
                            @"endDate" : self.endTimeTF.text,
                            @"numbers" : self.countTF.text,
                            @"price" : self.priceTF.text,
                            @"exchangeAddress" : self.addressTF.text,
                            @"companyId" : self.companyId,
                            @"type" : @"0", // 类型（0:红包，1:礼品券）
                            @"merchandName" : @"",
                            @"agencyId" : @(agencyid),
                            @"merchandPhoto" : @""
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            if (self.block) {
                self.block();
            }
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存失败"];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
    
}

#pragma mark -
- (void)showTimeWithTF:(UITextField *)TF {
    
    self.view.height = BLEJHeight - 20 - 270;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.view endEditing:YES];
//        if (_startTimeStr&&_startTimeStr.length>0) {
//            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
//            [minDateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
//            NSDate *scrollToDate = [minDateFormater dateFromString:_startTimeStr];
//
//            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"活动开始时间" scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
//
//                NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
//                //            NSLog(@"选择的日期：%@",date);
//                _startTimeStr = date;
//                //            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
//                //            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
//                [self.tableView reloadData];
//
//            }];
//            datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
//            //    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
//            //    datepicker.doneButtonColor = RGB(65, 188, 241);//确定按钮的颜色
//            //    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
//            [datepicker show];
//        }
//        else{
    __weak typeof(self) weakSelf = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay title:@"选择时间" CompleteBlock:^(NSDate *selectDate) {
                
//                self.view.height = BLEJHeight;
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                if (TF == weakSelf.endTimeTF) {
                    
                    NSInteger result = [weakSelf compareDate:weakSelf.beginTimeTF.text withDate:date];
                    if (result == -1 || result == 0) {
                        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"过期时间必须超过生效时间"];
                        return;
                    } else {
                        TF.text = date;
                    }
                } else {
                    TF.text = date;
                }
                
                if (TF == weakSelf.endTimeTF) {
                    
                    NSString *beginStr = [weakSelf.beginTimeTF.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    NSString *endStr = [weakSelf.endTimeTF.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@-%@", beginStr, endStr];
                } else {
                    
                    NSString *beginStr = [weakSelf.beginTimeTF.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@", beginStr];
                }
                
                
//                _startTimeStr = date;
//                [self.tableView reloadData];
                //            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
                //            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                
            }];
            datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
            datepicker.delegate = self;
            //        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
            //        datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
            [datepicker show];
//        }
    
}

#pragma mark - WSDatePickerViewDelegate
- (void)didClickCancelBtn {
    
    self.view.height = BLEJHeight;
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//比较两个日期的大小  日期格式为2016-08-14
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate {
    
    NSInteger aa = 0;
    NSComparisonResult result = [aDate compare:bDate];
    if (result == NSOrderedSame) {
        
        aa = 0;//相等
    } else if (result == NSOrderedAscending) {
        
        aa = 1;//bDate比aDate大
    } else if (result == NSOrderedDescending) {
        
        aa = -1;//bDate比aDate小
    }
    return aa;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
