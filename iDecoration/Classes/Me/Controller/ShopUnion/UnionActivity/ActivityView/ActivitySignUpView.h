//
//  ActivitySignUpView.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitySignUpView : UIView


/**
 报名活动的视图

 @param itemArray 自定义项目的名称数组
 @param costName 费用名称  没有费用传 @""
 @param price 费用价格
 @return view
 */
- (instancetype)initWithCustomItem:(NSArray *)itemArray costName:(NSString *)costName andPrice:(NSString *)price;


@property (nonatomic, copy) void(^sendCodeBlock)(UIButton *btn);
@property (nonatomic, copy) void(^finishBtnBlock)(NSInteger flag); // flag 1 为支付  2 为报名

@end
