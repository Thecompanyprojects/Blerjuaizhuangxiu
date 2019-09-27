//
//  ZCHNewProductCouponController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHNewProductCouponController.h"
#import "WSDatePickerView.h"

@interface ZCHNewProductCouponController ()<UITextFieldDelegate, WSDatePickerViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cashCouponNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productLogoView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UITextField *productCouponTF;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (weak, nonatomic) IBOutlet UITextField *productNameTF;
@property (weak, nonatomic) IBOutlet UITextField *beginTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIView *beginView;
@property (weak, nonatomic) IBOutlet UIView *endView;

@property (strong, nonatomic) NSData *imageData;
@property (copy, nonatomic) NSString *imageUrl;

@end

@implementation ZCHNewProductCouponController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"礼品券";
    self.productCouponTF.delegate = self;
    self.countTF.delegate = self;
    self.productNameTF.delegate = self;
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
    
    self.productLogoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapTopView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTopIconView:)];
    [self.productLogoView addGestureRecognizer:tapTopView];
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
    
    if (textField == self.productCouponTF) {
        self.cashCouponNameLabel.text = textField.text;
    }
    return YES;
}


- (IBAction)didClickFinishBtn:(UIButton *)sender {
    
    if (!self.imageUrl || [self.imageUrl isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请上传礼品券封面图"];
        return;
    }
    if ([self.productCouponTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入礼品券名称"];
        return;
    }
    if ([self.countTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入发行数量"];
        return;
    }
    if ([self.productNameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入商品名称"];
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
                            @"couponName" : self.productCouponTF.text,
                            @"startDate" : self.beginTimeTF.text,
                            @"endDate" : self.endTimeTF.text,
                            @"numbers" : self.countTF.text,
                            @"price" : @"",
                            @"exchangeAddress" : self.addressTF.text,
                            @"companyId" : self.companyId,
                            @"type" : @"1", // 类型（0:红包，1:礼品券）
                            @"merchandName" : self.productNameTF.text,
                            @"agencyId" : @(agencyid),
                            @"merchandPhoto" : self.imageUrl
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

#pragma mark - 点击顶部图片换图片(相机 相册)
- (void)didClickTopIconView:(UITapGestureRecognizer *)tap {
    
    // 先结束页面的编辑状态
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"相机", nil];
    actionSheet.tag = 10001;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 && [TTHelper checkPhotoLibraryAuthorizationStatus]) {
        
        //初始化UIImagePickerController
        UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc]init];
        // 获取方式1：通过相册（呈现全部相册) UIImagePickerControllerSourceTypePhotoLibrary
        // 获取方式2，通过相机              UIImagePickerControllerSourceTypeCamera
        // 获取方法3，通过相册（呈现全部图片）UIImagePickerControllerSourceTypeSavedPhotosAlbum
        pickerImageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 允许编辑，即放大裁剪
        pickerImageVC.allowsEditing = YES;
        // 自代理
        pickerImageVC.delegate = self;
        // 页面跳转
        [self presentViewController:pickerImageVC animated:YES completion:nil];
    } else if (buttonIndex == 1 && [TTHelper checkCameraAuthorizationStatus]) {
        // 通过相机的方式
        UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc] init];
        // 获取方式:通过相机
        pickerImageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImageVC.allowsEditing = YES;
        pickerImageVC.delegate = self;
        pickerImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:pickerImageVC animated:YES completion:^{
            
            [pickerImageVC.view layoutIfNeeded];
        }];
    } else {
        
    }
}

#pragma mark - PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageData = [NSObject imageData:chooseImage];
    
    if ([self.imageData length] > 0) {
        self.imageData = [GTMBase64 encodeData:self.imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:self.imageData encoding:NSUTF8StringEncoding];
    
    [self uploadImageWithBase64Str:imageStr];
}

//取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 上传图片
- (void)uploadImageWithBase64Str:(NSString *)base64Str {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UploadImageApi *uploadApi = [[UploadImageApi alloc] initWithImgStr:base64Str type:@"png"];
    [self.view hudShow:@"上传图片中..."];
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self.view textHUDHiddle];
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            
            self.imageUrl = dic[@"imageUrl"];
            self.productLogoView.image = [UIImage imageWithData:[GTMBase64 decodeData:self.imageData]];
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"图片上传失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view textHUDHiddle];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"图片上传失败, 请稍后重试"];
    }];
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
