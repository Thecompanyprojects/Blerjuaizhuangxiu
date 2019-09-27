//
//  GoodsDetailCommentCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"


@interface GoodsDetailCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentPromptLabel;


@property (nonatomic, strong) CommmentModel *model;
@end
