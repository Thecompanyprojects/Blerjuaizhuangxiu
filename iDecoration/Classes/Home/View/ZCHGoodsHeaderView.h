//
//  ZCHGoodsHeaderView.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsModel.h"
@interface ZCHGoodsHeaderView : UITableViewCell

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) goodsModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
