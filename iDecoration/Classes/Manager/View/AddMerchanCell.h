//
//  AddMerchanCell.h
//  iDecoration
//
//  Created by sty on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWCountButton.h"

@protocol AddMerchanCellDelegate<NSObject>
@optional
-(void)selectClick:(NSInteger)tag;
-(void)number:(NSString *)numstr andcell:(UITableViewCell *)cell;
@end

@interface AddMerchanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *merchanImgV;
@property (weak, nonatomic) IBOutlet UILabel *merchanNameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *browerL;
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;
@property (nonatomic, weak) id<AddMerchanCellDelegate>delegate;
@property (nonatomic,strong) JWCountButton *tempButton;
- (IBAction)circleBtnClick:(UIButton *)sender;
-(void)configData:(id)data isSelect:(BOOL)isSelect;
@end
