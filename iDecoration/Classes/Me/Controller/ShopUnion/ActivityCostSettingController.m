//
//  ActivityCostSettingController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ActivityCostSettingController.h"

@interface ActivityCostSettingController ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopCon;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *costTF;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@end

@implementation ActivityCostSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名费用";
    self.finishBtn.layer.cornerRadius = 7;
    self.finishBtn.layer.masksToBounds = YES;
    self.bgViewTopCon.constant = kNaviBottom;
    
    self.costTF.delegate = self;
    isHaveDian = NO;
    
    if (self.cost.doubleValue > 0) {
        self.costTF.text = self.cost;
    }
    if (self.costName.length > 0) {
        self.nameTF.text = self.costName;
    }
}

- (IBAction)finishiAction:(id)sender {
    if ([self.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动名称"];
        return;
    }
    if ([self.costTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动费用"];
        return;
    }
    
    if (self.finishBlock) {
        self.finishBlock(self.nameTF.text, self.costTF.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
//                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"亲，第一个数字不能为0!"];
//                    [self.view endEditing:YES];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
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



@end
