//
//  GoodsEditCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsEditCell.h"
#import "GoodsEditModel.h"


@implementation GoodsEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView path:(NSIndexPath *)path
{
    static NSString *TextFieldCellID = @"DesignCaseListMidCell";
    GoodsEditCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[GoodsEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    //    cell.backgroundColor = RGB(241, 242, 245);
    cell.path = path;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.addBtn];
        [self.backGroundV addSubview:self.hiddenV];
        [self.hiddenV addSubview:self.addTextBtn];
        [self.hiddenV addSubview:self.addPhotoBtn];
        [self.hiddenV addSubview:self.addVideoBtn];
        
        [self.backGroundV addSubview:self.backView];
        [self.backView addSubview:self.deleteBtn];
        [self.backView addSubview:self.photoImgV];
        [self.backView addSubview:self.textL];
        [self.backView addSubview:self.moveUpBtn];
        [self.backView addSubview:self.moveDownBtn];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

#pragma mark - action

-(void)configWith:(BOOL)isHidden data:(id)data isHaveDefaultLogo:(BOOL)isHaveDefaultLogo{
    if ([data isKindOfClass:[GoodsEditModel class]]) {
        GoodsEditModel *model = data;
        
        
        if (isHaveDefaultLogo) {
            if (model.image) {
                self.photoImgV.image = model.image;
            } else {
                [self.photoImgV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"edit_text_icon_normal"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        return;
                    }
                    
                    [self setNeedsLayout];
                    [self layoutIfNeeded];
                }];
            }
            
        }
        else{
            if (model.image) {
                self.photoImgV.image = model.image;
            } else {
                [self.photoImgV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:DefaultIcon] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        return;
                    }
                    
                    [self setNeedsLayout];
                    [self layoutIfNeeded];
                }];
            }
            
        }
        
        if (model.contentText.length<=0) {
            self.textL.text = @"点击添加文字";
            self.textL.textColor = COLOR_BLACK_CLASS_9;
        }
        else{
            self.textL.text = model.contentText;
            self.textL.textColor = COLOR_BLACK_CLASS_3;
        }
        
        
        CGSize textSize = [model.contentText boundingRectWithSize:CGSizeMake(self.backView.width-self.photoImgV.right-10-30, self.photoImgV.height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                      context:nil].size;
        if (textSize.height<=0) {
            self.textL.frame = CGRectMake(self.photoImgV.right+10, self.photoImgV.top, self.backView.width-self.photoImgV.right-10-30, 20);
        }
        else{
            self.textL.frame = CGRectMake(self.photoImgV.right+10, self.photoImgV.top, self.backView.width-self.photoImgV.right-10-30, textSize.height);
        }
        
        
        if (isHidden) {
            //隐藏
            self.addBtn.hidden = NO;
            self.hiddenV.hidden = YES;
            self.backGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,150);
            self.backView.frame = CGRectMake(5, self.addBtn.bottom+5, kSCREEN_WIDTH-10, 125);
            self.cellH = 150;
        }
        else{
            self.addBtn.hidden = YES;
            self.hiddenV.hidden = NO;
            self.backGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,165);
            self.backView.frame = CGRectMake(5, self.hiddenV.bottom+5, kSCREEN_WIDTH-10, 125);
            self.cellH = 165;
        }
    }
    
}

-(void)addBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(changeHiddenState:)]) {
        [self.delegate changeHiddenState:self.path];
    }
}

-(void)backGroundVGes:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(changeToHidden:)]) {
        [self.delegate changeToHidden:self.path];
    }
}

-(void)photoImgVClick:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(changePhotoCell:)]) {
        [self.delegate changePhotoCell:self.path];
    }
}

-(void)addTextBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addTextCell:)]) {
        [self.delegate addTextCell:self.path];
    }
}

-(void)addPhotoBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addPhotoCell:)]) {
        [self.delegate addPhotoCell:self.path];
    }
}

-(void)addVideoBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(addVideoCell:)]) {
        [self.delegate addVideoCell:self.path];
    }
}

-(void)removeBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(removePhotoCell:)]) {
        [self.delegate removePhotoCell:self.path];
    }
}

-(void)backViewClick:(UITapGestureRecognizer *)ges{
    if ([self.delegate respondsToSelector:@selector(editTextCell:)]) {
        [self.delegate editTextCell:self.path];
    }
}

-(void)moveToUp:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(moveCellToUp:)]) {
        [self.delegate moveCellToUp:self.path];
    }
}

-(void)moveToDown:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(moveCellToDown:)]) {
        [self.delegate moveCellToDown:self.path];
    }
}

#pragma mark - lazy

-(UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH,150)];
        //        _backView.layer.masksToBounds = YES;
        //        _backView.layer.cornerRadius = 10;
        //        _backView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        _backView.layer.borderWidth = 1.0f;
        _backGroundV.backgroundColor = RGB(241, 242, 245);
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundVGes:)];
        [_backGroundV addGestureRecognizer:ges];
    }
    return _backGroundV;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(kSCREEN_WIDTH/2-13, 5, 26, 15);
        //        _addBtn.backgroundColor = Red_Color;
        [_addBtn setImage:[UIImage imageNamed:@"edit_insert_normal"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(5, self.addBtn.bottom+5, kSCREEN_WIDTH-10, 125)];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 10;
        _backView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        _backView.layer.borderWidth = 1.0f;
        _backView.backgroundColor = White_Color;
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewClick:)];
        [_backView addGestureRecognizer:ges];
    }
    return _backView;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(5, 5, 15, 15);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_deleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(removeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

-(UIImageView *)photoImgV{
    if (!_photoImgV) {
        CGFloat width = self.backView.height-self.deleteBtn.bottom*2;
        _photoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.deleteBtn.right, self.deleteBtn.bottom, width, width)];
        _photoImgV.image = [UIImage imageNamed:@"edit_text_icon_normal"];
        _photoImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoImgVClick:)];
        [_photoImgV addGestureRecognizer:ges];
        _photoImgV.layer.masksToBounds = YES;
        _photoImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImgV;
}

-(UILabel *)textL{
    if (!_textL) {
        //        _textL = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImgV.right+10, self.photoImgV.top, self.backView.width-self.photoImgV.right-10, self.photoImgV.height)];
        _textL = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImgV.right+10, self.photoImgV.top, self.backView.width-self.photoImgV.right-10-30, 20)];
        _textL.textColor = COLOR_BLACK_CLASS_9;
        _textL.font = NB_FONTSEIZ_NOR;
        _textL.numberOfLines = 0;
        _textL.text = @"点击添加文字";
        _textL.userInteractionEnabled = YES;
        
        //        companyJob.backgroundColor = Red_Color;
        _textL.textAlignment = NSTextAlignmentLeft;
    }
    return _textL;
}

-(UIButton *)moveUpBtn{
    if (!_moveUpBtn) {
        _moveUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moveUpBtn.frame = CGRectMake(self.backView.width-30, 0, 30, 30);
        [_moveUpBtn setImage:[UIImage imageNamed:@"edit_moveup"] forState:UIControlStateNormal];
        [_moveUpBtn addTarget:self action:@selector(moveToUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moveUpBtn;
}

-(UIButton *)moveDownBtn{
    if (!_moveDownBtn) {
        _moveDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moveDownBtn.frame = CGRectMake(self.moveUpBtn.left, self.backView.height-30, self.moveUpBtn.width, self.moveUpBtn.height);
        [_moveDownBtn setImage:[UIImage imageNamed:@"edit_movedown"] forState:UIControlStateNormal];
        [_moveDownBtn addTarget:self action:@selector(moveToDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moveDownBtn;
}

-(UIView *)hiddenV{
    if (!_hiddenV) {
        _hiddenV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-54*3/2, 5, 54*3, 30)];
        //        _hiddenV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-54*2/2, 5, 54*2, 30)];
        _hiddenV.layer.masksToBounds = YES;
        //        _hiddenV.backgroundColor = White_Color;
        _hiddenV.layer.cornerRadius = 15;
        //        _hiddenV.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        _hiddenV.layer.borderWidth = 1.0f;
        //        _hiddenV.backgroundColor = White_Color;
    }
    return _hiddenV;
}

-(UIButton *)addTextBtn{
    if (!_addTextBtn) {
        _addTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _addTextBtn.frame = CGRectMake(0, 0, self.hiddenV.width/2, self.hiddenV.height);
        _addTextBtn.frame = CGRectMake(0, 0, self.hiddenV.width/3, self.hiddenV.height);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_normal"] forState:UIControlStateNormal];
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_pressed"] forState:UIControlStateHighlighted];
        [_addTextBtn addTarget:self action:@selector(addTextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTextBtn;
}

-(UIButton *)addPhotoBtn{
    if (!_addPhotoBtn) {
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _addPhotoBtn.frame = CGRectMake(self.addTextBtn.right, 0, self.hiddenV.width/2, self.hiddenV.height);
        _addPhotoBtn.frame = CGRectMake(self.addTextBtn.right, 0, self.hiddenV.width/3, self.hiddenV.height);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_addPhotoBtn setImage:[UIImage imageNamed:@"edit_add_image_normal"] forState:UIControlStateNormal];
        [_addPhotoBtn setImage:[UIImage imageNamed:@"edit_add_image_pressed"] forState:UIControlStateHighlighted];
        [_addPhotoBtn addTarget:self action:@selector(addPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //        _addPhotoBtn.layer.masksToBounds = YES;
        //        _addPhotoBtn.layer.cornerRadius = 10;
    }
    return _addPhotoBtn;
}

-(UIButton *)addVideoBtn{
    if (!_addVideoBtn) {
        _addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addVideoBtn.frame = CGRectMake(self.addPhotoBtn.right, 0, self.hiddenV.width/3, self.hiddenV.height);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_video_normal"] forState:UIControlStateNormal];
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_videl_pressed"] forState:UIControlStateHighlighted];
        [_addVideoBtn addTarget:self action:@selector(addVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addVideoBtn;
}

@end

