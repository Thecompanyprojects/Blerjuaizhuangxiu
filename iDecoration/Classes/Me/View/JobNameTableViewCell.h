//
//  JobNameTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

static UIButton *btn;
@protocol JobNameTableViewCellDelegate <NSObject>

@optional
- (void)didClickSelectedBtn:(UIButton *)btn withIndexpath:(NSIndexPath *)indexpath;

@end

@interface JobNameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<JobNameTableViewCellDelegate> delegate;
- (IBAction)didClickSelectBtn:(UIButton *)sender;

@end
