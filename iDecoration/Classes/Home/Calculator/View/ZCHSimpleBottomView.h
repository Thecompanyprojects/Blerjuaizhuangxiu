//
//  ZCHSimpleBottomView.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCHSimpleBottomViewDelegate <NSObject>

@optional
- (void)didClickPickerViewWithIndex:(NSInteger)index andSection:(NSInteger)section;

@end

@interface ZCHSimpleBottomView : UIView

// pickView的内容数组
@property (strong, nonatomic) NSArray *dataArr;
@property (weak, nonatomic) id<ZCHSimpleBottomViewDelegate> delegate;
@property (assign, nonatomic) NSInteger section;


@end
