//
//  WJGtextView.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJGtextView : UITextView
@property (nonatomic,strong)  UILabel *numberlabel;
@property (nonatomic, strong) NSString *customPlaceholder;
@property (nonatomic, strong) UIColor  *customPlaceholderColor;
@end
