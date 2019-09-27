//
//  LogoAndNameTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "LogoAndNameTableViewCell.h"

@interface LogoAndNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderView;
- (IBAction)coverBtnClick:(UIButton *)sender;

- (IBAction)lookCardBtnClick:(UIButton *)sender;

@end

@implementation LogoAndNameTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.modifyCoverBtn.backgroundColor = Main_Color;
    [self.modifyCoverBtn setTitleColor:White_Color forState:UIControlStateNormal];
    self.modifyCoverBtn.layer.masksToBounds = YES;
    self.modifyCoverBtn.layer.cornerRadius = 5;
    
    
    self.lookPersonCardBtn.backgroundColor = Main_Color;
    [self.lookPersonCardBtn setTitleColor:White_Color forState:UIControlStateNormal];
    self.lookPersonCardBtn.layer.masksToBounds = YES;
    self.lookPersonCardBtn.layer.cornerRadius = 5;
}
- (void)setUserLogo:(NSString *)userLogo {
    
    NSURL *url = [NSURL URLWithString:userLogo];
    [self.LogoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:DefaultManPic]];
}

- (void)setUserName:(NSString *)userName {
    
    _userName = userName;
    self.NameLabel.text = userName;
}

- (void)setGender:(NSInteger)gender {
    
    _gender = gender;
    if (gender == 1) {// 男
        self.genderView.image = [UIImage imageNamed:@"man"];
    } else {
        self.genderView.image = [UIImage imageNamed:@"woman"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (IBAction)coverBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(toModifyCover)]) {
        [self.delegate toModifyCover];
    }
}

- (IBAction)lookCardBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(toLookPersonCard)]) {
        [self.delegate toLookPersonCard];
    }
}
@end
