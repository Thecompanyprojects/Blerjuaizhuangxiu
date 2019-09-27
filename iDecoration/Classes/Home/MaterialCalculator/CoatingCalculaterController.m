//
//  CoatingCalculaterController.m
//  iDecoration
//
//  Created by zuxi li on 2017/7/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CoatingCalculaterController.h"

@interface CoatingCalculaterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *roomLengthTF;
@property (weak, nonatomic) IBOutlet UITextField *roomWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *roomHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *doorWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *doorHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *doorNumTF;
@property (weak, nonatomic) IBOutlet UITextField *windowWidthTF;
@property (weak, nonatomic) IBOutlet UITextField *windowHeightTF;
@property (weak, nonatomic) IBOutlet UITextField *windowNumTF;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *standTF;
@property (weak, nonatomic) IBOutlet UITextField *userCoatingTF;
@property (weak, nonatomic) IBOutlet UITextField *totalMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *startCalculateBtn;
@property (weak, nonatomic) IBOutlet UIButton *reCalculateBtn;

@end

@implementation CoatingCalculaterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kBackgroundColor;
    self.title = @"涂料计算器";
//    [self setScanFooterView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    self.standTF.text = @"8.60";
    self.startCalculateBtn.backgroundColor = kMainThemeColor;
    self.reCalculateBtn.backgroundColor = kMainThemeColor;
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startCalculateBtnClicked:(id)sender {
    [self.view endEditing:YES];
    CGFloat roomLength = self.roomLengthTF.text.doubleValue;
    CGFloat roomWidth = self.roomWidthTF.text.doubleValue;
    CGFloat roomHeight = self.roomHeightTF.text.doubleValue;
    CGFloat roomArea = 2 * (roomLength + roomWidth) * roomHeight + roomWidth * roomLength;
    
    CGFloat doorWidth = self.doorWidthTF.text.doubleValue;
    CGFloat doorHeight = self.doorHeightTF.text.doubleValue;
    CGFloat doorNum = self.doorNumTF.text.doubleValue;
    CGFloat doorArea = doorWidth * doorHeight * doorNum;
    
    CGFloat windowWidth = self.windowWidthTF.text.doubleValue;
    CGFloat windowHeight = self.windowHeightTF.text.doubleValue;
    CGFloat windowNum = self.windowNumTF.text.doubleValue;
    CGFloat windowArea = windowWidth * windowHeight * windowNum;
    
    CGFloat totalArea = roomArea - doorArea - windowArea;
    
    CGFloat price = self.priceTF.text.doubleValue;
    CGFloat stand = self.standTF.text.doubleValue;
    
    CGFloat totalCoating = totalArea / stand;
    CGFloat totalMoney = totalCoating * price;
    
    self.userCoatingTF.text = [NSString stringWithFormat:@"%.2f", totalCoating];
    self.totalMoneyTF.text = [NSString stringWithFormat:@"%.2f", totalMoney];
    
}
- (IBAction)reCalculateClicked:(id)sender {
    [self.view endEditing:YES];
    self.roomLengthTF.text = @"";
    self.roomWidthTF.text = @"";
    self.roomHeightTF.text = @"";
    self.doorWidthTF.text = @"";
    self.doorHeightTF.text = @"";
    self.doorNumTF.text = @"";
    self.windowWidthTF.text = @"";
    self.windowHeightTF.text = @"";
    self.windowNumTF.text = @"";
    self.priceTF.text = @"";
    self.standTF.text = @"8.60";
    self.userCoatingTF.text = @"";
    self.totalMoneyTF.text = @"";
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

#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        return 36;
    }else if (section != 0) {
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 4) {
        NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
        if (sectionTitle == nil) {
            return nil;
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 0, kSCREEN_WIDTH - 40, 30);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = sectionTitle;
        label.numberOfLines = 2;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 36)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        label.centerY = view.centerY;
        return view;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
}
@end
