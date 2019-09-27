//
//  BLEJTCalculatorBottomView.m
//  Calculator
//
//  Created by 赵春浩 on 17/5/4.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJTCalculatorBottomView.h"
//#import "BLEJCalculatorBudgetPriceCellModel.h"
//#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHCalculatorItemsModel.h"

@interface BLEJTCalculatorBottomView ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *phLabel;

@end

@implementation BLEJTCalculatorBottomView

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
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, BLEJWidth, 300);
}
- (IBAction)didClickConformBtn:(UIButton *)sender {
    
    if ([self.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入名称"];
        return;
    }
    if ([self.areaTF.text isEqualToString:@""] && [self.areaFirstLabel.text isEqualToString:@"数量"]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入数量"];
        return;
    }
    if ([self.areaTF.text isEqualToString:@""] && [self.areaFirstLabel.text isEqualToString:@"单位"]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单位"];
        return;
    }
    if ([self.unitPriceTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单价"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.nameTF.text forKey:@"name"];
    [dic setValue:self.areaTF.text forKey:@"area"];
    
    [dic setValue:self.unitPriceTF.text forKey:@"price"];
    [dic setValue:self.techTextView.text forKey:@"supplementTech"];
    if (self.areaLabel.text) {
        
        [dic setValue:self.areaLabel.text forKey:@"unitName"];
    } else {
        
        [dic setValue:@"" forKey:@"unitName"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil userInfo:dic];
}

- (void)setItemModel:(ZCHCalculatorItemsModel *)itemModel {
    
    _itemModel = itemModel;
    if (itemModel == nil) {
        
        self.areaTF.text = @"";
        self.priceLabel.text = @"元";
        self.unitPriceTF.text = @"";
        self.techTextView.text = @"";
        self.areaFirstLabel.text = @"数量";
        self.areaLabel.text = @"";
        
        if (self.techTextView.text.length > 0) {
            
            self.phLabel.hidden = YES;
        } else {
            
            self.phLabel.hidden = NO;
        }
        return;
    }
    
    self.nameTF.text = itemModel.supplementName;
    self.areaTF.text = @"";
    self.priceLabel.text = @"元";
    self.unitPriceTF.text = itemModel.supplementPrice;
    self.techTextView.text = itemModel.supplementTech;
    self.areaFirstLabel.text = @"数量";
    self.areaLabel.text = itemModel.supplementUnit;
    
    if (self.techTextView.text.length > 0) {
        
        self.phLabel.hidden = YES;
    } else {
        
        self.phLabel.hidden = NO;
    }
    
    
}


- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length) {
        
        self.phLabel.hidden = YES;
    } else {
        
        self.phLabel.hidden = NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (self.itemModel) {
        return NO;
    }
    return YES;
}

// 限制收款金额的最大值为99999999.99, 并且小数点之后最多只能有2位小数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (!self.isNeedNumKeyboard && textField == self.areaTF) {
        
        return YES;
    }
    
//    if ([self.areaFirstLabel.text isEqualToString:@"数量:"]) {// 限制不能输入小数
//        NSCharacterSet *cs;
//        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
//        BOOL canChange = [string isEqualToString:filtered];
//        
//        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
//        if ([futureString isEqualToString:@"0"]) {
//            if (string.length == 0) {
//                return YES;
//            } else {
//                return NO;
//            }
//        }
//        
//        [futureString insertString:string atIndex:range.location];
//        if ([futureString doubleValue] > 99999999 || canChange == NO) {
//            return NO;
//        }
//        return YES;
//    }
    
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
