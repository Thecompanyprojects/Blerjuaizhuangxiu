//
//  ActivitySignUpManageCell.m
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivitySignUpManageCell.h"
#import "SignUpManageListModel.h"

@implementation ActivitySignUpManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.signUpCodeL.hidden = YES;
    
}


- (IBAction)callPhoneBtn:(UIButton *)sender {
    if (self.callPhoneBlock) {
        self.callPhoneBlock(sender.tag);
    }
}

-(void)configData:(id)data{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([data isKindOfClass:[SignUpManageListModel class]]) {
        SignUpManageListModel *model = data;
        model.signUpTime = [self timeWithTimeIntervalString:model.signUpTime];
        self.signUpTimeL.text = [NSString stringWithFormat:@"报名时间：%@",model.signUpTime];
        self.signUpContentL.text = [NSString stringWithFormat:@"%@ 已报名 《%@》",model.userName,model.designTitle];
        NSString *fromStr;
        if (model.trueName.length>0&&model.companyName.length>0) {
            fromStr = [NSString stringWithFormat:@"来源：%@--%@",model.companyName,model.trueName];
        }
        
        else if(model.trueName.length<=0&&model.companyName.length>0){
            fromStr = [NSString stringWithFormat:@"来源：%@",model.companyName];
        }
        
        else if(model.trueName.length>0&&model.companyName.length<=0){
            fromStr = [NSString stringWithFormat:@"来源：%@",model.trueName];
        }
        else if(model.trueName.length<=0&&model.companyName.length<=0){
            fromStr = @"来源：暂无";
        }
        else{
            
        }
        self.signUpFromL.text = fromStr;
        self.signUpPhoneL.text = [NSString stringWithFormat:@"电话：%@",model.userPhone];
        if ([model.userPhone rangeOfString:@"*"].location==NSNotFound) {
            //不包含*
            self.callBtn.hidden = NO;
        }
        else{
            self.callBtn.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
