//
//  CompanyMarginNextController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CompanyMarginNextController.h"

#import "CompanyMarginPayController.h"


@interface CompanyMarginNextController ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopCon;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;



@end

@implementation CompanyMarginNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgViewTopCon.constant = self.navigationController.navigationBar.bottom + 5;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = YES;
    
    self.moneyTF.delegate = self;
    
    isHaveDian = NO;
    
    switch (self.marginType) {
        case MarginTypePayment: // 充值
        {
            self.title = @"充值";
            self.titleLabel.hidden = NO;
            self.titleLabel.text = @"充值金额最低￥200";
        }
            break;
        case MarginTypeMakeMoney: // 提现
        {
            self.title = @"提现";
            self.titleLabel.text = @"提现金额最低￥30";
            self.titleLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isHaveDian = NO;
    } else {
        isHaveDian = YES;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                if(single == '.')
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，第一个数字不能为小数点!"];
                    [self.view endEditing:YES];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0')
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，第一个数字不能为0!"];
                    [self.view endEditing:YES];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                }else{
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，您已经输入过小数点了!"];
                    [self.view endEditing:YES];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，您最多输入两位小数!"];
                        [self.view endEditing:YES];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，您输入的格式不正确!"];
            [self.view endEditing:YES];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
}


- (IBAction)nextAction:(id)sender {
    [self.view endEditing:YES];
    switch (self.marginType) {
        case MarginTypePayment: // 充值
        {
            if (self.moneyTF.text.doubleValue < 200) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，充值金额最低￥200哦！"];
                return;
            }
            CompanyMarginPayController *payController = [[CompanyMarginPayController alloc] initWithNibName:@"CompanyMarginPayController" bundle:nil];
            payController.companyId = self.companyId;
            payController.payMoney = self.moneyTF.text;
            MJWeakSelf;
            payController.successBlock = ^{
                if (weakSelf.backSuccessBlock) {
                    weakSelf.backSuccessBlock();
                }
            };
            [self.navigationController pushViewController:payController animated:YES];
        }
            break;
        case MarginTypeMakeMoney: // 提现
        {
            
        }
            break;
        default:
            break;
    }
}


@end
