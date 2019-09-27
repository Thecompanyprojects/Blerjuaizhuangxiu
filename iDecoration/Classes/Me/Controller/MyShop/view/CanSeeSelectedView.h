//
//  CanSeeSelectedView.h
//  iDecoration
//
//  Created by zuxi li on 2017/8/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanSeeSelectedView : UIView

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIImageView *thridImageView;

@property (nonatomic, copy) void(^selectedBlock)(NSString *text, NSInteger index);

@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (nonatomic, assign) NSInteger selectedIndex;  // 1 内网  2  外网  3 内外网

@end
