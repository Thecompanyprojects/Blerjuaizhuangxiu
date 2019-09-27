//
//  PlaceHolderTextView.h
//  SYLClient
//
//  Created by lxy on 2016/12/12.
//  Copyright © 2016年 liuxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView
/**
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderColor;

@end
