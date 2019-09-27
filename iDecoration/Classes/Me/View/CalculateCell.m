//
//  CalculateCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CalculateCell.h"

@interface CalculateCell()<UITextViewDelegate>
@property (nonatomic, strong) NSString *phoneNum;
//@property (weak, nonatomic) CalculateModel *calModel;

@end
@implementation CalculateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.phoneNumLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumLabelClicked:)];
    [self.phoneNumLabel addGestureRecognizer:tapGR];
    
    
    self.isReadFlag.layer.cornerRadius = 5;
    self.isReadFlag.layer.masksToBounds = YES;
    
    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNUmLabelLongPressGR:)];
    longGR.minimumPressDuration = 0.5;
    self.phoneNumLabel.userInteractionEnabled = YES;
    [self.phoneNumLabel addGestureRecognizer:longGR];
    
    self.toviewBtn = [UIButton new];
    self.toviewBtn.layer.masksToBounds = YES;
    self.toviewBtn.layer.borderWidth = 1;
    self.toviewBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.toviewBtn.layer.cornerRadius = 8;
    [self.toviewBtn setTitleColor:[UIColor redColor] forState:normal];
    self.toviewBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.toviewBtn.frame = CGRectMake(140, self.phoneNumLabel.top, 35, 25);
    [self.toviewBtn setTitle:@"查看" forState:normal];
    [self.toviewBtn addTarget:self action:@selector(toviewbtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.toviewBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CalculateModel *)model {
    /*
     1只有老数据   精简装均为空
     2有简装无精装
     3有精装无简装
     4有精装有简装
     */

    self.totalAreaLabel.text = [NSString stringWithFormat:@"%@ m²", model.floorArea];
    self.timeLabel.text = [self ConvertStrToTime:model.createDate];
    
    //1. 只有老数据
    if (([model.simpleSumoney isEqualToString:@""] || model.simpleSumoney == nil) && ([model.hardcoverSumoney isEqualToString:@""] || model.hardcoverSumoney == nil)) {
        self.priceNameLabel.text = @"总价";
        self.priceLabel.text = [NSString stringWithFormat:@"%@ 元",model.sumMoney];
        self.secondPriceLabel.text = @"";
        self.secondPriceNameLabel.text = @"";
    }
    // 2. 4. 有简装 有精装    有简装没精装
    if (model.simpleSumoney.length > 0) {
        // 没有精装
        if ([model.hardcoverSumoney isEqualToString:@""] || model.hardcoverSumoney == nil) {
            NSString *priceName = [model.simpleName stringByReplacingOccurrencesOfString:@"报价" withString:@""];
            self.priceNameLabel.text = priceName;
            self.priceLabel.text = [NSString stringWithFormat:@"%@ 元",model.simpleSumoney];
            self.secondPriceNameLabel.text = @"";
            self.secondPriceLabel.text = @"";
            
        } else {
            // 有精装
            NSString *priceName = [model.simpleName stringByReplacingOccurrencesOfString:@"报价" withString:@""];
            self.priceNameLabel.text = priceName;
            self.priceLabel.text = [NSString stringWithFormat:@"%@ 元",model.simpleSumoney];
            NSString *secondPriceName = [model.hardcoverName stringByReplacingOccurrencesOfString:@"报价" withString:@""];
            self.secondPriceNameLabel.text = secondPriceName;
            self.secondPriceLabel.text = [NSString stringWithFormat:@"%@ 元",model.hardcoverSumoney];
            
        }
        
    }
    // 3. 没简装 有精装
    if (([model.simpleSumoney isEqualToString:@""] || model.simpleSumoney == nil) && model.hardcoverSumoney.length > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@ 元",model.hardcoverSumoney];
        NSString *secondPriceName = [model.hardcoverName stringByReplacingOccurrencesOfString:@"报价" withString:@""];
        self.priceNameLabel.text = secondPriceName;
        self.secondPriceLabel.text = @"";
        self.secondPriceNameLabel.text = @"";
    }
    
    
    NSString *phoneNum = model.customerPhone;
    if (IsNilString(phoneNum)) {
        self.phoneNumLabel.text = @"";
        [self.callButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        self.phoneNumLabel.text = phoneNum;
        self.phoneNum = phoneNum;
    }
    self.huxingLabel.text = model.houseType;
    self.companyNameLb.text = model.companyName;
    if ([self.companyNameLb.text isEqualToString:@""]) {
        self.companyNameLbTopCon.constant = 0;
    }
    
    
    if (model.isStar.integerValue) {
        [self.starImageBtn setImage:[UIImage imageNamed:@"starSymbol_height"] forState:UIControlStateNormal];
    } else {
        [self.starImageBtn setImage:[UIImage imageNamed:@"starSymbol"] forState:UIControlStateNormal];
        
    }

    self.isReadFlagWidthCon.constant = model.isRead.integerValue ? 0 : 10;
    self.isReadFlag.backgroundColor = model.isRead.integerValue ? [UIColor clearColor] : [UIColor redColor];
    
    self.beizhuTextView.text = model.remark;
    
    CGSize size = [self.beizhuTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.beizhuTextView.frame), CGFLOAT_MAX)];
    CGFloat height = size.height;
    if (height < 30) {
        self.beizhuTVHeightCon.constant = 30;
    }else{
        self.beizhuTVHeightCon.constant = height;
    }
    
    self.placeHolderLabel.hidden = self.beizhuTextView.text.length > 0;

    if ([model.trueName isEqualToString:@""] || model.trueName == nil) {
        self.beizhuTopCon.constant = -17;
        self.workerLabel.hidden = YES;
    } else {
        self.workerLabel.text = [NSString stringWithFormat:@"业务员：%@", model.trueName];
    }
    if ([model.customerPhone containsString:@"****"]&&[model.companyCalVip isEqualToString:@"1"]) {
        [self.toviewBtn setHidden:NO];
        self.fromLab.text = @"来源：同城收单";
    }
    else
    {
        self.fromLab.text = @"";
        [self.toviewBtn setHidden:YES];
    }
}

- (IBAction)callButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(calculateCell:callButtton:phoneNumber:)]) {
        [self.delegate calculateCell:self callButtton:nil phoneNumber:self.phoneNum];
    }
}
- (void)phoneNumLabelClicked:(UITapGestureRecognizer *)tapGR{
    if ([self.delegate respondsToSelector:@selector(calculateCell:callButtton:phoneNumber:)]) {
        [self.delegate calculateCell:self callButtton:nil phoneNumber:self.phoneNum];
    }
}

- (void)phoneNUmLabelLongPressGR:(UILongPressGestureRecognizer *)longPressGR {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.phoneNumLabel.text;
    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"手机号已复制"];
}

- (NSString *)ConvertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
    
}

-(void)toviewbtnclick
{
    [self.delegate myTabVClick:self];
}

@end
