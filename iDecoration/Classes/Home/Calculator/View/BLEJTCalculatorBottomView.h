//
//  BLEJTCalculatorBottomView.h
//  Calculator
//
//  Created by 赵春浩 on 17/5/4.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class BLEJCalculatorBudgetPriceCellModel;
//@class BLEJCalculatorBaseAndSuppleListModel;
@class BLRJCalculatortempletModelAllCalculatorTypes;

@interface BLEJTCalculatorBottomView : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *unitPriceTF;
@property (weak, nonatomic) IBOutlet UITextView *techTextView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceFirstLabel;

// 补充报价模型
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *itemModel;

// 标记是否需要换成数字键盘
@property (assign, nonatomic) BOOL isNeedNumKeyboard;

@end
