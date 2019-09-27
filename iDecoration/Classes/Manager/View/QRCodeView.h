//
//  QRCodeView.h
//  iDecoration
//
//  Created by RealSeven on 2017/3/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *QRCodeImageView;

@property (nonatomic, copy) void(^hideBlock)(void);

@end
