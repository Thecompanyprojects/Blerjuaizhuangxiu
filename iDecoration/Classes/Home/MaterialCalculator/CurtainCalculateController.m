//
//  CurtainCalculateController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CurtainCalculateController.h"
#import "SinglePickerView.h"

@interface CurtainCalculateController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *curtainHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *curtainWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;

@property (weak, nonatomic) IBOutlet UITextField *useClothTF;
@property (weak, nonatomic) IBOutlet UITextField *totalMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *beginCalculateBtn;
@property (weak, nonatomic) IBOutlet UIButton *reCalculateBtn;

@property (weak, nonatomic) IBOutlet UILabel *clothWidthLb;
@property (weak, nonatomic) IBOutlet UILabel *clothWidhUnitLb;
@property (weak, nonatomic) IBOutlet UIButton *clothWidthBtn;

@property (nonatomic, strong) SinglePickerView *singlePickerView;

@property (nonatomic, strong) NSString *clothWidthStr;
@end

@implementation CurtainCalculateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"窗帘计算器";
//    [self setScanFooterView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.view.backgroundColor = kBackgroundColor;
    self.beginCalculateBtn.backgroundColor = kMainThemeColor;
    self.reCalculateBtn.backgroundColor = kMainThemeColor;
    self.clothWidthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.clothWidthBtn setTitle:@"1.5" forState:UIControlStateNormal];
    self.clothWidthStr = @"1.5";
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.singlePickerView.hidden = YES;
    [self.view endEditing:YES];
}

- (IBAction)clothBtnClicked:(id)sender {
    [self.view endEditing:YES];
    self.singlePickerView.hidden = NO;
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


#pragma mark - NormalMethod
- (IBAction)beginCalculateClicked:(id)sender {
    [self.view endEditing:YES];
    CGFloat curtainHeight = self.curtainHeightTF.text.floatValue;
    CGFloat curtainWidth = self.curtainWidthTF.text.floatValue;
    CGFloat price = self.priceTF.text.floatValue;
    CGFloat totalCloth = 0;
    if ([self.curtainHeightTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入窗帘高度"];
        return;
    }
    if ([self.curtainWidthTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入窗帘宽度"];
        return;
    }
    if ([self.clothWidthStr isEqualToString:@"1.5"]) {
        totalCloth = ceil(curtainWidth * 2 /1.5) * (curtainHeight + 0.2);
    }else if([self.clothWidthStr isEqualToString:@"2.8"]) {
        totalCloth = curtainWidth * 2;
    }
    
    CGFloat totalMoney = totalCloth * price;
    self.useClothTF.text = [NSString stringWithFormat:@"%.2f", totalCloth];
    self.totalMoneyTF.text = [NSString stringWithFormat:@"%.2f", totalMoney];
}
- (IBAction)reCalculateClicked:(id)sender {
    [self.view endEditing:YES];
    self.curtainWidthTF.text = @"";
    self.curtainHeightTF.text = @"";
    self.priceTF.text = @"";
    self.useClothTF.text = @"";
    self.totalMoneyTF.text = @"";
    self.clothWidthStr = @"1.5";
    [self.clothWidthBtn setTitle:@"1.5" forState:UIControlStateNormal];
}


#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 12;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.backgroundColor = kBackgroundColor;
    return v;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ((indexPat.section == 2 && indexPat.row == 1) || (indexPat.section == 2 && indexPat.row == 2)) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
}

- (SinglePickerView *)singlePickerView {
    MJWeakSelf;
    if (!_singlePickerView) {
        _singlePickerView = [[SinglePickerView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305 + 44, kSCREEN_WIDTH, 305)];
        [self.view addSubview:_singlePickerView];
        _singlePickerView.dataArray = @[@"1.5 米", @"2.8 米"];
        _singlePickerView.closeBtn.hidden = NO;
        _singlePickerView.hidden = YES;
        _singlePickerView.backgroundColor = [White_Color colorWithAlphaComponent:0];
        _singlePickerView.selectBlock = ^(NSInteger index) {
            [weakSelf.clothWidthBtn setTitle:@[@"1.5", @"2.8"][index] forState:UIControlStateNormal];
            weakSelf.clothWidthStr = @[@"1.5", @"2.8"][index];
        };
    }
    return _singlePickerView;
}

@end
