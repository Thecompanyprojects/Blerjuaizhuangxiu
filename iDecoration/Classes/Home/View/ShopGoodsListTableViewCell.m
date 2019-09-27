 //
//  ShopGoodsListTableViewCell.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopGoodsListTableViewCell.h"
#import "ZCHTapGestureRecognizer.h"
#import "NSString+Size.h"

@interface ShopGoodsListTableViewCell ()

//@property (strong, nonatomic) UIView *bottomView;

@end

@implementation ShopGoodsListTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)resuseIdentifier goodsArray:(NSArray *)goodsArr detailModel:(ShopDetailModel *)model {
    
    _detailModel = model;
//    _goodsArr = goodsArr;
    return [self initWithStyle:style reuseIdentifier:resuseIdentifier];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    
    CGFloat goodListCellHeight = 0;
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.text = _detailModel.detail;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont systemFontOfSize:14];
    CGSize contentSize = [_descriptionLabel.text boundingRectWithSize:CGSizeMake(BLEJWidth - 20, MAXFLOAT) withFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_descriptionLabel];
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView).offset(10);
        make.trailing.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(contentSize.height + 25);
    }];
    
    if (_goodsArr.count > 0) {
        
        CGFloat space = 5;
        CGFloat width = (kSCREEN_WIDTH - 4 * space) / 3;
        CGFloat height = width ;
        //有商品
        UILabel *constLabel = [[UILabel alloc] init];
        constLabel.text = @"商品展示";
        constLabel.font = [UIFont systemFontOfSize:15];
        constLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:constLabel];
        [constLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.top.mas_equalTo(_descriptionLabel.mas_bottom);
            make.height.mas_equalTo(40);
        }];
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView);
            make.height.mas_equalTo(0.6 );
            make.bottom.mas_equalTo(constLabel.mas_top);
        }];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.6);
            make.top.mas_equalTo(constLabel.mas_bottom);
        }];
        
        UIView *lastView;
        for (NSInteger i = 0; i < _goodsArr.count; i++) {
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = White_Color;
            [self.contentView addSubview:bgView];
            
            ZCHTapGestureRecognizer *tap = [[ZCHTapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickGoodsView:)];
            tap.index = i;
            [bgView addGestureRecognizer:tap];
            
            if (i < 2) {
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, height + 50));
                    if ( i == 0) {
                        make.left.mas_equalTo(self.contentView).offset(space);
                    }else{
                        make.left.mas_equalTo(lastView.mas_right).offset(space);
                    }
                    make.top.mas_equalTo(constLabel.mas_bottom).offset(10);

                }];
            }else {
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(width, height + 50));

                    if (i % 3 == 0) {
                        make.left.mas_equalTo(self.contentView).offset(space);
                        make.top.mas_equalTo(lastView.mas_bottom).offset(space);
                    }else{
                        make.left.mas_equalTo(lastView.mas_right).offset(space);
                        make.centerY.mas_equalTo(lastView);
                    }
                }];
                
            }
            lastView = bgView;
            
            NSDictionary *goodsDic = _goodsArr[i];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            [bgView addSubview:imageView];

            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(bgView);
                make.right.mas_equalTo(bgView);
                make.height.mas_equalTo(bgView).offset(-50);
                make.top.mas_equalTo(bgView);
            }];
            [imageView sd_setImageWithURL:[NSURL URLWithString:goodsDic[@"display"]]];
            
            UILabel *priceLabel = [[UILabel alloc] init];
            priceLabel.textColor = [UIColor redColor];
            priceLabel.font = [UIFont systemFontOfSize:13];
            priceLabel.textAlignment = NSTextAlignmentLeft;
            priceLabel.text = [NSString stringWithFormat:@"￥%@",goodsDic[@"price"]];
            [bgView addSubview:priceLabel];
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imageView.mas_bottom);
                make.left.mas_equalTo(imageView);
                make.height.mas_equalTo(@20);
                make.right.mas_equalTo(imageView).offset(-10);
            }];
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.text = goodsDic[@"name"];
            nameLabel.font = [UIFont systemFontOfSize:12];
            nameLabel.textColor = [UIColor lightGrayColor];
            [bgView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(priceLabel);
                make.top.mas_equalTo(priceLabel.mas_bottom);
                make.height.mas_equalTo(@30);
                make.right.mas_equalTo(imageView).offset(-10);
            }];
            
//            UIView *bottomView = [[UIView alloc] init];
//            bottomView.backgroundColor = [UIColor whiteColor];
//            [self.contentView addSubview:bottomView];
//            self.bottomView = bottomView;
//            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//                
//                make.left.mas_equalTo(self.contentView);
//                make.top.mas_equalTo(lastView.mas_bottom);
//                make.height.mas_equalTo(@20);
//                make.right.mas_equalTo(self.contentView);
//            }];
            
        }
        
        goodListCellHeight = 40.0 + (_goodsArr.count % 3 == 0 ? _goodsArr.count / 3 : (_goodsArr.count / 3 + 1)) * (((kSCREEN_WIDTH - 4 * space) / 3) + 50) + (_goodsArr.count / 3) * space + 10 + contentSize.height + 25;
    } else {
    //无商品
//        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_descriptionLabel.mas_bottom);
//            make.height.mas_equalTo(@20);
//            make.left.mas_equalTo(self.contentView);
//            make.right.mas_equalTo(self.contentView);
//        }];
        
        goodListCellHeight = contentSize.height + 25;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShopGoodsListTableViewCellNotification" object:[NSString stringWithFormat:@"%f", goodListCellHeight] userInfo:nil];
}

- (void)didClickGoodsView:(ZCHTapGestureRecognizer *)tap {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShopGoodsListTableViewCellDidNotification" object:[NSString stringWithFormat:@"%ld", tap.index]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
