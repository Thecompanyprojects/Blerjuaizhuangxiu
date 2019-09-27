//
//  floorBrickTableViewCell.h
//  iDecoration
//
//  Created by john wall on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@interface floorBrickTableViewCell : UITableViewCell<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *lenthAndWidthlength;
@property (weak, nonatomic) IBOutlet UILabel *nameLA;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property(copy,nonatomic)BLRJCalculatortempletModelAllCalculatorTypes *model;
//@property(strong,nonatomic) UIImageView *imageN;
@end
