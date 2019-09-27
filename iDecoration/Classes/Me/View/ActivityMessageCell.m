//
//  ActivityMessageCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivityMessageCell.h"

@interface ActivityMessageCell()
@property (nonatomic,copy) NSString *companyId;
@end

@implementation ActivityMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.phoneLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTapAction:)];
    [self.phoneLabel addGestureRecognizer:tapGR];
    
    self.toviewBtn = [UIButton new];
    self.toviewBtn.layer.masksToBounds = YES;
    self.toviewBtn.layer.borderWidth = 1;
    self.toviewBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.toviewBtn.layer.cornerRadius = 8;
    [self.toviewBtn setTitleColor:[UIColor redColor] forState:normal];
    self.toviewBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.toviewBtn.frame = CGRectMake(143, self.phoneLabel.top, 35, 20);
    [self.toviewBtn setTitle:@"查看" forState:normal];
    [self.toviewBtn addTarget:self action:@selector(toviewbtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.toviewBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)callTapAction:(UITapGestureRecognizer *)tapGR {
    if (self.callBlock) {
        self.callBlock(self.phoneLabel.text);
    }
}
- (IBAction)callAction:(id)sender {
    if (self.callBlock) {
        self.callBlock(self.phoneLabel.text);
    }
}

- (void)setModel:(SignUpManageListModel *)model {
    _model = model;
    self.companyId = [NSString stringWithFormat:@"%ld",(long)model.companyId];
//    self.timeLabel.text = [NSString stringWithFormat:@"报名时间：%@", [self stringFromInt:self.model.signUpTime/1000.0]];
    self.timeLabel.text = [NSString stringWithFormat:@"报名时间：%@",[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.signUpTime]];
    // 去掉活动名称中的换行符号
    NSString *userName = [self.model.designTitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.nameLabel.text = [NSString stringWithFormat:@"%@   已报名   《%@》", self.model.userName, userName];
    
    if ([model.userPhone containsString:@"***"]) {
        self.fromLab.text = @"同城收单";
        [self.toviewBtn setHidden:NO];
    }
    else
    {
        self.fromLab.text = @"";
        [self.toviewBtn setHidden:YES];
    }
    
    if ([self.model.trueName isEqualToString:@""]) {
        self.sourceLabel.text = [NSString stringWithFormat:@"来源：%@", self.model.companyName];
    } else if([self.model.companyName isEqualToString:@""] || self.model.companyName.length == 0) {
        self.sourceLabel.text = [NSString stringWithFormat:@"来源：%@", self.model.trueName];
    } else {
        self.sourceLabel.text = [NSString stringWithFormat:@"来源：%@   %@",self.model.companyName, self.model.trueName];
    }
  
    
    self.phoneLabel.text = self.model.userPhone;
    
    if (model.topFlag) {
        [self.starImageBtn setImage:[UIImage imageNamed:@"starSymbol_height"] forState:UIControlStateNormal];
    } else {
        [self.starImageBtn setImage:[UIImage imageNamed:@"starSymbol"] forState:UIControlStateNormal];
    }
    self.beizhuTextView.text = model.remarks;
    
    CGSize size = [self.beizhuTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.beizhuTextView.frame), CGFLOAT_MAX)];
    CGFloat height = size.height;
    if (height < 32) {
        self.beizhuTVHeightCon.constant = 32;
    }else{
        self.beizhuTVHeightCon.constant = height;
    }
    
    self.placeHolderLabel.hidden = self.beizhuTextView.text.length > 0;
    
}

- (NSString *)stringFromInt:(double)timeInterval {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *str = [dateFormatter stringFromDate:date];
    return  str;
}

-(void)toviewbtnclick
{
    if (self.toviewBlock) {
        self.toviewBlock(self.companyId);
    }
}

@end
