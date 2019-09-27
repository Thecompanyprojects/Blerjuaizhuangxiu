//
//  VIPExperienceTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/22.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPExperienceModel.h"
#import "SubsidiaryModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^VIPExperienceTableViewCellBlock)(void);
@interface VIPExperienceTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) VIPExperienceModel *model;
@property (copy, nonatomic) VIPExperienceTableViewCellBlock blockDidTouchButtonLogo;

- (void)setModel:(VIPExperienceModel *)model andIndexPath:(NSIndexPath *)indexPath;
- (void)setModelInShow:(SubsidiaryModel *)model andIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
