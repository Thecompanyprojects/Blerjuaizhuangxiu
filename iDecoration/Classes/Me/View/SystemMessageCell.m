//
//  SystemMessageCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SystemMessageCell.h"

@implementation SystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.flagLabel.hidden = YES;
    self.flagLabel.layer.cornerRadius = 6;
    self.flagLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(SystemMessageModel *)model {
    NSTimeInterval  timeInterval = model.createDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    self.timeLabel.text = dateStr;
    if (model.type == 0) { // 0投诉      1反馈
        self.messageTypeLabel.text = @"投诉通知";
        self.titleLabel.text = [NSString stringWithFormat:@"您有收到 %@ 类型的投诉", model.complainType];
    } else if(model.type == 1){
        self.messageTypeLabel.text = @"意见反馈回复";
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.text = [NSString stringWithFormat:@"内容：%@", model.content];
    }
    
    
    
}


@end
