//
//  NameCollectionViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NameCollectionViewCell.h"

@implementation NameCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.districtNameLabel.layer.borderColor = Bottom_Color.CGColor;
    self.deleteBtn.layer.cornerRadius = 10;
    self.deleteBtn.layer.masksToBounds = YES;
//    self.deleteBtn.layer.borderColor = [UIColor redColor].CGColor;
//    self.deleteBtn.layer.borderWidth = 1;
}

-(void)setDmodel:(DModel *)dmodel{
    
    self.districtNameLabel.text = dmodel.name;

}
//删除按钮
- (IBAction)deleteClick:(id)sender {
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end
