//
//  SystemMessageCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMessageModel.h"


@interface SystemMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (nonatomic, strong) SystemMessageModel *model;
@end
