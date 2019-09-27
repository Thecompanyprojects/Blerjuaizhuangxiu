//
//  LocalMusicCell.h
//  iDecoration
//
//  Created by sty on 2017/9/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalMusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songL;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

-(void)configData:(id)data isShowCheck:(BOOL)isShowCheck;
@end
