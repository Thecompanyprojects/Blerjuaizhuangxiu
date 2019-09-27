//
//  BLEJCalculatorBottomOneView.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class BLEJCalculatorBudgetPriceCellModel;
@class ZCHCalculatorItemsModel;
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@interface BLEJCalculatorBottomOneView : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *unitPriceTF;
@property (weak, nonatomic) IBOutlet UITextView *techTextView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *phLabel;

// 数据模型
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *modelItem;

//@property (strong, nonatomic) ZCHCalculatorItemsModel *itemModel;

// 标记是否需要换成数字键盘
//@property (assign, nonatomic) BOOL isNeedNumKeyboard;

@end
