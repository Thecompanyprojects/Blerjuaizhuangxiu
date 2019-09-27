//
//  fullSenceCollectionViewCell.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/9/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "fullSenceCollectionViewCell.h"

@implementation fullSenceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgimage.contentMode = UIViewContentModeScaleAspectFill;
    self.bgimage.layer.masksToBounds = YES;
}


-(void)setModel:(senceModel *)model{
    if (model.picHref) {
        [self.bgimage  sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    }
    self.dispalyNumberLabel.text = [NSString stringWithFormat:@"%ld", model.displayNumbers];
    if (model.picTitle) {
        self.nameLabel.text = model.picTitle;
    }
    


}


//编辑按钮
-(IBAction)editor:(UIButton *)sender{
    
    if (self.delegate && [self.delegate  respondsToSelector:@selector(editorCell:)]) {
        [self.delegate editorCell:sender.tag];
    }
    
}


//删除按钮
-(IBAction)delete:(UIButton *)sender{
    
    if (self.delegate && [self.delegate  respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:sender.tag];
    }
    
}



@end
