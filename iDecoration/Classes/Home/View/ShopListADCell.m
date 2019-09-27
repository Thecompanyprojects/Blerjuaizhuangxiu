//
//  ShopListADCell.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopListADCell.h"

@interface ShopListADCell()<SDCycleScrollViewDelegate>

@end
@implementation ShopListADCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    
//    _adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200) delegate:self placeholderImage:nil];
    _adImage = [[SDCycleScrollView alloc] init];
    _adImage.autoScrollTimeInterval = BANNERTIME;
    _adImage.backgroundColor = [UIColor blackColor];
    _adImage.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    _adImage.delegate = self;
    [self.contentView addSubview:_adImage];
    [_adImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(kSCREEN_WIDTH * 0.6);
    }];
    
    
    
//    _adImage = [[UIImageView alloc] init];
//    _adImage.contentMode = UIViewContentModeScaleToFill;
//    [self.contentView addSubview:_adImage];
//    [_adImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.height.mas_equalTo(200);
//    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *webUrl = self.hrefArray[index];
    
    if (webUrl.length > 0) {
        if (![webUrl ew_isUrlString]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
            return;
        }
        if (self.gotoAdWebBlock) {
            self.gotoAdWebBlock(webUrl);
        }
    }
}

@end
