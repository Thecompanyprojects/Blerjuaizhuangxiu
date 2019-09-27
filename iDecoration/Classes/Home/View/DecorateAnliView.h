//
//  DecorateAnliView.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorateAnliView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^clickBlock)(NSInteger idex);
@end
