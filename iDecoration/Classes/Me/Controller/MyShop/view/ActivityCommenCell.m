//
//  ActivityCommenCell.m
//  iDecoration
//
//  Created by sty on 2018/3/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ActivityCommenCell.h"

@implementation ActivityCommenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *ActivityCommenCellID = [NSString stringWithFormat:@"ActivityCommenCell%ld%ld",path.section,path.row];
    ActivityCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCommenCellID];
    //    cell.path = path;
    if (cell == nil) {
        cell =[[ActivityCommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActivityCommenCellID];
    }
    
    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        //        self.backgroundColor = kSepLineColor;
        
        self.backgroundColor = RGB(241, 242, 245);
        
        [self addSubview:self.activitySignUpV];
        
        [self.activitySignUpV addSubview:self.activitySignUpBtn];
        //
        [self.activitySignUpV addSubview:self.SignUpBigPlacholdV];
        [self.activitySignUpV addSubview:self.SignStartTimeL];
        [self.activitySignUpV addSubview:self.SignEndTimeL];
        [self.activitySignUpV addSubview:self.SignUpNumL];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(NSString *)actStartTime actEndTime:(NSString *)actEndTime haveSignUp:(NSString *)haveSignUp signUpNum:(NSString *)signUpNum isHaveActivity:(BOOL)isHaveActivity{
    if (!isHaveActivity) {
        self.activitySignUpBtn.hidden = NO;
        
        self.SignUpBigPlacholdV.hidden = YES;
        self.SignStartTimeL.hidden = YES;
        self.SignEndTimeL.hidden = YES;
        self.SignUpNumL.hidden = YES;
        
        self.activitySignUpV.frame = CGRectMake(5, 0, kSCREEN_WIDTH-10, 50);
    }
    else{
        self.activitySignUpBtn.hidden = YES;
        
        self.SignUpBigPlacholdV.hidden = NO;
        self.SignStartTimeL.hidden = NO;
        self.SignEndTimeL.hidden = NO;
        self.SignUpNumL.hidden = NO;
        
        self.SignStartTimeL.text = actStartTime;
        self.SignEndTimeL.text = actEndTime;
        if (haveSignUp.length<=0) {
            haveSignUp = @"0";
        }
        if (signUpNum.length<=0||[signUpNum isEqualToString:@"0"]) {
            signUpNum = @"无限制";
        }
        self.SignUpNumL.text = [NSString stringWithFormat:@"%@/%@",haveSignUp, signUpNum];
        
        
        self.activitySignUpV.frame = CGRectMake(5, 0, kSCREEN_WIDTH-10, 125);
    }
}

-(UIView *)activitySignUpV{
    if (!_activitySignUpV) {
        _activitySignUpV = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kSCREEN_WIDTH-10, 50)];
        _activitySignUpV.layer.masksToBounds = YES;
        _activitySignUpV.layer.cornerRadius = 10;
        _activitySignUpV.backgroundColor = White_Color;
    }
    return _activitySignUpV;
}

-(UIButton *)activitySignUpBtn{
    if (!_activitySignUpBtn) {
        _activitySignUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _activitySignUpBtn.frame = CGRectMake(0,0,self.activitySignUpV.width,50);
        _activitySignUpBtn.backgroundColor = White_Color;
        [_activitySignUpBtn setTitle:@"报名活动" forState:UIControlStateNormal];
        _activitySignUpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_activitySignUpBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_activitySignUpBtn setTitleColor:RGB(211, 192, 185) forState:UIControlStateNormal];
        _activitySignUpBtn.titleLabel.font = NB_FONTSEIZ_BIG;

        _activitySignUpBtn.userInteractionEnabled = NO;
        [_activitySignUpBtn setImage:[UIImage imageNamed:@"activity_littleFlag"] forState:UIControlStateNormal];
    }
    return _activitySignUpBtn;
}

-(UIImageView *)SignUpBigPlacholdV{
    if (!_SignUpBigPlacholdV) {
        //        CGFloat width = self.activitySignUpV.height-20*2;
        CGFloat width = 85;
        _SignUpBigPlacholdV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, width, width)];
        _SignUpBigPlacholdV.image = [UIImage imageNamed:@"activity_flag"];
    }
    return _SignUpBigPlacholdV;
}


-(UILabel *)SignStartTimeL{
    if (!_SignStartTimeL) {
        _SignStartTimeL = [[UILabel alloc]initWithFrame:CGRectMake(self.SignUpBigPlacholdV.right+10, self.SignUpBigPlacholdV.top, self.activitySignUpV.width-self.SignUpBigPlacholdV.right-10, 20)];
        _SignStartTimeL.text = @"10:00开始";
        _SignStartTimeL.textColor = COLOR_BLACK_CLASS_3;
        _SignStartTimeL.font = NB_FONTSEIZ_NOR;
        _SignStartTimeL.textAlignment = NSTextAlignmentLeft;
    }
    return _SignStartTimeL;
}

-(UILabel *)SignEndTimeL{
    if (!_SignEndTimeL) {
        _SignEndTimeL = [[UILabel alloc]initWithFrame:CGRectMake(self.SignUpBigPlacholdV.right+10, self.SignStartTimeL.bottom, self.activitySignUpV.width-self.SignUpBigPlacholdV.right-10, 20)];
        _SignEndTimeL.text = @"10:00结束";
        _SignEndTimeL.textColor = COLOR_BLACK_CLASS_3;
        _SignEndTimeL.font = NB_FONTSEIZ_NOR;
        _SignEndTimeL.textAlignment = NSTextAlignmentLeft;
    }
    return _SignEndTimeL;
}

-(UILabel *)SignUpNumL{
    if (!_SignUpNumL) {
        _SignUpNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.SignEndTimeL.left, self.SignEndTimeL.bottom+20, self.SignEndTimeL.width, 30)];
        _SignUpNumL.text = @"0/200";
        _SignUpNumL.textColor = COLOR_BLACK_CLASS_3;
        _SignUpNumL.font = NB_FONTSEIZ_NOR;
        _SignUpNumL.textAlignment = NSTextAlignmentLeft;
    }
    return _SignUpNumL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
