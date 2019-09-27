//
//  GenderTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GenderTableViewCell.h"

@implementation GenderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        if (!user.gender) {
            
            [self.maleBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
            [self.femaleBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
        }
        else
        {
            //男
            [self.maleBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
            [self.femaleBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
        }
    }
    
    
    else{
//        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
//        if (user.gender) {
//            
//            [self.maleBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//            [self.femaleBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
//        }
//        else
//        {
            //男
            [self.maleBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
            [self.femaleBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
//        }
    }
    
    
    
}

//男
- (IBAction)maleClick:(id)sender {
    
//    self.gender = 1;
    [self.maleBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
    [self.femaleBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
    
    if (self.maleBlock) {
        self.maleBlock(@"1");
    }
}

//女
- (IBAction)femaleClick:(id)sender {
    
//    self.gender = 0;
    [self.maleBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
    [self.femaleBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];

    if (self.femaleBlock) {
        self.femaleBlock(@"0");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
