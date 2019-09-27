//
//  SupervisorDiaryCell.m
//  iDecoration
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SupervisorDiaryCell.h"
#import "SupervisionModel.h"

@interface SupervisorDiaryCell ()<UITextViewDelegate>

@end

@implementation SupervisorDiaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.spacingH = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
//    NSString *temStr = [NSString stringWithFormat:@"SupervisorDiaryCell%ld%ld",path.section,path.row];
    static NSString *TextFieldCellID = @"SupervisorDiaryCell";
    SupervisorDiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[SupervisorDiaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    cell.path = path;
    if (!cell.dict) {
        cell.dict = [NSMutableDictionary dictionary];
    }
    
    if (!cell.array) {
        cell.array = [NSMutableArray array];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.sayTextV];
        [self.sayTextV addSubview:self.placeholerL];
        [self addSubview:self.photoV];
        [self addSubview:self.deleteContentBtn];
//        [self addSubview:self.lineV];
        
//        [self.contentView addSubview:self.sayTextV];
//        [self.sayTextV addSubview:self.placeholerL];
//        [self.contentView addSubview:self.photoV];
//        [self.contentView addSubview:self.deleteContentBtn];
//        [self.contentView addSubview:self.lineV];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data count:(NSInteger)count indexPath:(NSIndexPath *)path isPower:(BOOL)isPower isEdit:(BOOL)isEdit{
    if ([data isKindOfClass:[SupervisionModel class]]) {
        
//        if (path.row==count-1) {
//            self.lineV.hidden = NO;
//            
//        }else{
//            self.lineV.hidden = YES;
//        }
        
        SupervisionModel *model = data;
        
        if (model.contents.length<=0&&model.picture.length<=0) {
            CGFloat hh = 0;
            if (!isPower) {
                self.sayTextV.hidden = YES;
                self.placeholerL.hidden = YES;
                self.deleteContentBtn.hidden = YES;
                self.photoV.hidden = YES;
//                self.lineV.hidden = YES;
                hh = 0;
            }else{
                if (!isEdit){
                    self.sayTextV.hidden = YES;
                    self.placeholerL.hidden = YES;
                    self.deleteContentBtn.hidden = YES;
                    self.photoV.hidden = YES;
//                    self.lineV.hidden = YES;
                    hh = 0;
                }else{
                    
                    self.sayTextV.hidden = NO;
                    self.sayTextV.text = @"";
                    self.placeholerL.hidden = NO;
                    self.deleteContentBtn.hidden = YES;
                    self.photoV.hidden = NO;
//                    self.lineV.hidden = NO;
                    self.sayTextV.text = @"";
                    self.sayTextV.frame = CGRectMake(5, 10, kSCREEN_WIDTH-10, 50);
                    self.placeholerL.frame = CGRectMake(5, 7, self.sayTextV.width-5*2, 20);
                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, 80, 80);
//                    self.lineV.frame = CGRectMake(0, self.photoV.bottom+10, kSCREEN_WIDTH, 1);
                    self.photoV.image = [UIImage imageNamed:@"jia1"];
                    hh = self.photoV.bottom+10;
                    self.photoV.tag = path.row;
                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
                    [self.photoV addGestureRecognizer:ges];
                    
                    self.sayTextV.tag = path.row;
                }
                
            }
            
            if (!isPower) {
                self.sayTextV.userInteractionEnabled = NO;
                self.photoV.userInteractionEnabled = NO;
            }
            else{
                if (!isEdit) {
                    self.sayTextV.userInteractionEnabled = NO;
                    self.photoV.userInteractionEnabled = NO;
                }
                else{
                    self.sayTextV.userInteractionEnabled = YES;
                    self.photoV.userInteractionEnabled = YES;
                }
            }
            
            NSString *keyStr = [NSString stringWithFormat:@"%ld",path.row];
            NSString *valueStr = [NSString stringWithFormat:@"%f",hh];
            
            if ([[self.dict allKeys] containsObject:keyStr]) {
                [self.dict removeObjectForKey:keyStr];
            }
            [self.dict setObject:valueStr forKey:keyStr];
            
            self.cellH = hh;
            self.height = hh;
//            NSInteger count = self.array.count;
//            if (count<=0) {
//                NSDictionary *temDict = @{keyStr:valueStr};
//                [self.array addObject:temDict];
//            }
//            else{
//                BOOL isExit = NO;//
//                for (NSDictionary *dict in self.array) {
//                    if ([dict.allKeys containsObject:keyStr]) {
//                        isExit = YES;
//                        break;
//                    }
//                    else{
//                        isExit = NO;
//                    }
//                }
//                if (isExit) {
//                    NSDictionary *dict = @{keyStr:valueStr};
//                    [self.array replaceObjectAtIndex:path.row withObject:dict];
//                }
//                else{
//                    NSDictionary *temDict = @{keyStr:valueStr};
//                    [self.array addObject:temDict];
//                }
//            }
//            [self.dict setObject:valueStr forKey:keyStr];
        }
        else{
            self.sayTextV.text = model.contents;
            if (model.contents.length<=0) {
                self.placeholerL.hidden = NO;
            }
            else{
                self.placeholerL.hidden = YES;
            }
            
//            CGSize textSize = [model.contents boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10, CGFLOAT_MAX)
//                                                           options:NSStringDrawingUsesLineFragmentOrigin
//                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
//                                                           context:nil].size;
//            
//            if (textSize.height<50) {
//                textSize.height = 50;
//            }
            CGSize size = [self.sayTextV sizeThatFits:CGSizeMake(kSCREEN_WIDTH-10, CGFLOAT_MAX)];
            self.sayTextV.frame = CGRectMake(5, 10, kSCREEN_WIDTH-10, size.height);
            
            if (!isPower) {
                self.sayTextV.userInteractionEnabled = NO;
            }
            else{
                if (!isEdit) {
                    self.sayTextV.userInteractionEnabled = NO;
                }
                else{
                    self.sayTextV.userInteractionEnabled = YES;
                }
            }
            
            if (model.picture.length<=0) {
                //没有图片  -- 判断有没有权限 --没有权限--隐藏+   ---有权限判断是不是编辑状态 --是，显示+号，不是--隐藏
                            if (!isPower) {
                                self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, kSCREEN_WIDTH-20, 0);
                                self.deleteContentBtn.hidden = YES;
                                
                
                            }
                            else{
                                if (!isEdit) {
                                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, kSCREEN_WIDTH-20, 0);
                                    self.deleteContentBtn.hidden = YES;
                                }
                                else{
                                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, 80,80);
                                    self.photoV.image = [UIImage imageNamed:@"jia1"];
                                    self.deleteContentBtn.hidden = YES;
                                }
                            }

                
            }else{
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:model.picture]];
                SDImageCache *cache = [SDImageCache sharedImageCache];
                UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
                
                if (cachedImage) {
                    self.photoV.image = cachedImage;
                    [self.photoV sizeToFit];
                    CGFloat orgialH = self.photoV.height;
                    CGFloat orgialW = self.photoV.width;
                    
                    CGFloat nowH = orgialH*(kSCREEN_WIDTH-20)/orgialW;
                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom+10, kSCREEN_WIDTH-20, nowH);
                    //                deleteContentBtn.frame = CGRectMake(imgV.right-20, imgV.top-15, 30, 30);
                }
                
                else{
                    
                    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.picture]];
                    UIImage *image = [[UIImage alloc]initWithData:data];
//                    if (!image) {
//                        image = [UIImage imageNamed:@"carousel"];
//                    }
                    self.photoV.image = image;
                    CGFloat orgialH = self.photoV.height;
                    CGFloat orgialW = self.photoV.width;
                    
                    CGFloat nowH = orgialH*(kSCREEN_WIDTH-20)/orgialW;
                    self.photoV.frame = CGRectMake(10, self.sayTextV.bottom, kSCREEN_WIDTH-20, nowH);
                    //                deleteContentBtn.frame = CGRectMake(imgV.right-20, imgV.top-15, 30, 30);
                    
                    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                    //                    [SDImageCache sharedImageCache] remove
                }
                
                
                if (!isPower) {
                    self.photoV.userInteractionEnabled = NO;
                    self.deleteContentBtn.hidden = YES;
                }
                else{
                    if (!isEdit) {
                        self.photoV.userInteractionEnabled = NO;
                        self.deleteContentBtn.hidden = YES;
                    }
                    else{
                        self.photoV.userInteractionEnabled = YES;
                        self.deleteContentBtn.hidden = NO;
                    }
                }
            }
            
            
            
            
            
            
            
            
            self.sayTextV.tag = path.row;
            self.photoV.tag = path.row;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
            [self.photoV addGestureRecognizer:ges];
            
            self.deleteContentBtn.tag = path.row;
            [self.deleteContentBtn addTarget:self action:@selector(deleteContent:) forControlEvents:UIControlEventTouchUpInside];
            
            self.deleteContentBtn.frame = CGRectMake(self.photoV.right-20, self.photoV.top-15, 30, 30);
//            self.lineV.frame = CGRectMake(0, self.photoV.bottom+10, kSCREEN_WIDTH, 1);
            NSString *keyStr = [NSString stringWithFormat:@"%ld",path.row];
            CGFloat bottomlinev = self.photoV.bottom+10;
            NSString *valueStr = [NSString stringWithFormat:@"%f",bottomlinev];
            if ([[self.dict allKeys] containsObject:keyStr]) {
                [self.dict removeObjectForKey:keyStr];
            }
            
            [self.dict setObject:valueStr forKey:keyStr];
            self.cellH = bottomlinev;
            self.height = bottomlinev;
//            NSInteger count = self.array.count;
//            if (count<=0) {
//                NSDictionary *temDict = @{keyStr:valueStr};
//                [self.array addObject:temDict];
//            }
//            else{
//                BOOL isExit = NO;//
//                for (NSDictionary *dict in self.array) {
//                    if ([dict.allKeys containsObject:keyStr]) {
//                        isExit = YES;
//                        break;
//                    }
//                    else{
//                        isExit = NO;
//                    }
//                }
//                if (isExit) {
//                    NSDictionary *dict = @{keyStr:valueStr};
//                    [self.array replaceObjectAtIndex:path.row withObject:dict];
//                }
//                else{
//                    NSDictionary *temDict = @{keyStr:valueStr};
//                    [self.array addObject:temDict];
//                }
//            }
            
        }
        
        
//        self.imgVH = self.photoV.height;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    NSInteger tag = textView.tag;
    if (textView.text.length<=0) {
        self.placeholerL.hidden = NO;
    }
    else{
        self.placeholerL.hidden = YES;
    }
    
    textView.scrollEnabled = YES;
//    CGFloat width = CGRectGetWidth(self.sayTextV.frame);
//    CGFloat height = CGRectGetHeight(self.sayTextV.frame);
//    CGSize newSize = [self.sayTextV sizeThatFits:CGSizeMake(kSCREEN_WIDTH-10,MAXFLOAT)];
//    
//    CGRect newFrame = self.sayTextV.frame;
//    if (newSize.height<height) {
//        
//        if (newSize.height<50) {
//            newSize.height=50;
//        }
//        newFrame.size = CGSizeMake(fmax(width, newSize.width), newSize.height);
//    }
//    else{
//        newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
//    }

//    self.sayTextV.frame = CGRectMake(5, 10, kSCREEN_WIDTH-10, newFrame.size.height);
    
//    if ([self.delegate respondsToSelector:@selector(editContent:content:)]) {
//        [self.delegate editContent:tag content:textView.text];
//    }
    textView.layoutManager.allowsNonContiguousLayout = NO;
    textView .contentInset = UIEdgeInsetsMake(0,0,0,0);
//    [self.sayTextV scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
//    self.sayTextV.layoutManager.allowsNonContiguousLayout = NO;
    
//    [self.sayTextV scrollRectToVisible:CGRectMake(0, self.sayTextV.contentSize.height-15, self.sayTextV.contentSize.width, 10) animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSInteger tag = textView.tag;
    if (textView.text.length<=0) {
        self.placeholerL.hidden = NO;
    }
    else{
        self.placeholerL.hidden = YES;
    }
    
    textView.scrollEnabled = YES;
    textView.layoutManager.allowsNonContiguousLayout = NO;
//    CGFloat width = CGRectGetWidth(self.sayTextV.frame);
//    CGFloat height = CGRectGetHeight(self.sayTextV.frame);
//    CGSize newSize = [self.sayTextV sizeThatFits:CGSizeMake(kSCREEN_WIDTH-10,MAXFLOAT)];
//    
//    CGRect newFrame = self.sayTextV.frame;
//    if (newSize.height<height) {
//        
//        if (newSize.height<50) {
//            newSize.height=50;
//        }
//        newFrame.size = CGSizeMake(fmax(width, newSize.width), newSize.height);
//    }
//    else{
//        newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
//    }
//    NSString *keyStr = [NSString stringWithFormat:@"%ld",tag];
//    [self.dict setObject:@(newFrame.size.height) forKey:keyStr];
//    self.sayTextV.frame = CGRectMake(5, 10, kSCREEN_WIDTH-10, newFrame.size.height);
//    
    if ([self.delegate respondsToSelector:@selector(editContent:content:)]) {
        [self.delegate editContent:tag content:textView.text];
    }
    
//    [self.sayTextV scrollRectToVisible:CGRectMake(0, self.sayTextV.contentSize.height-15, self.sayTextV.contentSize.width, 10) animated:YES];

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

-(UITextView *)sayTextV{
    if (!_sayTextV) {
        _sayTextV = [[UITextView alloc]initWithFrame:CGRectMake(5, 10, kSCREEN_WIDTH-10, 50)];
        _sayTextV.textColor = COLOR_BLACK_CLASS_3;
        _sayTextV.font = NB_FONTSEIZ_NOR;
        //        _sayTextV.tag = i;
        _sayTextV.delegate = self;
//        _sayTextV.textContainerInset = UIEdgeInsetsMake(15,0, 10, 20);
        _sayTextV.layoutManager.allowsNonContiguousLayout = NO;
//        _sayTextV.scrollEnabled = NO;
    }
    return _sayTextV;
}

-(UILabel *)placeholerL{
    if (!_placeholerL) {
        _placeholerL = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, self.sayTextV.width-5*2, 20)];
        _placeholerL.textColor = COLOR_BLACK_CLASS_9;
        _placeholerL.font = [UIFont systemFontOfSize
                             :14];
        //        companyJob.backgroundColor = Red_Color;
        _placeholerL.text = @"说点什么吧";
        _placeholerL.textAlignment = NSTextAlignmentLeft;
    }
    return _placeholerL;
}

-(UIImageView *)photoV{
    if (!_photoV) {
        
        _photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.sayTextV.bottom, 80, 80)];
        _photoV.image = [UIImage imageNamed:@"jia1"];
        _photoV.userInteractionEnabled = YES;
        _photoV.layer.borderWidth = 1.0;
        _photoV.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addContentPhoto)];
        //        [imgV addGestureRecognizer:ges];
        
    }
    return _photoV;
}

-(UIButton *)deleteContentBtn{
    if (!_deleteContentBtn) {
        _deleteContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteContentBtn.frame = CGRectMake(self.photoV.right-20, self.photoV.top-15, 30, 30);
        _deleteContentBtn.layer.masksToBounds = YES;
        _deleteContentBtn.layer.cornerRadius = 15;
        //            deleteContentBtn.layer.borderWidth = 1.0;
        //            deleteContentBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        [_deleteContentBtn setImage:[UIImage imageNamed:@"del02.png"] forState:UIControlStateNormal];
//        deleteContentBtn.tag = i;
//        [deleteContentBtn addTarget:self action:@selector(deleteContent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteContentBtn;
}

//-(UIView *)lineV{
//    if (!_lineV) {
//        _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.photoV.bottom+10, kSCREEN_WIDTH, 1)];
//        _lineV.backgroundColor = COLOR_BLACK_CLASS_0;
//    }
//    return _lineV;
//}

@end
