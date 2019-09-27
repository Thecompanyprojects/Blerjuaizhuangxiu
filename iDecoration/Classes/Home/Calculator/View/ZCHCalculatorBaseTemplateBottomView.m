//
//  ZCHCalculatorBaseTemplateBottomView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCalculatorBaseTemplateBottomView.h"
//#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHCalculatorItemsModel.h"

@interface ZCHCalculatorBaseTemplateBottomView ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *phLabel;

@end

@implementation ZCHCalculatorBaseTemplateBottomView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    self.unitPriceTF.delegate = self;
    self.techTextView.delegate = self;
}

//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, BLEJWidth, 230);
//}

- (IBAction)didClickConformBtn:(UIButton *)sender {
    
    if ([self.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入名称"];
        return;
    }

    if ([self.unitPriceTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单价"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.nameTF.text forKey:@"name"];
    [dic setObject:self.unitPriceTF.text forKey:@"price"];
    [dic setObject:self.techTextView.text forKey:@"supplementTech"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickCalculatorBaseBottomViewConfirmBtnReplace" object:nil userInfo:dic];
}

//- (void)setBaseAndSuppleListModelFromBaseTemplate:(BLEJCalculatorBaseAndSuppleListModel *)baseAndSuppleListModelFromBaseTemplate {
//    
//    if (_baseAndSuppleListModelFromBaseTemplate != baseAndSuppleListModelFromBaseTemplate) {
//        _baseAndSuppleListModelFromBaseTemplate = baseAndSuppleListModelFromBaseTemplate;
//    }
//    self.nameTF.text = baseAndSuppleListModelFromBaseTemplate.supplementName;
//    if (self.isShowPercentage) {
//        
//        self.unitPriceTF.text = [NSString stringWithFormat:@"%.2f", [baseAndSuppleListModelFromBaseTemplate.supplementPrice doubleValue] * 100];
//    } else {
//        
//        self.unitPriceTF.text = baseAndSuppleListModelFromBaseTemplate.supplementPrice;
//    }
//    self.techTextView.text = baseAndSuppleListModelFromBaseTemplate.supplementTech;
//    
//    if (self.techTextView.text.length > 0) {
//        
//        self.phLabel.hidden = YES;
//    } else {
//        
//        self.phLabel.hidden = NO;
//    }
//}
-(void)setModel:(BLRJCalculatortempletModelAllCalculatorTypes *)model{
    
    _model =model;
    self.nameTF.text = model.supplementName;
    if (self.isShowPercentage) {
        
        self.unitPriceTF.text = [NSString stringWithFormat:@"%ld",  [model.supplementPrice integerValue]*100  ];
    } else {
        
        self.unitPriceTF.text = [NSString stringWithFormat:@"%.2ld", (long)[model.supplementPrice integerValue]];
    }
    self.techTextView.text = model.supplementTech;
    
    if (self.techTextView.text.length > 0) {
        
        self.phLabel.hidden = YES;
    } else {
        
        self.phLabel.hidden = NO;
    }
}



- (void)setIsShowPercentage:(BOOL)isShowPercentage {
    
    _isShowPercentage = isShowPercentage;
//    if (isShowPercentage) {
//        
//        self.unitPriceTF.text = [NSString stringWithFormat:@"%.2f", [self.baseAndSuppleListModelFromBaseTemplate.supplementPrice doubleValue] * 100];
//    } else {
//        
//        self.unitPriceTF.text = self.baseAndSuppleListModelFromBaseTemplate.supplementPrice;
//    }
    if (isShowPercentage) {
        
        self.unitPriceTF.text = [NSString stringWithFormat:@"%.2ld", [self.model.supplementPrice integerValue] * 100];
    } else {
        
        self.unitPriceTF.text =[NSString stringWithFormat:@"%.2ld", (long)[self.model.supplementPrice integerValue] ];
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
