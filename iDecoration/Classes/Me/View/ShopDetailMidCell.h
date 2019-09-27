//
//  ShopDetailMidCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailMidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIImageView *rightRow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLWidthCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentLRightCon;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;

-(void)configData:(id)data;
@end
