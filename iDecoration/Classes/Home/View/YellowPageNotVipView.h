//
//  YellowPageNotVipView.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YellowPageNotVipView : UIView

@property (nonatomic, copy) void(^OpenVipBlock)(void);
@property (nonatomic, copy) void(^ExperienceVipBlock)(void);

@end
