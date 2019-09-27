//
//  VrCommenCell.h
//  iDecoration
//
//  Created by sty on 2018/3/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VrCommenCellDelegate <NSObject>

-(void)deleteVr;
@end


@interface VrCommenCell : UITableViewCell
@property (nonatomic, strong) UIView *VRview;//添加VR
@property (nonatomic, strong) UIButton *VRBtn;
@property (nonatomic, strong) UILabel *VRLabel;

@property (nonatomic, strong) UILabel *VRTitleL;//全景描述
@property (nonatomic, strong) UIButton *VRdeleteBtn;
@property (nonatomic, strong) UIImageView *VRPlacholdV;//全景的默认占位图

@property (nonatomic, weak) id<VrCommenCellDelegate>delegate;

-(void)configCrib:(NSString *)cribStr imgStr:(NSString *)imgStr isHaveVR:(BOOL)isHaveVR;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
