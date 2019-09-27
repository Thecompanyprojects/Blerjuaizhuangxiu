//
//  VrCommenCell.m
//  iDecoration
//
//  Created by sty on 2018/3/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "VrCommenCell.h"

@implementation VrCommenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *VrCommenCellID = [NSString stringWithFormat:@"VrCommenCell%ld%ld",path.section,path.row];
    VrCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:VrCommenCellID];
    //    cell.path = path;
    if (cell == nil) {
        cell =[[VrCommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VrCommenCellID];
    }
    
    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        //        self.backgroundColor = kSepLineColor;
        
        self.backgroundColor = RGB(241, 242, 245);
        
        [self addSubview:self.VRview];
        
        [self.VRview addSubview:self.VRBtn];
        [self.VRview addSubview:self.VRLabel];
        [self.VRview addSubview:self.VRdeleteBtn];
        [self.VRview addSubview:self.VRPlacholdV];
        [self.VRview addSubview:self.VRTitleL];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configCrib:(NSString *)cribStr imgStr:(NSString *)imgStr isHaveVR:(BOOL)isHaveVR{
    
    if (!isHaveVR) {
        self.VRdeleteBtn.hidden = YES;
        self.VRPlacholdV.hidden = YES;
        self.VRTitleL.hidden = YES;
        
        self.VRBtn.hidden = NO;
        self.VRLabel.hidden = NO;
        
        
        self.VRview.frame = CGRectMake(5, 0, kSCREEN_WIDTH-10, 50);

    }
    else{
        self.VRdeleteBtn.hidden = NO;
        self.VRPlacholdV.hidden = NO;
        self.VRTitleL.hidden = NO;
        
        self.VRBtn.hidden = YES;
        self.VRLabel.hidden = YES;
        
        self.VRview.frame = CGRectMake(5, 0, kSCREEN_WIDTH-10, 125);
        
        [self.VRPlacholdV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        self.VRTitleL.text = cribStr;
    }
    
    self.VRBtn.frame = CGRectMake(self.VRview.width/2-80, self.VRview.height/2-10.5, 30, 21);
    self.VRLabel.frame = CGRectMake(self.VRBtn.right+5, self.VRBtn.top, 120, self.VRBtn.height);
    
    CGFloat widthTwo = self.VRview.height-self.VRdeleteBtn.bottom*2;
    self.VRPlacholdV.frame = CGRectMake(self.VRdeleteBtn.right, self.VRdeleteBtn.bottom, widthTwo, widthTwo);
    self.VRTitleL.frame = CGRectMake(self.VRPlacholdV.right+10,self.VRPlacholdV.top,self.VRview.width-self.VRPlacholdV.right-10,21);
}

#pragma mark - action

-(void)removeVR:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteVr)]) {
        [self.delegate deleteVr];
    }
}

-(UIView *)VRview{
    if (!_VRview) {
        _VRview = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kSCREEN_WIDTH-10, 125)];
        _VRview.layer.masksToBounds = YES;
        _VRview.layer.cornerRadius = 10;
        //        _backView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        _backView.layer.borderWidth = 1.0f;
//        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VRGes:)];
//        //        ges.numberOfTouches = 1;
//        _VRview.userInteractionEnabled = YES;
//        [_VRview addGestureRecognizer:ges];
        _VRview.backgroundColor = White_Color;
        
    }
    return _VRview;
}

-(UIButton *)VRBtn{
    if (!_VRBtn) {
        _VRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _VRBtn.frame = CGRectMake(self.VRview.width/2-80, self.VRview.height/2-10.5, 30, 21);
        [_VRBtn setTitle:@"VR" forState:UIControlStateNormal];
        [_VRBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _VRBtn.layer.masksToBounds = YES;
        _VRBtn.layer.cornerRadius = 5;
        
        _VRBtn.backgroundColor = COLOR_BLACK_CLASS_3;
        _VRBtn.titleLabel.font = NB_FONTSEIZ_BIG;
    }
    return _VRBtn;
}

-(UILabel *)VRLabel{
    if (!_VRLabel) {
        _VRLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.VRBtn.right+5, self.VRBtn.top, 120, self.VRBtn.height)];
        _VRLabel.textColor = RGB(211, 192, 185);
        _VRLabel.textAlignment = NSTextAlignmentLeft;
        _VRLabel.font = NB_FONTSEIZ_BIG;
        _VRLabel.text = @"添加全景效果图";
    }
    return _VRLabel;
}

-(UIButton *)VRdeleteBtn{
    if (!_VRdeleteBtn) {
        _VRdeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _VRdeleteBtn.frame = CGRectMake(5, 5, 15, 15);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_VRdeleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_VRdeleteBtn addTarget:self action:@selector(removeVR:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _VRdeleteBtn;
}

-(UIImageView *)VRPlacholdV{
    if (!_VRPlacholdV) {
        CGFloat width = self.VRview.height-self.VRdeleteBtn.bottom*2;
        _VRPlacholdV = [[UIImageView alloc]initWithFrame:CGRectMake(self.VRdeleteBtn.right, self.VRdeleteBtn.bottom, width, width)];
        _VRPlacholdV.image = [UIImage imageNamed:DefaultIcon];
    }
    return _VRPlacholdV;
}

-(UILabel *)VRTitleL{
    if (!_VRTitleL) {
        _VRTitleL = [[UILabel alloc]initWithFrame:CGRectMake(self.VRPlacholdV.right+10,self.VRPlacholdV.top,self.VRview.width-self.VRPlacholdV.right-10,21)];
        _VRTitleL.textColor = COLOR_BLACK_CLASS_3;
        _VRTitleL.font = NB_FONTSEIZ_NOR;
        _VRTitleL.text = @"添加全景";
        _VRTitleL.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _VRTitleL.textAlignment = NSTextAlignmentLeft;
    }
    return _VRTitleL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
