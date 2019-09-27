//
//  GoodsDetailEnterShopCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"


@interface GoodsDetailEnterShopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterShopBtn;

@property (nonatomic, strong) GoodsDetailModel *model;

@end
