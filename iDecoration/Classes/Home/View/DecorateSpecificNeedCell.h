//
//  DecorateSpecificNeedCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorateSpecificNeedCell : UITableViewCell

// 类型名字
@property (nonatomic, strong) NSString *titleName;

// 标签数组(按钮文字)
@property (nonatomic, strong) NSArray *buttonTitleArray;

// 选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;


// 是否单选 YES 单选   NO 多选
@property (nonatomic, assign) BOOL isSingleSelected;
// 被选中的按钮标题
@property (nonatomic, strong) NSMutableArray *selectedBtnTitleMulArray;
@property (nonatomic, copy) void(^selectedBlock)(NSMutableArray *selectedArray);

@end
