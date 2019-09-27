//
//  UploadAdvertisementCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/7/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderTextView.h"

typedef void(^UploadAdvertisementCellBlock)(NSString *string);
@interface UploadAdvertisementCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightCons;
@property (copy, nonatomic) UploadAdvertisementCellBlock blockTextViewChanged;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopCon;

@property (weak, nonatomic) IBOutlet PlaceHolderTextView *placeHolderTV;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
