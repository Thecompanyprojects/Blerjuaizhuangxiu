//
//  VoteCommenCell.m
//  iDecoration
//
//  Created by sty on 2018/3/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "VoteCommenCell.h"

@implementation VoteCommenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *VoteCommenCellID = [NSString stringWithFormat:@"VoteCommenCell%ld%ld",path.section,path.row];
    VoteCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:VoteCommenCellID];
    //    cell.path = path;
    if (cell == nil) {
        cell =[[VoteCommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VoteCommenCellID];
    }
    
    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        //        self.backgroundColor = kSepLineColor;
        
        self.backgroundColor = RGB(241, 242, 245);
        
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.addVoteL];
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.deleteBtn];
        [self.backView addSubview:self.votePlacholdV];
        [self.backView addSubview:self.voteTitleL];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configCrib:(NSString *)cribStr isHaveVote:(BOOL)isHaveVote{
    if (!isHaveVote) {
        self.deleteBtn.hidden = YES;
        self.votePlacholdV.hidden = YES;
        self.voteTitleL.hidden = YES;
        
        self.addVoteL.hidden = NO;
        self.imgV.hidden = NO;
        self.backView.frame = CGRectMake(5, 0, kSCREEN_WIDTH-10, 50);
    }
    else{
        self.deleteBtn.hidden = NO;
        self.votePlacholdV.hidden = NO;
        self.voteTitleL.hidden = NO;
        
        self.addVoteL.hidden = YES;
        self.imgV.hidden = YES;
        self.backView.frame = CGRectMake(5, 0, kSCREEN_WIDTH-10, 125);
        
    }
    
    CGFloat width = self.backView.height-self.deleteBtn.bottom*2;
    self.votePlacholdV.frame = CGRectMake(self.deleteBtn.right, self.deleteBtn.bottom, width, width);
    self.voteTitleL.frame = CGRectMake(self.votePlacholdV.right+10,self.votePlacholdV.top,self.backView.width-self.votePlacholdV.right-10,21);
    self.voteTitleL.text = cribStr;
}

#pragma mark - action

-(void)removeVote:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteVote)]) {
        [self.delegate deleteVote];
    }
}


-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kSCREEN_WIDTH-10, 50)];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 10;
        //        _backView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        _backView.layer.borderWidth = 1.0f;
        //        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VRGes:)];
        //        //        ges.numberOfTouches = 1;
        //        _VRview.userInteractionEnabled = YES;
        //        [_VRview addGestureRecognizer:ges];
        _backView.backgroundColor = White_Color;
        
    }
    return _backView;
}

-(UILabel *)addVoteL{
    if (!_addVoteL) {
        _addVoteL = [[UILabel alloc]initWithFrame:CGRectMake(self.backView.width/2-20, 0, 80, 50)];
        _addVoteL.textColor = RGB(211, 192, 185);
        _addVoteL.font = NB_FONTSEIZ_BIG;
        _addVoteL.text = @"添加投票";
        
        //        companyJob.backgroundColor = Red_Color;
        _addVoteL.textAlignment = NSTextAlignmentLeft;
    }
    return _addVoteL;
}

-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.addVoteL.left-17-8,self.backView.height/2-8.5,17,17)];
        _imgV.image = [UIImage imageNamed:@"poster_add"];
    }
    return _imgV;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(5, 5, 15, 15);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_deleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(removeVote:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

-(UIImageView *)votePlacholdV{
    if (!_votePlacholdV) {
        CGFloat width = self.backView.height-self.deleteBtn.bottom*2;
        _votePlacholdV = [[UIImageView alloc]initWithFrame:CGRectMake(self.deleteBtn.right, self.deleteBtn.bottom, width, width)];
        _votePlacholdV.image = [UIImage imageNamed:@"poster_seletion"];
    }
    return _votePlacholdV;
}

-(UILabel *)voteTitleL{
    if (!_voteTitleL) {
        _voteTitleL = [[UILabel alloc]initWithFrame:CGRectMake(self.votePlacholdV.right+10,self.votePlacholdV.top,self.backView.width-self.votePlacholdV.right-10,21)];
        _voteTitleL.textColor = COLOR_BLACK_CLASS_3;
        _voteTitleL.font = NB_FONTSEIZ_NOR;
        _voteTitleL.text = @"添加投票";
        _voteTitleL.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _voteTitleL.textAlignment = NSTextAlignmentLeft;
    }
    return _voteTitleL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
