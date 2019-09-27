//
//  ShareView.h
//  iDecoration
//
//  Created by RealSeven on 17/2/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *WeChatBtn;
@property (nonatomic, strong) UIButton *TimeLineBtn;
@property (nonatomic, strong) UIButton *QQBtn;
@property (nonatomic, strong) UIButton *QQZoneBtn;
@property (nonatomic, strong) UIButton *CloseBtn;
//@property (nonatomic, strong) UIButton *QRCodeBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) void(^weChatBlock)(void);
@property (nonatomic, copy) void(^timeLineBlock)(void);
@property (nonatomic, copy) void(^QQBlock)(void);
@property (nonatomic, copy) void(^QQZoneBlock)(void);
@property (nonatomic, copy) void(^closeBlock)(void);
//@property (nonatomic, copy) void(^QRCodeBlock)();

@end
