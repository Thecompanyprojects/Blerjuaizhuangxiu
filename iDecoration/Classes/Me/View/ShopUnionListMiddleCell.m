//
//  ShopUnionListMiddleCell.m
//  iDecoration
//
//  Created by sty on 2017/10/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopUnionListMiddleCell.h"
#import "ShopUnionListModel.h"

@implementation ShopUnionListMiddleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.logoImg.layer.masksToBounds = YES;
    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configData:(id)data{
    if ([data isKindOfClass:[ShopUnionListModel class]]) {
        ShopUnionListModel *model = data;
        [self.logoImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        
        CGSize size = [model.companyName boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-85-30-45, 21) withFont:NB_FONTSEIZ_NOR];
        
        self.companyNameL.text = model.companyName;
        self.companyWidthCons.constant = size.width+10;
        
//        [self.nameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
//        [self.nameBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, size.width)];
//        [self.nameBtn setTitle:model.companyName forState:UIControlStateNormal];
        if (![model.appVip integerValue]) {
            //不是vip
//            [self.nameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//            [self.nameBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            self.vipImg.hidden = YES;
        }
        else{
//            [self.nameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
//            [self.nameBtn setImage:[UIImage imageNamed:@"vip"] forState:UIControlStateNormal];
            self.vipImg.hidden = NO;
        }
        
        if (![model.isLeader integerValue]) {
            //不是盟主所在的公司
            self.leaderTagImgV.hidden = YES;
        }
        else{
            self.leaderTagImgV.hidden = NO;
        }
        
        NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]电话:",model.cityName] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9}];
        
        NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.companyLandline] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
        
       [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
        
        self.infoOneL.attributedText = tempAttrStringOne;

        NSMutableAttributedString *infoTwoAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"案例 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9}];
        
        NSMutableAttributedString *infoTwoAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.al] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)} ];
        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringTwo];
        
        NSMutableAttributedString *infoTwoAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"施工中 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringThree];
        
        if (!model.constructionTotal) {
            model.constructionTotal = @"0";
        }
        NSMutableAttributedString *infoTwoAttrStringFour = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.constructionTotal] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)}];
        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringFour];
        
//        NSMutableAttributedString *infoTwoAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"设计师 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
//        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringThree];
//
//        NSMutableAttributedString *infoTwoAttrStringFour = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.sjs] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)}];
//        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringFour];
//
        NSMutableAttributedString *infoTwoAttrStringFive = [[NSMutableAttributedString alloc] initWithString:@"商品 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringFive];

        NSMutableAttributedString *infoTwoAttrStringSix = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.goodsNum] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)} ];
        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringSix];

        NSMutableAttributedString *infoTwoAttrStringSeven = [[NSMutableAttributedString alloc] initWithString:@"展现量 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9} ];
        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringSeven];

        NSMutableAttributedString *infoTwoAttrStringEight = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.displayNumber] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)} ];
        [infoTwoAttrStringOne appendAttributedString:infoTwoAttrStringEight];
        

//        NSMutableAttributedString *shopAttrStringOne = [[NSMutableAttributedString alloc] initWithString:@"店铺商品 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9}];
//
//        NSMutableAttributedString *shopAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.goodsNum] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)} ];
        
//        NSMutableAttributedString *shopAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"件  浏览量 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9}];
//        NSMutableAttributedString *shopAttrStringThree = [[NSMutableAttributedString alloc] initWithString:@"展现量 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_9}];
        
//        NSMutableAttributedString *shopAttrStringFour = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.al] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)} ];
//        NSMutableAttributedString *shopAttrStringFour = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",model.displayNumber] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: RGB(107, 244, 73)} ];
//        [shopAttrStringOne appendAttributedString:shopAttrStringTwo];
//        [shopAttrStringOne appendAttributedString:shopAttrStringThree];
//        [shopAttrStringOne appendAttributedString:shopAttrStringFour];
        
//        if ([model.companyType integerValue]==1018) {
//            self.infoTwoL.attributedText = infoTwoAttrStringOne;
//        }
//        else{
//            self.infoTwoL.attributedText = shopAttrStringOne;
//        }
        self.infoTwoL.attributedText = infoTwoAttrStringOne;
//        self.infoTwoL.text = [NSString stringWithFormat:@""];
    }
}

@end
