//
//  CaseMaterialCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CaseMaterialCell.h"
#import "CaseMaterialTwoModel.h"

@interface CaseMaterialCell ()
@property (nonatomic, strong) UIImageView *photoV;
@property (nonatomic, strong) UILabel *designL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *bV;
@property (nonatomic, strong) UILabel *caseL;

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UIButton *vipV;//企业vip
@property (nonatomic, strong) UIButton *diaryVipBtn;//日志vip的标志
@property (nonatomic, strong) UILabel *phoneL;
@property (nonatomic, strong) UILabel *shopNumL;
@property (nonatomic, strong) UILabel *browerNumL;

@property (nonatomic, strong) UIButton *shopBtn;
@property (nonatomic, strong) UIButton *construcBtn;

@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UILabel *zanL;



@property (nonatomic, strong) UIButton *rewardBtn;
@property (nonatomic, strong) UILabel *rewardL;

@property (nonatomic, strong) UIView *commentV;

@property (nonatomic, strong) NSIndexPath *path;

@end

@implementation CaseMaterialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    static NSString *TextFieldCellID = @"CaseMaterialCell";
    CaseMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[CaseMaterialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    cell.path = path;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.photoV];
        [self addSubview:self.designL];
        [self addSubview:self.timeL];
        [self addSubview:self.bV];
        [self addSubview:self.caseL];
        [self addSubview:self.imgV];
        
        [self addSubview:self.construcBtn];//工地
        [self addSubview:self.vipV];//vip
        [self addSubview:self.diaryVipBtn];
        [self addSubview:self.shopNameL];
        
        [self addSubview:self.shopNumL];
        [self addSubview:self.browerNumL];
        
        
        
        [self addSubview:self.zanBtn];
        [self addSubview:self.zanL];
        
        [self addSubview:self.commentBtn];
        [self addSubview:self.commentL];
        [self addSubview:self.rewardBtn];
        [self addSubview:self.rewardL];
        
        [self addSubview:self.commentV];
        
        [self addSubview:self.deleteBtn];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}


#pragma mark  model 赋值
-(void)configWith:(id)data{
    if ([data isKindOfClass:[CaseMaterialTwoModel class]]) {
        CaseMaterialTwoModel *model = data;
        //头像
        [self.photoV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
        //职位和姓名
        self.designL.text = [NSString stringWithFormat:@"%@-%@",model.jobType,model.trueName];
        //时间
        NSString *time = [self timeWithTimeIntervalString:model.addTime];
        self.timeL.text = time;
        
        //展示图
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.coverMap] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        
        //分享标题
        self.shopNameL.text = model.shareTitle;

        //店铺名称
        if (model.companyName.length > 0) {
            NSString *tempShopName = [NSString stringWithFormat:@"%@",model.companyName];
            self.shopNumL.text = tempShopName;
            CGSize size = [tempShopName boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-self.shopNameL.left-45-5-45-5, 20) withFont:NB_FONTSEIZ_SMALL];
            self.shopNumL.frame = CGRectMake(self.shopNameL.left, self.phoneL.bottom+10, size.width+5, 20);
            
        }
        
        self.vipV.frame = CGRectMake(self.shopNumL.right,self.shopNumL.top+2, 45, 16);
        
        self.diaryVipBtn.frame = CGRectMake(self.vipV.right+5,self.vipV.top, 45, 16);
   
//        self.browerNumL.text = [NSString stringWithFormat:@"浏览量%@",model.browse];
        self.zanL.text = model.likeNum;
        
        NSInteger timeInt = [model.times integerValue]; //企业网会员
        NSInteger logInt = [model.isLog integerValue]; //云管理会员
        if (timeInt>0) {
            if (logInt>0) {
                self.vipV.hidden = NO;
                self.diaryVipBtn.hidden = NO;
                self.vipV.frame = CGRectMake(self.shopNumL.right,self.shopNumL.top+2, 45, 16);
                
                self.diaryVipBtn.frame = CGRectMake(self.vipV.right+5,self.vipV.top, 45, 16);
            }
            else{
                self.vipV.hidden = NO;
                self.diaryVipBtn.hidden = YES;
                self.vipV.frame = CGRectMake(self.shopNumL.right,self.shopNumL.top+2, 45, 16);
            }
        }
        else{
            if (logInt>0) {
                self.vipV.hidden = YES;
                self.diaryVipBtn.hidden = NO;
                self.diaryVipBtn.frame = CGRectMake(self.shopNumL.right,self.shopNumL.top+2, 45, 16);
            }
            else{
                self.vipV.hidden = YES;
                self.diaryVipBtn.hidden = YES;
            }
        }
        
        
        
        if (timeInt>0) {
            self.vipV.hidden = NO;
            self.shopBtn.hidden = NO;
        }
        else{
            self.vipV.hidden = YES;
            self.shopBtn.hidden = YES;
        }
        
        if (!model.agencysId||model.agencysId.length<=0) {
            [self.zanBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        }
        else{
            [self.zanBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        }
        
        [self.commentV removeAllSubViews];
        if (model.commentList.count<=0) {
            self.commentV.frame = CGRectMake(0, self.zanBtn.bottom+5, kSCREEN_WIDTH, 5);
            self.cellH = 200;
        }
        else{
            NSInteger count = model.commentList.count;
            CGFloat hh = 0;
            //CGFloat texthei = [self getHeightByWidth:kSCREEN_WIDTH-10*2 title:@"" font:14];
            for (int i=0; i<count; i++) {
                
                NSDictionary *dict = model.commentList[i];
                NSString *temStr = [NSString stringWithFormat:@"%@-%@:%@",[dict objectForKey:@"cJobTypeName"],[dict objectForKey:@"trueName"],[dict objectForKey:@"content"]];
                
                CGFloat texthei = [self getHeightByWidth:kSCREEN_WIDTH-10*2 title: temStr font:[UIFont systemFontOfSize:14]];
                
                UILabel *jobOrNameL = [[UILabel alloc]initWithFrame:CGRectMake(10, hh, kSCREEN_WIDTH-10*2, texthei)];
                jobOrNameL.textColor = COLOR_BLACK_CLASS_3;
                jobOrNameL.font = [UIFont systemFontOfSize:14];
                jobOrNameL.textAlignment = NSTextAlignmentLeft;
                

                jobOrNameL.numberOfLines = 0;
               // jobOrNameL.lineBreakMode = UILineBreakModeWordWrap;
                jobOrNameL.text = temStr;
                [jobOrNameL sizeToFit];
               
                
                CGSize textSize = [temStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10*2, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                       context:nil].size;
                
                NSLog(@"hei----%lf",textSize.height);
                
                jobOrNameL.frame = CGRectMake(10, hh, kSCREEN_WIDTH-10*2, texthei);
                
                hh = hh+texthei;
                [self.commentV addSubview:jobOrNameL];
            }
            self.commentV.frame = CGRectMake(0, self.zanBtn.bottom+5, kSCREEN_WIDTH, hh);
            self.cellH = 200+hh+10;
        }
        
    }
}

-(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}


#pragma mark - setter

-(UIImageView *)photoV{
    if (!_photoV) {
        _photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10,15, 40, 40)];
        _photoV.layer.cornerRadius = _photoV.width/2;
        _photoV.layer.masksToBounds = YES;
    }
    return _photoV;
}

-(UILabel *)designL{
    if (!_designL) {
        _designL = [[UILabel alloc]initWithFrame:CGRectMake(self.photoV.right+5, self.photoV.top, 200, 25)];
        _designL.textColor = COLOR_BLACK_CLASS_3;
        _designL.font = [UIFont systemFontOfSize
                         :14];
        _designL.textAlignment = NSTextAlignmentLeft;
    }
    return _designL;
}

-(UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]initWithFrame:CGRectMake(self.designL.left, self.designL.bottom, 100, 15)];
        _timeL.textColor = COLOR_BLACK_CLASS_3;
        _timeL.font = [UIFont systemFontOfSize
                         :12];
        _timeL.textAlignment = NSTextAlignmentLeft;
    }
    return _timeL;
}

-(UIImageView *)bV{
    if (!_bV) {
        _bV = [[UIImageView alloc]initWithFrame:CGRectMake(self.timeL.right+5,self.timeL.top+3, 10, 10)];
        _bV.image = [UIImage imageNamed:@"ty_red"];
    }
    return _bV;
}

-(UILabel *)caseL{
    if (!_caseL) {
        _caseL = [[UILabel alloc]initWithFrame:CGRectMake(self.bV.right+5, self.timeL.top, 80, 15)];
        _caseL.textColor = Red_Color;
        _caseL.font = [UIFont systemFontOfSize
                       :12];
        _caseL.textAlignment = NSTextAlignmentLeft;
        _caseL.text = @"本案主材";
    }
    return _caseL;
}

-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.photoV.left,self.photoV.bottom+20, 80, 80)];

    }
    return _imgV;
}

//企业网
-(UIButton *)construcBtn{
    if (!_construcBtn) {
        _construcBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-60-10, self.imgV.top, 60, 40)];

        [_construcBtn setImage:[UIImage imageNamed:@"hy"] forState:UIControlStateNormal];
        [_construcBtn setAdjustsImageWhenHighlighted:NO];
        [_construcBtn addTarget:self action:@selector(shopClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _construcBtn;
}

-(UIButton *)vipV{
    if (!_vipV) {
        _vipV = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipV.frame = CGRectMake(self.construcBtn.left-20-5,self.imgV.top, 50, 16);
        _vipV.backgroundColor = RGB(247, 210, 72);
        [_vipV setTitle:@"企业VIP" forState:UIControlStateNormal];
        [_vipV setTitleColor:White_Color forState:UIControlStateNormal];
        _vipV.titleLabel.font = NB_FONTSEIZ_TINE;
        _vipV.layer.cornerRadius = 5;
        _vipV.layer.masksToBounds = YES;
    }
    return _vipV;
}

-(UIButton *)diaryVipBtn{
    if (!_diaryVipBtn) {
        _diaryVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _diaryVipBtn.frame = CGRectMake(self.vipV.right,self.vipV.top, 50, 16);
        _diaryVipBtn.backgroundColor = RGB(247, 210, 72);
        [_diaryVipBtn setTitle:@"日志VIP" forState:UIControlStateNormal];
        [_diaryVipBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _diaryVipBtn.titleLabel.font = NB_FONTSEIZ_TINE;
        _diaryVipBtn.layer.cornerRadius = 5;
        _diaryVipBtn.layer.masksToBounds = YES;
    }
    return _diaryVipBtn;
}

-(UILabel *)shopNameL{
    if (!_shopNameL) {
        _shopNameL = [[UILabel alloc]initWithFrame:CGRectMake(self.imgV.right+10, self.imgV.top, kSCREEN_WIDTH-self.imgV.right-self.vipV.width-5-5-self.construcBtn.width-15, 40)];
        _shopNameL.numberOfLines = 2;
        _shopNameL.textColor = COLOR_BLACK_CLASS_3;
        _shopNameL.font = [UIFont systemFontOfSize
                       :14];
        _shopNameL.textAlignment = NSTextAlignmentLeft;
    }
    return _shopNameL;
}



-(UILabel *)phoneL{
    if (!_phoneL) {
        _phoneL = [[UILabel alloc]initWithFrame:CGRectMake(self.shopNameL.left, self.shopNameL.bottom+10, kSCREEN_WIDTH-self.shopNameL.left-80, 0)];
        _phoneL.textColor = COLOR_BLACK_CLASS_3;
        _phoneL.font = [UIFont systemFontOfSize
                           :12];
        _phoneL.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneL;
}

-(UILabel *)shopNumL{
    if (!_shopNumL) {
        _shopNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.shopNameL.left, self.phoneL.bottom+10, 130, 20)];
        _shopNumL.textColor = COLOR_BLACK_CLASS_3;
        _shopNumL.font = [UIFont systemFontOfSize
                        :12];
        _shopNumL.textAlignment = NSTextAlignmentLeft;
    }
    return _shopNumL;
}

-(UILabel *)browerNumL{
    if (!_browerNumL) {
        _browerNumL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-80-90, self.shopNumL.top, 90, 20)];
        
        _browerNumL.textColor = COLOR_BLACK_CLASS_3;
        _browerNumL.font = [UIFont systemFontOfSize
                          :12];
        _browerNumL.textAlignment = NSTextAlignmentRight;
    }
    return _browerNumL;
}






-(UIButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanBtn.frame = CGRectMake(kSCREEN_WIDTH/3/2-20-5, self.imgV.bottom+20, 20, 20);
        //            _addressBtn.backgroundColor = Red_Color;
        [_zanBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        [_zanBtn addTarget:self action:@selector(zanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanBtn;
}

-(UILabel *)zanL{
    if (!_zanL) {
        _zanL = [[UILabel alloc]initWithFrame:CGRectMake(self.zanBtn.right+10, self.zanBtn.top, 40, 20)];
        _zanL.textColor = COLOR_BLACK_CLASS_3;
        _zanL.font = [UIFont systemFontOfSize
                         :14];
        _zanL.text = @"0";
        //        companyJob.backgroundColor = Red_Color;
        _zanL.textAlignment = NSTextAlignmentLeft;
    }
    return _zanL;
}

-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(self.zanBtn.left+kSCREEN_WIDTH/3, self.imgV.bottom+20, 20, 20);
        //            _addressBtn.backgroundColor = Red_Color;
        [_commentBtn setImage:[UIImage imageNamed:@"ty_comment"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

-(UILabel *)commentL{
    if (!_commentL) {
        _commentL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentBtn.right+10, self.zanBtn.top, 40, 20)];
        _commentL.textColor = COLOR_BLACK_CLASS_3;
        _commentL.font = [UIFont systemFontOfSize
                      :14];
        _commentL.text = @"评论";
        //        companyJob.backgroundColor = Red_Color;
        _commentL.textAlignment = NSTextAlignmentLeft;
;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentClick)];
        _commentL.userInteractionEnabled = YES;
        [_commentL  addGestureRecognizer:tap];
    }
    return _commentL;
}

-(UIButton *)rewardBtn{
    if (!_rewardBtn) {
        _rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rewardBtn.frame = CGRectMake(self.commentBtn.left+kSCREEN_WIDTH/3, self.imgV.bottom+20, 20, 20);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_rewardBtn setImage:[UIImage imageNamed:@"reward"] forState:UIControlStateNormal];
        [_rewardBtn addTarget:self action:@selector(rewardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rewardBtn;
}


-(UILabel *)rewardL{
    if (!_rewardL) {
        _rewardL = [[UILabel alloc]initWithFrame:CGRectMake(self.rewardBtn.right+10, self.zanBtn.top, 40, 20)];
        _rewardL.textColor = COLOR_BLACK_CLASS_3;
        _rewardL.font = [UIFont systemFontOfSize
                          :14];
        _rewardL.text = @"打赏";
        //        companyJob.backgroundColor = Red_Color;
        _rewardL.textAlignment = NSTextAlignmentLeft;
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rewardBtnClick:)];
        _rewardL.userInteractionEnabled = YES;
        [_rewardL  addGestureRecognizer:tap];
    }
    return _rewardL;
}

-(UIView *)commentV{
    if (!_commentV) {
        _commentV = [[UIView alloc]initWithFrame:CGRectMake(0, self.zanBtn.bottom+5, kSCREEN_WIDTH, 5)];
        _commentV.backgroundColor = White_Color;
    }
    return _commentV;
}


-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deleteBtn.frame = CGRectMake(kSCREEN_WIDTH-24-15,self.designL.bottom-15,24,24);
        _deleteBtn.frame = CGRectMake(kSCREEN_WIDTH-60-15,self.designL.bottom-15,60,24);
        
        //            _addressBtn.backgroundColor = Red_Color;
//        [_deleteBtn setImage:[UIImage imageNamed:@"delete_log"] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//        _deleteBtn.backgroundColor = Red_Color;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}



-(void)commentClick{
    if ([self.delegate respondsToSelector:@selector(CasecommentWith:)]) {
        [self.delegate CasecommentWith:self.path];
    }
}

-(void)zanClick{
    if ([self.delegate respondsToSelector:@selector(CasezanWith:)]) {
        [self.delegate CasezanWith:self.path];
    }
}

-(void)contructClick{
    if ([self.delegate respondsToSelector:@selector(goCaseMatialVcWith:)]) {
        [self.delegate goCaseMatialVcWith:self.path];
    }
}

-(void)shopClick{
    if ([self.delegate respondsToSelector:@selector(goShopWith:)]) {
        [self.delegate goShopWith:self.path];
    }
}

-(void)deleteBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteShopWith:)]) {
        [self.delegate deleteShopWith:self.path];
    }
}

#pragma mark 打赏
-(void)rewardBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(rewardAction:)]) {
        [self.delegate rewardAction:self.path];
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
