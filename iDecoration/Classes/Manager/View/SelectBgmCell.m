//
//  SelectBgmCell.m
//  iDecoration
//
//  Created by sty on 2017/8/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SelectBgmCell.h"

@implementation SelectBgmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView path:(NSIndexPath *)path
{
    static NSString *TextFieldCellIDTwo = @"SelectBgmCell";
    SelectBgmCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellIDTwo];
    if (cell == nil) {
        cell =[[SelectBgmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellIDTwo];
    }
    cell.path = path;
    //    cell.backgroundColor = RGB(241, 242, 245);
    cell.userInteractionEnabled = YES;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = RGB(241, 242, 245);
        self.backgroundColor = White_Color;

        [self addSubview:self.backGronudV];
        [self.backGronudV addSubview:self.headTitleL];
        [self.backGronudV addSubview:self.numL];
        [self.backGronudV addSubview:self.checkImg];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(NSString *)headTitle count:(NSInteger)count dataArray:(NSArray *)dateArray isOpen:(BOOL)isOpen isShowHeadCheck:(BOOL)isShowHeadCheck musicTag:(NSInteger)musicTag{
    
    
    [self removeAllSubViews];
    [self addSubview:self.backGronudV];
    self.backGronudV.frame = CGRectMake(0, 10, kSCREEN_WIDTH-20, 50);
    
    self.headTitleL.text = headTitle;
    self.numL.text = [NSString stringWithFormat:@"%ld首",count];
    self.cellH = self.backGronudV.bottom;
    if (isOpen) {
        self.checkImg.hidden = YES;
        NSInteger count = dateArray.count;
        self.cellH = self.cellH+10;
        for (int i = 0; i<count; i++) {
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(15, self.cellH-1, self.backGronudV.width-15, 1)];
            lineV.backgroundColor = COLOR_BLACK_CLASS_0;
            UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectMake(15, lineV.bottom, self.backGronudV.width-15, 40)];
            contentL.textColor = COLOR_BLACK_CLASS_3;
            contentL.font = NB_FONTSEIZ_NOR;
            NSString *contentStr = dateArray[i];
            contentL.text = contentStr;
            contentL.backgroundColor = White_Color;
            
            contentL.userInteractionEnabled = YES;
            contentL.tag = i;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectMusicGes:)];
            [contentL addGestureRecognizer:ges];
            
            [self addSubview:lineV];
            [self addSubview:contentL];
            
            UIImageView *checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.backGronudV.width-24-15, self.cellH+7, 24, 24)];
            checkImg.image = [UIImage imageNamed:@"check_select"];
            [self addSubview:checkImg];
            if (musicTag==-1) {
                checkImg.hidden = YES;
            }
            else{
                if (musicTag==i) {
                    checkImg.hidden = NO;
                }
                else{
                    checkImg.hidden = YES;
                }
            }
            self.cellH = self.cellH+40;
        }
        
    }
    else{
        if (isShowHeadCheck) {
            self.checkImg.hidden = NO;
        }
        else{
            self.checkImg.hidden = YES;
        }
        
    }
//    self.cellH = self.backGronudV.bottom;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
}

-(void)selectMusicGes:(UITapGestureRecognizer *)ges{
    NSInteger tag = ges.view.tag;
    if ([self.delegate respondsToSelector:@selector(selectMusicPath:tag:)]) {
        [self.delegate selectMusicPath:self.path tag:tag];
    }
}

-(void)backGronudVClick:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(openOrCloseTargetWith:)]) {
        [self.delegate openOrCloseTargetWith:self.path];
    }
}

#pragma mark - lazy

-(UIView *)backGronudV{
    if (!_backGronudV) {
        _backGronudV = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH-20, 50)];
        _backGronudV.backgroundColor = White_Color;
//        _backGronudV.layer.masksToBounds = YES;
//        _backGronudV.layer.cornerRadius = 10;
        
        _backGronudV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGronudVClick:)];
        [_backGronudV addGestureRecognizer:ges];
    }
    return _backGronudV;
}

-(UILabel *)headTitleL{
    if (!_headTitleL) {
        _headTitleL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH-15, 30)];
        _headTitleL.textColor = COLOR_BLACK_CLASS_3;
        _headTitleL.font = NB_FONTSEIZ_BIG;
        
    }
    return _headTitleL;
}

-(UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]initWithFrame:CGRectMake(self.headTitleL.left, self.headTitleL.bottom, self.headTitleL.width, 20)];
        _numL.textColor = COLOR_BLACK_CLASS_9;
        _numL.font = NB_FONTSEIZ_SMALL;
        
    }
    return _numL;
}

-(UIImageView *)checkImg{
    if (!_checkImg) {
        _checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.backGronudV.width-24-15, self.backGronudV.height/2-24/2-5, 24, 24)];
        
        _checkImg.image = [UIImage imageNamed:@"check_select"];
    }
    return _checkImg;
}

- (void)setSelected:(BOOL)selected animated
                   :(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
