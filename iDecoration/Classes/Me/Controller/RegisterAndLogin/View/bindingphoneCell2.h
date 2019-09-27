//
//  bindingphoneCell2.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bindingphoneCell2 : UITableViewCell
typedef void(^bindingphoneCell2Block)(NSString *string);

@property (copy, nonatomic) bindingphoneCell2Block block;

@property (nonatomic,strong) UITextField *codeText;
@end
