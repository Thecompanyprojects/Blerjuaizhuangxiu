//
//  AddMerchanCell.m
//  iDecoration
//
//  Created by sty on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddMerchanCell.h"
#import "GoodsListModel.h"
#import "STYCouponSelectModel.h"


@interface AddMerchanCell()

@end

@implementation AddMerchanCell


-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-20);
        make.bottom.equalTo(weakSelf).with.offset(-10);
        make.width.mas_offset(80);
        make.height.mas_offset(24);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView addSubview:self.tempButton];
    [self setuplayout];
    [self example1];
    // Initialization code
}

- (IBAction)circleBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectClick:)]) {
        [self.delegate selectClick:sender.tag];
       
    }
}

-(void)configData:(id)data isSelect:(BOOL)isSelect{
    if ([data isKindOfClass:[GoodsListModel class]]) {
        GoodsListModel *model = data;
        [self.merchanImgV sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        
        self.merchanNameL.text = model.name;
        NSArray *activityArray = model.activityList;
        if (activityArray.count>0) {
            if (activityArray.count<=3) {
                CGFloat leftX = 120;
                for (int i = 0; i<activityArray.count; i++) {
                    UILabel *activityL = [[UILabel alloc]initWithFrame:CGRectMake(leftX, 31, 75, 25)];
                    
                    ActivityListModel *activityModel = activityArray[i];
                    activityL.text = activityModel.activityType;
                    //                        activityL.text = @"手机刷机啊";
                    activityL.textColor = Red_Color;
                    activityL.font = NB_FONTSEIZ_NOR;
                    activityL.textAlignment = NSTextAlignmentCenter;
                    activityL.layer.masksToBounds = YES;
                    activityL.layer.borderWidth = 1.0;
                    activityL.layer.cornerRadius = 5;
                    activityL.layer.borderColor = Red_Color.CGColor;
                    [self addSubview:activityL];
                    if (kSCREEN_WIDTH<=350) {
                        leftX = leftX+75+1;
                    }
                    else{
                        leftX = leftX+75+10;
                    }
                    
                }
            }
            else{
                CGFloat leftX = 120;
                for (int i = 0; i<3; i++) {
                    UILabel *activityL = [[UILabel alloc]initWithFrame:CGRectMake(leftX, 31, 75, 25)];
                    ActivityListModel *activityModel = activityArray[i];
                    activityL.text = activityModel.activityType;
                    //                        activityL.text = @"手机刷机";
                    activityL.textColor = Red_Color;
                    activityL.font = NB_FONTSEIZ_NOR;
                    activityL.textAlignment = NSTextAlignmentCenter;
                    activityL.layer.masksToBounds = YES;
                    activityL.layer.borderWidth = 1.0;
                    activityL.layer.cornerRadius = 5;
                    activityL.layer.borderColor = Red_Color.CGColor;
                    [self addSubview:activityL];
                    if (kSCREEN_WIDTH<=350) {
                        leftX = leftX+75+1;
                    }
                    else{
                        leftX = leftX+75+5;
                    }
                }
            }
        }
        self.priceL.text = [NSString stringWithFormat:@"¥%@",model.price];
        self.priceL.textColor = Red_Color;
        //收藏量
        self.browerL.text = [NSString stringWithFormat:@"%ld",model.collectionNum];
        self.browerL.hidden = YES;
        
        if (isSelect) {
            [self.circleBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
        }
        else{
            [self.circleBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
        }
    }
    
    if ([data isKindOfClass:[STYCouponSelectModel class]]){
        STYCouponSelectModel *model = data;
        self.merchanNameL.text = model.giftName;
        [self.merchanImgV sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        if (!model.numbers||model.numbers.length<=0) {
            self.priceL.text = [NSString stringWithFormat:@"数量： "];
        }
        else{
            self.priceL.text = [NSString stringWithFormat:@"数量： "];
        }
        
//        self.priceL.textColor = Red_Color;
        //收藏量
//        self.browerL.text = [NSString stringWithFormat:@"%ld",model.collectionNum];
        self.tempButton.currentNumber = [model.numbers integerValue];
        self.browerL.hidden = YES;
        
        if (isSelect) {
            [self.circleBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
        }
        else{
            [self.circleBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)example1
{
     __weak typeof (self) weakSelf = self;
    _tempButton.valueChanged = ^(NSInteger number, BOOL isIncrease) {
        NSLog(@"%@ value=%ld",isIncrease?@"加":@"减",number);
        NSString *numstr = [NSString stringWithFormat:@"%ld",number];
        [weakSelf.delegate number:numstr andcell:weakSelf];
    };
}

#pragma mark - getters

-(JWCountButton *)tempButton
{
    if(!_tempButton)
    {
        _tempButton = [[JWCountButton alloc] init];
        _tempButton.shakeAnimation = YES;
        _tempButton.maxValue = 10086;
        _tempButton.minValue = 1;
        _tempButton.increaseImage = [UIImage imageNamed:@"coupon_increase"];
        _tempButton.decreaseImage = [UIImage imageNamed:@"coupon_decrease"];
        _tempButton.layer.masksToBounds = YES;
        _tempButton.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        _tempButton.layer.borderWidth = 1;
    }
    return _tempButton;
}



@end
