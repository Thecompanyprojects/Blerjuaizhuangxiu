//
//  ShopUnionListCommonCell.h
//  iDecoration
//
//  Created by sty on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopUnionListCommonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UnionlogoImgV;
@property (weak, nonatomic) IBOutlet UILabel *UnionnameL;
@property (weak, nonatomic) IBOutlet UILabel *UnionNumL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unionNumRightCont;


-(void)configWith:(id)data;
@end
