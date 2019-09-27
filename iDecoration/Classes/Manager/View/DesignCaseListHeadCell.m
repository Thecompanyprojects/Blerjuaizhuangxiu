//
//  DesignCaseListHeadCell.m
//  iDecoration
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DesignCaseListHeadCell.h"

@interface DesignCaseListHeadCell()
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UILabel *lab2;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) UIImageView *img1;
@end

@implementation DesignCaseListHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellID = @"DesignCaseListHeadCell";
    DesignCaseListHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[DesignCaseListHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.backImgV];
        [self addSubview:self.lab1];
        [self addSubview:self.lab2];
        [self addSubview:self.titleL];
        [self addSubview:self.titleTwo];
        [self addSubview:self.addMusicBtn];
        [self addSubview:self.editCoverBtn];
        [self addSubview:self.line];
        [self addSubview:self.img0];
        [self addSubview:self.img1];
        //        self.lineVTwo.hidden = YES;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(NSString *)title titleTwo:(NSString *)titleTwo coverImg:(NSString *)coverImg songName:(NSString *)songName{
    
    if (self.titleIsShow) {
        self.titleL.hidden = YES;
        self.titleTwo.hidden = YES;
    }
    self.titleL.text = title;
    if (titleTwo.length<=0) {
        titleTwo = @"(可不填写)";
    }
    self.titleTwo.text = titleTwo;
    [self.backImgV sd_setImageWithURL:[NSURL URLWithString:coverImg] placeholderImage:nil];

    if (!songName||songName.length<=0) {
        [self.addMusicBtn setTitle:@"添加音乐" forState:UIControlStateNormal];
        self.addMusicBtn.frame = CGRectMake(10, 185, 80, 20);
    }
    else{
        [self.addMusicBtn setTitle:songName forState:UIControlStateNormal];
        CGSize size = [songName boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH/2, 20) withFont:NB_FONTSEIZ_NOR];
        self.addMusicBtn.frame = CGRectMake(10, 185, size.width+30, 20);
    }
}

#pragma mark - action


-(void)changeTitle:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(changeCoverTitle)]) {
        [self.delegate changeCoverTitle];
    }
}

-(void)changeTitleTwo:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(changeCoverTitleTwo)]) {
        [self.delegate changeCoverTitleTwo];
    }
}

-(void)changeCover:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(changeCoverImg)]) {
        [self.delegate changeCoverImg];
    }
}

-(void)changeMusic:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addMusic)]) {
        [self.delegate addMusic];
    }
}

#pragma mark - lazy

-(UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 180)];
        //_backImgV.backgroundColor = COLOR_BLACK_CLASS_0;
        _backImgV.backgroundColor = [UIColor whiteColor];
        _backImgV.contentMode = UIViewContentModeScaleAspectFill;
        _backImgV.layer.masksToBounds = YES;
    }
    return _backImgV;
}

-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, self.backImgV.bottom+30, kSCREEN_WIDTH-20, 30)];
        _lab1.text = @"主 标 题";
        _lab1.textColor = COLOR_BLACK_CLASS_3;
        _lab1.font = [UIFont systemFontOfSize:16];
    }
    return _lab1;
}

-(UILabel *)lab2
{
    if(!_lab2)
    {
        _lab2 = [[UILabel alloc] init];
        _lab2 = [[UILabel alloc]initWithFrame:CGRectMake(self.lab1.left, self.lab1.bottom+10, kSCREEN_WIDTH-20, 30)];
        _lab2.textColor = COLOR_BLACK_CLASS_3;
        _lab2.font = [UIFont systemFontOfSize:16];
        _lab2.text = @"副 标 题";
    }
    return _lab2;
}

-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(120, self.lab1.top, kSCREEN_WIDTH-140, 30)];
        _titleL.textColor = COLOR_BLACK_CLASS_9;
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.text = @"";
        _titleL.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _titleL.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTitle:)];
        [_titleL addGestureRecognizer:ges];
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}

-(UILabel *)titleTwo{
    if (!_titleTwo) {
        _titleTwo = [[UILabel alloc]initWithFrame:CGRectMake(self.titleL.left, self.titleL.bottom+10, kSCREEN_WIDTH-140, 30)];
        _titleTwo.textColor = COLOR_BLACK_CLASS_9;
        _titleTwo.font = [UIFont boldSystemFontOfSize:14];
        _titleTwo.text = @"";
        _titleTwo.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _titleTwo.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTitleTwo:)];
        [_titleTwo addGestureRecognizer:ges];
        _titleTwo.textAlignment = NSTextAlignmentLeft;
    }
    return _titleTwo;
}

-(UIButton *)addMusicBtn{
    if (!_addMusicBtn) {
        _addMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addMusicBtn.frame = CGRectMake(10, 185, 80, 20);
        [_addMusicBtn setTitle:@"添加音乐" forState:UIControlStateNormal];
//        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addMusicBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _addMusicBtn.titleLabel.font = NB_FONTSEIZ_SMALL;
        _addMusicBtn.layer.masksToBounds = YES;
        _addMusicBtn.layer.cornerRadius = 5;
        _addMusicBtn.layer.borderWidth = 1.0;
        _addMusicBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        _addMusicBtn.backgroundColor = White_Color;
        [_addMusicBtn addTarget:self action:@selector(changeMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    }
    return _addMusicBtn;
}

-(UIButton *)editCoverBtn{
    if (!_editCoverBtn) {
        _editCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editCoverBtn.frame = CGRectMake(kSCREEN_WIDTH-10-80, self.addMusicBtn.top, self.addMusicBtn.width, self.addMusicBtn.height);
        [_editCoverBtn setTitle:@"编辑封面" forState:UIControlStateNormal];
        //        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_editCoverBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _editCoverBtn.titleLabel.font = NB_FONTSEIZ_SMALL;
        _editCoverBtn.layer.masksToBounds = YES;
        _editCoverBtn.layer.cornerRadius = 5;
        _editCoverBtn.layer.borderWidth = 1.0;
        _editCoverBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        _editCoverBtn.backgroundColor = White_Color;
        
        [_editCoverBtn addTarget:self action:@selector(changeCover:) forControlEvents:UIControlEventTouchUpInside];
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    }
    return _editCoverBtn;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = COLOR_BLACK_CLASS_3;
        _line.frame = CGRectMake(0, self.lab1.bottom+4.5, kSCREEN_WIDTH, 0.5);
    }
    return _line;
}

-(UIImageView *)img0
{
    if(!_img0)
    {
        _img0 = [[UIImageView alloc] init];
        _img0.frame = CGRectMake(kSCREEN_WIDTH-14-18, self.lab1.top+4, 18, 18);
        _img0.image = [UIImage imageNamed:@"right1"];
    }
    return _img0;
}

-(UIImageView *)img1
{
    if(!_img1)
    {
        _img1 = [[UIImageView alloc] init];
        _img1.frame = CGRectMake(self.img0.left, self.lab2.top+4, 18, 18);
        _img1.image = [UIImage imageNamed:@"right1"];
    }
    return _img1;
}

@end
