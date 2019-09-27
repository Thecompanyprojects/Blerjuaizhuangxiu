//
//  SupervisorDiaryCellTwo.h
//  iDecoration
//
//  Created by Apple on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SupervisorDiaryCellTwoDelegate <NSObject>

-(void)changeContentPhoto:(NSInteger)tag;
-(void)deleteContentPhoto:(NSInteger)tag;
-(void)editContent:(NSInteger)tag content:(NSString *)content;

@end

@interface SupervisorDiaryCellTwo : UITableViewCell

@property (nonatomic, weak)UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextView *saySomeV;
@property (weak, nonatomic) IBOutlet UILabel *placeHoldL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saySomeNsH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVNsW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVNsH;
//@property (weak, nonatomic) IBOutlet UIButton *deleteContentBtn;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteNsTop;

-(void)configWith:(id)data count:(NSInteger)count indexPath:(NSIndexPath *)path isPower:(BOOL)isPower isEdit:(BOOL)isEdit;
@property (nonatomic, weak) id<SupervisorDiaryCellTwoDelegate>delegate;
@end
