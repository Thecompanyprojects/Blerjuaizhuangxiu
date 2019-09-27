//
//  ZCHGoodsShowCollectionViewCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHGoodsShowCollectionViewCell.h"
#import "ZCHGoodsShowModel.h"

@interface ZCHGoodsShowCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZCHGoodsShowCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setModel:(ZCHGoodsShowModel *)model {
    
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.display] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    self.deleteBtn.hidden = !self.isShowDelete;
//    self.iconView.userInteractionEnabled = YES;
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didClickIconView:)];
//    longPress.minimumPressDuration = 1.0;
//    [self.iconView addGestureRecognizer:longPress];
}

//- (void)didClickIconView:(UILongPressGestureRecognizer *)longPress {
//    
//    // 长按手势必须处理这两种状态(不然这个方法会被调用两次)
//    if (longPress.state == UIGestureRecognizerStateBegan) {
//        
//        self.deleteBtn.hidden = NO;
//        if (self.clickDeleteBlock) {
//            
//            self.clickDeleteBlock([NSIndexPath indexPathForRow:-1 inSection:-1]);
//        }
//    }else if (longPress.state == UIGestureRecognizerStateEnded){
//        
//    }
//}



- (IBAction)didClickDeleteBtn:(UIButton *)sender {
    
    if (self.clickDeleteBlock) {
        
        self.clickDeleteBlock(self.cellItem);
    }
}

@end
