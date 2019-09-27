//
//  XianHuaJinQiGuanzhuCell.h
//  iDecoration
//
//  Created by john wall on 2018/10/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XianHuaJinQiGuanzhuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jinQiNumber;
@property (weak, nonatomic) IBOutlet UILabel *flowerNumber;
@property (weak, nonatomic) IBOutlet UILabel *foucsNumber;
-(void)setData:(NSDictionary *)dic;
@end
