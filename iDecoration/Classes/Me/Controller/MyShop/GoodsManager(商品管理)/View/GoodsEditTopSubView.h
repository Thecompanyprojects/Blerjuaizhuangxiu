//
//  GoodsEditTopSubView.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsEditTopSubView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *lineView;

@end
