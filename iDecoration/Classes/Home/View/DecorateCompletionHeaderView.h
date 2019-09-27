//
//  DecorateCompletionHeaderView.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorateCompletionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoLabelHeightCon;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, copy) void(^shareBlock)();
@end
