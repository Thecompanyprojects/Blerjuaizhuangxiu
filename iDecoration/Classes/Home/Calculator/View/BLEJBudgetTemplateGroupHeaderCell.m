//
//  BLEJBudgetTemplateGroupHeaderCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetTemplateGroupHeaderCell.h"
#import "ZCHSimpleSettingRoomModel.h"

@interface BLEJBudgetTemplateGroupHeaderCell ()
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
//@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

// 从xib形式转化为纯代码形式   控制不了view的fram
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *plusBtn;
@end

@implementation BLEJBudgetTemplateGroupHeaderCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    self.contentView.backgroundColor = kBackgroundColor;
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
    }];
    
    self.plusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.plusBtn addTarget:self action:@selector(didClickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.plusBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.plusBtn];
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    self.minusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.minusBtn addTarget:self action:@selector(didClickMinusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.minusBtn setImage:[UIImage imageNamed:@"-"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.minusBtn];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plusBtn.mas_left).equalTo(-10);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
}

- (IBAction)didClickMinusBtn:(UIButton *)sender {
    
    NSLog(@"----");
    if ([self.budgetTemplateGroupHeaderCellDelegate respondsToSelector:@selector(didClickMinusBtnWithSection:andIsSelected:)]) {
        
        [self.budgetTemplateGroupHeaderCellDelegate didClickMinusBtnWithSection:self.sectionIndex andIsSelected:!sender.selected];
    }
}
- (IBAction)didClickPlusBtn:(UIButton *)sender {
    
    NSLog(@"++++");
    if ([self.budgetTemplateGroupHeaderCellDelegate respondsToSelector:@selector(didClickPlusBtnWithSection:)]) {
        
        [self.budgetTemplateGroupHeaderCellDelegate didClickPlusBtnWithSection:self.sectionIndex];
    }
}

- (void)setTitle:(NSString *)title {
    
    if (_title != title) {
        _title = title;
    }
    self.nameLabel.text = title;
}

- (void)setIsShowMinusAndPlusBtn:(BOOL)isShowMinusAndPlusBtn {
    
    if (_isShowMinusAndPlusBtn != isShowMinusAndPlusBtn) {
        
        _isShowMinusAndPlusBtn = isShowMinusAndPlusBtn;
    }
    self.plusBtn.hidden = !isShowMinusAndPlusBtn;
    self.minusBtn.hidden = !isShowMinusAndPlusBtn;
}

- (void)setIsRotate:(BOOL)isRotate {
    

//    if (_isRotate != isRotate) {
//
//        _isRotate = isRotate;
//    }
    
    if (isRotate) {
        
        self.minusBtn.transform = CGAffineTransformRotate(self.minusBtn.transform, -M_PI_2);
    } else {
        
        self.minusBtn.transform = CGAffineTransformIdentity;
    }
    
     //   self.minusBtn.transform = CGAffineTransformIdentity;
}

- (void)setModel:(ZCHSimpleSettingRoomModel *)model {
    
    _model = model;
    self.nameLabel.text = model.name;
}

@end
