//  CCPScrollView.h
//  Created by C CP on 16/9/27.
//  Copyright © 2016年 C CP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOfHomeBroadcast.h"
typedef void(^clickLabelBlock)(NSInteger index,NSString *titleString);


//滚动方向
typedef enum ScrollingAnimateDirection{
    /**
     **默认的方向（水平)
     **/
    UIDefaultScrollDirection = 0,
    /*
     *水平滚动
     **/
    UIHorizontalScrollDirection = 1,
    /*
     *垂直滚动
     **/
    UIVerticalScrollDirection = 2
    
} scrollingDirection;


@interface LRSTextScrollView : UIView


/**

 */
@property (strong, nonatomic) NetworkOfHomeBroadcast *model;

/**

 */
@property (strong, nonatomic) UIImageView *imageView;
/**
 *  根据数据 创建label 并设置滚动方向
 */
- (void)setTitleArray:(NSArray *)titleArray andScrollDirection:(scrollingDirection)directionType;

/**
 *  是否可以拖拽
 */
@property (nonatomic,assign) BOOL isCanManualScroll;
/**
 *  block回调
 */
@property (nonatomic,copy)void(^clickLabelBlock)(NSInteger index,NSString *titleString);
/**
 *  字体颜色
 */
@property (nonatomic,strong) UIColor *titleColor;
/**
 *  背景颜色
 */
@property (nonatomic,strong) UIColor *BGColor;
/**
 *  字体大小
 */
@property (nonatomic,assign) CGFloat titleFont;
/**
 循环次数
 */
@property (assign, nonatomic) NSInteger loopCount;

/**
 *  关闭定时器
 */
- (void)removeTimer;

/**
 *  添加定时器
 */
- (void)addTimer;

/**
 *  label的点击事件
 */
- (void) clickTitleLabel:(clickLabelBlock) clickLabelBlock;

/**
 重置循环次数
 */
- (void)reloadLoopCount;
@end
