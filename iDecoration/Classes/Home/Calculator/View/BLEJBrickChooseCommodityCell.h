//
//  BLEJBrickChooseCommodityCell.h
//  iDecoration
//
//  Created by john wall on 2018/8/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"
@interface BLEJBrickChooseCommodityCell : UITableViewCell
@property (strong, nonatomic) UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *DesciptionLA;
@property (weak, nonatomic) IBOutlet UILabel *nameLA;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property(nonatomic,strong)GoodsListModel *goodModel;
@end
