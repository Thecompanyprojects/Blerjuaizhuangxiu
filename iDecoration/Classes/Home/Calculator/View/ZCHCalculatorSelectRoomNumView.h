//
//  ZCHCalculatorSelectRoomNumView.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCHCalculatorSelectRoomNumViewDelegate <NSObject>

@optional
- (void)didClickRoomCount:(NSInteger)roomCount;

@end

@interface ZCHCalculatorSelectRoomNumView : UIView

@property (assign, nonatomic) NSInteger count;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) BOOL isFromZero;
@property (weak, nonatomic) id<ZCHCalculatorSelectRoomNumViewDelegate> delegate;

@end
