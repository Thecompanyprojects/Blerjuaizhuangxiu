//
//  EnterTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chatdelegate <NSObject>

-(void)enterChat;

@end

@interface EnterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (nonatomic, assign) void(^enterBlock)();

@property(nonatomic,weak)id<chatdelegate>  delegate;

@end
