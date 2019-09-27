//
//  DesignIntroduceCell.m
//  iDecoration
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DesignIntroduceCell.h"
#import "CaseDesignModel.h"

@interface DesignIntroduceCell ()<UITextViewDelegate>

@end

@implementation DesignIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path 
{
    static NSString *TextFieldCellID = @"DesignIntroduceCell";
    DesignIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[DesignIntroduceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    cell.path = path;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.saySomeV];
        [self.saySomeV addSubview:self.someL];
        [self addSubview:self.photoV];
        [self addSubview:self.supportL];
        [self addSubview:self.continueAddBtn];
//        [self resetBottomV];
        [self addSubview:self.bottomV];
        
        [self addSubview:self.deleteModelBtn];
        self.continueAddBtn.hidden = YES;

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data isPower:(BOOL)isPower isEdit:(BOOL)isEdit{
    if ([data isKindOfClass:[CaseDesignModel class]]) {
        CaseDesignModel *model = data;
        NSString *comment = model.cdDesignComments;
        if (!isPower) {
            self.someL.hidden = YES;
        }
        else{
            if (!comment||comment.length<=0) {
                //            comment = @"";
                self.someL.hidden = NO;
            }
            else{
                self.someL.hidden = YES;
            }
        }
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 10;
        paragraphStyle.firstLineHeadIndent = 10;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.paragraphSpacing = 10;
//        paragraphStyle.headIndent = 2;
        NSDictionary *attributes = @{NSFontAttributeName:NB_FONTSEIZ_NOR,NSParagraphStyleAttributeName:paragraphStyle};
        self.saySomeV.attributedText = [[NSAttributedString alloc]initWithString:comment attributes:attributes];
        
        CGSize sizeToFit = [self.saySomeV sizeThatFits:CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT)];
        
//        if (comment.length<=0) {
        
        if (!comment||comment.length<=0) {
            sizeToFit.height = 30;
        }
        self.saySomeV.frame = CGRectMake(10, 0, kSCREEN_WIDTH-20, sizeToFit.height);
        self.someL.frame = CGRectMake(14, 0, self.saySomeV.width-14, self.saySomeV.height);
        if (model.cdPicture.length<=0) {
//            self.photoV.frame = CGRectMake(15, self.saySomeV.bottom, kSCREEN_WIDTH/3,kSCREEN_WIDTH/3);
//            self.photoV.image = [UIImage imageNamed:@"jia1"];
            self.deleteModelBtn.hidden = YES;
            
            if (!isPower) {
                self.photoV.frame = CGRectMake(15, self.saySomeV.bottom, kSCREEN_WIDTH/3,0);
            }else{
                if (!isEdit) {
                    self.photoV.frame = CGRectMake(15, self.saySomeV.bottom, kSCREEN_WIDTH/3,0);
                }
                else{
                    self.photoV.frame = CGRectMake(15, self.saySomeV.bottom, kSCREEN_WIDTH/3,kSCREEN_WIDTH/3);
                    self.photoV.image = [UIImage imageNamed:@"jia1"];
                }
            }
            
//            self.supportL.frame = CGRectMake(0, self.photoV.bottom+5, kSCREEN_WIDTH, 20);
//            self.continueAddBtn.frame = CGRectMake(kSCREEN_WIDTH-15-80, self.supportL.bottom+5, 80, 20);
//            
//            self.bottomV.frame = CGRectMake(0, self.continueAddBtn.bottom+5, kSCREEN_WIDTH, 50);
//            self.cellH = self.bottomV.bottom+20;
            
        }
        else{
            
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:model.cdPicture]];
            SDImageCache *cache = [SDImageCache sharedImageCache];
            UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
            
            if (cachedImage) {
                self.photoV.image = cachedImage;
                
                [self.photoV sizeToFit];
                CGFloat orgalW = self.photoV.width;
                CGFloat orgalH= self.photoV.height;
                CGFloat nowW = kSCREEN_WIDTH-30;
                CGFloat nowH = orgalH * nowW / orgalW;
                self.photoV.frame = CGRectMake(15, self.saySomeV.bottom+20, nowW,nowH);
                self.deleteModelBtn.hidden = NO;
                
                self.deleteModelBtn.frame = CGRectMake(kSCREEN_WIDTH-30, self.photoV.top-10, 30, 30);
                self.deleteModelBtn.layer.cornerRadius = self.deleteModelBtn.width/2;
                
            }
            
            else{
                
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.cdPicture]];
                UIImage *image = [[UIImage alloc]initWithData:data];
                if (!image) {
                    image = [UIImage imageNamed:DefaultIcon];
                }
                self.photoV.image = image;
                [self.photoV sizeToFit];
                CGFloat orgalW = self.photoV.width;
                CGFloat orgalH= self.photoV.height;
                CGFloat nowW = kSCREEN_WIDTH-30;
                CGFloat nowH = orgalH * nowW / orgalW;
                self.photoV.frame = CGRectMake(15, self.saySomeV.bottom+20, nowW,nowH);
                self.deleteModelBtn.hidden = NO;
                
                self.deleteModelBtn.frame = CGRectMake(kSCREEN_WIDTH-30, self.photoV.top-10, 30, 30);
                self.deleteModelBtn.layer.cornerRadius = self.deleteModelBtn.width/2;
                
                [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                //                    [SDImageCache sharedImageCache] remove
            }
            
            
            
            
            
        }
        
        self.supportL.frame = CGRectMake(0, self.photoV.bottom+5, kSCREEN_WIDTH, 20);
        self.continueAddBtn.frame = CGRectMake(kSCREEN_WIDTH-15-80, self.supportL.bottom+5, 80, 20);
        self.bottomV.frame = CGRectMake(0, self.continueAddBtn.bottom+5, kSCREEN_WIDTH, 50);
        self.cellH = self.bottomV.bottom+10;

        
        
    }
}


#pragma mark - setter

-(UIButton *)deleteModelBtn{
    if (!_deleteModelBtn) {
        _deleteModelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteModelBtn.frame = CGRectMake(kSCREEN_WIDTH-20, 0, 20, 20);

        _deleteModelBtn.layer.masksToBounds = YES;
        _deleteModelBtn.layer.cornerRadius = 10;
//        _addBtn.layer.borderWidth = 1.0;
//        _addBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        //            _addressBtn.backgroundColor = Red_Color;
        [_deleteModelBtn setImage:[UIImage imageNamed:@"del02"] forState:UIControlStateNormal];
        [_deleteModelBtn addTarget:self action:@selector(deletebtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteModelBtn;
}

-(UITextView *)saySomeV{
    if (!_saySomeV) {
        _saySomeV = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH-20, 50)];
        _saySomeV.delegate = self;
        _saySomeV.textColor = COLOR_BLACK_CLASS_3;
        _saySomeV.font = NB_FONTSEIZ_NOR;
        _saySomeV.scrollEnabled = NO;
//        _saySomeV.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _saySomeV;
}

-(UILabel *)someL{
    if (!_someL) {
        _someL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.saySomeV.width, 21)];
        _someL.textColor = COLOR_BLACK_CLASS_9;
        _someL.font = [UIFont systemFontOfSize
                         :14];
        //        companyJob.backgroundColor = Red_Color;
        _someL.textAlignment = NSTextAlignmentLeft;
        _someL.text = @"说点什么吧";
    }
    return _someL;
}

-(UIImageView *)photoV{
    if (!_photoV) {
        _photoV = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.saySomeV.bottom, kSCREEN_WIDTH-30, 200)];
        _photoV.image = [UIImage imageNamed:@"jia-kong"];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoVClick)];
        _photoV.userInteractionEnabled = YES;
        [_photoV addGestureRecognizer:ges];
    }
    
    return _photoV;
}

-(UILabel *)supportL{
    if (!_supportL) {
        _supportL = [[UILabel alloc]initWithFrame:CGRectMake(0, self.photoV.bottom+5, kSCREEN_WIDTH, 20)];
        _supportL.textColor = COLOR_BLACK_CLASS_9;
        _supportL.font = [UIFont systemFontOfSize
                       :14];
        //        companyJob.backgroundColor = Red_Color;
        _supportL.textAlignment = NSTextAlignmentCenter;
        _supportL.text = @"建议对每张效果图分开讲解";
    }
    return _supportL;
}

-(UIButton *)continueAddBtn{
    if (!_continueAddBtn) {
        _continueAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueAddBtn.frame = CGRectMake(kSCREEN_WIDTH-15-80, self.supportL.bottom+5, 80, 20);
        [_continueAddBtn setTitle:@"继续添加" forState:UIControlStateNormal];
//        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_continueAddBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        _continueAddBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [_continueAddBtn addTarget:self action:@selector(continueAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueAddBtn;
}

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, self.continueAddBtn.bottom+5, kSCREEN_WIDTH, 50)];
        _bottomV.backgroundColor = White_Color;
        _bottomV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popV)];
        [_bottomV addGestureRecognizer:ges];
        
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
        leftL.textColor = COLOR_BLACK_CLASS_3;
        leftL.font = [UIFont systemFontOfSize
                      :14];
        //        companyJob.backgroundColor = Red_Color;
        leftL.textAlignment = NSTextAlignmentLeft;
        leftL.text = @"谁能看见";
        
        UILabel *rightL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-30-120, 0, 120, 50)];
        rightL.textColor = COLOR_BLACK_CLASS_3;
        rightL.font = [UIFont systemFontOfSize
                       :14];
        //        companyJob.backgroundColor = Red_Color;
        rightL.textAlignment = NSTextAlignmentRight;
        rightL.text = @"所有朋友可见";
        self.lookL = rightL;
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-20, 18, 10, 14)];
        imgV.image = [UIImage imageNamed:@"common_arrow_btn"];
        
        UIImageView *imgTwoV = [[UIImageView alloc]initWithFrame:CGRectMake(rightL.left-20, 15, 20, 20)];
        imgTwoV.image = [UIImage imageNamed:@"world"];
        imgTwoV.layer.masksToBounds = YES;
        imgTwoV.layer.cornerRadius = 10;
        
        [_bottomV addSubview:leftL];
        [_bottomV addSubview:self.lookL];
        [_bottomV addSubview:imgV];
        [_bottomV addSubview:imgTwoV];
        
        
    }
    return _bottomV;
}

-(void)resetBottomV{
    [self.bottomV removeAllSubViews];
    UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 50)];
    leftL.textColor = COLOR_BLACK_CLASS_3;
    leftL.font = [UIFont systemFontOfSize
                  :14];
    //        companyJob.backgroundColor = Red_Color;
    leftL.textAlignment = NSTextAlignmentLeft;
    leftL.text = @"谁能看见";
    
    UILabel *rightL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-30-120, 0, 120, 50)];
    rightL.textColor = COLOR_BLACK_CLASS_3;
    rightL.font = [UIFont systemFontOfSize
                   :14];
    //        companyJob.backgroundColor = Red_Color;
    rightL.textAlignment = NSTextAlignmentRight;
    rightL.text = @"所有朋友可见";
    
    [self.bottomV addSubview:leftL];
    [self.bottomV addSubview:rightL];
}

-(void)continueAddBtnClick{
    if ([self.delegate respondsToSelector:@selector(continueAdd)]) {
        [self.delegate continueAdd];
    }
}

-(void)photoVClick{
    if ([self.delegate respondsToSelector:@selector(changeDesignPhoto:)]) {
        [self.delegate changeDesignPhoto:self.path];
    }
}

-(void)deletebtnClick{
    if ([self.delegate respondsToSelector:@selector(deleteIntroductPhotoWith:)]) {
        [self.delegate deleteIntroductPhotoWith:self.path];
    }
}

-(void)popV{
    if ([self.delegate respondsToSelector:@selector(selectIsVail)]) {
        [self.delegate selectIsVail];
    }
}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
//    return YES;
//    
//}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
//    return YES;
//}

-(void)textViewDidChange:(UITextView *)textView{
    textView.scrollEnabled = YES;
    if (textView.text.length>0) {
        self.someL.hidden = YES;
    }
    else{
        self.someL.hidden = NO;
    }
//    self.someL.text = textView.text;
//    CGSize sizeFit = [self.someL sizeThatFits:CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT)];
//    self.someL.height = sizeFit.height;
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0) {
        self.someL.hidden = YES;
    }
    else{
        self.someL.hidden = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(saveContentWith:content:)]) {
        [self.delegate saveContentWith:self.path content:textView.text];
    }
    self.saySomeV.scrollEnabled = NO;
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    CGRect frame = textView.frame;
//    float
//}

@end
