//
//  TheRedPavilionTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheRedPavilionModel.h"

@interface TheRedPavilionTableViewCell : UITableViewCell
typedef void(^TheRedPavilionTableViewCellBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIButton *buttonFlower;
@property (weak, nonatomic) IBOutlet UIButton *buttonBanner;
@property (weak, nonatomic) IBOutlet UILabel *labelRight;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFlower;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBanner;
@property (weak, nonatomic) IBOutlet UILabel *labelCompany;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (copy, nonatomic) TheRedPavilionTableViewCellBlock blockDidTouchButton;

+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame lineLength:(int)length lineSpacing:(int)spacing lineColor:(UIColor *)color;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setModel:(TheRedPavilionModel *)model;
@end
