//
//  MyCompanyHeadCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCompanyHeadCellDelegate <NSObject>

-(void)editCompanyInfoOrDeleteCompany;

@end

@interface MyCompanyHeadCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<MyCompanyHeadCellDelegate>delegate;

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *sloganL;

-(void)configWith:(id)data;
@end
