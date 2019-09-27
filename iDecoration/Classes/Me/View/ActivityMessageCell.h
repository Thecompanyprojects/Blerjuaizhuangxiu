//
//  ActivityMessageCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignUpManageListModel.h"

@interface ActivityMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, strong) SignUpManageListModel *model;

@property (nonatomic, copy) void(^callBlock)(NSString *phoneNum);
@property (nonatomic, copy) void(^toviewBlock)(NSString *companyId);

@property (weak,nonatomic)UITableView * tableView;
// 星标按钮
@property (weak, nonatomic) IBOutlet UIButton *starImageBtn;
// 备注TextView
@property (weak, nonatomic) IBOutlet UITextView *beizhuTextView;
// 备注的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beizhuTVHeightCon;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLab;
@property (nonatomic,strong) UIButton *toviewBtn;
@end
