//
//  DiscountPackageFooterView.h
//  iDecoration
//
//  Created by 张毅成 on 2018/7/26.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscountPackageFooterView : UIView

typedef void(^DiscountPackageFooterViewCellBlock)(NSInteger tag);

@property (copy, nonatomic) DiscountPackageFooterViewCellBlock blockDidTouchButton;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)didTouchButton:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
