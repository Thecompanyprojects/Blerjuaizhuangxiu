//
//  HomeClassificationView.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeClassificationView : UIView
typedef void(^HomeClassificationViewBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (copy, nonatomic) HomeClassificationViewBlock blockDidTouchView;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *arrayHeight;

@end
