//
//  AddressBookTableViewCell2.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/6.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeniusSquareListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddressBookTableViewCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelRight;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
- (void)setModel:(GeniusSquareListModel *)model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
