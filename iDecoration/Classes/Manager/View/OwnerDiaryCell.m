//
//  OwnerDiaryCell.m
//  iDecoration
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "OwnerDiaryCell.h"
#import "OwnerDiaryModel.h"

@interface OwnerDiaryCell ()<UITextViewDelegate>

@end


@implementation OwnerDiaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    static NSString *TextFieldCellID = @"OwnerDiaryCell";
    OwnerDiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[OwnerDiaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    cell.path = path;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.saySomeV];
        [self.saySomeV addSubview:self.someL];
        [self addSubview:self.lineVOne];
        [self addSubview:self.photosView];
//        [self addSubview:self.continueAddBtn];
//        [self addSubview:self.deleteModelBtn];
        [self addSubview:self.lineVTwo];
        
        self.lineVOne.hidden = YES;
//        self.lineVTwo.hidden = YES;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data isShowAdd:(BOOL)isShowAdd{
    if ([data isKindOfClass:[OwnerDiaryModel class]]) {
        [self.imgArray removeAllObjects];
        OwnerDiaryModel *model = data;
        NSString *contentStr = model.content;
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 10;
//        paragraphStyle.firstLineHeadIndent = 10;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.paragraphSpacing = 10;
        //        paragraphStyle.headIndent = 2;
        NSDictionary *attributes = @{NSFontAttributeName:NB_FONTSEIZ_NOR,NSParagraphStyleAttributeName:paragraphStyle};
        self.saySomeV.attributedText = [[NSAttributedString alloc]initWithString:contentStr attributes:attributes];
        
        if (contentStr.length<=0) {
            self.someL.hidden = NO;
            self.saySomeV.frame = CGRectMake(10, 0, kSCREEN_WIDTH-20, 50);
        }
        else{
            self.someL.hidden = YES;
            
            CGSize sizeToFit = [self.saySomeV sizeThatFits:CGSizeMake(kSCREEN_WIDTH-20, MAXFLOAT)];
            if (sizeToFit.height<=50) {
                sizeToFit.height=50;
            }
            self.saySomeV.frame = CGRectMake(10, 0, kSCREEN_WIDTH-20, sizeToFit.height);
        }
        
//        self.cellH = self.saySomeV.height+5;
        
        NSArray *picList = model.imgList;
        NSMutableArray *tempArray = [NSMutableArray array];
        NSInteger count = picList.count;
        if (count<=0) {
            
            if (!isShowAdd) {
                self.photosView.hidden = YES;
                self.photosView.frame = CGRectMake(0, self.saySomeV.bottom+5, kSCREEN_WIDTH, 0);
                self.photosView.collectionView.height = 0;
                self.lineVTwo.frame = CGRectMake(0, self.photosView.bottom+4, kSCREEN_WIDTH, 1);
                self.cellH = self.saySomeV.bottom+5;
            }
            else{
                self.photosView.hidden = NO;
                [tempArray addObject:[UIImage imageNamed:@"jia_kuang"]];
                //                self.photosView.hidden = NO;
                self.photosView.frame = CGRectMake(0, self.saySomeV.bottom+5, kSCREEN_WIDTH, kSCREEN_WIDTH/3);
                self.lineVTwo.frame = CGRectMake(0, self.photosView.bottom+4, kSCREEN_WIDTH, 1);
                self.photosView.collectionView.height = kSCREEN_WIDTH/3;
                [self.photosView setYPPhotosView:tempArray];
                self.cellH = self.photosView.bottom+5;
            }
            

//            }
            
        }
        else{
            self.photosView.hidden = NO;
            for (NSDictionary *dict in picList) {
                NSString *picUrl = [dict objectForKey:@"picUrl"];
//                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]];
//                UIImage *img = [UIImage imageWithData:imgData];
//                if (img) {
//                    [self.imgArray addObject:img];
//                }
                if (picUrl) {
                    [tempArray addObject:picUrl];
                }
                
                            }
            
//            row = (tempArray.count)/3;
            if (!isShowAdd) {
                
            }
            else{
                [tempArray addObject:[UIImage imageNamed:@"jia_kuang"]];
            }
            
            NSInteger tempCount = tempArray.count;
            NSInteger row = 0 ;
            if (tempCount==0) {
                row = 0;
            }
            else if(tempCount<=3){
                row = 1;
            }
            else{
                NSInteger yu = tempCount%3;
                if (yu==0) {
                    row = tempCount/3;
                }
                else{
                    row = tempCount/3+1;
                }
                
            }
            
//            _photosView.isShowZongAddBtn = !isShowAdd;
                            [self.photosView setYPPhotosView:tempArray];
            
                
                            self.photosView.frame = CGRectMake(0, self.saySomeV.bottom+5, kSCREEN_WIDTH, kSCREEN_WIDTH/3*row);
            self.lineVTwo.frame = CGRectMake(0, self.photosView.bottom+4, kSCREEN_WIDTH, 1);
                            self.photosView.collectionView.height = kSCREEN_WIDTH/3*row;
            
            self.cellH = self.photosView.bottom+5;
        }
        

    }
}



-(UITextView *)saySomeV{
    if (!_saySomeV) {
        _saySomeV = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH-20, 50)];
        _saySomeV.delegate = self;
        _saySomeV.textColor = COLOR_BLACK_CLASS_3;
        _saySomeV.font = NB_FONTSEIZ_NOR;
        _saySomeV.scrollEnabled = NO;
    }
    return _saySomeV;
}

-(UILabel *)someL{
    if (!_someL) {
        _someL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.saySomeV.width-10, 20)];
        _someL.textColor = COLOR_BLACK_CLASS_9;
        _someL.font = [UIFont systemFontOfSize
                       :14];
        //        companyJob.backgroundColor = Red_Color;
        _someL.textAlignment = NSTextAlignmentLeft;
        _someL.text = @"说点什么吧";
    }
    return _someL;
}

-(UIView *)lineVOne{
    if (!_lineVOne) {
        _lineVOne = [[UIView alloc] initWithFrame:CGRectMake(0, self.saySomeV.bottom+2, kSCREEN_WIDTH, 1)];
        _lineVOne.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineVOne;
}

-(YPPhotosView *)photosView{
    if (!_photosView) {
        _photosView = [[YPPhotosView alloc]initWithFrame:CGRectMake(0, self.saySomeV.bottom+5, kSCREEN_WIDTH, kSCREEN_WIDTH/3)];
    }
    //    _photosView.collectionView.height = kSCREEN_WIDTH/3;
    __weak OwnerDiaryCell *weakSelf=self;
    _photosView.clickcloseImage = ^(NSInteger index){
        if ([weakSelf.delegate respondsToSelector:@selector(deletePhotoWith:path:)]) {
            [weakSelf.delegate deletePhotoWith:index path:weakSelf.path];
        }
    };
    
    _photosView.clicklookImage = ^(NSInteger index , NSArray *imageArr){
        
        
        if ([weakSelf.delegate respondsToSelector:@selector(lookPhoto:imgArray:path:)]) {
            [weakSelf.delegate lookPhoto:index imgArray:weakSelf.imgArray path:weakSelf.path];
        }
        
    };
    
    _photosView.clickChooseView = ^{
        // 调用相册
        
        
        if ([weakSelf.delegate respondsToSelector:@selector(addPhotoWithPath:)]) {
            [weakSelf.delegate addPhotoWithPath:weakSelf.path];
        }
        
        
        
        
    };
    
    return _photosView;
}

//-(UIButton *)continueAddBtn{
//    if (!_continueAddBtn) {
//        _continueAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _continueAddBtn.frame = CGRectMake(kSCREEN_WIDTH-15-80, self.photosView.bottom+5, 80, 20);
//        [_continueAddBtn setTitle:@"继续添加" forState:UIControlStateNormal];
//        //        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_continueAddBtn setTitleColor:Main_Color forState:UIControlStateNormal];
//        _continueAddBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//        [_continueAddBtn addTarget:self action:@selector(continueAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _continueAddBtn;
//}

-(UIButton *)deleteModelBtn{
    if (!_deleteModelBtn) {
        _deleteModelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteModelBtn.frame = CGRectMake(kSCREEN_WIDTH-20, 0, 20, 20);
//        [_deleteModelBtn setTitle:@"继续添加" forState:UIControlStateNormal];
//        //        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_deleteModelBtn setTitleColor:Main_Color forState:UIControlStateNormal];
//        _deleteModelBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [_deleteModelBtn setImage:[UIImage imageNamed:@"-"] forState:UIControlStateNormal];
        [_deleteModelBtn addTarget:self action:@selector(delteModelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteModelBtn;
}

-(UIView *)lineVTwo{
    if (!_lineVTwo) {
        _lineVTwo = [[UIView alloc] initWithFrame:CGRectMake(0, self.photosView.bottom+4, kSCREEN_WIDTH, 1)];
        _lineVTwo.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineVTwo;
}


-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.someL.hidden = YES;
    }
    else{
        self.someL.hidden = NO;
    }
    self.saySomeV.scrollEnabled = YES;
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

//-(void)continueAddBtnClick{
//    if ([self.delegate respondsToSelector:@selector(continueAddWithPath:)]) {
//        [self.delegate continueAddWithPath:self.path];
//    }
//}

-(void)delteModelBtnClick{
    if ([self.delegate respondsToSelector:@selector(deleteModelWithPath:)]) {
        [self.delegate deleteModelWithPath:self.path];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
