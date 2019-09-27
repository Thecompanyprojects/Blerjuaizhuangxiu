//
//  ZCHEditGoodsCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZCHEditGoodsCellDelegate <NSObject>

@optional
- (void)didClickIconBtn:(UIButton *)btn andCellRow:(NSInteger)rowIndex andIntroText:(NSString *)introText;
@end

typedef void(^ClickDeleteBtnBlock)(NSInteger index);
@interface ZCHEditGoodsCell : UITableViewCell

@property (weak, nonatomic) id<ZCHEditGoodsCellDelegate> delegate;
@property (assign, nonatomic) NSInteger rowIndex;
@property (strong, nonatomic) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UITextView *introTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introTVHeightCon;
@property (nonatomic, weak) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (copy, nonatomic) ClickDeleteBtnBlock clickDeleteBlock;

@end
