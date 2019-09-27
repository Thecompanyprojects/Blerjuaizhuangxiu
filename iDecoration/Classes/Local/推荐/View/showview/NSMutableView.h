//
//  NSMutableView.h
//  Family
//
//  Created by zhangming on 17/6/13.
//  Copyright © 2017年 youjiesi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJGtextView.h"
@interface NSMutableView : UIView
@property (nonatomic,strong) UIButton *sendBtn;
@property (weak, nonatomic) WJGtextView *textView;
@end
