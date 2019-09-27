//
//  GoodsShareQRCodeView.m
//  iDecoration
//
//  Created by zuxi li on 2017/9/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsShareQRCodeView.h"

@interface GoodsShareQRCodeView()

@property (nonatomic, strong) UIView *middleBgView;

@property (nonatomic, strong) UILabel *shopNameLabel;

@property (nonatomic, strong) UILabel *goodsNameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation GoodsShareQRCodeView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        [self coverImageView];
        [self middleBgView];
        [self shopNameLabel];
        
        [self priceLabel];
        [self goodsNameLabel];
        [self bottomLabel];
        [self QRCodeImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        
        [self coverImageView];
        [self middleBgView];
        [self shopNameLabel];
        
        [self priceLabel];
        [self goodsNameLabel];
        [self bottomLabel];
        [self QRCodeImageView];
    }
    return self;
}

- (void)setShopName:(NSString *)shopName {
    _shopName = shopName;
    self.shopNameLabel.text = shopName;


//    CGSize maximumLabelSize = CGSizeMake(kSCREEN_WIDTH - 16, 9999);
//    CGSize expectSize = [self.shopNameLabel sizeThatFits:maximumLabelSize];
//    if (expectSize.height > 24) {
//        [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(8);
//            make.top.equalTo(0);
//            make.right.equalTo(-8);
//            make.height.equalTo(expectSize.height + 4);
//        }];
//    }
}

- (void)setGoodsName:(NSString *)goodsName {
    _goodsName = goodsName;
    self.goodsNameLabel.text = goodsName;
    

    
//    CGSize maximumLabelSize = CGSizeMake(kSCREEN_WIDTH - 16, 9999);
//    CGSize expectSize = [self.goodsNameLabel sizeThatFits:maximumLabelSize];
//    if (expectSize.height > 24) {
//        [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(8);
//            make.top.equalTo(self.shopNameLabel.mas_bottom).equalTo(0);
//            make.right.equalTo(-8);
//            make.height.equalTo(expectSize.height + 4);
//        }];
//    }
    
}

- (void)setPrice:(NSString *)price {
    _price = price;
    self.priceLabel.text = price;

}
#pragma  mark - lazyMethod

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        [self addSubview:_coverImageView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
//            make.height.equalTo(kSCREEN_WIDTH * 2.0 /3.0);
            make.height.equalTo(kSCREEN_WIDTH);
        }];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
    }
    return _coverImageView;
}

- (UIView *)middleBgView {
    if (_middleBgView == nil) {
        _middleBgView = [UIView new];
        [self addSubview:_middleBgView];
        [_middleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverImageView.mas_bottom).equalTo(0);
            make.left.right.equalTo(0);
            make.height.greaterThanOrEqualTo(1);
        }];
        _middleBgView.backgroundColor = [UIColor whiteColor];
    }
    return _middleBgView;
}

- (UILabel *)shopNameLabel {
    if (_shopNameLabel == nil) {
        _shopNameLabel = [UILabel new];
        [self.middleBgView addSubview:_shopNameLabel];
        _shopNameLabel.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
         [_shopNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _shopNameLabel.numberOfLines = 1;
        [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.top.equalTo(4);
            make.right.equalTo(-8);
            make.height.greaterThanOrEqualTo(24);
        }];
        _shopNameLabel.backgroundColor = [UIColor whiteColor];
        _shopNameLabel.font = [UIFont systemFontOfSize:16];
        
       
    }
    return _shopNameLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [UILabel new];
        [self.middleBgView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(8);
            make.top.equalTo(self.shopNameLabel.mas_bottom).equalTo(4);
            make.right.equalTo(-8);
            make.height.equalTo(24);
            make.bottom.equalTo(-4);
            make.width.greaterThanOrEqualTo(10);
        }];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.backgroundColor = [UIColor whiteColor];
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.textColor = [UIColor redColor];
    }
    return _priceLabel;
}

- (UILabel *)goodsNameLabel {
    if (_goodsNameLabel == nil) {
        _goodsNameLabel = [UILabel new];
        [self.middleBgView addSubview:_goodsNameLabel];
        _goodsNameLabel.preferredMaxLayoutWidth = kSCREEN_WIDTH - 16;
        [_goodsNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _goodsNameLabel.numberOfLines = 1;
        [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.top.equalTo(self.shopNameLabel.mas_bottom).equalTo(4);
//            make.right.equalTo(-8);
            make.right.equalTo(self.priceLabel.mas_left).equalTo(-8);
            make.height.greaterThanOrEqualTo(24);
            make.bottom.equalTo(-4);
        }];
        _goodsNameLabel.backgroundColor = [UIColor whiteColor];
        _goodsNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _goodsNameLabel;
}

- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [UILabel new];
        [self addSubview:_bottomLabel];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(-10);
            make.height.equalTo(20);
            
        }];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.font = [UIFont systemFontOfSize:14];
        _bottomLabel.text = @"商品详情扫描二维码";
    }
    return _bottomLabel;
}

- (UIImageView *)QRCodeImageView {
    if (_QRCodeImageView == nil) {
        _QRCodeImageView = [UIImageView new];
        [self addSubview:_QRCodeImageView];
        [_QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(self.bottomLabel.mas_top).equalTo(-10);
            make.top.equalTo(self.priceLabel.mas_bottom).equalTo(10);
            make.width.equalTo(_QRCodeImageView.mas_height);
        }];
    }
    return _QRCodeImageView;
}
@end
