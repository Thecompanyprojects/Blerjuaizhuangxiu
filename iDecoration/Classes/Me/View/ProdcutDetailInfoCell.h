//
//  ProdcutDetailInfoCell.h
//  iDecoration
//
//  Created by sty on 2018/3/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdcutDetailInfoCell : UITableViewCell
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, assign) CGFloat cellH;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;

-(void)configDataWith:(NSString *)centenStr imgStr:(NSString *)imgStr;
@end
