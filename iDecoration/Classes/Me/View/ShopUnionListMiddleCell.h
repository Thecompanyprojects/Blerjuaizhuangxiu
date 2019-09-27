//
//  ShopUnionListMiddleCell.h
//  iDecoration
//
//  Created by sty on 2017/10/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopUnionListMiddleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *infoOneL;
@property (weak, nonatomic) IBOutlet UILabel *infoTwoL;
@property (weak, nonatomic) IBOutlet UILabel *companyNameL;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *leaderTagImgV;

-(void)configData:(id)data;
@end
