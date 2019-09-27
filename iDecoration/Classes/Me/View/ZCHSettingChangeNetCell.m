//
//  ZCHSettingChangeNetCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSettingChangeNetCell.h"

static UIButton *btn;
@interface ZCHSettingChangeNetCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation ZCHSettingChangeNetCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)didClickSelectBtn:(UIButton *)sender {
    
    if (btn) {
        btn.selected = NO;
    }
    sender.selected = YES;
    btn = sender;
    if ([self.delegate respondsToSelector:@selector(didClickSelectedBtn:withIndexpath:)]) {
        
        [self.delegate didClickSelectedBtn:sender withIndexpath:self.indexPath];
    }
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    if ([[dic allKeys] containsObject:@"isOuter"]) {
        
        self.selectBtn.selected = [dic[@"isOuter"] boolValue];
        self.userNameLabel.text = @"切换到公共网络";
        self.companyNameLabel.hidden = YES;
        self.selectBtn.selected = NO;
        
        if (![dic[@"isOuter"] boolValue]) {
            self.selectBtn.selected = YES;
            btn = self.selectBtn;
            if ([self.delegate respondsToSelector:@selector(didClickSelectedBtn:withIndexpath:)]) {
                
                [self.delegate didClickSelectedBtn:self.selectBtn withIndexpath:self.indexPath];
            }
        }
        return;
    }
    
    self.companyNameLabel.hidden = NO;
    self.userNameLabel.text = [NSString stringWithFormat:@"业主: %@", [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"trueName"]];
    self.companyNameLabel.text = dic[@"companyName"];
    
    if ([dic[@"innerAndOuterSwitch"] isEqualToString:@"0"]) {
        
        self.selectBtn.selected = YES;
        btn = self.selectBtn;
        if ([self.delegate respondsToSelector:@selector(didClickSelectedBtn:withIndexpath:)]) {
            
            [self.delegate didClickSelectedBtn:self.selectBtn withIndexpath:self.indexPath];
        }
    } else {
        
        self.selectBtn.selected = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
