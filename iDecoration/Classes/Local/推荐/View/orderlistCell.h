//
//  orderlistCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderleftImg.h"
@class rankingModel;
@interface orderlistCell : UITableViewCell
@property (nonatomic,strong) orderleftImg *leftView;
-(void)setdata:(rankingModel *)model;
-(void)setnumber:(NSString *)num;
@end
