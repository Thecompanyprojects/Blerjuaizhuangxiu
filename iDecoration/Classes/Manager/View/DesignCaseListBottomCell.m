//
//  DesignCaseListBottomCell.m
//  iDecoration
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DesignCaseListBottomCell.h"

@implementation DesignCaseListBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = RGB(241, 242, 245);
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellIDTwo = @"DesignCaseListBottomCell";
    DesignCaseListBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellIDTwo];
    if (cell == nil) {
        cell =[[DesignCaseListBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellIDTwo];
    }
//    cell.backgroundColor = RGB(241, 242, 245);
    cell.userInteractionEnabled = YES;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.bottombackGroundV];
        
//        [self.bottombackGroundV addSubview:self.bottomaddBtn];
//        [self.bottombackGroundV addSubview:self.hiddenV];
        
//        [self.bottombackGroundV addSubview:self.backView];
//        [self.backView addSubview:self.addVoteL];
//        [self.backView addSubview:self.imgV];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(BOOL)isHidden{
//    if (isHidden) {
//        //隐藏
//        self.bottomaddBtn.hidden = NO;
//        self.hiddenV.hidden = YES;
//        self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,60);
//        self.backView.frame = CGRectMake(5, self.bottomaddBtn.bottom+5, kSCREEN_WIDTH-10, 35);
//        self.cellH = 60;
//    }
//    else{
//        self.bottomaddBtn.hidden = YES;
//        self.hiddenV.hidden = NO;
//        self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,75);
//        self.backView.frame = CGRectMake(5, self.hiddenV.bottom+5, kSCREEN_WIDTH-10, 35);
//        self.cellH = 75;
//    }
    self.cellH = 60;
}

#pragma mark - action

-(void)bottomaddBtnClick{
    YSNLog(@"111");
    if ([self.delegate respondsToSelector:@selector(changeBottomHiddenState)]) {
        [self.delegate changeBottomHiddenState];
    }
}

-(void)backGroundVGes:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(changeBottomToHidden)]) {
        [self.delegate changeBottomToHidden];
    }
}

#pragma mark - lazy

-(UIView *)bottombackGroundV{
    if (!_bottombackGroundV) {
        _bottombackGroundV = [[UIView alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH,60)];
//        _bottombackGroundV.backgroundColor = RGB(241, 242, 245);
        _bottombackGroundV.backgroundColor = Red_Color;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundVGes:)];
//        ges.numberOfTouches = 1;
        _bottombackGroundV.userInteractionEnabled = YES;
        [_bottombackGroundV addGestureRecognizer:ges];
    }
    return _bottombackGroundV;
}

-(UIButton *)bottomaddBtn{
    if (!_bottomaddBtn) {
        _bottomaddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomaddBtn.frame = CGRectMake(kSCREEN_WIDTH/2-13, 5, 26, 15);
        //        _addBtn.backgroundColor = Red_Color;
        [_bottomaddBtn setImage:[UIImage imageNamed:@"edit_insert_normal"] forState:UIControlStateNormal];
        [_bottomaddBtn addTarget:self action:@selector(bottomaddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomaddBtn;
}




-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(5, self.bottomaddBtn.bottom+5, kSCREEN_WIDTH-10, 35)];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 10;
//        _backView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
//        _backView.layer.borderWidth = 1.0f;
        _backView.backgroundColor = White_Color;
        
    }
    return _backView;
}

-(UILabel *)addVoteL{
    if (!_addVoteL) {
        _addVoteL = [[UILabel alloc]initWithFrame:CGRectMake(self.backView.width/2-20, 0, 80, self.backView.height)];
        _addVoteL.textColor = RGB(211, 192, 185);
        _addVoteL.font = NB_FONTSEIZ_NOR;
        _addVoteL.text = @"添加投票";
        
        //        companyJob.backgroundColor = Red_Color;
        _addVoteL.textAlignment = NSTextAlignmentLeft;
    }
    return _addVoteL;
}

-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.addVoteL.left-10-15,self.backView.height/2-7.5,15,15)];
        _imgV.image = [UIImage imageNamed:@"poster_add"];
    }
    return _imgV;
}

-(UIView *)hiddenV{
    if (!_hiddenV) {
        _hiddenV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/10*3, 5, kSCREEN_WIDTH/10*4, 30)];
        _hiddenV.layer.masksToBounds = YES;
        _hiddenV.layer.cornerRadius = 10;
        _hiddenV.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        _hiddenV.layer.borderWidth = 1.0f;
        _hiddenV.backgroundColor = White_Color;
    }
    return _hiddenV;
}

@end
