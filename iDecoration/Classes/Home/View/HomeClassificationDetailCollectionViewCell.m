//
//  HomeClassificationDetailCollectionViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "HomeClassificationDetailCollectionViewCell.h"

@implementation HomeClassificationDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(HomeClassificationDetailModel *)model {
    self.viewLineBottomToRight.constant = model.viewLineBottomToRight;
    self.viewLineBottomToLeft.constant = model.viewLineBottomToLeft;
    self.viewLineRightToBottom.constant = model.viewLineRightToBottom;
    self.viewLineRightToTop.constant = model.viewLineRightToTop;
    self.viewLineRight.hidden = model.viewLineRightHidden;
    self.viewLineBottom.hidden = model.viewLineBottomHidden;
}
@end
