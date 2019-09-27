//
//  NewMyPersonCardFourCell.h
//  iDecoration
//
//  Created by sty on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewMyPersonCardFourCellDelegate <NSObject>
@optional

-(void)goToDiayVC:(NSInteger)tag;
-(void)goAllCase;

@end

@interface NewMyPersonCardFourCell : UITableViewCell
@property (nonatomic, strong) UIView *firstV;
@property (nonatomic, strong) UILabel *caseL;//案例
@property (nonatomic ,strong) UIView *SegmentLeftV;
@property (nonatomic ,strong) UIView *SegmentRightV;

@property (nonatomic, strong) UIButton *allCaseBtn;

@property (nonatomic, strong) UIView *secondV;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, weak) id<NewMyPersonCardFourCellDelegate>delegate;
-(void)configData:(NSMutableArray *)array;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
