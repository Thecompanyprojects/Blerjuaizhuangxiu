//
//  GoodsDetailContentCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GoodsDetailContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopToContetLabelBottomCon;

@property (nonatomic, copy) void(^clickImageBlock)();

@end
