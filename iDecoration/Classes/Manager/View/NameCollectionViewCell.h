//
//  NameCollectionViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DModel.h"

@interface NameCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *districtNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, strong) DModel *dmodel;

@property (copy, nonatomic) void(^deleteBlock)();


@end
