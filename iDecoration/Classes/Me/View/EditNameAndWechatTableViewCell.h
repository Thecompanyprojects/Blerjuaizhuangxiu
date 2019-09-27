//
//  EditNameAndWechatTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNameAndWechatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *ContentTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentFCons;

@end
