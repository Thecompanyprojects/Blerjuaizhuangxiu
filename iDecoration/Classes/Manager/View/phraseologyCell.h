//
//  phraseologyCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface phraseologyCell : UITableViewCell
@property (nonatomic,strong) UIButton *submitbtn;
-(void)setdata:(NSString *)contentstr andtype:(NSString *)type andisshow:(BOOL)show;
@end
