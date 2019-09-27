//
//  TitleTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "TitleTableViewCell.h"
#import "ConstructionMemberModel.h"
#import "MainMaterialMemberModel.h"

@interface TitleTableViewCell()

@end

@implementation TitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellID = @"TitleTableViewCell";
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[TitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.addBtn];
        [self addSubview:self.reduceBtn];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data{
    if ([data isKindOfClass:[NSArray class]]) {
        [self removeAllSubViews];
        NSArray *array = data;
        NSInteger count = array.count;
        if (count<=0) {
            return;
        }
        if ([array[0] isKindOfClass:[ConstructionMemberModel class]]) {
            if (count == 1) {
                ConstructionMemberModel *model = array[0];
                self.cellH = 80;
                UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/3, 80)];
                [self addSubview:backV];
                
                backV.tag = 0;
                backV.userInteractionEnabled = YES;
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookTap:)];
                [backV addGestureRecognizer:ges];

                
                UIImageView *photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
                //            photoV.backgroundColor = Red_Color;
                
                [photoV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
                
                
                
                UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(photoV.right+3, 15, backV.width-photoV.right-3, 35)];
                nameL.textColor = COLOR_BLACK_CLASS_3;
                nameL.font = NB_FONTSEIZ_SMALL;
                nameL.numberOfLines = 0;
                //        companyJob.backgroundColor = Red_Color;
                nameL.textAlignment = NSTextAlignmentLeft;
                nameL.text = model.trueName;
                
                CGSize textSize1 = [model.trueName boundingRectWithSize:CGSizeMake(backV.width-photoV.right-3, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                                context:nil].size;
                if (textSize1.height<30) {
                    textSize1.height = 30;
                }
                nameL.height = textSize1.height;
                
                UILabel *jobL = [[UILabel alloc]initWithFrame:CGRectMake(nameL.left, nameL.bottom, nameL.width, 15)];
                jobL.textColor = COLOR_BLACK_CLASS_6;
                jobL.font = [UIFont systemFontOfSize
                             :14];
                //        companyJob.backgroundColor = Red_Color;
                jobL.textAlignment = NSTextAlignmentLeft;
                jobL.text = model.cJobTypeName;
                
                [backV addSubview:photoV];
                [backV addSubview:nameL];
                [backV addSubview:jobL];
                
                
                self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/2-25, 15, 50, 50);
                self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, 15, 50, 50);
                [self addSubview:self.addBtn];
                [self addSubview:self.reduceBtn];
                if(!self.isShowReduceBtn){
                    self.addBtn.hidden = YES;
                    self.reduceBtn.hidden = YES;
                }
                else{
                    self.addBtn.hidden = NO;
                    self.reduceBtn.hidden = NO;
                }
            }
            else{
                CGFloat ww = kSCREEN_WIDTH/3;
                CGFloat hh = 0;
                NSInteger lastX = 0;
                NSInteger lastY = 0;
                for (int i = 0; i<count; i++) {
                    NSInteger x = i/3; // 行
                    NSInteger y = i%3; // 列
                    ConstructionMemberModel *model = array[i];
                    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(ww*y, 80*x, ww, 80)];
                    [self addSubview:backV];
                    
                    backV.tag = i;
                    backV.userInteractionEnabled = YES;
                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookTap:)];
                    [backV addGestureRecognizer:ges];
                    
                    //                if (i == 0) {
                    //                    backV.backgroundColor = Red_Color;
                    //                }else{
                    //                    backV.backgroundColor = Black_Color;
                    //                }
                    //                backV.backgroundColor =
                    
                    UIImageView *photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
                    //            photoV.backgroundColor = Red_Color;
                    
                    [photoV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(photoV.right-15, photoV.top-5, 20, 20);
                    deleteBtn.layer.masksToBounds = YES;
                    deleteBtn.layer.cornerRadius = deleteBtn.width/2;
//                                deleteBtn.layer.borderWidth = 1.0;
//                                deleteBtn.layer.borderColor = White_Color.CGColor;
                    //            _addressBtn.backgroundColor = Red_Color;
                    [deleteBtn setImage:[UIImage imageNamed:@"del02"] forState:UIControlStateNormal];
                    deleteBtn.tag = i;
                    [deleteBtn addTarget:self action:@selector(deletePeoPleWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(photoV.right+3, 15, backV.width-photoV.right-3, 35)];
                    nameL.textColor = COLOR_BLACK_CLASS_3;
                    nameL.font = NB_FONTSEIZ_SMALL;
                    nameL.numberOfLines = 0;
                    //        companyJob.backgroundColor = Red_Color;
                    nameL.textAlignment = NSTextAlignmentLeft;
                    nameL.text = model.trueName;
                    
                    CGSize textSize1 = [model.trueName boundingRectWithSize:CGSizeMake(backV.width-photoV.right-3, CGFLOAT_MAX)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                                    context:nil].size;
                    if (textSize1.height<30) {
                        textSize1.height = 30;
                    }
                    nameL.height = textSize1.height;
                    
                    UILabel *jobL = [[UILabel alloc]initWithFrame:CGRectMake(nameL.left, nameL.bottom, 60, 20)];
                    jobL.textColor = COLOR_BLACK_CLASS_6;
                    jobL.font = NB_FONTSEIZ_SMALL;
                    //        companyJob.backgroundColor = Red_Color;
                    jobL.textAlignment = NSTextAlignmentLeft;
                    jobL.text = model.cJobTypeName;
                    
                    [backV addSubview:photoV];
                    [backV addSubview:deleteBtn];
                    [backV addSubview:nameL];
                    [backV addSubview:jobL];
                    
                    if (self.isShow) {
                        
                        if ([model.deleteFlag integerValue]==1) {
                            deleteBtn.hidden = YES;
                        }else{
                            deleteBtn.hidden = NO;
                        }
                    }else{
                        deleteBtn.hidden = YES;
                    }
                    
                    if (i == count-1) {
                        lastX = i/3;
                        lastY = i%3;
                    }
                    hh = 80*x+80;
                }
                if (lastY == 0) {
                    //                self.cellH = hh+80;
                    self.cellH = hh;
                    self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/3+10, hh+15-80, 50, 50);
                    self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, self.addBtn.top, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                    
                    if(!self.isShowReduceBtn){
                        self.addBtn.hidden = YES;
                        self.reduceBtn.hidden = YES;
                    }
                    else{
                        self.addBtn.hidden = NO;
                        self.reduceBtn.hidden = NO;
                    }
                    
                }
                else if(lastY == 1){
//                    self.cellH = hh+80;
                    
                    self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/3*2+10, hh+15-80, 50, 50);
                    self.reduceBtn.frame = CGRectMake(10, self.addBtn.top+80, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                    
                    if(!self.isShowReduceBtn){
                        self.addBtn.hidden = YES;
                        self.reduceBtn.hidden = YES;
                        self.cellH = hh;
                    }
                    else{
                        self.addBtn.hidden = NO;
                        self.reduceBtn.hidden = NO;
                        self.cellH = hh+80;
                    }
                }
                else{
//                    self.cellH = hh+80;
                    
                    self.addBtn.frame = CGRectMake(10, hh+15, 50, 50);
                    self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, self.addBtn.top, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                    
                    if(!self.isShowReduceBtn){
                        self.addBtn.hidden = YES;
                        self.reduceBtn.hidden = YES;
                        self.cellH = hh;
                    }
                    else{
                        self.addBtn.hidden = NO;
                        self.reduceBtn.hidden = NO;
                        self.cellH = hh+80;
                    }
                }
            }
        }
    }
}

-(void)configWith:(id)data siteModel:(SiteModel *)siteModel{
    
    if ([data isKindOfClass:[NSArray class]]) {
        [self removeAllSubViews];
        NSArray *array = data;
        NSInteger count = array.count;
        if (count<=0) {
            self.cellH = 20;
            return;
        }
        if ([array[0] isKindOfClass:[MainMaterialMemberModel class]]) {
            if (count == 1) {
                MainMaterialMemberModel *model = array[0];
                self.cellH = 80;
                UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/3, 80)];
                [self addSubview:backV];
                
                backV.tag = 0;
                backV.userInteractionEnabled = YES;
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookTap:)];
                [backV addGestureRecognizer:ges];
                
                UIImageView *photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
                //            photoV.backgroundColor = Red_Color;
                
                [photoV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
                
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(photoV.right-20, photoV.top, 20, 20);
                deleteBtn.layer.masksToBounds = YES;
                deleteBtn.layer.cornerRadius = deleteBtn.width/2;
//                deleteBtn.layer.borderWidth = 1.0;
//                deleteBtn.layer.borderColor = White_Color.CGColor;
                //            _addressBtn.backgroundColor = Red_Color;
                [deleteBtn setImage:[UIImage imageNamed:@"shanchutupian"] forState:UIControlStateNormal];
                deleteBtn.tag = 0;
                [deleteBtn addTarget:self action:@selector(deletePeoPleWith:) forControlEvents:UIControlEventTouchUpInside];
                
                
                if (self.isShow) {
                    deleteBtn.hidden = NO;
                }else{
                    deleteBtn.hidden = YES;
                }
                
                UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(photoV.right+3, 15, backV.width-photoV.right-3, 35)];
                nameL.textColor = COLOR_BLACK_CLASS_3;
                nameL.font = NB_FONTSEIZ_SMALL;
                nameL.numberOfLines = 0;
                //        companyJob.backgroundColor = Red_Color;
                nameL.textAlignment = NSTextAlignmentLeft;
                nameL.text = model.trueName;
                
                
                CGSize textSize1 = [model.trueName boundingRectWithSize:CGSizeMake(backV.width-photoV.right-3, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                                context:nil].size;
                if (textSize1.height<30) {
                    textSize1.height = 30;
                }
                nameL.height = textSize1.height;
                
                UILabel *jobL = [[UILabel alloc]initWithFrame:CGRectMake(nameL.left, nameL.bottom, nameL.width, 15)];
                jobL.textColor = COLOR_BLACK_CLASS_6;
                jobL.font = [UIFont systemFontOfSize
                             :12];
                //        companyJob.backgroundColor = Red_Color;
                jobL.textAlignment = NSTextAlignmentLeft;
                jobL.text = model.cJobTypeName;
                
                [backV addSubview:photoV];
                [backV addSubview:deleteBtn];
                [backV addSubview:nameL];
                [backV addSubview:jobL];
                
                
                self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/2-25, 15, 50, 50);
                self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, 15, 50, 50);
                [self addSubview:self.addBtn];
                [self addSubview:self.reduceBtn];
            }
            else{
                CGFloat ww = kSCREEN_WIDTH/3;
                CGFloat hh = 0;
                NSInteger lastX = 0;
                NSInteger lastY = 0;
                for (int i = 0; i<count; i++) {
                    NSInteger x = i/3; // 行
                    NSInteger y = i%3; // 列
                    MainMaterialMemberModel *model = array[i];
                    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(ww*y, 80*x, ww, 80)];
                    [self addSubview:backV];
                    
                    backV.tag = i;
                    backV.userInteractionEnabled = YES;
                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookTap:)];
                    [backV addGestureRecognizer:ges];
                    //                if (i == 0) {
                    //                    backV.backgroundColor = Red_Color;
                    //                }else{
                    //                    backV.backgroundColor = Black_Color;
                    //                }
                    //                backV.backgroundColor =
                    
                    UIImageView *photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
                    //            photoV.backgroundColor = Red_Color;
                    
                    [photoV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(photoV.right-20, photoV.top, 20, 20);
                    deleteBtn.layer.masksToBounds = YES;
                    deleteBtn.layer.cornerRadius = deleteBtn.width/2;
//                    deleteBtn.layer.borderWidth = 1.0;
//                    deleteBtn.layer.borderColor = White_Color.CGColor;
                    //            _addressBtn.backgroundColor = Red_Color;
                    [deleteBtn setImage:[UIImage imageNamed:@"shanchutupian"] forState:UIControlStateNormal];
                    deleteBtn.tag = i;
                    [deleteBtn addTarget:self action:@selector(deletePeoPleWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(photoV.right+3, 15, backV.width-photoV.right-3, 35)];
                    nameL.textColor = COLOR_BLACK_CLASS_3;
                    nameL.font = NB_FONTSEIZ_SMALL;
                    //        companyJob.backgroundColor = Red_Color;
                    nameL.textAlignment = NSTextAlignmentLeft;
                    nameL.text = model.trueName;
                    nameL.numberOfLines = 0;
                    
                    
                    CGSize textSize1 = [model.trueName boundingRectWithSize:CGSizeMake(backV.width-photoV.right-3, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                        context:nil].size;
                    if (textSize1.height<30) {
                        textSize1.height = 30;
                    }
                    nameL.height = textSize1.height;
                    
                    UILabel *jobL = [[UILabel alloc]initWithFrame:CGRectMake(nameL.left, nameL.bottom, nameL.width, 15)];
                    jobL.textColor = COLOR_BLACK_CLASS_6;
                    jobL.font = NB_FONTSEIZ_SMALL;
                    //        companyJob.backgroundColor = Red_Color;
                    jobL.textAlignment = NSTextAlignmentLeft;
                    jobL.text = model.cJobTypeName;
                    
                    [backV addSubview:photoV];
                    [backV addSubview:deleteBtn];
                    [backV addSubview:nameL];
                    [backV addSubview:jobL];
                    
                    if (self.isShow) {
                        
//                        if (siteModel.ccHouseholderId==[model.cpPersonId integerValue]) {
//                            //创建人不能删除
//                            deleteBtn.hidden = YES;
//                        }else{
//                            deleteBtn.hidden = NO;
//                        }
                        deleteBtn.hidden = NO;
                    }else{
                        deleteBtn.hidden = YES;
                    }
                    
                    if (i == count-1) {
                        lastX = i/3;
                        lastY = i%3;
                    }
                    hh = 80*x+80;
                }
                if (lastY == 0) {
                    //                self.cellH = hh+80;
                    self.cellH = hh;
                    self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/3+10, hh+15-80, 50, 50);
                    self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, self.addBtn.top, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                }
                else if(lastY == 1){
                    
                    
                    self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/3*2+10, hh+15-80, 50, 50);
                    self.reduceBtn.frame = CGRectMake(10, self.addBtn.top+80, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                    if (!self.isShowReduceBtn) {
                        self.cellH = hh;
                    }
                    else{
                        self.cellH = hh+80;
                    }
                }
                else{
                    self.cellH = hh+80;
                    
                    self.addBtn.frame = CGRectMake(10, hh+15, 50, 50);
                    self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, self.addBtn.top, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                }
            }
        }
    }
}


//主材日志添加人员
-(void)configWith:(id)data isLogin:(BOOL)isLogin ccComplete:(NSInteger )ccComplete isExit:(BOOL)isExit cJobTypeId:(NSInteger)cJobTypeId{
    if ([data isKindOfClass:[NSArray class]]) {
        [self removeAllSubViews];
        NSArray *array = data;
        NSInteger count = array.count;
        if (count<=0) {
            self.cellH = 20;
            return;
        }
        //MainMaterialMemberModel
        if ([array[0] isKindOfClass:[MainMaterialMemberModel class]]) {
            if (count == 1) {
                MainMaterialMemberModel *model = array[0];
                self.cellH = 80;
                UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/3, 80)];
                [self addSubview:backV];
                
                backV.tag = 0;
                backV.userInteractionEnabled = YES;
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookTap:)];
                [backV addGestureRecognizer:ges];
                
                UIImageView *photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
                //            photoV.backgroundColor = Red_Color;
                
                [photoV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
                
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(photoV.right-20, photoV.top, 20, 20);
                deleteBtn.layer.masksToBounds = YES;
                deleteBtn.layer.cornerRadius = deleteBtn.width/2;
                //                deleteBtn.layer.borderWidth = 1.0;
                //                deleteBtn.layer.borderColor = White_Color.CGColor;
                //            _addressBtn.backgroundColor = Red_Color;
                [deleteBtn setImage:[UIImage imageNamed:@"shanchutupian"] forState:UIControlStateNormal];
                deleteBtn.tag = 0;
                [deleteBtn addTarget:self action:@selector(deletePeoPleWith:) forControlEvents:UIControlEventTouchUpInside];
                
                
                if (self.isShow) {
                    
                    if ([model.deleteFlag integerValue]==1) {
                        deleteBtn.hidden = YES;
                    }else{
                        deleteBtn.hidden = NO;
                    }
                }else{
                    deleteBtn.hidden = YES;
                }
                
                UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(photoV.right+3, 15, backV.width-photoV.right-3, 35)];
                nameL.textColor = COLOR_BLACK_CLASS_3;
                nameL.font = NB_FONTSEIZ_SMALL;
                nameL.numberOfLines = 0;
                //        companyJob.backgroundColor = Red_Color;
                nameL.textAlignment = NSTextAlignmentLeft;
                nameL.text = model.trueName;
                
                
                CGSize textSize1 = [model.trueName boundingRectWithSize:CGSizeMake(backV.width-photoV.right-3, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                                context:nil].size;
                if (textSize1.height<30) {
                    textSize1.height = 30;
                }
                nameL.height = textSize1.height;
                
                UILabel *jobL = [[UILabel alloc]initWithFrame:CGRectMake(nameL.left, nameL.bottom, nameL.width, 15)];
                jobL.textColor = COLOR_BLACK_CLASS_6;
                jobL.font = [UIFont systemFontOfSize
                             :12];
                //        companyJob.backgroundColor = Red_Color;
                jobL.textAlignment = NSTextAlignmentLeft;
                jobL.text = model.cJobTypeName;
                
                [backV addSubview:photoV];
                [backV addSubview:deleteBtn];
                [backV addSubview:nameL];
                [backV addSubview:jobL];
                
                
                self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/2-25, 15, 50, 50);
                self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, 15, 50, 50);
                [self addSubview:self.addBtn];
                [self addSubview:self.reduceBtn];
                
                if ((!isExit)||(!isLogin)||ccComplete==2||ccComplete==3) {
                    self.addBtn.hidden = YES;
                    self.reduceBtn.hidden = YES;
                }
                else{
                    self.addBtn.hidden = NO;
                    //总经理和店面经理(或经理)可以删除人员
                    if (cJobTypeId ==1002||cJobTypeId==1027||cJobTypeId ==1003) {
                        self.reduceBtn.hidden = NO;
                    }
                    else{
                        self.reduceBtn.hidden = YES;
                    }
                }
                
            }
            else{
                CGFloat ww = kSCREEN_WIDTH/3;
                CGFloat hh = 0;
                NSInteger lastX = 0;
                NSInteger lastY = 0;
                for (int i = 0; i<count; i++) {
                    NSInteger x = i/3; // 行
                    NSInteger y = i%3; // 列
                    MainMaterialMemberModel *model = array[i];
                    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(ww*y, 80*x, ww, 80)];
                    [self addSubview:backV];
                    
                    backV.tag = i;
                    backV.userInteractionEnabled = YES;
                    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookTap:)];
                    [backV addGestureRecognizer:ges];
                    //                if (i == 0) {
                    //                    backV.backgroundColor = Red_Color;
                    //                }else{
                    //                    backV.backgroundColor = Black_Color;
                    //                }
                    //                backV.backgroundColor =
                    
                    UIImageView *photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
                    //            photoV.backgroundColor = Red_Color;
                    
                    [photoV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
                    
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.frame = CGRectMake(photoV.right-20, photoV.top, 20, 20);
                    deleteBtn.layer.masksToBounds = YES;
                    deleteBtn.layer.cornerRadius = deleteBtn.width/2;
                    //                    deleteBtn.layer.borderWidth = 1.0;
                    //                    deleteBtn.layer.borderColor = White_Color.CGColor;
                    //            _addressBtn.backgroundColor = Red_Color;
                    [deleteBtn setImage:[UIImage imageNamed:@"shanchutupian"] forState:UIControlStateNormal];
                    deleteBtn.tag = i;
                    [deleteBtn addTarget:self action:@selector(deletePeoPleWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (self.isShow) {
                        
                        if ([model.deleteFlag integerValue]==1) {
                            deleteBtn.hidden = YES;
                        }else{
                            deleteBtn.hidden = NO;
                        }
                    }else{
                        deleteBtn.hidden = YES;
                    }
                    
                    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(photoV.right+3, 15, backV.width-photoV.right-3, 35)];
                    nameL.textColor = COLOR_BLACK_CLASS_3;
                    nameL.font = NB_FONTSEIZ_SMALL;
                    //        companyJob.backgroundColor = Red_Color;
                    nameL.textAlignment = NSTextAlignmentLeft;
                    nameL.text = model.trueName;
                    nameL.numberOfLines = 0;
                    
                    
                    CGSize textSize1 = [model.trueName boundingRectWithSize:CGSizeMake(backV.width-photoV.right-3, CGFLOAT_MAX)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                                    context:nil].size;
                    if (textSize1.height<30) {
                        textSize1.height = 30;
                    }
                    nameL.height = textSize1.height;
                    
                    UILabel *jobL = [[UILabel alloc]initWithFrame:CGRectMake(nameL.left, nameL.bottom, nameL.width, 15)];
                    jobL.textColor = COLOR_BLACK_CLASS_6;
                    jobL.font = NB_FONTSEIZ_SMALL;
                    //        companyJob.backgroundColor = Red_Color;
                    jobL.textAlignment = NSTextAlignmentLeft;
                    jobL.text = model.cJobTypeName;
                    
                    [backV addSubview:photoV];
                    [backV addSubview:deleteBtn];
                    [backV addSubview:nameL];
                    [backV addSubview:jobL];
                    
//                    if (self.isShow) {
//                        deleteBtn.hidden = NO;
//                    }else{
//                        deleteBtn.hidden = YES;
//                    }
                    
                    if (i == count-1) {
                        lastX = i/3;
                        lastY = i%3;
                    }
                    hh = 80*x+80;
                }
                
                if ((!isExit)||(!isLogin)||ccComplete==2||ccComplete==3) {
                    self.addBtn.hidden = YES;
                    self.reduceBtn.hidden = YES;
                }
                else{
                    self.addBtn.hidden = NO;
                    //总经理和店面经理可以删除人员
                    if (cJobTypeId ==1002||cJobTypeId==1027||cJobTypeId ==1003) {
                        self.reduceBtn.hidden = NO;
                    }
                    else{
                        self.reduceBtn.hidden = YES;
                    }
                }
                if (lastY == 0) {
                    //                self.cellH = hh+80;
                    self.cellH = hh;
                    self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/3+10, hh+15-80, 50, 50);
                    self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, self.addBtn.top, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                }
                else if(lastY == 1){
                    
                    
                    self.addBtn.frame = CGRectMake(kSCREEN_WIDTH/3*2+10, hh+15-80, 50, 50);
                    self.reduceBtn.frame = CGRectMake(10, self.addBtn.top+80, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                    if ((self.reduceBtn.hidden==YES)&&(self.addBtn.hidden==YES)) {
                        self.cellH = hh;
                    }
                    else{
                        if ((self.reduceBtn.hidden==YES)&&(self.addBtn.hidden==NO)) {
                            self.cellH=hh;
                        }
                        if ((self.reduceBtn.hidden==NO)&&(self.addBtn.hidden==NO)) {
                            self.cellH = hh+80;
                        }
                    }
                    //                    if (!self.isShowReduceBtn) {
                    //                        self.cellH = hh;
                    //                    }
                    //                    else{
                    //                        self.cellH = hh+80;
                    //                    }
                }
                else{
                    self.cellH = hh+80;
                    
                    self.addBtn.frame = CGRectMake(10, hh+15, 50, 50);
                    self.reduceBtn.frame = CGRectMake(self.addBtn.left+kSCREEN_WIDTH/3, self.addBtn.top, 50, 50);
                    [self addSubview:self.addBtn];
                    [self addSubview:self.reduceBtn];
                    
                    if (self.reduceBtn.hidden==YES&&self.addBtn.hidden==YES) {
                        self.cellH = hh;
                    }
                    else{
                        if (self.reduceBtn.hidden==YES&&self.reduceBtn.hidden==NO) {
                            self.cellH=hh+80;
                        }
                        if (self.reduceBtn.hidden==NO&&self.addBtn.hidden==NO) {
                            self.cellH = hh+80;
                        }
                    }
                }
            }
        }
    }
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(100, 20, 50, 50);
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 5;
        _addBtn.layer.borderWidth = 1.0;
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        [_addBtn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

-(UIButton *)reduceBtn{
    if (!_reduceBtn) {
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBtn.frame = CGRectMake(self.addBtn.right+20, self.addBtn.top, 50, 50);
        _reduceBtn.layer.masksToBounds = YES;
        _reduceBtn.layer.cornerRadius = 5;
        _reduceBtn.layer.borderWidth = 1.0;
        _reduceBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        [_reduceBtn addTarget:self action:@selector(reduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_reduceBtn setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    }
    return _reduceBtn;
}

-(void)addBtnClick{
    if ([self.delegate respondsToSelector:@selector(addPeople)]) {
        [self.delegate addPeople];
    }
}

-(void)reduceBtnClick{
    if ([self.delegate respondsToSelector:@selector(reducePeople)]) {
        [self.delegate reducePeople];
    }
}

-(void)deletePeoPleWith:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(deleteWith:)]) {
        [self.delegate deleteWith:sender.tag];
    }
}

-(void)lookTap:(UITapGestureRecognizer *)ges{
    NSInteger tag = ges.view.tag;
    if ([self.delegate respondsToSelector:@selector(lookDetailInfo:)]) {
        [self.delegate lookDetailInfo:tag];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
