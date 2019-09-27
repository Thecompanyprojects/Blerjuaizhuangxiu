//
//  UnionActivitySetCell.m
//  iDecoration
//
//  Created by sty on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UnionActivitySetCell.h"

@implementation UnionActivitySetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTime:(NSString *)startTimeStr endTimeStr:(NSString *)endTimeStr{
    if (startTimeStr.length<=0) {
        startTimeStr = @"开始时间";
    }
    if (endTimeStr.length<=0) {
        endTimeStr = @"结束时间";
    }
    [self.startBtn setTitle:startTimeStr forState:UIControlStateNormal];
    [self.endBtn setTitle:endTimeStr forState:UIControlStateNormal];
}

- (IBAction)startBtnClick:(id)sender {
    if (self.startBtnBlock) {
        self.startBtnBlock();
    }
}

- (IBAction)endBtnClick:(id)sender {
    if (self.endBtnBlock) {
        self.endBtnBlock();
    }
}
@end
