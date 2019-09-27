//
//  UnionActivityListCell.h
//  iDecoration
//
//  Created by sty on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeautifulArtListModel.h"

@interface UnionActivityListCell : UITableViewCell
@property (nonatomic, copy)void(^stateBtnBlock)(NSInteger tag);

@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
@property (weak, nonatomic) IBOutlet UILabel *activityNameL;
@property (weak, nonatomic) IBOutlet UILabel *beginL;
@property (weak, nonatomic) IBOutlet UILabel *endL;
@property (weak, nonatomic) IBOutlet UILabel *personNumL;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
- (IBAction)stateBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityBtnCont;


@property (strong, nonatomic) BeautifulArtListModel *beautyModel;

-(void)configData:(id)data isLeader:(BOOL)isLeader;
@end
