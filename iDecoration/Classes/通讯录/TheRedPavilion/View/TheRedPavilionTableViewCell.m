//
//  TheRedPavilionTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "TheRedPavilionTableViewCell.h"

@implementation TheRedPavilionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewBG.layer.masksToBounds = NO;
    // 设置阴影颜色
    self.viewBG.layer.shadowColor = [UIColor blackColor].CGColor;
    // 设置阴影的偏移量，默认是（0， -3）
    self.viewBG.layer.shadowOffset = CGSizeMake(4, 4);
    // 设置阴影不透明度，默认是0
    self.viewBG.layer.shadowOpacity = 0.8;
    // 设置阴影的半径，默认是3
    self.viewBG.layer.shadowRadius = 4;
    self.imageViewIcon.layer.masksToBounds = true;
    self.imageViewIcon.layer.cornerRadius = 25;
    UIView *view = [TheRedPavilionTableViewCell createDashedLineWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 60, 1) lineLength:3 lineSpacing:5 lineColor:[UIColor hexStringToColor:@"999999"]];
    view.clipsToBounds = true;
    [self.viewLine addSubview:view];
}

- (void)setModel:(TheRedPavilionModel *)model {
    [self.imageViewIcon sd_setImageWithURL:model.photo placeholderImage:nil];
    self.labelCompany.text = model.companyName;
    self.labelName.text = model.name;
    self.labelLeft.text = model.jobTypeName.length?[NSString stringWithFormat:@" %@ ",model.jobTypeName]:@"";
    self.labelRight.text = model.jobName.length?[NSString stringWithFormat:@" %@ ",model.jobName]:@"";
    self.numberOfBanner.text = model.banner?:@"0";
    self.numberOfFlower.text = model.flower?:@"0";
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TheRedPavilionTableViewCell";
    TheRedPavilionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

//绘制虚线
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame lineLength:(int)length lineSpacing:(int)spacing lineColor:(UIColor *)color{
    UIView *dashedLine = [[UIView alloc] initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTouchButton:(UIButton *)sender {
    if (self.blockDidTouchButton) {
        self.blockDidTouchButton(sender.tag);
    }
}

@end
