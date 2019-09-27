//
//  DiscountPackageTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/7/24.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DiscountPackageTableViewCellBlock)(NSInteger tag);

@interface DiscountPackageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (copy, nonatomic) DiscountPackageTableViewCellBlock blockDidTouchButton;

- (IBAction)didTouchButtonSelected:(UIButton *)sender;
+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
