//
//  LogoAndNameTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogoAndNameTableViewCellDelegate <NSObject>

@optional
-(void)toModifyCover;
-(void)toLookPersonCard;
@end

@interface LogoAndNameTableViewCell : UITableViewCell


//@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (nonatomic, copy) NSString *userLogo;
//@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, weak) id<LogoAndNameTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *modifyCoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookPersonCardBtn;
@end
