//
//  localofferCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class localofferModel;
@interface localofferCell : UITableViewCell
-(void)setdata:(localofferModel *)model andwithtype:(NSString *)type;
@end
