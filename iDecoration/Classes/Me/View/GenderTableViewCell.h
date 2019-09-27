//
//  GenderTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;

//@property (nonatomic, assign) NSInteger gender;
//@property (nonatomic, assign) NSInteger female;

@property (copy, nonatomic) void(^maleBlock)(NSString *male);
@property (copy, nonatomic) void(^femaleBlock)(NSString *female);

@end
