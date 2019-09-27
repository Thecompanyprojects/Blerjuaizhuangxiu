//
//  SupervisorDiaryCellTwo.m
//  iDecoration
//
//  Created by Apple on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SupervisorDiaryCellTwo.h"
#import "SupervisionModel.h"

@interface SupervisorDiaryCellTwo ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *deleteContentBtn;
@end

@implementation SupervisorDiaryCellTwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
    self.imgV.layer.borderWidth = 1;
    self.saySomeV.delegate = self;
    self.saySomeV.scrollEnabled = NO;
    self.saySomeV.backgroundColor = White_Color;
    [self addSubview:self.deleteContentBtn];
}




-(void)configWith:(id)data count:(NSInteger)count indexPath:(NSIndexPath *)path isPower:(BOOL)isPower isEdit:(BOOL)isEdit{
    if ([data isKindOfClass:[SupervisionModel class]]) {
        
            if (path.row==count-1) {
                self.lineV.hidden = NO;

            }else{
                self.lineV.hidden = YES;
            }
        
        SupervisionModel *model = data;
        
        if (model.contents.length<=0&&model.picture.length<=0) {
            
            self.deleteContentBtn.hidden = YES;
            CGFloat hh = 0;
            if (!isPower) {
                self.saySomeV.hidden = YES;
                self.placeHoldL.hidden = YES;
//                self.deleteContentBtn.hidden = YES;
                self.imgV.hidden = YES;
                self.lineV.hidden = YES;
                hh = 0;
            }else{
                if (!isEdit){
                    self.saySomeV.hidden = YES;
                    self.placeHoldL.hidden = YES;
                    //                self.deleteContentBtn.hidden = YES;
                    self.imgV.hidden = YES;
                    self.lineV.hidden = YES;
                    hh = 0;
                }else{
                    
                    self.saySomeV.hidden = NO;
                    self.saySomeV.text = @"";
                    self.placeHoldL.hidden = NO;
//                    self.deleteContentBtn.hidden = YES;
                    self.imgV.hidden = NO;
                    self.lineV.hidden = NO;
                    self.saySomeNsH.constant = 80;
//                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, 80, 80);
//                    self.lineV.frame = CGRectMake(0, self.photoV.bottom+10, kSCREEN_WIDTH, 1);
                    self.imgV.image = [UIImage imageNamed:@"jia1"];
                    self.imgVNsW.constant = 80;
                    self.imgVNsH.constant = 80;
                    self.imgV.tag = path.row;
                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
                    [self.imgV addGestureRecognizer:ges];
                    
                    self.saySomeV.tag = path.row;
                }
                
            }
            
            if (!isPower) {
                self.saySomeV.userInteractionEnabled = NO;
                self.imgV.userInteractionEnabled = NO;
            }
            else{
                if (!isEdit) {
                    self.saySomeV.userInteractionEnabled = NO;
                    self.imgV.userInteractionEnabled = NO;
                }
                else{
                    self.saySomeV.userInteractionEnabled = YES;
                    self.imgV.userInteractionEnabled = YES;
                }
            }
            

            
        }
        else{
            self.saySomeV.text = model.contents;
            if (model.contents.length<=0) {
                self.placeHoldL.hidden = NO;
            }
            else{
                self.placeHoldL.hidden = YES;
            }
            
//            CGSize textSize = [model.contents boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-20, CGFLOAT_MAX)
//                                                           options:NSStringDrawingUsesLineFragmentOrigin
//                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
//                                                           context:nil].size;
//            
//            if (textSize.height<25) {
//                textSize.height = 25;
//            }
            
            
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//                    paragraphStyle.lineSpacing = 10;
//                    paragraphStyle.firstLineHeadIndent = 10;
//                    paragraphStyle.alignment = NSTextAlignmentLeft;
//                    paragraphStyle.paragraphSpacing = 10;
//            //        paragraphStyle.headIndent = 2;
//                    NSDictionary *attributes = @{NSFontAttributeName:NB_FONTSEIZ_NOR,NSParagraphStyleAttributeName:paragraphStyle};
//                    self.saySomeV.attributedText = [[NSAttributedString alloc]initWithString:model.contents attributes:attributes];
            
            CGSize constraintSize = CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT);
            CGSize size = [self.saySomeV sizeThatFits:constraintSize];
            if (size.height<50) {
                self.saySomeNsH.constant = 50;
            }else{
                self.saySomeNsH.constant = size.height;
            }
            
            if (!isPower) {
                self.saySomeV.userInteractionEnabled = NO;
            }
            else{
                if (!isEdit) {
                    self.saySomeV.userInteractionEnabled = NO;
                }
                else{
                    self.saySomeV.userInteractionEnabled = YES;
                }
            }
            
            if (model.picture.length<=0) {
                self.deleteContentBtn.hidden = YES;
                //没有图片  -- 判断有没有权限 --没有权限--隐藏+   ---有权限判断是不是编辑状态 --是，显示+号，不是--隐藏
                if (!isPower) {
//                    self.imgV.hidden = YES;
                    self.imgVNsW.constant = 0;
                    self.imgVNsH.constant = 0;
//                    self.deleteContentBtn.hidden = YES;
                    
                    self.imgV.userInteractionEnabled = NO;
                }
                else{
                    if (!isEdit) {
                        
                        self.imgVNsH.constant = 0;
                        self.imgVNsW.constant = 0;
                        self.imgV.userInteractionEnabled = NO;
//                        self.deleteContentBtn.hidden = YES;
                    }
                    else{
//                        self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, 80,80);
                        self.imgVNsW.constant = 80;
                        self.imgVNsH.constant = 80;
                        self.imgV.image = [UIImage imageNamed:@"jia1"];
                        self.imgV.userInteractionEnabled = YES;
//                        self.deleteContentBtn.hidden = YES;
                    }
                }
                
                
            }else{
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:model.picture]];
                SDImageCache *cache = [SDImageCache sharedImageCache];
                UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
                YSNLog(@"%@",cachedImage);
                if (cachedImage) {
                    self.imgV.image = cachedImage;
                    
                    [self.imgV sizeToFit];
                    CGFloat orgialH = self.imgV.height;
                    CGFloat orgialW = self.imgV.width;
                    
                    CGFloat nowH = orgialH*(kSCREEN_WIDTH-20)/orgialW;
//                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom+10, kSCREEN_WIDTH-20, nowH);
                    self.imgVNsW.constant = kSCREEN_WIDTH-20;
                    self.imgVNsH.constant = nowH;
//                    self.imgVNsH.constant = 100;
                }
                
                else{
                    
                    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.picture]];
                    UIImage *image = [[UIImage alloc]initWithData:data];
                    if (!image) {
                        image = [UIImage imageNamed:@"carousel"];
                    }
                    self.imgV.image = image;
                    [self.imgV sizeToFit];
                    CGFloat orgialH = self.imgV.height;
                    CGFloat orgialW = self.imgV.width;
                    
                    CGFloat nowH = orgialH*(kSCREEN_WIDTH-20)/orgialW;
//                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, kSCREEN_WIDTH-20, nowH);
                    self.imgVNsW.constant = kSCREEN_WIDTH-20;
                    self.imgVNsH.constant = nowH;
                    
                    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                }
                
                
                if (!isPower) {
                    self.imgV.userInteractionEnabled = NO;
                    self.deleteContentBtn.hidden = YES;
                }
                else{
                    if (!isEdit) {
                        self.imgV.userInteractionEnabled = NO;
                        self.deleteContentBtn.hidden = YES;
                    }
                    else{
                        self.imgV.userInteractionEnabled = YES;
                        self.deleteContentBtn.hidden = NO;
                    }
                }
            }
            
            
            
            
            
            
            
            
            self.saySomeV.tag = path.row;
            self.imgV.tag = path.row;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
            [self.imgV addGestureRecognizer:ges];
            
            self.deleteContentBtn.tag = path.row;
            [self.deleteContentBtn addTarget:self action:@selector(deleteContent:) forControlEvents:UIControlEventTouchUpInside];
//
            self.deleteContentBtn.frame = CGRectMake(kSCREEN_WIDTH-30, self.saySomeNsH.constant+10, 30, 30);

            
            
            
        }
        
        
        
    }
}


-(void)textViewDidChange:(UITextView *)textView{
    NSInteger tag = textView.tag;
    [textView flashScrollIndicators];
    if (textView.text.length<=0) {
        self.placeHoldL.hidden = NO;
    }else{
        self.placeHoldL.hidden = YES;
    }
    

//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineSpacing = 10;
//    paragraphStyle.firstLineHeadIndent = 10;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    paragraphStyle.paragraphSpacing = 10;
//    //        paragraphStyle.headIndent = 2;
//    NSDictionary *attributes = @{NSFontAttributeName:NB_FONTSEIZ_NOR,NSParagraphStyleAttributeName:paragraphStyle};
//    self.saySomeV.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:attributes];
    
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 20, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:14]];
    
//    CGSize constraintSize = CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT);
//    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<50) {
        self.saySomeNsH.constant = 50;
    }else{
        self.saySomeNsH.constant = size.height;
    }
    self.deleteContentBtn.frame = CGRectMake(kSCREEN_WIDTH-30, self.saySomeNsH.constant+10, 30, 30);
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
//    NSInteger tag = textView.tag;
//    if ([self.delegate respondsToSelector:@selector(editContent:content:)]) {
//        [self.delegate editContent:tag content:textView.text];
//    }
    
    
    if (textView.text.length<=0) {
        self.placeHoldL.hidden = NO;
    }else{
        self.placeHoldL.hidden = YES;
    }
    
        NSInteger tag = textView.tag;
        if ([self.delegate respondsToSelector:@selector(editContent:content:)]) {
            [self.delegate editContent:tag content:textView.text];
        }

}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    CGRect frame = textView.frame;
//    float height = [self heightForTextView:textView WithText:textView.text];
////    frame.size.height = height;
//    [UIView animateWithDuration:0.5 animations:^{
////        textView.frame = frame;
//        self.saySomeNsH.constant = height+22;
//    }];
//    return YES;
//}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

-(void)changePhoto:(UITapGestureRecognizer *)ges{
    NSInteger tag = ges.view.tag;
    if ([self.delegate respondsToSelector:@selector(changeContentPhoto:)]) {
        [self.delegate changeContentPhoto:tag];
    }
}

-(void)deleteContent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(deleteContentPhoto:)]) {
        [self.delegate deleteContentPhoto:sender.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (IBAction)deleteContentBtn:(id)sender {
//}

-(UIButton *)deleteContentBtn{
    if (!_deleteContentBtn) {
        _deleteContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteContentBtn.frame = CGRectMake(self.imgV.right-20, self.imgV.top-15, 30, 30);
        _deleteContentBtn.layer.masksToBounds = YES;
        _deleteContentBtn.layer.cornerRadius = 15;
        //            deleteContentBtn.layer.borderWidth = 1.0;
        //            deleteContentBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        [_deleteContentBtn setImage:[UIImage imageNamed:@"del02.png"] forState:UIControlStateNormal];
    }
    return _deleteContentBtn;
}

#pragma mark - 计算图片按照比例显示
- (CGSize)calculateImageSizeWithSize:(CGSize)size {
    
    CGSize finalSize;
    if (size.width / BLEJWidth > size.height / BLEJHeight) {
        
        finalSize.width = size.width * BLEJWidth / size.width;
        finalSize.height = size.height * BLEJWidth / size.width;
    } else {
        
        finalSize.width = size.width * BLEJHeight / size.height;
        finalSize.height = size.height * BLEJHeight / size.height;
    }
    return finalSize;
}

@end
