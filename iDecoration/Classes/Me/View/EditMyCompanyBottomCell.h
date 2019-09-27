//
//  EditMyCompanyBottomCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMyCompanyBottomCell : UITableViewCell
@property (nonatomic, strong) UIView *headV;
@property (nonatomic, strong) UILabel *companySlognL;
@property (nonatomic, strong) UITextView *companySlognV;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
