//
//  EditGoodsParameterCell.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditGoodsParameterCell;

@protocol EditGoodsParameterCellDelegate <NSObject>

- (void)editGoodsParameterCellDeleteAction:(EditGoodsParameterCell *)cell;
@end

@interface EditGoodsParameterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UILabel *nameNumLabel;

@property (weak, nonatomic) IBOutlet UITextView *describeTV;
@property (weak, nonatomic) IBOutlet UILabel *describeNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *describeTVHeight;

@property (weak, nonatomic) IBOutlet UILabel *describeTVPlaceHolder;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;


@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@property (nonatomic, weak) id<EditGoodsParameterCellDelegate> delegate;


@property (weak,nonatomic)UITableView * tableView;

- (void)setName:(NSString *)name andDescribe:(NSString *)describe;

- (void)setNewParamName:(NSString *)name andDescribe:(NSString *)describe;

@end
