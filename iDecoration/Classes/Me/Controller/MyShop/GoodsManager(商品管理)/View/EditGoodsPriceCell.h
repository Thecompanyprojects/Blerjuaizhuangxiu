//
//  EditGoodsPriceCell.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsPriceModel.h"
#import "ZYCTextField.h"
@class EditGoodsPriceCell;

@protocol EditGoodsPriceCellDelegate <NSObject>
- (void)editGoodsPriceCellDeleteAction:(EditGoodsPriceCell *)cell;
- (void)editGoodsPriceCellUploadImage:(EditGoodsPriceCell *)cell;

@end


@interface EditGoodsPriceCell : UITableViewCell

@property (nonatomic, weak) id<EditGoodsPriceCellDelegate> delegate;

@property (nonatomic, strong) GoodsPriceModel *model;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet ZYCTextField *nameTF;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet ZYCTextField *priceTF;
@property (weak, nonatomic) IBOutlet ZYCTextField *unitTF;
@property (weak, nonatomic) IBOutlet ZYCTextField *numTF;

@end
