//
//  BLEJBudgetGuideCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetGuideCell.h"
#import "IQUIView+Hierarchy.h"
#import "BLEJBudgetPriceController.h"
@interface BLEJBudgetGuideCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *areaBgView;
@property (weak, nonatomic) IBOutlet UIView *oneBgView;
@property (weak, nonatomic) IBOutlet UIView *twoBgView;
@property (weak, nonatomic) IBOutlet UILabel *myHomeAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *squarMetreLabel;

@property (weak, nonatomic) IBOutlet UILabel *sittingRoomLable;
@property (weak, nonatomic) IBOutlet UILabel *bedroomLable;
@property (weak, nonatomic) IBOutlet UILabel *diningRoomLable;
@property (weak, nonatomic) IBOutlet UILabel *kitchenLable;
@property (weak, nonatomic) IBOutlet UILabel *bathroomLable;
@property (weak, nonatomic) IBOutlet UILabel *balconyLable;

@end

@implementation BLEJBudgetGuideCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.areaTF.delegate = self;
    self.phoneNumTF.delegate = self;
    self.areaBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.oneBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.twoBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    #warning 后台拖后腿 后续版本增加该功能 暂时注释
//    [GetImageVerificationCode setImageVerificationCodeToImageView:self.imageViewImageVerificationCode];
    self.sendTestCodeBtn.alpha = 0.4;
    [self.sendTestCodeBtn setEnabled:NO];
    
    UITapGestureRecognizer *tapArea = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickMyHomeAreaLabel:)];
    [self.myHomeAreaLabel addGestureRecognizer:tapArea];
    
    UITapGestureRecognizer *tapSquar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSquarMetreLabel:)];
    [self.squarMetreLabel addGestureRecognizer:tapSquar];
    
    UITapGestureRecognizer *sittingRoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSittingRoomLabel:)];
    [self.sittingRoomLable addGestureRecognizer:sittingRoom];
    UITapGestureRecognizer *bedroom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBedroomLabel:)];
    [self.bedroomLable addGestureRecognizer:bedroom];
    UITapGestureRecognizer *diningRoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickDiningRoomLabel:)];
    [self.diningRoomLable addGestureRecognizer:diningRoom];
    UITapGestureRecognizer *kitchen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickKitchenLabel:)];
    [self.kitchenLable addGestureRecognizer:kitchen];
    UITapGestureRecognizer *bathroom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBathroomLabel:)];
    [self.bathroomLable addGestureRecognizer:bathroom];
    UITapGestureRecognizer *balcony = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBalconyLabel:)];
    [self.balconyLable addGestureRecognizer:balcony];
    
}





#pragma mark  生成预算
    
  
    
    
         
#pragma mark - 点击下拉按钮或者数字按钮
- (IBAction)didClickBottomPullOrNumberBtn:(UIButton *)sender {
    
    [self resignFirstResponder];
    if (self.areaTF.text == nil || [self.areaTF.text isEqualToString:@""]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先输入您家的面积"];
        return;
    }
    NSArray *countArr;
    double houseArea = [self.areaTF.text doubleValue];
    if (houseArea <= 80) {// 客厅 卧室 餐厅 厨房 卫生间 阳台
        
        countArr = @[@(3), @(2), @(2), @(2), @(1), @(5)];
    }
    if (houseArea <= 120 && houseArea > 80) {
        
//        countArr = @[@(3), @(3), @(2), @(2), @(2), @(5)];
        countArr = @[@(3), @(4), @(2), @(2), @(3), @(5)];
    }
    if (houseArea <= 180 && houseArea > 120) {
        
//        countArr = @[@(3), @(5), @(2), @(2), @(2), @(5)];
        countArr = @[@(3), @(6), @(2), @(2), @(4), @(5)];
    }
    if (houseArea > 180) {
        
//        countArr = @[@(3), @(8), @(2), @(2), @(3), @(5)];
        countArr = @[@(3), @(8), @(2), @(2), @(5), @(5)];
    }
    
    
    // 1001/2001 客厅
    // 1002/2002 卧室
    // 1003/2003 餐厅
    // 1004/2004 厨房
    // 1005/2005 卫浴
    // 1006/2006 阳台
    switch (sender.tag) {
        case 1001:
        case 2001:// 客厅
            
            self.currentBtn = self.sittingRoomBtn;
            if ([self.BLEJBudgetGuideCellDelegate respondsToSelector:@selector(didClickSelectRoomCount:andTitle:andCurrentIndex:andShowZero:)]) {
                
                if (houseArea <= 80) {
                    
                    [self.BLEJBudgetGuideCellDelegate didClickSelectRoomCount:[countArr[0] integerValue] andTitle:@"   客厅" andCurrentIndex:[self.sittingRoomBtn.titleLabel.text integerValue] andShowZero:1];
                } else {
                    
                    [self.BLEJBudgetGuideCellDelegate didClickSelectRoomCount:[countArr[0] integerValue] andTitle:@"   客厅" andCurrentIndex:[self.sittingRoomBtn.titleLabel.text integerValue] andShowZero:0];
                }
            }
            break;
        case 1002:
        case 2002:// 卧室
            
            self.currentBtn = self.bedroomBtn;
            if ([self.BLEJBudgetGuideCellDelegate respondsToSelector:@selector(didClickSelectRoomCount:andTitle:andCurrentIndex:andShowZero:)]) {
                
                [self.BLEJBudgetGuideCellDelegate didClickSelectRoomCount:[countArr[1] integerValue] andTitle:@"   卧室" andCurrentIndex:[self.bedroomBtn.titleLabel.text integerValue] andShowZero:0];
            }
            break;
        case 1003:
        case 2003:// 餐厅
            
            self.currentBtn = self.diningRoomBtn;
            if ([self.BLEJBudgetGuideCellDelegate respondsToSelector:@selector(didClickSelectRoomCount:andTitle:andCurrentIndex:andShowZero:)]) {
                
                [self.BLEJBudgetGuideCellDelegate didClickSelectRoomCount:[countArr[2] integerValue] andTitle:@"   餐厅" andCurrentIndex:[self.diningRoomBtn.titleLabel.text integerValue] andShowZero:1];
            }
            break;
        case 1004:
        case 2004:// 厨房
            
            self.currentBtn = self.kitchenBtn;
            if ([self.BLEJBudgetGuideCellDelegate respondsToSelector:@selector(didClickSelectRoomCount:andTitle:andCurrentIndex:andShowZero:)]) {
                
                [self.BLEJBudgetGuideCellDelegate didClickSelectRoomCount:[countArr[3] integerValue] andTitle:@"   厨房" andCurrentIndex:[self.kitchenBtn.titleLabel.text integerValue] andShowZero:1];
            }
            break;
        case 1005:
        case 2005:// 卫生间
            
            self.currentBtn = self.bathroomBtn;
            if ([self.BLEJBudgetGuideCellDelegate respondsToSelector:@selector(didClickSelectRoomCount:andTitle:andCurrentIndex:andShowZero:)]) {
                
                [self.BLEJBudgetGuideCellDelegate didClickSelectRoomCount:[countArr[4] integerValue] andTitle:@"   卫浴" andCurrentIndex:[self.bathroomBtn.titleLabel.text integerValue] andShowZero:0];
            }
            break;
        case 1006:
        case 2006:// 阳台
            
            self.currentBtn = self.balconyBtn;
            if ([self.BLEJBudgetGuideCellDelegate respondsToSelector:@selector(didClickSelectRoomCount:andTitle:andCurrentIndex:andShowZero:)]) {
                
                [self.BLEJBudgetGuideCellDelegate didClickSelectRoomCount:[countArr[5] integerValue] andTitle:@"   阳台" andCurrentIndex:[self.balconyBtn.titleLabel.text integerValue] andShowZero:1];
            }
            break;
        default:
            break;
    }
    
}



//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//    if (textField == self.areaTF) {
//        
//        if (textField.isAskingCanBecomeFirstResponder == YES) {
//            
//            [self.sittingRoomBtn setTitle:@"1" forState:UIControlStateNormal];
//            [self.bedroomBtn setTitle:@"1" forState:UIControlStateNormal];
//            [self.diningRoomBtn setTitle:@"1" forState:UIControlStateNormal];
//            [self.kitchenBtn setTitle:@"1" forState:UIControlStateNormal];
//            [self.bathroomBtn setTitle:@"1" forState:UIControlStateNormal];
//            [self.balconyBtn setTitle:@"1" forState:UIControlStateNormal];
//        } else {
//            
//        }
//    }
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.areaTF) {
        [self.sittingRoomBtn setTitle:@"1" forState:UIControlStateNormal];
        [self.bedroomBtn setTitle:@"1" forState:UIControlStateNormal];
        [self.diningRoomBtn setTitle:@"1" forState:UIControlStateNormal];
        [self.kitchenBtn setTitle:@"1" forState:UIControlStateNormal];
        [self.bathroomBtn setTitle:@"1" forState:UIControlStateNormal];
        [self.balconyBtn setTitle:@"1" forState:UIControlStateNormal];
    }
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.phoneNumTF) {
        
        if (textField.text.length == 11) {
            
            if ([self isCorrectPhoneNumWithPhoneNum:textField.text]) {
                self.sendTestCodeBtn.alpha = 1;
                [self.sendTestCodeBtn setEnabled:YES];
            } else {
                self.sendTestCodeBtn.alpha = 0.4;
                [self.sendTestCodeBtn setEnabled:NO];
            }
        } else {
            self.sendTestCodeBtn.alpha = 0.4;
            [self.sendTestCodeBtn setEnabled:NO];
        }
        
    }
    
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneNumTF) {
        
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString insertString:string atIndex:range.location];
        if ([futureString doubleValue] > 99999999999) {
            
            return NO;
        } else {
            
            return YES;
        }
    }
    
    return YES;
}

- (IBAction)didClickSendTestCodeBtn:(UIButton *)sender {
    
    if ([self.BLEJBudgetGuideCellDelegate respondsToSelector:@selector(didClickSendTestCodeBtnWithPhoneNumber:withBtn:)]) {
        
        [self.BLEJBudgetGuideCellDelegate didClickSendTestCodeBtnWithPhoneNumber:self.phoneNumTF.text withBtn:sender];
    }
}

- (BOOL)isCorrectPhoneNumWithPhoneNum:(NSString *)phoneNum {
    
    NSString *MOBILE = @"^1[3|4|5|7|8|][0-9]{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNum];
}

- (void)setIsShowTelNum:(BOOL)isShowTelNum {
    
    _isShowTelNum = isShowTelNum;
    if (isShowTelNum) {
        
        self.phoneNumTF.hidden = NO;
        self.testCodeTF.hidden = NO;
        self.sendTestCodeBtn.hidden = NO;
        self.textFieldImageVerificationCode.hidden = false;
    } else {
        self.textFieldImageVerificationCode.hidden = true;
        self.phoneNumTF.hidden = YES;
        self.testCodeTF.hidden = YES;
        self.sendTestCodeBtn.hidden = YES;
    }
}

- (void)didClickMyHomeAreaLabel:(UITapGestureRecognizer *)tap {
    
    [self.areaTF becomeFirstResponder];
}

- (void)didClickSquarMetreLabel:(UITapGestureRecognizer *)tap {
    
    [self.areaTF becomeFirstResponder];
}



- (void)didClickSittingRoomLabel:(UITapGestureRecognizer *)tap {
    
    [self didClickBottomPullOrNumberBtn:self.sittingRoomBtn];
}

- (void)didClickBedroomLabel:(UITapGestureRecognizer *)tap {
    
    [self didClickBottomPullOrNumberBtn:self.bedroomBtn];
}

- (void)didClickDiningRoomLabel:(UITapGestureRecognizer *)tap {
    
    [self didClickBottomPullOrNumberBtn:self.diningRoomBtn];
}

- (void)didClickKitchenLabel:(UITapGestureRecognizer *)tap {
    
    [self didClickBottomPullOrNumberBtn:self.kitchenBtn];
}

- (void)didClickBathroomLabel:(UITapGestureRecognizer *)tap {
    
    [self didClickBottomPullOrNumberBtn:self.bathroomBtn];
}

- (void)didClickBalconyLabel:(UITapGestureRecognizer *)tap {
    
    [self didClickBottomPullOrNumberBtn:self.balconyBtn];
}



//- (UIViewController *)viewController {
//    UIResponder *next = self.nextResponder;
//    do {
//        //判断响应者是否为视图控制器
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = next.nextResponder;
//    } while (next != nil);
//    
//    return nil;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
  //  [super setSelected:selected animated:animated];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
  //  [super touchesBegan:touches withEvent:event];
    
}
@end
