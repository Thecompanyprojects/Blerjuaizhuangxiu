//
//  UnionActivitySetCell.h
//  iDecoration
//
//  Created by sty on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnionActivitySetCell : UITableViewCell
@property (nonatomic,strong)void(^startBtnBlock)();
@property (nonatomic,strong)void(^endBtnBlock)();
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

- (IBAction)startBtnClick:(id)sender;
- (IBAction)endBtnClick:(id)sender;
-(void)setTime:(NSString *)startTimeStr endTimeStr:(NSString *)endTimeStr;
@end
