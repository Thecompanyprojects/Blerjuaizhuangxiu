//
//  WallPaperCalculatorController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "WallPaperCalculatorController.h"

@interface WallPaperCalculatorController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *homeLengthTF;
@property (weak, nonatomic) IBOutlet UITextField *homeWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *homeHeightTF;

@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *standerTF;
@property (weak, nonatomic) IBOutlet UITextField *paperNumTF;
@property (weak, nonatomic) IBOutlet UITextField *totalMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *beginCalculateBtn;
@property (weak, nonatomic) IBOutlet UIButton *reCalculateBtn;

@end

@implementation WallPaperCalculatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"壁纸计算器";
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
//    [self setScanFooterView];
    self.paperNumTF.userInteractionEnabled = NO;
    self.totalMoneyTF.userInteractionEnabled = NO;
    self.beginCalculateBtn.backgroundColor = kMainThemeColor;
    self.reCalculateBtn.backgroundColor = kMainThemeColor;
    self.standerTF.text = @"5.20";
    
    self.homeLengthTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.homeWidthTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.homeHeightTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.standerTF.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setScanFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skimming"]];
    [footerView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(20, 10));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    [footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV);
        make.left.equalTo(imageV.mas_right).equalTo(5);
    }];
    label.text = self.dispalyNum;
}

- (IBAction)beginCalculateClicked:(id)sender {
    [self.view endEditing:YES];
    CGFloat area = 0;
    NSInteger paperNum = 0;
    CGFloat price = 0;
    if ([self.homeLengthTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入房间长度"];
        return;
    }
    // 宽和高没有
    if ([self.homeWidthTF.text isEqualToString:@""] && [self.homeHeightTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入房间宽度或高度"];
        return;
    }
    // 宽没有
    if ([self.homeWidthTF.text isEqualToString:@""]) {
        CGFloat homeHeight = self.homeHeightTF.text.floatValue;
        CGFloat homeLength = self.homeLengthTF.text.floatValue;
        area = homeHeight * homeLength;
    } else if ([self.homeHeightTF.text isEqualToString:@""]) {
        // 高没有
        CGFloat homeWidth = self.homeWidthTF.text.floatValue;
        CGFloat homeLength = self.homeLengthTF.text.floatValue;
        area = homeWidth * homeLength;
    } else {
        CGFloat homeHeight = self.homeHeightTF.text.floatValue;
        CGFloat homeLength = self.homeLengthTF.text.floatValue;
        CGFloat homeWidth = self.homeWidthTF.text.floatValue;
        area = homeHeight * (homeWidth + homeLength) * 2;
    }
    paperNum =  ceil(area / self.standerTF.text.floatValue);
    price = paperNum * self.priceTF.text.floatValue;
    
    self.paperNumTF.text = [NSString stringWithFormat:@"%ld", paperNum];
    self.totalMoneyTF.text = [NSString stringWithFormat:@"%.2f", price];
   
}

- (IBAction)reCalculateClicked:(id)sender {
    [self.view endEditing:YES];
    self.homeLengthTF.text = @"";
    self.homeWidthTF.text = @"";
    self.homeHeightTF.text = @"";
    self.priceTF.text = @"";
    self.standerTF.text = @"5.20";
    self.paperNumTF.text = @"";
    self.totalMoneyTF.text = @"";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        
        if (single == '0'&& [textField.text isEqualToString:@"0"]) {
            [self.view endEditing:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，不能连续输入两个0"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
            
        }
        
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    [self.view endEditing:YES];
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
                
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [self.view endEditing:YES];
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt=range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        [self.view endEditing:YES];
                        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self.view endEditing:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 12;
    }
    if (section == 2) {
        return 36;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
        if (sectionTitle == nil) {
            return nil;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 0, kSCREEN_WIDTH - 40, 30);
//        label.backgroundColor = [UIColor clearColor];
        label.backgroundColor = kBackgroundColor;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = sectionTitle;
        label.numberOfLines = 2;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 36)];
//        view.backgroundColor = [UIColor clearColor];
        view.backgroundColor = kBackgroundColor;
        [view addSubview:label];
        label.centerY = view.centerY;
        return view;
    } else {
        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor clearColor];
        view.backgroundColor = kBackgroundColor;
        return view;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ((indexPat.section == 2 && indexPat.row == 1) || indexPat.section == 3) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
}


@end
