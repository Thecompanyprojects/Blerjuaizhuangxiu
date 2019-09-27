//
//  WallTitleCalculaterController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "WallTitleCalculaterController.h"
#import "SinglePickerView.h"


@interface WallTitleCalculaterController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *roomLengTF;
@property (weak, nonatomic) IBOutlet UITextField *roomWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *roomHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *doorWdithTF;
@property (weak, nonatomic) IBOutlet UITextField *doorHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *doorNum;
@property (weak, nonatomic) IBOutlet UITextField *windowWidth;
@property (weak, nonatomic) IBOutlet UITextField *windowHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *windowNum;
@property (weak, nonatomic) IBOutlet UITextField *titleLengthTF;
@property (weak, nonatomic) IBOutlet UITextField *titleWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *useTitleTF;
@property (weak, nonatomic) IBOutlet UITextField *totalMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *beginCalculateBtn;
@property (weak, nonatomic) IBOutlet UIButton *reCalculageBtn;
@property (weak, nonatomic) IBOutlet UIButton *standerBtn;

@property (nonatomic, strong) SinglePickerView *singlePickerView;
@property (nonatomic, strong) NSString *standerStr;

@end

@implementation WallTitleCalculaterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"墙砖计算器";
    self.view.backgroundColor = kBackgroundColor;
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    [self setScanFooterView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    self.beginCalculateBtn.backgroundColor = kMainThemeColor;
    self.reCalculageBtn.backgroundColor = kMainThemeColor;
    
    [self.standerBtn setTitle:@"100X100" forState:UIControlStateNormal];
    self.titleWidthTF.text = @"100";
    self.titleLengthTF.text = @"100";
    self.standerStr = @"0";
    self.standerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self singlePickerView];
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

- (void)loadView {
    [super loadView];
    [self separateViewAndTableView];
}
// 通过分离tableviewController的self.view和self.tableview来实现 显示pickerView位置不随tableView的位置改变
- (void)separateViewAndTableView{
    UITableView *tablieView = (UITableView *)self.view;
    self.view = [[UIView alloc] init];
    tablieView.frame = self.view.bounds;
    self.tableView = tablieView;
}
// 重写tableView的setter和getter方法实现self.tableview和self.view分离
- (void)setTableView:(UITableView *)tableView {
    [self.tableView removeFromSuperview];
    [self.view addSubview:tableView];
}
- (UITableView *)tableView {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            return (UITableView *)view;
        }
    }
    return [UITableView new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    self.singlePickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.singlePickerView.hidden = YES;
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

- (IBAction)standerBtnClicked:(id)sender {
    [self.view endEditing:YES];
    self.singlePickerView.hidden = NO;
}

- (IBAction)beginCalculateClicked:(id)sender {
    self.singlePickerView.hidden = YES;
    [self.view endEditing:YES];
    
    CGFloat roomLegth = self.roomLengTF.text.floatValue;
    CGFloat roomWidth = self.roomWidthTF.text.floatValue;
    CGFloat roomHeight = self.roomHeightTF.text.floatValue;
    
    CGFloat doorWidth = self.doorWdithTF.text.floatValue;
    CGFloat doorHeight = self.doorHeightTF.text.floatValue;
    NSInteger doorNum = self.doorNum.text.integerValue;
    
    CGFloat windowWidth = self.windowWidth.text.floatValue;
    CGFloat windowHeight = self.windowHeightTF.text.floatValue;
    NSInteger windowNum = self.windowNum.text.integerValue;
    CGFloat totalArea = ((roomLegth + roomWidth) * roomHeight * 2) - (doorWidth * doorHeight * doorNum) - (windowWidth * windowHeight * windowNum);
    CGFloat titleLength = self.titleLengthTF.text.floatValue / 1000.0;
    CGFloat titleWidth = self.titleWidthTF.text.floatValue / 1000.0;
    CGFloat stand = self.standerStr.floatValue;
    NSInteger totalTitle = 0;
    if (stand == 0) {
        if (titleLength == 0 || titleWidth == 0) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择标准规格墙砖"];
            return;
        }
        totalTitle = ceil(totalArea / (titleLength * titleWidth) * 1.05);
    } else {
        totalTitle = ceil(totalArea / stand * 1.05);
    }
    CGFloat price = self.priceTF.text.floatValue;
    CGFloat totalMoney = price * totalTitle;
    self.useTitleTF.text = [NSString stringWithFormat:@"%ld", totalTitle];
    self.totalMoneyTF.text = [NSString stringWithFormat:@"%.2f", totalMoney];
}
- (IBAction)reCalculateClicked:(id)sender {
    self.singlePickerView.hidden = YES;
    [self.view endEditing:YES];
    
    self.standerStr = @"0";
    [self.standerBtn setTitle:@"100X100" forState:UIControlStateNormal];
    self.titleWidthTF.text = @"100";
    self.titleLengthTF.text = @"100";
    
    self.roomLengTF.text = @"";
    self.roomWidthTF.text = @"";
    self.roomWidthTF.text = @"";
    self.doorWdithTF.text = @"";
    self.doorHeightTF.text = @"";
    self.doorNum.text = @"";
    self.windowWidth.text = @"";
    self.windowHeightTF.text = @"";
    self.windowNum.text = @"";
    self.priceTF.text = @"";
    self.useTitleTF.text = @"";
    self.totalMoneyTF.text = @"";
}


#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 12;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ((indexPat.section == 4 && indexPat.row == 1) || (indexPat.section == 4 && indexPat.row == 2)) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor =[UIColor clearColor];
    return v;
}


- (SinglePickerView *)singlePickerView {
    MJWeakSelf;
    if (!_singlePickerView) {
        _singlePickerView = [[SinglePickerView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305 + 44, kSCREEN_WIDTH, 305)];
        [self.view addSubview:_singlePickerView];
        _singlePickerView.dataArray = @[@"100X100", @"100X200", @"100X250", @"150X250", @"200X300", @"250X300", @"250X400", @"300X450", @"300X600", @"400X800"];
        _singlePickerView.closeBtn.hidden = NO;
        _singlePickerView.hidden = YES;
        _singlePickerView.backgroundColor = [White_Color colorWithAlphaComponent:0];
        _singlePickerView.selectBlock = ^(NSInteger index) {
            [weakSelf.standerBtn setTitle:@[@"100X100", @"100X200", @"100X250", @"150X250", @"200X300", @"250X300", @"250X400", @"300X450", @"300X600", @"400X800"][index] forState:UIControlStateNormal];
            NSString *titleStr = @[@"100X100", @"100X200", @"100X250", @"150X250", @"200X300", @"250X300", @"250X400", @"300X450", @"300X600", @"400X800"][index];
            NSArray *titleArray = [titleStr componentsSeparatedByString:@"X"];
            weakSelf.titleLengthTF.text = titleArray[0];
            weakSelf.titleWidthTF.text = titleArray[1];
            weakSelf.standerStr = @[@"0.01", @"0.02", @"0.025", @"0.0375", @"0.06", @"0.075", @"0.1", @"0.135", @"0.18", @"0.32"][index];
        };
    }
    return _singlePickerView;
}

@end
