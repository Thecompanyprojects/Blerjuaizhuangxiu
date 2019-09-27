//
//  HomeClassificationDetailCollectionViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeClassificationDetailModel.h"

@interface HomeClassificationDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineBottomToRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineBottomToLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineRightToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineRightToTop;
@property (weak, nonatomic) IBOutlet UIView *viewLineRight;
@property (weak, nonatomic) IBOutlet UIView *viewLineBottom;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *arrayTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
- (void)setModel:(HomeClassificationDetailModel *)model;

@end
