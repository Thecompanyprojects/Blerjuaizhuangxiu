//
//  CommonHeadCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonHeadCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
-(void)configWith:(id)data;
@end
