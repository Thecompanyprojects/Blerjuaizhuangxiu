//
//  ClearShareView.h
//  iDecoration
//
//  Created by RealSeven on 17/3/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearShareView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) QRCodeView *codeView;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *shareTableView;
@property (nonatomic, copy) void(^closeBlock)();
@property (nonatomic, copy) void(^weChatBlock)();
@property (nonatomic, copy) void(^timeLineBlock)();
@property (nonatomic, copy) void(^QQBlock)();
@property (nonatomic, copy) void(^QQZoneBlock)();
@property (nonatomic, copy) void(^QRCodeBlock)();
@end
