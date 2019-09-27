//
//  distributionenvelopeHeaderView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/1.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface distributionenvelopeHeaderView : UIView
@property (nonatomic,strong) UIButton *submitBtn;
-(void)setdata:(NSString *)cashMoney and:(NSString *)moneyTotal;
@end
