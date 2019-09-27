//
//  ZCHCalculatorBaseTemplateBottomView.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class BLEJCalculatorBaseAndSuppleListModel;
@class ZCHCalculatorItemsModel;
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

@interface ZCHCalculatorBaseTemplateBottomView : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *unitPriceTF;
@property (weak, nonatomic) IBOutlet UITextView *techTextView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceFirstLabel;

// 从基础模板传进来的模型
//@property (strong, nonatomic) BLEJCalculatorBaseAndSuppleListModel *baseAndSuppleListModelFromBaseTemplate;

@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *model;

// 标记是否需要将数值乘以100 (后边是%)
@property (assign, nonatomic) BOOL isShowPercentage;

@end
