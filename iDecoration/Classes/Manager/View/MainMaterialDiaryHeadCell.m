//
//  MainMaterialDiaryHeadCell.m
//  iDecoration
//
//  Created by Apple on 2017/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MainMaterialDiaryHeadCell.h"
#import "MainDiarySiteModel.h"

#import "copyLabel.h"
@interface MainMaterialDiaryHeadCell()

@property (nonatomic, strong) UILabel *userNameLeftL;//户主
@property (nonatomic, strong) UILabel *userNameRightL;

@property (nonatomic, strong) copyLabel *nodeNumLeftL;//工地编号
@property (nonatomic, strong) copyLabel *nodeNumRightL;
@property (nonatomic, strong) UILabel *socialNameLeftL;//小区名称
@property (nonatomic, strong) UILabel *socialNameRightL;
@property (nonatomic, strong) UILabel *contructionAddressLeftL;//施工地址
@property (nonatomic, strong) UILabel *contructionAddressRightL;
@property (nonatomic, strong) UILabel *shareTitleLeftL;//分享标题
@property (nonatomic, strong) UILabel *shareTitleRightL;

@property (nonatomic, strong) UILabel *shopAreaLeftL;//房屋面积
@property (nonatomic, strong) UILabel *shopAreaRightL;

@property (nonatomic, strong) UILabel *nowNodeTitleLeftL;//当前节点
@property (nonatomic, strong) UILabel *nowNodeTitleRightL;

@property (nonatomic, strong) UILabel *contructionSiteLeftL;//施工单位
@property (nonatomic, strong) UILabel *contructionSiteRightL;
@property (nonatomic, strong) UILabel *contructionType;//店铺类型

@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIImageView *shopImgV;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UILabel *shopAddressL;
@property (nonatomic, strong) UIButton *inPutBtn;


@end

@implementation MainMaterialDiaryHeadCell

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
    static NSString *TextFieldCellID = @"MainMaterialDiaryHeadCell";
    MainMaterialDiaryHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[MainMaterialDiaryHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    cell.path = path;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.userNameLeftL];
        [self addSubview:self.userNameRightL];
        [self addSubview:self.editBtn];
        [self addSubview:self.nodeNumLeftL];
        [self addSubview:self.nodeNumRightL];
        [self addSubview:self.socialNameLeftL];
        [self addSubview:self.socialNameRightL];
        [self addSubview:self.contructionAddressLeftL];
        [self addSubview:self.contructionAddressRightL];
        
        [self addSubview:self.shareTitleLeftL];
        [self addSubview:self.shareTitleRightL];
        
        [self addSubview:self.shopAreaLeftL];
        [self addSubview:self.shopAreaRightL];
        
//        [self addSubview:self.nowNodeTitleLeftL];
//        [self addSubview:self.nowNodeTitleRightL];
        
//        [self addSubview:self.contructionSiteLeftL];
//        [self addSubview:self.contructionSiteRightL];
//        [self addSubview:self.contructionType];
        
        [self addSubview:self.lineV];
        [self addSubview:self.shopImgV];
        [self addSubview:self.shopNameL];
        [self addSubview:self.shopAddressL];
        [self addSubview:self.inPutBtn];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    return self;
}

-(void)configWith:(id)data{
    
    if ([data isKindOfClass:[MainDiarySiteModel class]]) {
        MainDiarySiteModel *model = data;
        // 户主
        self.userNameRightL.text = model.ccHouseholderName;
        // 工单编号
        self.nodeNumRightL.text = model.constructionNo;
        CGSize nodeTextSize = [self.nodeNumRightL.text boundingRectWithSize:CGSizeMake(self.nodeNumRightL.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        self.nodeNumRightL.frame = CGRectMake(self.nodeNumLeftL.right+15, self.nodeNumLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, nodeTextSize.height);
        
        // 小区名称
        self.socialNameRightL.text = model.ccAreaName;
        CGSize socialTextSize = [self.socialNameRightL.text boundingRectWithSize:CGSizeMake(self.socialNameRightL.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        self.socialNameLeftL.frame = CGRectMake(self.userNameLeftL.left, self.nodeNumRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height);
        self.socialNameRightL.frame = CGRectMake(self.nodeNumLeftL.right+15, self.socialNameLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, 20);
        
         // 施工地址
        self.contructionAddressRightL.text = model.ccAddress;
        CGSize addressTextSize = [self.contructionAddressRightL.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - self.contructionAddressLeftL.right - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        self.contructionAddressLeftL.frame = CGRectMake(self.userNameLeftL.left, self.socialNameRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height);
        self.contructionAddressRightL.frame = CGRectMake(self.nodeNumLeftL.right+15, self.contructionAddressLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, 20);
        
        // 分享标题
        self.shareTitleRightL.text = model.ccShareTitle;
//        CGSize shareTextSize = [self.shareTitleRightL.text boundingRectWithSize:CGSizeMake(self.shareTitleRightL.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
//        self.shareTitleRightL.height = shareTextSize.height;
        self.shareTitleLeftL.frame = CGRectMake(self.userNameLeftL.left, self.contructionAddressRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height);
        self.shareTitleRightL.frame = CGRectMake(self.nodeNumLeftL.right+15, self.shareTitleLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, 20);
//        self.shareTitleLeftL.centerY = self.shareTitleRightL.centerY;
        
        //面积
        NSString *areaStr = model.ccAcreage;
        if (!areaStr||areaStr.length<=0) {
            areaStr = @"";
        }
        else{
            areaStr = [areaStr stringByAppendingString:@"㎡"];
        }
        
        self.shopAreaRightL.text = areaStr;
        self.shopAreaLeftL.frame = CGRectMake(self.userNameLeftL.left, self.shareTitleLeftL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height);
        self.shopAreaRightL.frame = CGRectMake(self.nodeNumLeftL.right+15, self.shopAreaLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, self.nodeNumLeftL.height);
        self.lineV.frame = CGRectMake(0, self.shopAreaLeftL.bottom+10, kSCREEN_WIDTH, 0.5);
        
        //店铺信息
        self.shopImgV.frame = CGRectMake(8, self.lineV.bottom+7, 60, 60);
        self.shopNameL.frame = CGRectMake(self.shopImgV.right+5,self.shopImgV.top,kSCREEN_WIDTH-self.shopImgV.right-5-5,25);
        self.shopAddressL.frame = CGRectMake(self.shopImgV.right+5,self.shopNameL.bottom,kSCREEN_WIDTH-self.shopImgV.right-5-5,20);
        CGFloat www = kSCREEN_WIDTH-self.shopImgV.right-5-5;
        self.inPutBtn.frame = CGRectMake(self.shopImgV.right+5+www/2-30,self.shopAddressL.bottom,60,15);
        
        //节点名称
//        self.nowNodeTitleRightL.text = model.crRoleName;
//        self.nowNodeTitleLeftL.frame = CGRectMake(self.userNameLeftL.left, self.shareTitleRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height);
//        self.nowNodeTitleRightL.frame = CGRectMake(self.nodeNumLeftL.right+15, self.nowNodeTitleLeftL.top, kSCREEN_WIDTH - self.nowNodeTitleLeftL.right - 15 - 15, self.nodeNumLeftL.height);
        
        // 施工单位
//        NSMutableAttributedString *siteAttrString = [[NSMutableAttributedString alloc] initWithString:model.ccBuilder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
//        NSString *typeStr = [NSString stringWithFormat:@"(%@)",model.typeName];
//        NSMutableAttributedString *mulAttriStr = [[NSMutableAttributedString alloc] initWithString:typeStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Main_Color} ];
//        [siteAttrString appendAttributedString:mulAttriStr];
//        self.contructionSiteRightL.attributedText = siteAttrString;
//
//        NSString *addressStr = [siteAttrString string];
//
//        CGSize contructionTextSize = [addressStr boundingRectWithSize:CGSizeMake(self.contructionSiteRightL.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
//        self.contructionSiteLeftL.frame = CGRectMake(self.userNameLeftL.left, self.nowNodeTitleRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height);
//        self.contructionSiteRightL.frame = CGRectMake(self.nodeNumLeftL.right+15, self.contructionSiteLeftL.top, kSCREEN_WIDTH - self.contructionSiteLeftL.right - 15 - 15, contructionTextSize.height);
     
        [self.shopImgV sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        self.shopNameL.text = model.companyName;
        self.shopAddressL.text = model.companyAddess;
        self.cellHeight = self.inPutBtn.bottom + 12 ;
    }

}

#pragma mark - setter
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(kSCREEN_WIDTH-15-15, self.userNameLeftL.top, 25, 25);
        [_editBtn setImage:[UIImage imageNamed:@"editDiary"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

-(UILabel *)userNameLeftL{
    if (!_userNameLeftL) {
        _userNameLeftL = [[UILabel alloc]initWithFrame:CGRectMake(8, 20, 85, 20)];
        _userNameLeftL.textColor = COLOR_BLACK_CLASS_3;
        _userNameLeftL.font = [UIFont systemFontOfSize
                         :16];
        _userNameLeftL.text = @"户        主：";
        //        companyJob.backgroundColor = Red_Color;
        _userNameLeftL.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameLeftL;
}

-(UILabel *)userNameRightL{
    if (!_userNameRightL) {
        _userNameRightL = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.right+15, self.userNameLeftL.top, 150, self.userNameLeftL.height)];
        _userNameRightL.textColor = COLOR_BLACK_CLASS_3;
        _userNameRightL.font = [UIFont systemFontOfSize
                               :16];
        //        companyJob.backgroundColor = Red_Color;
        _userNameRightL.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameRightL;
}



-(UILabel *)nodeNumLeftL{
    if (!_nodeNumLeftL) {
        _nodeNumLeftL = [[copyLabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.left, self.userNameRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height)];
        _nodeNumLeftL.textColor = COLOR_BLACK_CLASS_3;
        _nodeNumLeftL.font = [UIFont systemFontOfSize
                               :16];
        _nodeNumLeftL.text = @"工单编号：";
        //        companyJob.backgroundColor = Red_Color;
        _nodeNumLeftL.textAlignment = NSTextAlignmentLeft;
       
 
    }
    return _nodeNumLeftL;
}

-(UILabel *)nodeNumRightL{
    if (!_nodeNumRightL) {
        _nodeNumRightL = [[copyLabel alloc]initWithFrame:CGRectMake(self.nodeNumLeftL.right+15, self.nodeNumLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, self.nodeNumLeftL.height)];
        _nodeNumRightL.textColor = COLOR_BLACK_CLASS_3;
        _nodeNumRightL.font = [UIFont systemFontOfSize
                                :16];
        //        companyJob.backgroundColor = Red_Color;
        _nodeNumRightL.textAlignment = NSTextAlignmentLeft;
        _nodeNumRightL.numberOfLines = 0;
    }
    return _nodeNumRightL;
}

-(UILabel *)socialNameLeftL{
    if (!_socialNameLeftL) {
        _socialNameLeftL = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.left, self.nodeNumRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height)];
        _socialNameLeftL.textColor = COLOR_BLACK_CLASS_3;
        _socialNameLeftL.font = [UIFont systemFontOfSize
                              :16];
        _socialNameLeftL.text = @"小区名称：";
        //        companyJob.backgroundColor = Red_Color;
        _socialNameLeftL.textAlignment = NSTextAlignmentLeft;
    }
    return _socialNameLeftL;
}

-(UILabel *)socialNameRightL{
    if (!_socialNameRightL) {
        _socialNameRightL = [[UILabel alloc]initWithFrame:CGRectMake(self.nodeNumLeftL.right+15, self.socialNameLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, self.nodeNumLeftL.height)];
        _socialNameRightL.textColor = COLOR_BLACK_CLASS_3;
        _socialNameRightL.font = [UIFont systemFontOfSize
                               :16];
        //        companyJob.backgroundColor = Red_Color;
        _socialNameRightL.textAlignment = NSTextAlignmentLeft;
        _socialNameRightL.numberOfLines = 0;
    }
    return _socialNameRightL;
}

-(UILabel *)contructionAddressLeftL{
    if (!_contructionAddressLeftL) {
        _contructionAddressLeftL = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.left, self.socialNameRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height)];
        _contructionAddressLeftL.textColor = COLOR_BLACK_CLASS_3;
        _contructionAddressLeftL.font = [UIFont systemFontOfSize
                              :16];
        _contructionAddressLeftL.text = @"施工地址：";
        //        companyJob.backgroundColor = Red_Color;
        _contructionAddressLeftL.textAlignment = NSTextAlignmentLeft;
    }
    return _contructionAddressLeftL;
}

-(UILabel *)contructionAddressRightL{
    if (!_contructionAddressRightL) {
        _contructionAddressRightL = [[UILabel alloc]initWithFrame:CGRectMake(self.nodeNumLeftL.right+15, self.contructionAddressLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, self.nodeNumLeftL.height)];
        _contructionAddressRightL.textColor = COLOR_BLACK_CLASS_3;
        _contructionAddressRightL.font = [UIFont systemFontOfSize
                               :16];
        //        companyJob.backgroundColor = Red_Color;
        _contructionAddressRightL.textAlignment = NSTextAlignmentLeft;
        _contructionAddressRightL.numberOfLines = 0;
    }
    return _contructionAddressRightL;
}

-(UILabel *)shareTitleLeftL{
    if (!_shareTitleLeftL) {
        _shareTitleLeftL = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.left, self.contructionAddressRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height)];
        _shareTitleLeftL.textColor = COLOR_BLACK_CLASS_3;
        _shareTitleLeftL.font = [UIFont systemFontOfSize
                              :16];
        _shareTitleLeftL.text = @"分享标题：";
        //        companyJob.backgroundColor = Red_Color;
        _shareTitleLeftL.textAlignment = NSTextAlignmentLeft;
    }
    return _shareTitleLeftL;
}

-(UILabel *)shareTitleRightL{
    if (!_shareTitleRightL) {
        _shareTitleRightL = [[UILabel alloc]initWithFrame:CGRectMake(self.nodeNumLeftL.right+15, self.shareTitleLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, self.nodeNumLeftL.height)];
        _shareTitleRightL.textColor = COLOR_BLACK_CLASS_3;
        _shareTitleRightL.font = [UIFont systemFontOfSize
                               :16];
        //        companyJob.backgroundColor = Red_Color;
        _shareTitleRightL.textAlignment = NSTextAlignmentLeft;
        _shareTitleRightL.numberOfLines = 0;
    }
    return _shareTitleRightL;
}

-(UILabel *)shopAreaLeftL{
    if (!_shopAreaLeftL) {
        _shopAreaLeftL = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.left, self.shareTitleLeftL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height)];
        _shopAreaLeftL.textColor = COLOR_BLACK_CLASS_3;
        _shopAreaLeftL.font = [UIFont systemFontOfSize
                                 :16];
        _shopAreaLeftL.text = @"面        积：";
        //        companyJob.backgroundColor = Red_Color;
        _shopAreaLeftL.textAlignment = NSTextAlignmentLeft;
    }
    return _shopAreaLeftL;
}

-(UILabel *)shopAreaRightL{
    if (!_shopAreaRightL) {
        _shopAreaRightL = [[UILabel alloc]initWithFrame:CGRectMake(self.nodeNumLeftL.right+15, self.shopAreaLeftL.top, kSCREEN_WIDTH-self.nodeNumLeftL.right-15-15, self.nodeNumLeftL.height)];
        _shopAreaRightL.textColor = COLOR_BLACK_CLASS_3;
        _shopAreaRightL.font = [UIFont systemFontOfSize
                                  :16];
        //        companyJob.backgroundColor = Red_Color;
        _shopAreaRightL.textAlignment = NSTextAlignmentLeft;
        _shopAreaRightL.numberOfLines = 0;
    }
    return _shopAreaRightL;
}

//-(UILabel *)nowNodeTitleLeftL{
//    if (!_nowNodeTitleLeftL) {
//        _nowNodeTitleLeftL = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.left, self.shareTitleRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height)];
//        _nowNodeTitleLeftL.textColor = COLOR_BLACK_CLASS_3;
//        _nowNodeTitleLeftL.font = [UIFont systemFontOfSize
//                                      :16];
//        //        companyJob.backgroundColor = Red_Color;
//        _nowNodeTitleLeftL.textAlignment = NSTextAlignmentLeft;
//        _nowNodeTitleLeftL.text = @"当前节点：";
//    }
//    return _nowNodeTitleLeftL;
//}
//
//-(UILabel *)nowNodeTitleRightL{
//    if (!_nowNodeTitleRightL) {
//        _nowNodeTitleRightL = [[UILabel alloc]initWithFrame:CGRectMake(self.nodeNumLeftL.right+15, self.nowNodeTitleLeftL.top, kSCREEN_WIDTH - self.nowNodeTitleLeftL.right - 15 - 15, self.nodeNumLeftL.height)];
//        _nowNodeTitleRightL.textColor = COLOR_BLACK_CLASS_3;
//        _nowNodeTitleRightL.font = [UIFont systemFontOfSize
//                                       :16];
//        //        companyJob.backgroundColor = Red_Color;
//        _nowNodeTitleRightL.textAlignment = NSTextAlignmentLeft;
//        _nowNodeTitleRightL.numberOfLines = 0;
//        
//    }
//    return _nowNodeTitleRightL;
//}
//
//-(UILabel *)contructionSiteLeftL{
//    if (!_contructionSiteLeftL) {
//        _contructionSiteLeftL = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLeftL.left, self.nowNodeTitleRightL.bottom+8, self.userNameLeftL.width, self.userNameLeftL.height)];
//        _contructionSiteLeftL.textColor = COLOR_BLACK_CLASS_3;
//        _contructionSiteLeftL.font = [UIFont systemFontOfSize
//                                 :16];
//        //        companyJob.backgroundColor = Red_Color;
//        _contructionSiteLeftL.textAlignment = NSTextAlignmentLeft;
//        _contructionSiteLeftL.text = @"施工单位：";
//    }
//    return _contructionSiteLeftL;
//}
//
//-(UILabel *)contructionSiteRightL{
//    if (!_contructionSiteRightL) {
//        _contructionSiteRightL = [[UILabel alloc]initWithFrame:CGRectMake(self.nodeNumLeftL.right+15, self.contructionSiteLeftL.top, kSCREEN_WIDTH - self.contructionSiteLeftL.right - 15 - 15, self.nodeNumLeftL.height)];
//        _contructionSiteRightL.textColor = COLOR_BLACK_CLASS_3;
//        _contructionSiteRightL.font = [UIFont systemFontOfSize
//                                  :16];
//        //        companyJob.backgroundColor = Red_Color;
//        _contructionSiteRightL.textAlignment = NSTextAlignmentLeft;
//        _contructionSiteRightL.numberOfLines = 0;
//        
//    }
//    return _contructionSiteRightL;
//}
//
//-(UILabel *)contructionType{
//    if (!_contructionType) {
//        _contructionType = [[UILabel alloc]initWithFrame:CGRectMake(self.contructionSiteRightL.right, self.contructionSiteLeftL.top, kSCREEN_WIDTH-self.contructionSiteRightL.right-15, self.nodeNumLeftL.height)];
//        _contructionType.textColor = Main_Color;
//        _contructionType.font = [UIFont systemFontOfSize
//                                       :16];
//        //        companyJob.backgroundColor = Red_Color;
//        _contructionType.textAlignment = NSTextAlignmentLeft;
//    }
//    return _contructionType;
//}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.shopAreaLeftL.bottom+10, kSCREEN_WIDTH, 0.5)];
        _lineV.backgroundColor = kSepLineColor;
    }
    return _lineV;
}

-(UIImageView *)shopImgV{
    if (!_shopImgV) {
        _shopImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.shopAreaLeftL.left, self.lineV.bottom+7, 60, 60)];
        _shopImgV.image = [UIImage imageNamed:DefaultIcon];
        _shopImgV.userInteractionEnabled = YES;
//        _shopImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _shopImgV;
}

-(UILabel *)shopNameL{
    if (!_shopNameL) {
        _shopNameL = [[UILabel alloc]initWithFrame:CGRectMake(self.shopImgV.right+5,self.shopImgV.top,kSCREEN_WIDTH-self.shopImgV.right-5-5,25)];
        _shopNameL.textColor = COLOR_BLACK_CLASS_3;
        _shopNameL.font = NB_FONTSEIZ_NOR;
        //        companyJob.backgroundColor = Red_Color;
        _shopNameL.textAlignment = NSTextAlignmentLeft;
    }
    return _shopNameL;
}

-(UILabel *)shopAddressL{
    if (!_shopAddressL) {
        _shopAddressL = [[UILabel alloc]initWithFrame:CGRectMake(self.shopImgV.right+5,self.shopNameL.bottom,kSCREEN_WIDTH-self.shopImgV.right-5-5,20)];
        _shopAddressL.textColor = COLOR_BLACK_CLASS_3;
        _shopAddressL.font = NB_FONTSEIZ_SMALL;
        //        companyJob.backgroundColor = Red_Color;
        _shopAddressL.textAlignment = NSTextAlignmentLeft;
    }
    return _shopAddressL;
}

-(UIButton *)inPutBtn{
    if (!_inPutBtn) {
        CGFloat www = kSCREEN_WIDTH-self.shopImgV.right-5-5;
        _inPutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inPutBtn.frame = CGRectMake(self.shopImgV.right+5+www/2-30,self.shopAddressL.bottom,60,15);
        _inPutBtn.backgroundColor = White_Color;
        [_inPutBtn setTitle:@"进店逛逛" forState:UIControlStateNormal];
        _inPutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_inPutBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        _inPutBtn.titleLabel.font = NB_FONTSEIZ_TINE;
        [_inPutBtn addTarget:self action:@selector(inPutBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        successBtn.layer.masksToBounds = YES;
//        successBtn.layer.cornerRadius = 5;
    }
    return _inPutBtn;
}



#pragma mark - action

-(void)editClick{
    if ([self.delegate respondsToSelector:@selector(modifyCon)]) {
        [self.delegate modifyCon];
    }
}

-(void)inPutBtnClick{
    if ([self.delegate respondsToSelector:@selector(goToShopLook)]) {
        [self.delegate goToShopLook];
    }
}

@end
