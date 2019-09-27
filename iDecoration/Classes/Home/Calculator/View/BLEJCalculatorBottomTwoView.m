//
//  BLEJCalculatorBottomTwoView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BLEJCalculatorBottomTwoView.h"
//#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHCalculatorItemsModel.h"


@interface BLEJCalculatorBottomTwoView ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;


@end

@implementation BLEJCalculatorBottomTwoView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    self.areaTF.delegate = self;
    self.unitPriceTF.delegate = self;
    self.techTextView.delegate = self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, BLEJWidth, 260);
}

- (IBAction)didClickConformBtn:(UIButton *)sender {
    
    if ([self.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入名称"];
        return;
    }
    if ([self.areaTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单位"];
        return;
    }
    if ([self.unitPriceTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单价"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.nameTF.text forKey:@"name"];
    [dic setObject:self.areaTF.text forKey:@"area"];
    
    [dic setObject:self.unitPriceTF.text forKey:@"price"];
    [dic setObject:self.techTextView.text forKey:@"supplementTech"];
    [dic setObject:self.areaLabel.text forKey:@"unitName"];
    
    
    if (self.calcaulatorTypeModel == nil) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil userInfo:dic];
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil userInfo:dic];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length) {
        
        self.phLabel.hidden = YES;
    } else {
        
        self.phLabel.hidden = NO;
    }
}

// 限制收款金额的最大值为99999999.99, 并且小数点之后最多只能有2位小数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (!self.isNeedNumKeyboard && textField == self.areaTF) {
        return YES;
    }
    
    if ([self.areaFirstLabel.text isEqualToString:@"数量"]) {// 限制不能输入小数
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        if ([futureString isEqualToString:@"0"]) {
            if (string.length == 0) {
                return YES;
            } else {
                return NO;
            }
        }
        
        [futureString insertString:string atIndex:range.location];
        if ([futureString doubleValue] > 99999999 || canChange == NO) {
            return NO;
        }
        return YES;
    }
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERSANDDIAN]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    
    if ([futureString isEqualToString:@"0"]) {
        if ([string isEqualToString:@"."] || string.length == 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    [futureString insertString:string atIndex:range.location];
    NSInteger flag = 0;
    if ([futureString doubleValue] > 99999999.99 || canChange == NO) {
        return NO;
    }
    const NSInteger limited = 2;
    for (int i = futureString.length - 1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    NSArray *arr = [textField.text componentsSeparatedByString:@"."];
    if (arr.count == 2) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        BOOL canChange = [string isEqualToString:filtered];
        
        if (canChange ==YES) {
            if (string.length == 0) {
                return YES;
            }
            
            return YES;
            
        } else {
            
            return NO;
        }
    }
    return YES;
}

- (void)setIsNeedNumKeyboard:(BOOL)isNeedNumKeyboard {
    
    _isNeedNumKeyboard = isNeedNumKeyboard;
    self.areaTF.keyboardType = isNeedNumKeyboard ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
