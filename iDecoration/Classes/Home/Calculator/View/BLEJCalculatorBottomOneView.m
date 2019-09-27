//
//  BLEJCalculatorBottomOneView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BLEJCalculatorBottomOneView.h"
//#import "BLEJCalculatorBudgetPriceCellModel.h"
//#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHCalculatorItemsModel.h"

@interface BLEJCalculatorBottomOneView ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation BLEJCalculatorBottomOneView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    self.areaTF.delegate = self;
    self.unitPriceTF.delegate = self;
    self.techTextView.delegate = self;
    self.areaTF.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, BLEJWidth, 280);
}

- (IBAction)didClickConformBtn:(UIButton *)sender {
    
    if ([self.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入名称"];
        return;
    }
    if ([self.areaTF.text isEqualToString:@""]) {
//        if (self.model == nil) {
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单位/数量"];
//        } else {
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入面积"];
//        }
        if (self.modelItem == nil) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单位/数量"];
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先输入您家的面积！"];
        }
        return;
    }
    if ([self.unitPriceTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单价"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.nameTF.text forKey:@"name"];
    [dic setValue:self.areaTF.text forKey:@"area"];
//    if (self.model != nil) {
    if (self.modelItem != nil) {
//        if ([self.model.type isEqualToString:@"3"] || [self.model.type isEqualToString:@"4"]) {
//            
//            [dic setValue:[NSString stringWithFormat:@"%.4f", [self.unitPriceTF.text doubleValue] / 100] forKey:@"price"];
//        } else {
//            
//            [dic setValue:self.unitPriceTF.text forKey:@"price"];
//        }
        if ([@[@"2021", @"2022", @"2023", @"2024"] containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.modelItem.templeteTypeNo]]) {
            
            [dic setValue:[NSString stringWithFormat:@"%.4f", [self.unitPriceTF.text doubleValue] / 100] forKey:@"price"];
        } else {
            
            [dic setValue:self.unitPriceTF.text forKey:@"price"];
        }
    } else {
        
        [dic setValue:self.unitPriceTF.text forKey:@"price"];
    }
    [dic setValue:self.techTextView.text forKey:@"supplementTech"];
    [dic setValue:self.areaLabel.text forKey:@"unitName"];
    
//    if (self.model == nil) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil userInfo:dic];
//    } else {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil userInfo:dic];
//    }
    
    if (self.modelItem == nil) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil userInfo:dic];
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil userInfo:dic];
    }
}

 
-(void)setModelItem:(BLRJCalculatortempletModelAllCalculatorTypes *)modelItem{
    
    _modelItem =modelItem;
    if (modelItem ==nil) {
        self.nameTF.text = @"";
        self.areaTF.text = @"";
        self.unitPriceTF.text = @"";
        self.techTextView.text = @"";
        
        self.areaFirstLabel.text = @"面积";
        self.areaLabel.text = @"平米";
        
        return;
    } else {
        NSString *str=    [NSString stringWithFormat:@"%.2lu", (unsigned long)modelItem.templeteTypeNo ];
        if (![@[@"2021", @"2022", @"2023", @"2024"] containsObject: str]) {
            self.unitPriceTF.text = [NSString stringWithFormat:@"%.2ld", [modelItem.supplementPrice integerValue]  * 100];
        } else {
            
            self.unitPriceTF.text = [NSString stringWithFormat:@"%.2ld", [modelItem.supplementPrice integerValue]  * 100];
        }
        
        self.nameTF.text = modelItem.supplementName;
        self.techTextView.text = modelItem.supplementTech;
        self.areaTF.text = [NSString stringWithFormat:@"%.2lu", (unsigned long)modelItem.number ];
        
        if ([@[@"2021", @"2022", @"2023", @"2024"] containsObject:str]) {
            if ([modelItem.supplementName isEqualToString:@"其他费用"] || [modelItem.supplementName isEqualToString:@"直接费用"]) {
                
                self.areaFirstLabel.text = @"金额:";
                self.areaLabel.text = @"元";
                self.priceFirstLabel.text = @"单价:";
                self.priceLabel.text = @"%";
            } else {
                
                self.areaFirstLabel.text = @"直接:";
                self.areaLabel.text = @"元";
                self.priceFirstLabel.text = @"单价:";
                self.priceLabel.text = @"%";
            }
        } else if ([str  isEqualToString:@"2016"]) {
            
            self.areaFirstLabel.text = @"数量:";
            self.areaLabel.text = modelItem.supplementUnit;
            self.priceFirstLabel.text = @"单价:";
            self.priceLabel.text = @"元";
        } else if ([str isEqualToString:@"2030"]) {
            
            self.areaFirstLabel.text = @"长度:";
            self.areaLabel.text = @"米";
            self.priceFirstLabel.text = @"单价:";
            self.priceLabel.text = @"元";
        } else if ([str integerValue] > 0) {
            
            self.areaFirstLabel.text = @"面积:";
            self.areaLabel.text = @"平米";
            self.priceFirstLabel.text = @"单价:";
            self.priceLabel.text = @"元";
        } else {
            
            self.areaFirstLabel.text = @"数量:";
            self.areaLabel.text = modelItem.supplementUnit;
            self.priceFirstLabel.text = @"单价:";
            self.priceLabel.text = @"元";
        }
    }
    
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
    
    return NO;
}

// 限制收款金额的最大值为99999999.99, 并且小数点之后最多只能有2位小数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //  && textField == self.areaTF
//    if (!self.isNeedNumKeyboard) {
//        
//        return YES;
//    }
    
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
    
    if ([self.modelItem.supplementName isEqualToString:@"其他费用"] || [self.modelItem.supplementName isEqualToString:@"直接费用"] || [self.areaFirstLabel.text containsString:@"直接:"]) {
        return NO;
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

//- (void)setIsNeedNumKeyboard:(BOOL)isNeedNumKeyboard {
//    
//    _isNeedNumKeyboard = isNeedNumKeyboard;
//    
//    
//    self.areaTF.keyboardType = isNeedNumKeyboard ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
