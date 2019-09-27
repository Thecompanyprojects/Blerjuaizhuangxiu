//
//  GoodsListCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsListCell.h"

/*
 // 商品icon
 @property (nonatomic, strong) UIImageView *iconIV;
 // 商品名称
 @property (nonatomic, strong) UILabel *nameLabel;
 // 商品折扣视图
 @property (nonatomic, strong) UIView *discountView;
 // 商品价格视图
 @property (nonatomic, strong) UIView *priceView;
 @property (nonatomic, strong) UILabel *presentPriceLabel;
 @property (nonatomic, strong) UILabel *oldPriceLabel;
 @property (nonatomic, strong) UILabel *collectionLabel;
 */
@implementation GoodsListCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _iconIV = [[UIImageView alloc] init];
    _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    _iconIV.layer.masksToBounds = YES;
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _discountView = [UIView new];
    _priceView = [UIView new];
    _presentPriceLabel = [UILabel new];
    _presentPriceLabel.font = [UIFont systemFontOfSize:14];
    _presentPriceLabel.textColor = [UIColor redColor];
    
    _oldPriceLabel = [UILabel new];
    _oldPriceLabel.textColor = [UIColor darkGrayColor];
    
//    _collectionLabel = [UILabel new];
//    _collectionLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_iconIV];
    [self addSubview:_nameLabel];
    [self addSubview:_discountView];
    [self addSubview:_priceView];
    [self.priceView addSubview:_presentPriceLabel];
    [self.priceView addSubview:_oldPriceLabel];
//    [self.priceView addSubview:_collectionLabel];
}


- (void)setIsGrid:(BOOL)isGrid {
    _isGrid = isGrid;
    
//    CGFloat LeftMargin = 10;
//    CGFloat middleMargin = 5;
//    CGFloat cellWidth = (kSCREEN_WIDTH - 100 - LeftMargin * 2 - middleMargin)/2.0;
    CGFloat cellwidth = self.cellWidth; // (kSCREEN_WIDTH - 125)/2.0;
    
    // cellHeight = 68 + cellwidth
    if (isGrid) {
        // 格子视图
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(0);
            make.height.equalTo(cellwidth);
        }];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(2);
            make.right.equalTo(-2);
            make.top.equalTo(self.iconIV.mas_bottom).equalTo(4);
            make.height.equalTo(16);
        }];
        [self.discountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).equalTo(4);
            make.left.right.equalTo(0);
            make.height.equalTo(20);
        }];
        [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.discountView.mas_bottom).equalTo(4);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-4);
            make.height.equalTo(16);
        }];
        [self.presentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(2);
        }];
        self.oldPriceLabel.font = [UIFont systemFontOfSize:10];
        [self.oldPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.presentPriceLabel);
            make.left.equalTo(self.presentPriceLabel.mas_right);
        }];
//        self.collectionLabel.font = [UIFont systemFontOfSize:10];
//        [self.collectionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.presentPriceLabel);
//            make.right.equalTo(-2);
//        }];
    } else {
        // 列表视图  列表高 120
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(0);
            make.width.equalTo(120);
        }];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(4);
            make.right.equalTo(-4);
            make.top.equalTo(8);
            make.height.equalTo(30);
        }];
        [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(-8);
            make.height.equalTo(16);
        }];
        [self.discountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(self.nameLabel.mas_bottom).equalTo(4);
            make.bottom.equalTo(self.priceView.mas_top).equalTo(-4);
        }];
        [self.presentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(4);
        }];
        _oldPriceLabel.font = [UIFont systemFontOfSize:12];
        [self.oldPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.presentPriceLabel);
            make.left.equalTo(self.presentPriceLabel.mas_right).equalTo(4);
        }];
//        _collectionLabel.font = [UIFont systemFontOfSize:12];
//        [self.collectionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.presentPriceLabel);
//            make.right.equalTo(-4);
//        }];
    }
}

- (void)setModel:(GoodsListModel *)model {
    _model = model;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.display]];
    self.nameLabel.text = model.name;
    self.discountView.backgroundColor = [UIColor whiteColor];
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.price] ;
    self.oldPriceLabel.text = @"";  // 原价 没有
//    if (model.collectionNum > 0) {
//        if (self.isGrid) {
//            self.collectionLabel.text = [NSString stringWithFormat:@"%ld收藏", (long)model.collectionNum];  // 收藏没有
//        } else {
//            self.collectionLabel.text = [NSString stringWithFormat:@"%ld 收藏", (long)model.collectionNum];  // 收藏没有
//        }
//        
//    } else {
//        self.collectionLabel.text = self.isGrid ? @"0收藏" : @"0 收藏";
//        
//    }
    
    //折扣视图 测试折扣
    [self.discountView removeAllSubViews];
    NSMutableArray *mulArr = [NSMutableArray array];
    NSInteger count = model.activityList.count > 3 ? 3 : model.activityList.count;
    for (int i = 0; i < count; i ++) {
        ActivityListModel *amodel = model.activityList[i];
        [mulArr addObject:amodel.activityName];
    }
    NSArray *discountTitleArray = [mulArr copy];
    UILabel *lastLabel = nil;
    CGFloat labelHeight = 14;
    for (int i = 0; i < discountTitleArray.count; i ++) {
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = 2;
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:11];
        label.text = discountTitleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelWidth = [self getWidthWithText:label.text height:labelHeight font:11] + 4;
        if (i == 0) {
            label.frame = CGRectMake(2, 2, labelWidth, labelHeight);
        } else {
            CGFloat x = CGRectGetMaxX(lastLabel.frame) + 3;
            CGFloat y = lastLabel.frame.origin.y;;
            
            if (_isGrid) { // 方格视图
                if (self.cellWidth - x - 2 >= labelWidth) {
                    y = lastLabel.frame.origin.y;
                } else {
                    x = 2;
                    y = lastLabel.frame.origin.y + labelHeight + 2;
                    if (y + labelHeight + 2 > 20) { // 20为 discountView 视图的高度
                        return;
                    }
                }
                label.frame = CGRectMake(x, y, labelWidth, labelHeight);
            } else {
                CGFloat discountViewWidth = model.isYellowPageClassifyLayout ? (kSCREEN_WIDTH - 120 - 90):(kSCREEN_WIDTH - 120);
                if (discountViewWidth - x - 2 >= labelWidth) { // discountViewWidth 为 discountView 视图的宽度
                    y = lastLabel.frame.origin.y;
                } else {
                    x = 2;
                    y = lastLabel.frame.origin.y + labelHeight + 2;
                    if (y + labelHeight + 2 > 60) { // 60 为 discountView 视图的高度 的大概高度
                        return;
                    }
                }
                label.frame = CGRectMake(x, y, labelWidth, labelHeight);
            }
            
        }
        
        [self.discountView addSubview:label];
        lastLabel = label;
    }
    
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}

@end
